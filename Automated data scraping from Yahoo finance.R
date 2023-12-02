
pacman::p_load(tidyverse, 
               xml2, 
               rvest, 
               robotstxt,
               shiny,
               janitor,
               scico,
               shinythemes) 
# 1. Listing URLs
yahoo_finance_url_list <- c(
  "https://finance.yahoo.com/world-indices/",
  "https://finance.yahoo.com/commodities/",
  "https://finance.yahoo.com/trending-tickers/"
)

# 2. Writing Function
get_market_data <- function(url){
  tables <- read_html(url) %>%
    html_nodes(xpath='//*[@id="list-res-table"]/div[1]/table') %>%
    html_table()
  return(tables)
}

# 3. Automate with purrr
result_list <- map(yahoo_finance_url_list, get_market_data)

# 4. Write a function to clean names
get_NLC <- function(table){
  NLC <- table %>% 
    select(Name, `Last Price`, `% Change`)
  # name, last price change
  names(NLC) <- janitor::make_clean_names(names(NLC))
  return(NLC)
}

# Apply get_NLC to each table in each list
cleaned_table <- map(result_list, ~map(., get_NLC))
cleaned_table

