#Fifth#

###AVG. MONTHLY TEMPERATURE###

##IMPORTANT NOTE:##
# Temporal disaggregation, as performed here for each U.S. state, is a very
# computationally intensive process that can take several minutes even on fast
# computers. To save local resources and especially time, the script was
# therefore designed to be run in the batch job system of the HPC cluster of the
# RRZ, called "Hummel". Access to the cluster was done via the terminal software
# "MobaXTerm".

#Required packages#
#Restart R after each script so the packages load properly! (Ctrl+Shift+F10)#

library(readr)

install.packages("tempdisagg",repos = "http://cran.us.r-project.org")
install.packages("tsbox",repos = "http://cran.us.r-project.org")
library(tempdisagg)

# The Data for the average monthly temperature can only be loaded as separate
# files per state, with a respective URL. The imported list contains the
# respective URLs to access the files. The list itself was created by hand.
TEMP_URLS <- read_csv("TEMP_URLS.txt", 
                      col_names = FALSE)
#Port the list into a string vector
urls <- unname(unlist(TEMP_URLS))

#Starting with Virginia as our Treatmentgroup
Virginia <- read.csv(urls[which(urls=="Virginia")+1])
#The first four rows contain unimportant information, thus removing them
Virginia <- Virginia[-(1:4),]
#The function imports the date-column as the rownames for some reason, fix this
#by creating a separate column
Virginia$Date <- row.names(Virginia)
#Now get the columns back into the right order
Virginia <- data.frame(Virginia$Date,Virginia$Average.Temperature)
#Change the columnnames for uniformity
colnames(Virginia) <- c("Time","Value")

#The original Date is in an non-standard format
#We thus have to paste the individual numbers together to make a conversion to a
#standard Date-format possible
for (i in 1:length(Virginia$Time)){
  year <- substr(Virginia$Time[i],1,4)
  month <- substr(Virginia$Time[i],5,6)
  day <- c("01")
  Virginia$Time[i] <- paste(year,month,day,sep="-")
}

#Now the standard as.Date() function can identify the character string
Virginia$Time <- as.Date(Virginia$Time,origin="1970-01-01")
#Port the Virgina dataset into an pure dataframe object, for better compliance
Virginia <- data.frame(unlist(Virginia$Time),as.numeric(unlist(Virginia$Value)))
colnames(Virginia) <- c("Time","Value")

#Furthermore limit the series for obersvations for the interpolation to run faster
#as we do not need obervations prior to the year 2010

#IMPORTANT: This still takes very long, thus again here the recommendation to
#outsource the task to a HPC-enviroment. For exemplary execution one can limit
#the timespan to "2019-01-01" to shorten the needed computation
#time substantially!
Virginia <- Virginia[Virginia$Time >= "2010-01-01",]
####

#Execute the interpolation
t_d <- td(Virginia ~ 1, conversion = "mean", to = "day", method = "denton-cholette", criterion = "proportional", h = 2)
Virginia <- predict(t_d)

#Create a identifier column
Virginia$State <- urls[which(urls=="Virginia")]
#Create the baseline panel to later be exported
panel <- data.frame(Virginia)
colnames(panel) <- c("Time","Temperature","State")

#Since we did Virginia beforehand we remove it from our list
#The name identifier
urls <- urls[-which(urls=="Virginia")+1]
#and the url
urls <- urls[-which(urls=="Virginia")]

#Now we repeate the above steps for all states
#Important here is the count requirement for "i" as i should do steps of two to
#always get the url of the current state

for (i in seq(2,length(urls),by=2)){
  state <- read.csv(urls[i])
  state <- state[-(1:4),]
  state$Date <- row.names(state)
  state <- data.frame(state$Date,state$Average.Temperature)
  colnames(state) <- c("Time","Value")
  
  for (j in 1:length(state$Time)){
    year <- substr(state$Time[j],1,4)
    month <- substr(state$Time[j],5,6)
    day <- c("01")
    state$Time[j] <- paste(year,month,day,sep="-")
  }
  
  state$Time <- as.Date(state$Time,origin="1970-01-01")
  
  state <- data.frame(unlist(state$Time),as.numeric(unlist(state$Value)))
  colnames(state) <- c("Time","Value")
  
  #IMPORTANT: This still takes very long, thus again here the recommendation to
  #outsource the task to a HPC-enviroment. For exemplary execution one can limit
  #the timespan to "2019-01-01" to shorten the needed computation
  #time substantially!
  state <- state[state$Time >= "2010-01-01",]
  
  t_d <- td(state ~ 1, conversion = "mean", to = "day", method = "denton-cholette", criterion = "proportional", h = 2)
  state <- predict(t_d)
  
  state$State <- urls[i-1]
  
  colnames(state) <- c("Time","Temperature","State")
  
  panel <- rbind(panel,state)
  
}

#Set the working-directory to the folder where the script is currently located!#
#Make sure the directory is writeable!#
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
#Export the results
write.csv(panel,file="TEMP.csv")