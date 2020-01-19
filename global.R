library(dplyr)
library(ggplot2)
library(shiny)
library(shinydashboard)
library(tidyverse)
library(googleVis)
library(maps)
#library(plotly)
#library(readxl)
library(ggthemes)
library(gganimate)


employment_change <- read.csv(file = "./us_state_emplchange_2015-2016.txt", sep = ',', header = TRUE)

#Excluding the United States (combined) data and extracting only the rows with states' total numbers.
df = employment_change %>% 
  filter(., STATE!=0, ENTRSIZE==1)

#Selecting cooumns with percentaage change instead of raw numbers.
df = df %>%
  select(., STATEDSCR, NCSDSCR, PCTCHG_EMPL)

#Changing column name to make them understandable
colnames(df) = c("state.name", "industry.name", "Employment.Change")
#Note: plyr::rename in the previous step does the same job.

#Spreading out industry.name to column-wise.
map.df = df %>%
spread(., industry.name, "Employment.Change")

#Spreading out industry.name to column-wise. - now removed
#df = dcast(setDT(df), state.name ~ industry.name, value.var = c("Establishment.Change", "Employment.Change"))

#Choice option for selectizeInput in ui.R
choice1 = colnames(map.df %>% select(., -state.name, -Total, -`Industries not classified`))
