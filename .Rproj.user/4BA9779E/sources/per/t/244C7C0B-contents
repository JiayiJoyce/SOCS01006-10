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
  countrycode,
  ggmap,
  httr,
  gtrendsR,
  osmdata,
  leaflet,
  trendecon
)



bb <- getbb ("beijing china")
london_rst <- opq(bb) %>% #gets bounding box
  add_osm_feature(key = "amenity", value = "school") %>% #searches for charities
  osmdata_sf() #download OSM data as sf (simple features -- spatial data format in R)

head(london_rst$osm_polygons)$name

#select name and geometry for charities
rst_osm_points <- london_rst$osm_points %>% #select point data from downloaded OSM data
  select(name, geometry) #for now just selecting the name and geometry to plot

rst_osm_polygons <- london_rst$osm_polygons %>%
  select(name, geometry)

london_charities <- rbind(rst_osm_points, rst_osm_polygons)


leaflet() %>%
  addPolygons(
    data = london_rst$osm_polygons,
    label = london_rst$osm_polygons$name
  ) %>% 
  addCircles(
    data = london_rst$osm_points,
    label = london_rst$osm_points$name
  ) %>% 
  addProviderTiles("CartoDB.Positron")