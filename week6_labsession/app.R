#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# setup----
install.packages("shiny")
library(shiny)
if (!require("pacman")) {
  install.packages("pacman")
}

pacman::p_load(
  shiny,
  ggplot2,
  dplyr) 

options(scipen=999)
data <- read.csv("/Users/chenjiayi/Desktop/Computational/SOCS01006-10/emdat_app.csv")


