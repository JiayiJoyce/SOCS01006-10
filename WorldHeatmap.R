
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
  )%>%
  filter(Year==1969)%>%
  as_tibble()
data%>%
  print(n=48)

mapdata <- map_data("world")

# mapdata

combined_dataset<- left_join(mapdata,data,by="region")#修改了leftjoin顺序，不知道怎么地图就全了
    # filter(is.na(long) | is.na(lat))%>%
    # as_tibble()
combined_dataset



map1 <- combined_dataset %>%
  ggplot(aes(x = long, y = lat, group=group)) +
  geom_map(
    aes(map_id=region),
    map = combined_dataset,
    colour="black"
  )+
  geom_polygon(
    aes(group=group,
        fill=deaths),
    colour="black"
  )+
  scale_fill_continuous(low = "lightblue",high="lightpink")
  theme_minimal()

print(map1)




