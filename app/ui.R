library(shiny)
library(shinydashboard)


shinyUI(dashboardPage(
  dashboardHeader(title = "coinr"),

  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("th-large")),
      menuItem("Historical rates", tabName = "history", icon = icon("calendar")),
      menuItem("Histogram", tabName = "histogram"),
      menuItem("Portfolio", tabName = "portfolio", icon = icon("money")),
      menuItem("Source", href = "//github.com/oleskiewicz/coinr", icon = icon("code"))
    )
  ),

  dashboardBody(
    tabItems(

      tabItem(
        tabName = "home",
        h2("Home")
      ),

      tabItem(
        tabName = "history",
        h2("Historical rates")
      ),

      tabItem(
        tabName = "histogram",
        h2("Histogram"),

        sidebarLayout(
          sidebarPanel(
            sliderInput("bins",
              "Number of bins:",
              min = 1,
              max = 50,
              value = 30
            )
          ),

          mainPanel(
            plotOutput("distPlot")
          )
        )
      ),

      tabItem(
        tabName = "portfolio",
        h2("Portfolio")
      )

    )
  )
))
