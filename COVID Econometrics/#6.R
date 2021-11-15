#Sixth#

##In this script we want to combine the data from all previous scripts into one suitable 
##Panel to be used for the synthetic control method

#Set the working-directory to the folder where the script is currently located!#
#Make sure the directory is writeable!#
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

##Install and load required packages
install.packages("readr")
library(readr)

install.packages("dplyr")
library(dplyr)

#First: Load in the Corona-Cases as the baseline outcome-variable
###CASES REPORTED BY THE NY-TIMES###
#For commentary see the first script!
nytimes <- read.csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv")

nytimes <- nytimes %>% group_by(fips) %>% arrange(fips,.by_group = TRUE)
nytimes <- nytimes %>% group_by(fips) %>% mutate(Diff = (cases - lag(cases))/lag(cases))
nytimes$date <- as.Date(nytimes$date)

panel <- data.frame(nytimes$date,nytimes$state,nytimes$fips,nytimes$Diff)
colnames(panel) <- c("Date","State","ID","New_Cases")

##Covariates##
#1st - ILI#
#Import the output of the third script!
ILI <- read_csv("ILI.csv")
#Subset for the relevant columns
temp <- data.frame(ILI$Date,ILI$Region,ILI$ILI)
colnames(temp) <- c("Date","State","ILI")
#Transform the date-column into a date-format again, since the import does not
#handle this correctly
temp$Date <- as.Date(temp$Date)

#Merge both dataframes on Date and State#
panel <- merge.data.frame(panel,temp,by = c("Date","State"))
#Remove temporary dataframe#
rm(temp)

#2nd - Population/Density#
#Import the output of the fourth script!
POP <- read_csv("POP.csv")
temp <- data.frame(POP$Date,POP$State,POP$Population,POP$Density)
colnames(temp) <- c("Date","State","Population","Density")
#Transform the date-column into a date-format again, since the import does not
#handle this correctly
temp$Date <- as.Date(temp$Date)

#Merge both dataframes on Date and State#
panel <- merge.data.frame(panel,temp,by = c("Date","State"))
#Remove temporary dataframe#
rm(temp)

#3rd - Temperature#
#Import the output of the fifth script!
TEMP <- read_csv("TEMP.csv")
temp <- data.frame(TEMP$Time,TEMP$State,TEMP$Temperature)
colnames(temp) <- c("Date","State","Temperature")
#Transform the date-column into a date-format again, since the import does not
#handle this correctly
temp$Date <- as.Date(temp$Date)

#Merge both dataframes on Date and State#
panel <- merge.data.frame(panel,temp,by = c("Date","State"))
#Remove temporary dataframe#
rm(temp)

#Arrange the final panel by the states ID
panel <- arrange(panel,ID)

#Set the working-directory to the folder where the script is currently located!#
#Make sure the directory is writeable!#
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
#Export the results
write.csv(panel,file="PANEL.csv")
