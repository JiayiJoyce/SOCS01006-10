#
# Week 06 Lab Problem Set 
# Disaster Statistics Trend App based on EMDAT dataset
#
# 
#
#    
#
# SETUP
if (!require(shiny)) install.packages("shiny")
if (!require(ggplot2)) install.packages("ggplot2")
if (!require(dplyr)) install.packages("dplyr")

library(shiny)
library(ggplot2)
library(dplyr)

# Read data from CSV
data <- read.csv("/Users/chenjiayi/Downloads/emdat_app.csv")

ui <- fluidPage(
  
  # Header
  h1("Disaster statistics trends"),
  
  # Sidebar layout
  sidebarLayout(
    
    # Sidebar panel
    sidebarPanel(
      selectInput(
        inputId = "country",
        label = "Select country",
        choices = unique(data$country),
        selected = "Belgium"
      ),
      
      selectInput(
        inputId = "variable",
        label = "Select variable",
        choices = c("Deaths", "Injuries", "Homelessness"),
        selected = "Deaths"
      ),
      
      sliderInput(
        inputId = "year_range",
        label = "Select year range",
        min = min(data$Year),
        max = max(data$Year),
        value = c(min(data$Year), max(data$Year)),
        step = 1,
        sep = ""
      )
    ),
    
    # Main panel
    mainPanel(
      plotOutput("plot")
    )
  )
)

server <- function(input, output, session) {
  
  output$plot <- renderPlot({
    variable <- switch(input$variable,
                       "Deaths" = "deaths",
                       "Injuries" = "injuries",
                       "Homelessness" = "homelessness")
    
    data %>%
      filter(country == input$country, 
             Year >= input$year_range[1], 
             Year <= input$year_range[2]) %>%
      ggplot(aes(Year, .data[[variable]])) +
      geom_line() +
      labs(y = input$variable)
  })
  
}

shinyApp(ui, server)

