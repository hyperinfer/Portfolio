#Second#

###COVID POLICIES AND MEASSURES###

#Set the working-directory to the folger where the script is currently located!#
#Make sure the directory is writeable!#
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#Required packages#
#Restart R after each script so the packages load properly! (Ctrl+Shift+F10)#
install.packages('R.utils')
install.packages("openxlsx")
install.packages("Rtools")

#Load the required dataset from CoronaNet
#Since the original data is stored in a gz.archive-format we need a special
#package to download it directly
library(data.table)
#Filedownload directly from websource
t <- fread("https://github.com/saudiwin/corona_tscs/raw/master/data/CoronaNet/data_bulk/coronanet_release.csv.gz")

#We now want to just look at the United States of America
USA <- t[t$ISO_A3=="USA"]
#Since our unit of observation are the 52 federal states we make a list for further comparrison
States <- unique(USA$province)
States
#As we see on entry is empty, which denotes a policy action by the federal government
#Since the federal government isnt a state we delete the entry
States <- States[-which(States=="")]
States

#We further Subset the country by states with some curfew-policy
Curfew <- USA[USA$type=="Curfew"]
#And list those states
Curfewstates <- unique(Curfew$province)

#Through the difference between the States-list and the Curfewstates-list we can
#no identify the No-Curfew-States
NoCurfewstates <- setdiff(States,Curfewstates)

#Make a table of curfew and no curfew states
all_states<- data.frame(NoCurfewstates=NoCurfewstates,Curfewstates=c(Curfewstates,rep(NA,16)))
#Saving a table
write.table(all_states, "curfew_states.txt", quote = F, sep= "\t", row.names = F)

#Furthermore the now left states should not have enacted any Curfew-policies below state level
#We filter those who did
Curfew <- Curfew[Curfew$init_country_level=="Municipal"]
temp <- unique(Curfew$province)
#We now have a first list of Treatment-Contestants, as in states who through a
#first filtration of the data might be a good treatment-group
Contestants <- setdiff(Curfewstates,temp)
rm(temp,Curfew)
Contestants

#By manual identification Louisiana, Ohio and Virginia remain possible Treamtent-Contestants
Louisiana <- USA[USA$province=="Louisiana"]
Ohio <- USA[USA$province=="Ohio"]
Virginia <- USA[USA$province=="Virginia"]

##Virginia##
#three month before:  14/09/20
#one month after:   31/02/21
Virginia <- Virginia[Virginia$date_start>="2020-07-14",]

