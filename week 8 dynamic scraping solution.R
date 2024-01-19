##############Week08 Automated Data Collection II###############################
###########################Lab Material#########################################
##############################SOCS0100##########################################
# Empty your environment 
rm(list=ls())

# Setup
if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")

pacman::p_load(
  RSelenium,
  rvest,
  purrr,
  dplyr,
  ggplot2,
  plotly,
  countrycode
)

driver <- rsDriver(browser = "firefox",
                   chromever = NULL,
                   port = 4567L)




# Connecting to browser

remote_driver <- driver$client

# Navigating to the page
url <- "https://www.forbes.com/real-time-billionaires"
remote_driver$navigate(url)

webElems <- remote_driver$findElements(using = "xpath", '/html/body/div/div/div/div/div[2]/button[2]')

webElems[[1]]$clickElement()
Sys.sleep(10) # wait for page loading

main <- remote_driver$findElements(using = "css", value = ".fbs-table")
table <- read_html(main[[1]]$getElementAttribute("outerHTML")[[1]]) # get html

table  %>% html_nodes(xpath = "//tr[@class='base ng-scope']")

webElem <- remote_driver$findElement("css", ".scrolly-table")
webElem$sendKeysToElement(list(key = "end"))

main <- remote_driver$findElements(using = "css", value = ".fbs-table")
Sys.sleep(1)
table <- read_html(main[[1]]$getElementAttribute("outerHTML")[[1]]) # get html
table  %>% html_nodes(xpath = "//tr[@class='base ng-scope']")

webElem <- remote_driver$findElement("css", ".scrolly-table")
for (i in 1:50) {
  cat("Scroll", i, "\n")
  webElem$sendKeysToElement(list(key = "end"))
  Sys.sleep(3)
}
driver$server$stop()
main <- remote_driver$findElements(using = "css", value = ".fbs-table")

table <- main[[1]]$getElementAttribute("outerHTML")[[1]] # get html
# get all lines with attributes

# Assuming 'table' is the HTML content
html <- read_html(table)

# Select the rows with class 'base ng-scope'
data <- html %>% html_nodes(xpath = "//tr[@class='base ng-scope']")

# Extract data from each column and create a data-frame with all columns
forbes2023 <- tibble(
  name = data %>% html_nodes(xpath = "//td[@class='name']") %>% html_text(),
  rank = data %>% html_nodes(xpath = "//td[@class='rank']") %>% html_text(),
  money = data %>% html_nodes(xpath = "//td[@class='Net Worth']") %>% html_text(),
  age = data %>% html_nodes(xpath = "//td[@class='age']") %>% html_text(),
  source = data %>% html_nodes(xpath = "//td[@class='source']") %>% html_text(),
  country = data %>% html_nodes(xpath = "//td[@class='Country/Territory']") %>% html_text() 
)

# Replace empty cells with NA for the entire data frame
forbes2023 <- forbes2023 %>% mutate_all(~ ifelse(. == "", NA, .))

# Clean and convert 'money' to numeric
forbes2023$money <- as.numeric(gsub("\\$|B", "", forbes2023$money))


head(forbes2023)

##Bonus: DataViz
# Aggregate money by country
total_money_by_country <- aggregate(money ~ country, data = forbes2023, sum)

# Convert country names to ISO codes for mapping
iso_country <- countrycode(total_money_by_country$country, "country.name", "iso3c")

# Create an interactive choropleth map
plot_ly(
  locations = iso_country,
  z = total_money_by_country$money,
  text = paste("Country: ", total_money_by_country$country, "<br>Net Worth: $", total_money_by_country$money, "B"),
  type = "choropleth",
  colorscale = "Viridis"
) %>%
  layout(
    title = "Billionaires' Wealth Distribution by Country",
    geo = list(
      showframe = FALSE,
      projection = list(type = 'mercator')
    )
  )

