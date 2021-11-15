#Seventh#

###EXECUTION OF THE SYNTHETIC CONTROLL ESTIMATION###

# An immense help and orientation for writing this script is the material from
# the book "Causal Inference: The Mixtape." written by Scott Cunningham and
# published in 2021. The material belongs to the chapter "Synthetic Control" and
# is freely available via a Google Collaboratory under the link
# https://colab.research.google.com/github/scunning1975/mixtape_learnr/blob/main/R_ipynb/Synthetic_Control.ipynb#scrollTo=respected-appendix

#Install and load required packages
install.packages("tidyverse")
install.packages("cli")
install.packages("haven")
install.packages("stargazer")
install.packages("robustbase")
install.packages("Synth")
install.packages("devtools")
devtools::install_github("bcastanho/SCtools")

library(haven)
library(tidyverse)
library(stargazer)
library(Synth)
library(SCtools)

install.packages("plm")
library(plm)

install.packages('R.utils')
library(data.table)

#Set the working-directory to the folder where the script is currently located!#
#Make sure the directory is writeable!#
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#Read in the panel we created in the sixth script
PANEL <- read_csv("PANEL.csv")
#Port the dataset into a pure dataframe for better compliance!
PANEL <- as.data.frame(PANEL)

#We subset the Panel for Dates after the first of April 2020 since then every U.S. State hat at
#least one recorded corona case!

PANEL <- PANEL[PANEL$Date >= "2020-04-01",]

#Secondary we can subset for Dates before the 31st of December 2020 to create a balanced Panel

PANEL <- PANEL[PANEL$Date <= "2020-12-31",]


#The package "plm" encompasses some functions for the evaluation of panel datasets
#Check if our Dataset really is balanced
is.pbalanced(PANEL,index = "ID")

#Find out which ID our Treatment-group has
PANEL$ID[which(PANEL$State=="Virginia")[1]]
#Virginia = 51

#Find out which IDs our Controls have
#The code is largely copied here from the second script. For commentary see there!
#Controls:
t <- fread("https://github.com/saudiwin/corona_tscs/raw/master/data/CoronaNet/data_bulk/coronanet_release.csv.gz")

USA <- t[t$ISO_A3=="USA"]
States <- unique(USA$province)
States <- States[-which(States=="")]

Curfew <- USA[USA$type=="Curfew"]
Curfewstates <- unique(Curfew$province)

NoCurfewstates <- setdiff(States,Curfewstates)

#This is our Set of potential Control-Units, some of which can be removed beforehand because of 
#obvious differences
NoCurfewstates

#Remove D.C. preemtively since it isn't a conventional state
controls <- NoCurfewstates[-which(NoCurfewstates=="Washington, D.C.")]
#Remove Alaska since it is not connected with Mainland U.S. and hast vastly different
#environmental conditions
controls <- controls[-which(controls=="Alaska")]

#We now want to ensure that our chosen controls fulfil the
#common trend assumption critically in the case-rate
#Import the csv created in the second script!
correlation <- read_csv("correlation.csv")
correlation <- correlation[,-1]
colnames(correlation) <- c("State","Corr")

#Generate the baseline-list of controls
controls <- data.frame(controls,rep(NA))
colnames(controls) <- c("State","ID")
#Append the correlation-results from the csv above!
controls <- merge.data.frame(controls,correlation,by="State")

#Add the states-ID into the controll-list as later the name and id is needed!
for (i in 1:length(controls$State)){
  controls$ID[i] = PANEL$ID[which(PANEL$State==controls$State[i])[1]]
}

#Florida is not present in the final panel, mainly because the ILI-Meassure we
#want to use wasn't recorded in Florida

controls <- na.omit(controls)
attr(controls,"na.action") <- NULL

#Arrange the control-list by its correlation value!
controls <- arrange(controls,desc(Corr))

#Since the dataprep()-function can't use Date-format Dates we convert them to numeric
PANEL$Date <- as.numeric(PANEL$Date)

#Extract final selected controls
controls_selected = controls[1:22,]
write.table(controls_selected, "controls_selected.txt", quote = F, sep= "\t", row.names = F)

#Generate the needed dataprep object
dataprep_out <- dataprep(
  foo = PANEL,
  predictors = c("ILI","Population","Density","Temperature"),
  predictors.op = "mean",
  time.predictors.prior = seq(as.Date("2020-04-01"),as.Date("2020-12-13"),"day"),
  dependent = "New_Cases",
  unit.variable = "ID",
  unit.names.variable = "State",
  time.variable = "Date",
  treatment.identifier = 51,
  controls.identifier = controls$ID[1:22],
  time.optimize.ssr = seq(as.Date("2020-04-01"),as.Date("2020-12-13"),"day"),
  time.plot = seq(as.Date("2020-12-07"),as.Date("2020-12-21"),"day")
)

#Estimate the synthetic control
synth_out <- synth(data.prep.obj = dataprep_out)

#Write tables
v_results<-synth_out[[1]]
w_results<-as.data.frame(synth_out[[2]])
w_results$ID<-rownames(w_results)
#Merge with states
controls_selected<-controls_selected[,-3]
w_results<-merge(controls_selected,w_results,by="ID")
#Save tables
write.table(v_results, "v_results.txt", quote = F, sep= "\t", row.names = T)
write.table(w_results, "w_results.txt", quote = F, sep= "\t", row.names = F)


#IMPRORTANT: The Scripts 7_a, 7_b and 7_c generate some necessary functions for
#the creation of the graphs and plots below. Execute all the cripts in their
#chronological order (a,b,c) step by step before continuing!


#Generate plots
cli::cli_h1("Path Plot")
path.plot(synth_out, dataprep_out,Legend.position = "bottom")
#Modify the function for plotting
#Separate script creating the function has to be run prior to plotting
#create a new custom function path.plot_modify
path.plot_modify(synth_out, dataprep_out,Legend.position = "bottomright", Xlab = "Date")

cli::cli_h1("Gap Plot")
gaps.plot(synth_out, dataprep_out)
#Separate script creating the function has to be run prior to plotting
#create a new custom functin gaps.plot_modify
gaps.plot_modify(synth_out, dataprep_out,Xlab = "Date", Ylab = "Difference between growth rates (percentage points)")

cli::cli_h1("Placebos")
placebos <- generate.placebos(dataprep_out, synth_out, Sigf.ipop = 3)
placebos$t1 <-as.Date("2020-12-14")
placebos$df$year<-as.Date(placebos$df$year)
#Plotting function still plots x-axis as numeric
plot_placebos(placebos)
#Pass date information separately and create a new custom function plot_placebos_modify
#Modify the function for plotting
#Separate script creating the function has to be prior to plotting
years<-as.Date(placebos$df$year)
myt1<-as.Date("2020-12-14")
plot_placebos_modify(placebos, ylab = "MSPE", xlab = "Date")


## Test how extreme was the observed treatment effect given the placebos
ratio <- mspe.test(placebos)
ratio$p.val

#Plot
mspe.plot(placebos, discard.extreme = F, plot.hist = FALSE, ylab = "Controls",xlab = "Post/Pre RMSPE ratio")

#Now create a path plot for appendix - extended time
#Important: run 7_d script now and than continue with the lines
#Changing our dataprep_out so it would contain all the timeframe within time.plot var
dataprep_out <- dataprep(
  foo = PANEL,
  predictors = c("ILI","Population","Density","Temperature"),
  predictors.op = "mean",
  time.predictors.prior = seq(as.Date("2020-04-01"),as.Date("2020-12-13"),"day"),
  dependent = "New_Cases",
  unit.variable = "ID",
  unit.names.variable = "State",
  time.variable = "Date",
  treatment.identifier = 51,
  controls.identifier = controls$ID[1:22],
  time.optimize.ssr = seq(as.Date("2020-04-01"),as.Date("2020-12-13"),"day"),
  time.plot = seq(as.Date("2020-04-01"),as.Date("2020-12-31"),"day")
)
synth_out <- synth(data.prep.obj = dataprep_out)
#Plotting the new extended path
path.plot_modify(synth_out, dataprep_out,Legend.position = "bottomright", Xlab = "Date")

