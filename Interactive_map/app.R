# setup----
library(shiny)
pacman::p_load(
  shiny,
  ggplot2,
  dplyr,
  shinythemes,
  tidyverse,
  giscoR,
  mapview,
  sf,
  leafsync,
  leaflet.extras2
) 

options(scipen=999)
data <- read.csv("/Users/chenjiayi/Desktop/Computational/SOCS01006-10/emdat_app.csv")
data<- data%>%
  rename(
    region=country
  )

mapdata <- map_data("world")

data<- left_join(data,mapdata,by="region",relationship = "many-to-many")
view(data)

#Not the set up bit----

ui <- fluidPage(
  theme = shinytheme("superhero"),
  h1("This is an Interactive Map"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        inputId = "year_for_map",
        label = "Select year",
        min = min(data$Year),
        max = max(data$Year),
        value = "1945",
        sep = ""
      ),
      selectInput(
        inputId = "which_statistic",
        label = "Select Death, Injuries or Homelessness",
        choices = c("Deaths", "Injuries", "Homelessness"),
        selected = "Deaths"
      )
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel(
          "Plot - Work in Progress"
        ),
        
        tabPanel(
          "Linechart - Work in Progress"
        ),
        
        tabPanel(
          "Interactive Map",
          plotOutput("interactive_map")
        )
      )
    )
  )
)

server <- function(input, output, session) {
  output$interactive_map <- renderPlot({
    variable <- switch(input$variable,
                       "Deaths" = "deaths",
                       "Injuries" = "injuries",
                       "Homelessness" = "homelessness")
   
        data %>%
        filter(Year == input$year_for_map) %>%
        ggplot(aes(x= long, y= lat,group=group)) +
        geom_polygon(aes(fill=.data[[which_statistic]]), colour="black") 
    })
  
}

shinyApp(ui, server)
