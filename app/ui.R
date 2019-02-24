library(shiny)
library(shinydashboard)


shinyUI(dashboardPage(
  dashboardHeader(title = "coinr"),

  dashboardSidebar(
    sidebarMenu(
      menuItem("Historical rates", tabName = "history", icon = icon("calendar")),
      menuItem("Portfolio", tabName = "portfolio", icon = icon("money")),
      menuItem("Source", href = "//github.com/oleskiewicz/coinr", icon = icon("code"))
    )
  ),

  dashboardBody(
    tabItems(
      tabItem(
        tabName = "history",

        fluidRow(
          valueBoxOutput("minprice"),
          valueBoxOutput("maxprice")
        ),

        dygraphOutput("btcprice")
      ),

      tabItem(
        tabName = "portfolio",
        h2("Portfolio")
      )
    )
  )
))
