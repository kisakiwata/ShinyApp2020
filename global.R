library(plyr)
library(tidyr)
library(dplyr)
library(ggplot2)
library(shiny)
library(shinydashboard)
library(googleVis)
library(maps)
#library(plotly)
#library(readxl)
library(ggthemes)
library(gganimate)


#####This is for first plot and state map, using 2015-2016 data

employment_change <- read.csv(file = "./us_state_emplchange_2016.txt", sep = ',', header = TRUE)

#Excluding the United States (combined) data and extracting only the rows with states' total numbers.
df = employment_change %>% 
  dplyr::filter(., STATE!=0, ENTRSIZE==1)

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
choice1 = colnames(map.df %>% select(., -state.name, -`Industries not classified`))


######### This is for the second plot #########

#Excluding the United States (combined) data and extracting only the rows with states' total numbers.
ent.df = employment_change %>% 
  dplyr::filter(., STATE!=0)


#Selecting columns and renaming them.
ent.df = ent.df %>%
  select(., STATEDSCR, ENTRSIZE, NCSDSCR, PCTCHG_ESTB, PCTCHG_EMPL) %>% 
  plyr::rename(., c("STATEDSCR"="state.name", "ENTRSIZE"="enterprise.size", "NCSDSCR"="industry.name", "PCTCHG_ESTB"="Establishment.Change", "PCTCHG_EMPL"="Employment.Change"))

################ Plot for 2010 - 2016 from all the text files
#### moved to OUTPUT file
files = list.files(pattern="*.txt")


# First apply read.csv, then rbind
handle_each <- function(x){
  year <- as.numeric(gsub("[^0-9]+", "", x),perl=TRUE) 
  temp <- read.csv(x, header = FALSE, sep = ',', stringsAsFactors = FALSE)
  temp$year <- year
  return(temp)
}
myfiles = do.call(rbind, lapply(files, handle_each))

#################

#Change the files to data frame.
df2 = as.data.frame.table(myfiles)


#df2 = as.data.frame.table(read.csv("./df2.csv"))

#Removing old column names
df2 <- df2[-1, ]

# changing names
df2 = df2 %>%
select(., Freq.V29, Freq.V3, Freq.V30, Freq.V8, Freq.V9, Freq.V23, Freq.V24, Freq.V25, Freq.V26, Freq.V27, Freq.V28, Freq.year) %>%
plyr::rename(., c("Freq.V29"="state.name", "Freq.V3"="enterprise.size", "Freq.V30"="industry","Freq.V8"="Net.Change.Est", "Freq.V9"="Net.Change.Emp", "Freq.V23"="Establishment.change", "Freq.V24"="Employment.change", "Freq.V25"="Employment.birth", "Freq.V26"="Employment.death", "Freq.V27"="Employment.expansion", "Freq.V28"="Employment.contraction", "Freq.year"="year"))


df3 = df2 %>%
  dplyr::filter(., state.name == "United States") %>% 
  dplyr::filter(., industry=="Total") %>% 
  slice(., 1:56) %>% 
  select(., year, enterprise.size, Net.Change.Est, Net.Change.Emp) %>% 
  gather(., key="Type", value="Net.Change", Net.Change.Est, Net.Change.Emp)

df3$Net.Change = as.numeric(as.character(df3$Net.Change))
df3$enterprise.size = as.numeric(as.character(df3$enterprise.size))

#Choice option for time series plot in ui.R
choice2 = 1:8



