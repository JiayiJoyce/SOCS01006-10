pacman::p_load(tidyverse, # tidyverse pkgs including purrr
               purrr, # automating 
               xml2, # parsing XML
               rvest, # parsing HTML
               robotstxt,
               janitor,
               dplyr,
               plotly)

paths_allowed(paths="https://finance.yahoo.com/world-indices/?guccounter=1")

yahoo_finance_url <- "https://finance.yahoo.com/world-indices/?guccounter=1"
parsed <- read_html(yahoo_finance_url)

parsed.sub <- html_element(parsed, xpath = '//*[@id="list-res-table"]/div[1]/table')

table.df <- html_table(parsed.sub)   
head(table.df)


NLC<-table.df%>% 
  select(Name,`Last Price`,`% Change`)
#name,last price change
names(NLC) <- janitor::make_clean_names(names(NLC))
head(NLC)

#can scrape the table directly through html_nodes
# alternative to scraping entire- can scrape individual function- retrieve each coloum as a list
#then combine each one as a list

# NLC<-NLC[order(NLC$last_price),]


NLC$percent_change <-as.numeric(gsub("%","",NLC$percent_change))
plot_ly(NLC,x=~name, y=~last_price, type='bar',color = ~percent_change) %>%
  layout(title="Stock indices prices and changes",
         xaxis= list(title="Name"),
         yaxis= list(title="price"))

