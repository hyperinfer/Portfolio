#Third#

##IMPORTANT NOTE:##
# Temporal disaggregation, as performed here for each U.S. state, is a very
# computationally intensive process that can take several minutes even on fast
# computers. To save local resources and especially time, the script was
# therefore designed to be run in the batch job system of the HPC cluster of the
# RRZ, called "Hummel". Access to the cluster was done via the terminal software
# "MobaXTerm".

#Required packages#
#Restart R after each script so the packages load properly! (Ctrl+Shift+F10)#
install.packages("readr")
library(readr)

install.packages("tempdisagg",repos = "http://cran.us.r-project.org")
install.packages("tsbox",repos = "http://cran.us.r-project.org")
library(tempdisagg)

install.packages("dplyr",repos = "http://cran.us.r-project.org")
library(dplyr)

#Set the working-directory to the folger where the script is currently located!#
#Make sure the directory is writeable!#
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

###Influenca-Like-Illnesses Data###
##Keep the Dataset in the same location as the script##
##Import-Data##
ILINet <- read_csv("ILINet.csv", 
                   col_types = cols(`UNWEIGHTED ILI` = col_number()))

#Subset on the relevant columns
set <- data.frame(ILINet[,2],ILINet[,3],ILINet[,4],ILINet[,6])

#Transform the year-week format into a more readable format
#The transformationerrors are not relevant for further steps, as we dont use the Date-column
#from this dataframe (see below)
set$Date <- as.Date(paste(set$YEAR, set$WEEK, 1, sep="-"),"%Y-%W-%w")

#Start to Interpolate the Series for Virginia#
#Create a temporary dataframe with the observations for Virginia
temp <- data.frame(seq(as.Date("2010-10-04"),as.Date("2021-07-12"),"week"), set[set$REGION=="Virginia",4])


#The td()-function performs the actual disaggregation
#To limit the needed time for the disaggregation to take place, limit the
#sequence when defining the "temp" object above! For example choose "2020-01-06"
#as the first week of 2020 to shorten the computation!
temp <- temp[temp[,1]>="2020-01-06",]
#Delete this line if you plan on running the script in HPC-Environment to get the full series
#The longer the initial series the better the fit of the interpolation! Thus we
#want to exclude as minimal observations as possible!


#Interpolate the first Series
t_d <- td(temp ~ 1, conversion = "mean", to = "day", method = "denton-cholette", criterion = "proportional", h = 2)
Virginia <- predict(t_d)
#Write the Series in a new dataframe with the region-identifier
table <- data.frame(Virginia,"Virginia")
colnames(table) <- c("Date","ILI","Region")

#Now we look at the other Regions we want to include in our Interpolation
states <- unique(set$REGION)
#Put Virginia on top of the list
states <- states[-which(states=="Virginia")]
states <- c("Virginia",states)
#Remove oversea territories and non-state entities like New York City
states[c(52:55)]
states <- states[-c(52:55)]
#Remove Florida since it has no observations
states <- states[-which(states=="Florida")]

#Check whether all States share the same timespan (a balanced panel)
#This is done with the help of the "group_by" command from the dplyr-package!

set %>% group_by(set$REGION)
set %>% count(set$REGION)
#All States (excluding the ones above) have 563 observations!

#Create the universal time frame#
time <- seq(as.Date("2010-10-04"),as.Date("2021-07-12"),"week")


#Loop over the steps to interpolate the observations statewise and add them to the table#
#This loop takes extremely long to execute on normal machines, thus it is recommended to
#outsource the task to some HPC-Environment!
for (i in 2:length(states)){
  #As above: to shorten the computation you can limit the "temp" object again to
  #some closer date
  temp <- data.frame(time, set[set$REGION==states[i],4])
  t_d <- td(temp ~ 1, conversion = "mean", to = "day", method = "denton-cholette", criterion = "proportional", h = 2)
  temp_2 <- predict(t_d)
  temp_3 <- data.frame(temp_2,states[i])
  colnames(temp_3) <- c("Date","ILI","Region")
  table <- rbind(table,temp_3)
}

#write the results into an exportable format
#the ouput will be locally saved in the same location as the script
write.csv(table,file="ILI.csv")
