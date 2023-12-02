
pacman::p_load(tidyverse, 
               xml2, 
               rvest, 
               robotstxt,
               shiny,
               janitor,
               scico,
               shinythemes) 

# 1. get url
yahoo_finance_url<- "https://finance.yahoo.com/world-indices/"
# 2. Parse the webpage
parsed_yahoo_finance_webpage <- read_html(yahoo_finance_url)
# 3. Parse subsections in webpage
parsed_world_indices <- html_element(parsed, xpath = '//*[@id="list-res-table"]/div[1]/table')
# 4. Organize parsed subsections into table data
table.df <- html_table(parsed_world_indices)   


# 1.Writing Function
get_market_data <- function()




  
  
  
  
  
  #UI----
ui <- fluidPage(
  theme= shinytheme("superhero"),
  sidebarLayout(
    sidebarPanel(
      titlePanel("Scraped Yahoo finance data"),
      selectInput(
        inputId = "Market",
        label = "select the Market you would like to view",
        choices = c("World Indices", "Trending Tickers","Futures")
      )
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Greatest Increase"),
        tabPanel("Greatest Decrease"),
        tabPanel("top 10 by price")
      )
      
      
      )
    )
  )











#Server----
server <- function(input, output, session) {
}
shinyApp(ui, server)