# Week 6 lecture----
# setup----

library(shiny)
if (!require("pacman")) {
  install.packages("pacman")
}

pacman::p_load(
  shiny,
  ggplot2,
  dplyr) 

options(scipen=999)
data <- read.csv("/Users/chenjiayi/Desktop/Computational/SOCS01006-10/emdat_app.csv")

#the UI ----
ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "darkly"),
  h1("Disaster statistics trends"),
  sidebarLayout(
    

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
        step = 7,
        sep = ""#put space and removes coma
     
      )
    ),
    
    # Main panel
    mainPanel(
      plotOutput("plot")
      
    )
  )
)

# the server-----
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
      
      ggplot(aes(Year, .data[[variable]])) +#plot each variable here over years
      geom_line() +
      labs(y = input$variable)
  })
  
  
}

shinyApp(ui, server)



# identify peak, andscrape year