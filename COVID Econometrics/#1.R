#First#

###CASES REPORTED BY THE NY-TIMES###

#Required packages#
#Restart R after each script so the packages load properly! (Ctrl+Shift+F10)#
install.packages("dplyr")
install.packages("ggplot2")
install.packages("ggpubr")

#Load in the original dataset directly from the websource
cases <- read.csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv")

library(dplyr)

#Group the panel-set by state
cases <- cases %>% group_by(state) %>% arrange(state,.by_group = TRUE)
#Calculate the cases growth rate#
cases <- cases %>% group_by(state) %>% mutate(Diff = (cases - lag(cases))/lag(cases))
#Calculate the new daily cases#
cases <- cases %>% group_by(state) %>% mutate(Diff2 = (cases - lag(cases)))
#Transform the date into a date-format
cases$date <- as.Date(cases$date)

#Searching for the treatment group#
##Louisiana##
#Curfew from 17/03/20 till 13/04/20#
Louisiana <- cases[cases$state=="Louisiana",]
#Delete first entry since NA
Louisiana <- Louisiana[-1,]

library(ggplot2)
ggplot(data=Louisiana,aes(x=date,y=Diff))+
  geom_line()+
  geom_vline(xintercept = as.numeric(Louisiana$date[which(Louisiana$date=="2020-03-17")]),colour="red")+ 
  geom_vline(xintercept = as.numeric(Louisiana$date[which(Louisiana$date=="2020-04-20")]),colour="red") 


##Ohio##
#Curfew from 19/11/20 till 30/01/21#
Ohio <- cases[cases$state=="Ohio",]
Ohio <- Ohio[-1,]

library(ggplot2)
ggplot(data=Ohio,aes(x=date,y=Diff))+
  geom_line()+
  geom_vline(xintercept = as.numeric(Ohio$date[which(Ohio$date=="2020-11-19")]),colour="red")+ 
  geom_vline(xintercept = as.numeric(Ohio$date[which(Ohio$date=="2021-01-30")]),colour="red") 


##Virginia##
#Curfew from 14/12/20 till 31/01/21#
Virginia <- cases[cases$state=="Virginia",]
Virginia <- Virginia[-1,]

#Plot new cases
library(ggplot2)
library(ggpubr)
ggplot(data=Virginia,aes(x=date,y=Diff2))+
  geom_line()+
  geom_vline(xintercept = as.numeric(Virginia$date[which(Virginia$date=="2020-12-20")]),colour="red")+ 
  geom_vline(xintercept = as.numeric(Virginia$date[which(Virginia$date=="2021-01-31")]),colour="red")+ 
theme_pubr()+
labs(x = "Date", y = "New cases")+
annotate("rect", xmin = as.Date("2020-12-20", "%Y-%m-%d"),
xmax = as.Date("2021-01-31", "%Y-%m-%d"), ymin=-Inf, ymax=Inf, alpha = 1/5, fill = "red")

#Plot total cases
ggplot(data=Virginia,aes(x=date,y=cases))+
  geom_line()+
  geom_vline(xintercept = as.numeric(Virginia$date[which(Virginia$date=="2020-12-20")]),colour="red")+ 
  geom_vline(xintercept = as.numeric(Virginia$date[which(Virginia$date=="2021-01-31")]),colour="red")+ 
  theme_pubr()+
  labs(x = "Date", y = "Total cases")+
  annotate("rect", xmin = as.Date("2020-12-20", "%Y-%m-%d"),
           xmax = as.Date("2021-01-31", "%Y-%m-%d"), ymin=-Inf, ymax=Inf, alpha = 1/5, fill = "red")

##CORELATION COMPARISON##
#Creation of the Correlation-list for later use to select the controlls
#Virginia has been selected as treatment group so cor = 1#

#Generate the baseline table where the case-series are compared in correlation
table <- cases[cases$state=="Virginia",]
table <- data.frame(table$date,table$Diff)
colnames(table) <- c("Date","Virginia")
table <- table[table$Date >= "2020-04-01" & table$Date < "2020-12-14",]

#Generate list of states to work through, with Virigina on top as our treatment-unit
states <- unique(cases$state)
states <- states[-which(states=="Virginia")]
states <- c("Virginia",states)

#Loop through the steps to append the cases for each individual state to the baseline "table"
for (i in 2:length(states)){
  temp <- cases[cases$state==states[i],]
  temp <- data.frame(temp$date,temp$Diff)
  colnames(temp) <- c("Date",states[i])
  temp <- temp[temp$Date >= "2020-04-01" & temp$Date < "2020-12-14",]
  
  table <- merge(table,temp,by="Date")
  
}

#Generate the correlationmatrix
corrmat <- matrix(nrow=length(states),ncol=2)
#Add state-names for identification
corrmat[,1] <- states
#Add the correlation-values to the matrix
for (i in 1:length(states)){
  corrmat[i,2] <- cor(table$Virginia,table[,i+1])
}

#Port the matrix into a dataframe to be later exported to a csv-file
casecorr <- data.frame(corrmat)
#Arrange the dataframe descending base on the correlation values
casecorr <- arrange(casecorr,X2)

#Set the working directory to the folder the script is currently located
#Make sure the directory is writable!
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
#Export the dataframe for later use
write.csv(casecorr,file="correlation.csv")
