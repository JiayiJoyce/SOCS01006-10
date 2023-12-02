
# 0. Set up: installing packages, remove the # in front of them to run-----

#set working directory
setwd("/Users/chenjiayi/Desktop/Computational/DVHZ3-SOCS0100-Assignment")

#clearing environment
rm(list = ls())

#install Groundhog if it is not installed, remove # to run
 if (!require("groundhog")) {
install.packages("groundhog")
}

#creating the vector pkgs that include all the packages needed for the following task
pkgs <- c("tidyverse", 
          "kableExtra",
          "flextable", 
          "skimr",
          "ggplot2",
          "glue", 
          "janitor", 
          "countrycode")

# install packages as they are available on 2023-11-04, remove # to install
groundhog.library(pkgs, "2023-11-04")
install.packages("devtools")
install.packages("sysfonts")
install.packages("showtext")

library(devtools)
library(sysfonts)
library(showtext)

# install.packages("remotes")
remotes::install_github("MatthewBJane/ThemePark")
library(ThemePark)
head(themepark_themes)

# 1. Part I-A Data Exploration and contextualisation ------------
#importing data
energy_and_fuel <- read_csv("/Users/chenjiayi/Desktop/Computational/DVHZ3-SOCS0100-Assignment/Number of people with and without energy access (OWID based on World Bank, 2021).csv")
#inspecting data
str(energy_and_fuel)
summary(energy_and_fuel)



# 2. Data wrangling--------
#In this section I will create two new subsets: country_percentage_energy_and_fuel and income_based_entity
#make column names machine readable
cleaned_energy_and_fuel<-janitor::clean_names(energy_and_fuel) 
#creating three new columns: total_population, percentage_with_electricity_access and percentage_with_clean_fuel_access
percentage_energy_and_fuel <- cleaned_energy_and_fuel %>% 
  mutate(total_population = number_of_people_with_access_to_electricity +number_of_people_without_access_to_electricity) %>%
  mutate(percentage_with_electricity_access= number_of_people_with_access_to_electricity / total_population) %>%
  mutate(percentage_with_clean_fuel_access= number_with_clean_fuels_cooking/total_population)

#filtering out income-based entity and subsetting them into income_based_entity dataframe
income_based_entity <- percentage_energy_and_fuel %>%
  filter(str_detect(entity, "(?i)high|low|middle") & !str_detect(entity, "excluding")& str_detect(entity, "income"))

#inspecting the dataset
income_based_entity %>%
  group_by(entity) %>%
  summarize(
    avg_access_electircity = mean(percentage_with_electricity_access, na.rm = TRUE) %>% round(2),
    avg_access_fuel = mean(percentage_with_clean_fuel_access, na.rm = TRUE) %>% round(2),
    sd_access_electircity = sd(percentage_with_electricity_access, na.rm = TRUE) %>% round(2),
    sd_access_fuel = sd(percentage_with_clean_fuel_access, na.rm = TRUE) %>% round(2),
  )


#getting a list of all individual country names
country_names <- countrycode::codelist$country.name.en
#filtering out individual countries from the percentage_energy_and_fuel dataset
country_percentage_energy_and_fuel<- percentage_energy_and_fuel%>%
  dplyr::filter(entity %in% country_names)
#renaming entity to country, since there are only individual countries in there now
country_percentage_energy_and_fuel<-country_percentage_energy_and_fuel%>% rename(country=entity)

#function to replace 0 with NA to avoid sharp plunge in data during visualisation
replace_0_with_NA <- function (x) {
  x[x == 0] <- NA
  x
}
#applying this function to all columns in country_percentage_energy_and_fuel
country_percentage_energy_and_fuel <- purrr::map_df(country_percentage_energy_and_fuel,replace_0_with_NA)

#finding out the five most populous countries in 2019
country_percentage_energy_and_fuel%>%
  dplyr::filter(year==2019) %>%
  arrange(desc(total_population)) %>%
  slice(1:5)

top_five_population <- country_percentage_energy_and_fuel %>%
  dplyr::filter(country %in% c("China","India","United States","Indonesia","Pakistan"))
  






# 3. Data Visualisation for income based entities------
options(scipen=999)
create_point_plot <- function(i) {
  income_based_entity %>%
    ggplot(aes_string(x = names(income_based_entity)[2], y = names(income_based_entity)[i]),
           color = "entity") +
    geom_point() +
    geom_smooth(method = "lm", se = TRUE, color = "purple") +  # Add trend lin
    labs(
      title = glue("The Trend of {names(income_based_entity)[i]}"),
      y = glue("{names(income_based_entity)[i]}")
    )+
    scale_color_manual(values = c("blue", "red", "green","yellow","black"))
    
}

plots_list <- map(3:ncol(income_based_entity), create_point_plot)
plots_list
 


# 4. Data visualisation for top five population countries----
options(scipen=999)
ggplot(top_five_population, aes(x = year, y = percentage_with_electricity_access , linetype = country)) + geom_point(colour="pink"
  ) +
  geom_smooth(method = "lm", se = TRUE
              ,colour="skyblue"
              ) +theme_friends()
geom_smooth()
  
