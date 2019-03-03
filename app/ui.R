library(dplyr)
library(dygraphs)
library(ggplot2)
library(jsonlite)
library(shiny)
library(shinydashboard)


shinyUI(dashboardPage(
  dashboardHeader(title = "coinr"),

  dashboardSidebar(
    sidebarMenu(
      menuItem("Portfolio", tabName = "portfolio", icon = icon("money")),
      menuItem("Historical rates", tabName = "history", icon = icon("calendar")),
      menuItem("Source", href = "//github.com/oleskiewicz/coinr", icon = icon("code"))
    )
  ),

  dashboardBody(
    tabItems(
      tabItem(
        tabName = "portfolio",

        fluidRow(
          valueBoxOutput("balance", width = 4),
          box(
            plotOutput("portfolio.bands", height = "80px"),
            width = 8
          )
        ),

        fluidRow(
          box(
            title = "Market cap",
            plotOutput("portfolio.current")
          ),
          box(
            title = "Balanced",
            plotOutput("portfolio.balanced")
          )
        ),

        fluidRow(dataTableOutput("coins"))
      ),

      tabItem(
        tabName = "history",

        fluidRow(
          valueBoxOutput("minprice", width=6),
          valueBoxOutput("maxprice", width=6)
        ),

        fluidRow(dygraphOutput("btcprice"))
      )
    )
  )
))
