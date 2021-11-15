#Fourth#

#Required packages#
#Restart R after each script so the packages load properly! (Ctrl+Shift+F10)#

install.packages("readr")
library(readr)

# In this case we deal with decennially observations, which aren't handled
# correctly by the td() function from the "tempdisagg" package! The "zoo"
# package contains a function na.spline() which utilizes a cubic spline
# interpolation to replace missing values in the dataset. Here we want to
# interpolate the years between each survey date (i.e. the years 1 to 9 of each
# respective decade).
install.packages("zoo",repos = "http://cran.us.r-project.org")
library(zoo)

install.packages("tempdisagg",repos = "http://cran.us.r-project.org")
install.packages("tsbox",repos = "http://cran.us.r-project.org")
library(tempdisagg)

##IMPORTANT NOTE:##
# Temporal disaggregation, as performed here for each U.S. state, is a very
# computationally intensive process that can take several minutes even on fast
# computers. To save local resources and especially time, the script was
# therefore designed to be run in the batch job system of the HPC cluster of the
# RRZ, called "Hummel". Access to the cluster was done via the terminal software
# "MobaXTerm".

#Load in the data directly from the weg-source
apportionment <- read_csv("https://www2.census.gov/programs-surveys/decennial/2020/data/apportionment/apportionment.csv")
#Subset the data for observations of the federal states
apportionment <- apportionment[apportionment$`Geography Type`=="State",]

#Generate a list of all states with Virginia, as our treatment-unit on top
states <- unique(apportionment$Name)
states <- states[-which(states=="Virginia")]
states <- c("Virginia",states)

#Subset in a separate dataframe the relevant columns for Virigina
Virginia <- data.frame(apportionment[apportionment$Name=="Virginia",1],apportionment[apportionment$Name=="Virginia",3],apportionment[apportionment$Name=="Virginia",4],apportionment[apportionment$Name=="Virginia",6])
#Transform the date-column to a date-format
Virginia$Year <- as.Date(ISOdate(Virginia$Year, 1, 1))
#rename the columns uniformly for later binding of the columns
colnames(Virginia) <- c("State","Time","Population","Density")

#Generate the temporary dataset containing the yearly observations
set <- data.frame(seq.Date(as.Date("1910-01-01"),as.Date("2020-01-01"),"year"))
colnames(set) <- c("Time")
#Merge the available census-data onto the respective year
set <- merge(set,Virginia,by="Time",all=TRUE)
set <- set[,-2]

##Zoo-Package
#Use the spline interpolation to fill the remaining gaps in the yearly series
#for both population level and density
set$Population <- na.spline(set$Population)
set$Density <- na.spline(set$Density)


#Subset the population series and the density series into two separate
#dataframes for the interpolation function
#to run properly
pop <- data.frame(set[,1],set[,2])
colnames(pop) <- c("Time","Value")

dens <- data.frame(set[,1],set[,3])
colnames(dens) <- c("Time","Value")

#Furthermore limit the series for obersvations for the interpolation to run faster
#as we do not need obervations prior to the year 2010

#IMPORTANT: This still takes very long, thus again here the recommendation to
#outsource the task to a HPC-enviroment. For exemplary execution one can limit
#the timespan to "2019-01-01" to shorten the needed computation
#time substantially!

pop <- pop[pop$Time >= "2010-01-01",]
dens <- dens[dens$Time >= "2010-01-01",]

#Execute the Denton-Cholette Interpolation
t_d <- td(pop ~ 1, conversion = "mean", to = "day", method = "denton-cholette", criterion = "proportional", h = 2)
pop <- predict(t_d)

t_d <- td(dens ~ 1, conversion = "mean", to = "day", method = "denton-cholette", criterion = "proportional", h = 2)
dens <- predict(t_d)

#Create the final panel-set where all observations are collected
panel <- merge(pop,dens,by="time")
#Add an group-identifier-column
panel$State <- "Virginia"
colnames(panel) <- c("Date","Population","Density","State")

#Cleanup the Enviroment
rm(dens,pop,set,t_d,Virginia)

#Now we have to repeate the above steps for every state - using a loop
# The process is again very computationally intensive, so it is best to
# outsource it. For exemplary execution, the time span of the "pop" and "dens"
# objects in the loop can be fitted in again (as above)!

for (i in 2:length(states)){
  state <- data.frame(apportionment[apportionment$Name==states[i],1],apportionment[apportionment$Name==states[i],3],apportionment[apportionment$Name==states[i],4],apportionment[apportionment$Name==states[i],6])
  state$Year <- as.Date(ISOdate(state$Year, 1, 1))
  colnames(state) <- c("State","Time","Population","Density")
  
  set <- data.frame(seq.Date(as.Date("1910-01-01"),as.Date("2020-01-01"),"year"))
  colnames(set) <- c("Time")
  set <- merge(set,state,by="Time",all=TRUE)
  set <- set[,-2]
  
  set$Population <- na.spline(set$Population)
  set$Density <- na.spline(set$Density)
  
  pop <- data.frame(set[,1],set[,2])
  colnames(pop) <- c("Time","Value")
  
  dens <- data.frame(set[,1],set[,3])
  colnames(dens) <- c("Time","Value")
  
  pop <- pop[pop$Time >= "2010-01-01",]
  dens <- dens[dens$Time >= "2010-01-01",]
  
  t_d <- td(pop ~ 1, conversion = "mean", to = "day", method = "denton-cholette", criterion = "proportional", h = 2)
  pop <- predict(t_d)
  
  t_d <- td(dens ~ 1, conversion = "mean", to = "day", method = "denton-cholette", criterion = "proportional", h = 2)
  dens <- predict(t_d)
  
  set <- merge(pop,dens,by="time")
  set$State <- states[i]
  colnames(set) <- c("Date","Population","Density","State")
  
  panel <- rbind(panel,set)
}

#Set the working-directory to the folder where the script is currently located!#
#Make sure the directory is writeable!#
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
#Export the results
write.csv(panel,file="POP.csv")