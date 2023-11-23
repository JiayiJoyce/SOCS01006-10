
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
library(devtools)
library(sysfonts)
library(showtext)
library(ThemePark)


options(scipen=999)
data <- read.csv("/Users/chenjiayi/Desktop/Computational/SOCS01006-10/emdat_app.csv")
data<- data%>%
  rename(
    region=country
  )

mapdata <- map_data("world")

combined_dataset<- left_join(data,mapdata,by="region")
  # filter(!is.na(data$deaths))

map1 <- combined_dataset %>%
  filter(Year == 2015) %>%
  ggplot(aes(x = long, y = lat, group=group)) +
  geom_polygon(aes(fill = deaths), colour = "black")+
  # scale_fill_gradient2(name= "number of deaths",low="green",mid="yellow",high="red",na.value="grey50",guide = "colourbar",midpoint=2500)
  scale_fill_distiller(
    name = "number of deaths",
    palette = "RdYlGn",  # You can choose a different palette if needed
    na.value = "grey50", guide = "colourbar"
  )
  theme_barbie()+
  theme(
    legend.position = "bottom"
  )

# Display the plot
print(map1)


print(combined_dataset %>%
        filter(Year == 2013) %>%
        filter(is.na(long) | is.na(lat)))

