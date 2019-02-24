library(coindeskr)
library(dygraphs)
library(shiny)
library(shinydashboard)


shinyServer(function(input, output) {
  last31 <- get_last31days_price()

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
})
