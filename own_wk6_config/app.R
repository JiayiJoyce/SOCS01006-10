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

#data<- left_join(mapdata,data, by="")
#shinyapp shift tab to add basic structure
#UI----

ui <- fluidPage(
  fluidPage(theme = shinytheme("superhero"),
            #fluidPage(theme = shinytheme("cerulean")
  
  h1("This is my own work"),
  
  navlistPanel( 
    "All that data",
    
    tabPanel("About",h3("This should be a brief introduction of the data"),
             br(),
             "This is a fintered dataset that displays the death, injuries and homelessness by country by year"
             
             ),
    
    tabPanel("Data Summary",
             verbatimTextOutput("summarized_data"),
             ),
    
    
    "Plots",
    #week6 -----
    tabPanel("Wk6 Line-The one used in class",
             
             selectInput(
               inputId = "country",
               label = "Select country",
               choices = unique(data$region),
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
               step = 3,
               sep = ""
             ),
             plotOutput("classplot")
    ),
             
             # selectInput(----
             #   inputId = "continents_map",
             #   label = "Select continents",
             #   choices= c("Asia","Europe","Africa","North America","South America","Oceania"),
             #   selected = "Europe"
             # ),
             # textOutput("interactive_map")
             
 #draft 1----            
             ),
    
    tabPanel("Death"),
    tabPanel("Additional ones just in case"),
    tabPanel("Additional ones just in case"),
    tabPanel("Additional ones just in case"),
    tabPanel("Additional ones just in case")
  )
)



server <- function(input, output, session) {
  output$summarized_data<- renderPrint(summary(data))
  
  output$classplot <- renderPlot({
    variable <- switch(input$variable,
                       "Deaths" = "deaths",
                       "Injuries" = "injuries",
                       "Homelessness" = "homelessness")
    
    data %>%
      filter(region == input$country, 
             Year >= input$year_range[1], 
             Year <= input$year_range[2]) %>%
      
      ggplot(aes(Year, .data[[variable]])) +#plot each variable here over years
      geom_line() +
      labs(y = input$variable)
  })
  
  # output$interactive_map <- renderText(
  #   if (input$continets_map == "Europe"){
  #     "currently working on it!"
  #   } 
  #   else{
  #     "sorry, this isn't finalized yet"
  #   }
  #  ) 
    
  
}
shinyApp(ui,server)
