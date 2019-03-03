library(coindeskr)
library(dygraphs)
library(ggplot2)
library(shiny)
library(shinydashboard)


# config
config.bands <- tribble(
  ~band, ~weight,
  "BIG", 0.7,
  "MID", 0.3
)
config.holdings <- tribble(
  ~symbol, ~amount, ~band,
  "BTC", 1.0, "BIG",
  "ETH", 1.0, "BIG",
  "DASH", 1.0, "MID",
  "XRP", 1.0, "BIG",
  "NANO", 1.0, "MID",
  "NEO", 1.0, "MID",
  "XLM", 1.0, "MID",
  "XMR", 1.0, "MID",
  "ZEC", 1.0, "MID",
  "LTC", 1.0, "MID",
  "MIOTA", 1.0, "MID",
) %>% arrange(symbol)


# rebalance portfolio into 2 bands, each weighted by market cap
rebalance <- function(coins, bands) {
  result <- coins
  result$target <- 0.0
  market_caps <- coins %>%
    group_by(band) %>%
    summarise(market_cap_usd = sum(market_cap_usd))

  for (band in unique(config.bands$band)) {
    result[result$band == band, ]$target <-
      config.bands[config.bands$band == band, ]$weight *
        result[result$band == band, ]$market_cap_usd /
        market_caps[market_caps$band == band, ]$market_cap_usd *
        sum(coins$value_usd) /
        result[result$band == band, ]$price_usd
  }

  return(result)
}


shinyServer(function(input, output) {
  last31 <- get_last31days_price()

  coins <- fromJSON(txt = "https://api.coinmarketcap.com/v1/ticker") %>%
    as_tibble() %>%
    filter(symbol %in% config.holdings$symbol) %>%
    arrange(symbol) %>%
    mutate(market_cap_usd = as.numeric(market_cap_usd)) %>%
    mutate(price_usd = as.numeric(price_usd)) %>%
    mutate(amount = config.holdings$amount) %>%
    mutate(value_usd = price_usd * amount) %>%
    mutate(band = config.holdings$band) %>%
    mutate(date = Sys.Date()) %>%
    select(symbol, name, amount, value_usd, band, price_usd, market_cap_usd, date)

  output$coins <- renderDataTable(coins)

  output$balance <- renderValueBox({
    valueBox(
      value = format(round(sum(coins$value_usd), 5), nsmall = 5),
      subtitle = "Portfolio balance",
      icon = icon("dollar")
    )
  })

  output$minprice <- renderValueBox({
    valueBox(
      value = min(last31),
      subtitle = "31 days minimum",
      icon = icon("arrow-down")
    )
  })

  output$maxprice <- renderValueBox({
    valueBox(
      value = max(last31),
      subtitle = "31 days maximum",
      icon = icon("arrow-up")
    )
  })

  output$btcprice <- renderDygraph(
    dygraph(data = last31, main = "Bitcoin USD Price for Last 31 days") %>%
      dyHighlight(
        highlightCircleSize = 5,
        highlightSeriesBackgroundAlpha = 0.2,
        hideOnMouseOut = FALSE,
        highlightSeriesOpts = list(strokeWidth = 3)
      ) %>%
      dyRangeSelector()
  )

  output$portfolio.bands <- renderPlot({
    ggplot(config.bands, aes(1, weight, fill = as.factor(weight))) + geom_col() +
      theme_void() + coord_flip()
  })

  output$portfolio.current <- renderPlot({
    ggplot(
      coins,
      aes(symbol, market_cap_usd, fill = factor(band))
    ) + geom_col() + theme(legend.position = "bottom")
  })

  output$portfolio.balanced <- renderPlot({
    ggplot(
      rebalance(coins, config.bands),
      aes(symbol, target * price_usd, fill = band)
    ) + geom_col() + theme(legend.position = "bottom")
  })
})
