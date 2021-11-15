##Probit
install.packages('tempdisagg')
install.packages('aod')
install.packages('stargazer')
install.packages("sandwich")
library(stargazer)
library(lmtest)
library(sandwich)
library(car)
library(dplyr)


##GSADF-Panel

library(readxl)
Eins <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Australien.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Eins$ID <- c(rep(1))
Zwei <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Belgien.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Zwei$ID <- c(rep(2))
Drei <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Daenemark.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Drei$ID <- c(rep(3))
Vier <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Deutschland.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Vier$ID <- c(rep(4))
Funf <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_England.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Funf$ID <- c(rep(5))
Sechs <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Estland.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Sechs$ID <- c(rep(6))
Sieben <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Finnland.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Sieben$ID <- c(rep(7))
Acht <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Frankreich.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Acht$ID <- c(rep(8))
Neun <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Griechenland.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Neun$ID <- c(rep(9))
Zehn <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Irland.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Zehn$ID <- c(rep(10))
Elf <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Island.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Elf$ID <- c(rep(11))
Zwolf <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Italien.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Zwolf$ID <- c(rep(12))
Dreizehn <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Israel.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Dreizehn$ID <- c(rep(13))
Vierzehn <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Italien.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Vierzehn$ID <- c(rep(14))
Funfzehn <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Japan.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Funfzehn$ID <- c(rep(15))
Sechszehn <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Kanada.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Sechszehn$ID <- c(rep(16))
Siebzehn <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Kolumbien.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Siebzehn$ID <- c(rep(17))
Achtzehn <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Korea.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Achtzehn$ID <- c(rep(18))
Neunzehn <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Lettland.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Neunzehn$ID <- c(rep(19))
Zwanzig <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Litauen.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Zwanzig$ID <- c(rep(20))
Einundzwanzig <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Luxenburg.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Einundzwanzig$ID <- c(rep(21))
Zweiundzwanzig <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Mexiko.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Zweiundzwanzig$ID <- c(rep(22))
Dreiundzwanzig <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Neuseeland.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Dreiundzwanzig$ID <- c(rep(23))
Vierundzwanzig <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Niederlande.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Vierundzwanzig$ID <- c(rep(24))
Funfundzwanzig <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Norwegen.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Funfundzwanzig$ID <- c(rep(25))
Sechsundzwanzig <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Österreich.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Sechsundzwanzig$ID <- c(rep(26))
Siebenundzwanzig <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Polen.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Siebenundzwanzig$ID <- c(rep(27))
Achtundzwanzig <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Portugal.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Achtundzwanzig$ID <- c(rep(28))
Neunundzwanzig <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Schweden.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Neunundzwanzig$ID <- c(rep(29))
Dreisig <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Schweitz.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Dreisig$ID <- c(rep(30))
Einunddreisig <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Slowakai.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Einunddreisig$ID <- c(rep(31))
Zweiunddreisig <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Slowenien.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Zweiunddreisig$ID <- c(rep(32))
Dreiunddreisig <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Spanien.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Dreiunddreisig$ID <- c(rep(33))
Vierunddreisig <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Tschechien.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Vierunddreisig$ID <- c(rep(34))
Funfunddreisig <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Türkei.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Funfunddreisig$ID <- c(rep(35))
Sechsunddreisig <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Ungarn.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Sechsunddreisig$ID <- c(rep(36))
Siebenundreisig <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_USA.xlsx",col_types = c("date", "skip", "skip", "skip", "skip", "numeric", "skip"))
Siebenundreisig$ID <- c(rep(37))

gsadf <- rbind(Eins, Zwei, Drei, Vier, Funf, Sechs, Sieben, Acht, Neun, Zehn, Elf, Zwolf, Dreizehn, Vierzehn, Funfzehn, Sechszehn, Siebzehn, Achtzehn, Neunzehn, Zwanzig, Einundzwanzig, Zweiundzwanzig, Dreiundzwanzig, Vierundzwanzig, Funfundzwanzig, Sechsundzwanzig, Siebenundzwanzig, Achtundzwanzig, Neunundzwanzig, Dreisig, Einunddreisig, Zweiunddreisig, Dreiunddreisig, Vierunddreisig, Funfunddreisig, Sechsunddreisig, Siebenundreisig)

rm(Eins, Zwei, Drei, Vier, Funf, Sechs, Sieben, Acht, Neun, Zehn, Elf, Zwolf, Dreizehn, Vierzehn, Funfzehn, Sechszehn, Siebzehn, Achtzehn, Neunzehn, Zwanzig, Einundzwanzig, Zweiundzwanzig, Dreiundzwanzig, Vierundzwanzig, Funfundzwanzig, Sechsundzwanzig, Siebenundzwanzig, Achtundzwanzig, Neunundzwanzig, Dreisig, Einunddreisig, Zweiunddreisig, Dreiunddreisig, Vierunddreisig, Funfunddreisig, Sechsunddreisig, Siebenundreisig)

##GDP Var.
#quartl.
## Wachtstumsrate zur Vorperiode, durch Hundert geteilt um einheitliche Transformation zu haben
GDP <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/Probit/Formated/GDP.xlsx")

library(anytime)
GDP$Time = anydate(GDP$Time)

size = ncol(GDP)

library(tempdisagg)

for (i in 2:size){
  t = GDP[1]
  t[2] = GDP[i]
  id = as.numeric(colnames(t[2]))
  t_td <- td(t ~ 1, conversion = "mean", to = "month", method = "denton-cholette", criterion = "proportional", h = 2)
  t <- predict(t_td)
  remove(t_td)
  t[3] = rep(c(id))
  colnames(t)[2] <- "gdp"
  colnames(t)[3] <- "ID"
  assign(paste("GDP",id,sep="_"),t)
  rm(t)
}

GDP_Panel <- rbind(GDP_1,GDP_2,GDP_3,GDP_4,GDP_5,GDP_6,GDP_7,GDP_8,GDP_9,GDP_10,GDP_11,GDP_12,GDP_13,GDP_14,GDP_15,GDP_16,GDP_17,GDP_18,GDP_19,GDP_20,GDP_21,GDP_22,GDP_23,GDP_24,GDP_25,GDP_26,GDP_27,GDP_28,GDP_29,GDP_30,GDP_31,GDP_32,GDP_33,GDP_34,GDP_35,GDP_36,GDP_37)
GDP_Panel <- arrange(GDP_Panel,ID)
rm(GDP_1,GDP_2,GDP_3,GDP_4,GDP_5,GDP_6,GDP_7,GDP_8,GDP_9,GDP_10,GDP_11,GDP_12,GDP_13,GDP_14,GDP_15,GDP_16,GDP_17,GDP_18,GDP_19,GDP_20,GDP_21,GDP_22,GDP_23,GDP_24,GDP_25,GDP_26,GDP_27,GDP_28,GDP_29,GDP_30,GDP_31,GDP_32,GDP_33,GDP_34,GDP_35,GDP_36,GDP_37)
rm(GDP)

##Interest Var.
#mtl.
#Nr.35 (Türkei) fehlt

Long <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/Probit/Formated/Long term.xlsx")
Short <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/Probit/Formated/Short term.xlsx")

library(anytime)
Long$time = anydate(Long$time)
Short$time = anydate(Short$time)

size = ncol(Long)

for (i in 2:size){
  t = Long[1]
  t[2] = Long[i]
  id = as.numeric(colnames(t[2]))
  t[3] = rep(c(id))
  colnames(t)[2] <- "long"
  colnames(t)[3] <- "ID"
  t = na.omit(t)
  assign(paste("Long",id,sep="_"),t)
  rm(t,d,e)
}

Long_Panel <- rbind(Long_1,Long_2,Long_3,Long_4,Long_5,Long_6,Long_7,Long_8,Long_9,Long_10,Long_11,Long_12,Long_13,Long_14,Long_15,Long_16,Long_17,Long_18,Long_19,Long_20,Long_21,Long_22,Long_23,Long_24,Long_25,Long_26,Long_27,Long_28,Long_29,Long_30,Long_31,Long_32,Long_33,Long_34,Long_36,Long_37)
rm(Long_1,Long_2,Long_3,Long_4,Long_5,Long_6,Long_7,Long_8,Long_9,Long_10,Long_11,Long_12,Long_13,Long_14,Long_15,Long_16,Long_17,Long_18,Long_19,Long_20,Long_21,Long_22,Long_23,Long_24,Long_25,Long_26,Long_27,Long_28,Long_29,Long_30,Long_31,Long_32,Long_33,Long_34,Long_36,Long_37)
rm(Long)

size = ncol(Short)

for (i in 2:size){
  t = Short[1]
  t[2] = Short[i]
  id = as.numeric(colnames(t[2]))
  t[3] = rep(c(id))
  colnames(t)[2] <- "short"
  colnames(t)[3] <- "ID"
  t = na.omit(t)
  assign(paste("Short",id,sep="_"),t)
  rm(t,d,e)
}
 
Short_Panel <- rbind(Short_1,Short_2,Short_3,Short_4,Short_5,Short_6,Short_7,Short_8,Short_9,Short_10,Short_11,Short_12,Short_13,Short_14,Short_15,Short_16,Short_17,Short_18,Short_19,Short_20,Short_21,Short_22,Short_23,Short_24,Short_25,Short_26,Short_27,Short_28,Short_29,Short_30,Short_31,Short_32,Short_33,Short_34,Short_36,Short_37)
rm(Short_1,Short_2,Short_3,Short_4,Short_5,Short_6,Short_7,Short_8,Short_9,Short_10,Short_11,Short_12,Short_13,Short_14,Short_15,Short_16,Short_17,Short_18,Short_19,Short_20,Short_21,Short_22,Short_23,Short_24,Short_25,Short_26,Short_27,Short_28,Short_29,Short_30,Short_31,Short_32,Short_33,Short_34,Short_36,Short_37)
rm(Short)

Int_Panel <- merge(Long_Panel,Short_Panel,by=c("time","ID"))
Int_Panel <- arrange(Int_Panel,ID)
Int_Panel[5] <- Int_Panel[3]-Int_Panel[4]
colnames(Int_Panel)[5] <- "spread"

rm(Long_Panel,Short_Panel)

##Disp. Income
##Delta Log da in level
##jährlich
##Nr.12 fehlt (Island)

inc <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/Probit/Formated/gross_disp_income.xlsx")

library(anytime)
inc$time = anydate(inc$time)

size = ncol(inc)

for (i in 2:size){
  t = inc[1]
  t[2] = inc[i]
  id = as.numeric(colnames(t[2]))
  t_td <- td(t ~ 1, conversion = "mean", to = "quarterly", method = "denton-cholette", criterion = "proportional", h = 2)
  t <- predict(t_td)
  remove(t_td)
  t_td <- td(t ~ 1, conversion = "mean", to = "monthly", method = "denton-cholette", criterion = "proportional", h = 2)
  t <- predict(t_td)
  remove(t_td)
  t[3] = rep(c(id))
  colnames(t)[2] <- "inc"
  colnames(t)[3] <- "ID"
  t = na.omit(t)
  t <- arrange(t,ID)
  d = diff(t$inc)
  e = t$inc[-length(t$inc)]
  t[4] = c(NA,(d/e))
  colnames(t)[4] <- "delta_inc"
  assign(paste("inc",id,sep="_"),t)
  rm(t,d,e)
}

inc_Panel <- rbind(inc_1,inc_2,inc_3,inc_4,inc_5,inc_6,inc_7,inc_8,inc_9,inc_10,inc_11,inc_13,inc_14,inc_15,inc_16,inc_17,inc_18,inc_19,inc_20,inc_21,inc_22,inc_23,inc_24,inc_25,inc_26,inc_27,inc_28,inc_29,inc_30,inc_31,inc_32,inc_33,inc_34,inc_35,inc_36,inc_37)
rm(inc_1,inc_2,inc_3,inc_4,inc_5,inc_6,inc_7,inc_8,inc_9,inc_10,inc_11,inc_13,inc_14,inc_15,inc_16,inc_17,inc_18,inc_19,inc_20,inc_21,inc_22,inc_23,inc_24,inc_25,inc_26,inc_27,inc_28,inc_29,inc_30,inc_31,inc_32,inc_33,inc_34,inc_35,inc_36,inc_37)
rm(inc)

#ALQ
#mtl.
#Nr.23 fehlt (Neuseeland) & Nr.30 (Schweitz)
ALQ <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/Probit/Formated/ALQ.xlsx")

library(anytime)
ALQ$time = anydate(ALQ$time)

size = ncol(ALQ)

for (i in 2:size){
  t = ALQ[1]
  t[2] = ALQ[i]
  id = as.numeric(colnames(t[2]))
  t[3] = rep(c(id))
  colnames(t)[2] <- "alq"
  colnames(t)[3] <- "ID"
  t = na.omit(t)
  assign(paste("alq",id,sep="_"),t)
  rm(t,d,e)
}

alq_panel <- rbind(alq_1,alq_2,alq_3,alq_4,alq_5,alq_6,alq_7,alq_8,alq_9,alq_10,alq_11,alq_12,alq_13,alq_14,alq_15,alq_16,alq_17,alq_18,alq_19,alq_20,alq_21,alq_22,alq_24,alq_25,alq_26,alq_27,alq_28,alq_29,alq_31,alq_32,alq_33,alq_34,alq_35,alq_36,alq_37)
alq_panel <- arrange(alq_panel,ID)
rm(alq_1,alq_2,alq_3,alq_4,alq_5,alq_6,alq_7,alq_8,alq_9,alq_10,alq_11,alq_12,alq_13,alq_14,alq_15,alq_16,alq_17,alq_18,alq_19,alq_20,alq_21,alq_22,alq_24,alq_25,alq_26,alq_27,alq_28,alq_29,alq_31,alq_32,alq_33,alq_34,alq_35,alq_36,alq_37)
rm(ALQ)

#Stocks
#Index
#mtl
#delta-log weil Level
#Nr.20 fehlt (Litauen)
Stock <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/Probit/Formated/Stocks.xlsx")

library(anytime)
Stock$time = anydate(Stock$time)

size = ncol(Stock)

for (i in 2:size){
  t = Stock[1]
  t[2] = Stock[i]
  id = as.numeric(colnames(t[2]))
  t[3] = rep(c(id))
  colnames(t)[2] <- "stock"
  colnames(t)[3] <- "ID"
  t = na.omit(t)
  t <- arrange(t,ID)
  d = diff(t$stock)
  e = t$stock[-length(t$stock)]
  t[4] = c(NA,(d/e))
  colnames(t)[4] <- "delta_stock"
  assign(paste("stock",id,sep="_"),t)
  rm(t,d,e)
}

stock_panel <- rbind(stock_1,stock_2,stock_3,stock_4,stock_5,stock_6,stock_7,stock_8,stock_9,stock_10,stock_11,stock_12,stock_13,stock_14,stock_15,stock_16,stock_17,stock_18,stock_19,stock_21,stock_22,stock_23,stock_24,stock_25,stock_26,stock_27,stock_28,stock_29,stock_30,stock_31,stock_32,stock_33,stock_34,stock_35,stock_36,stock_37)
rm(stock_1,stock_2,stock_3,stock_4,stock_5,stock_6,stock_7,stock_8,stock_9,stock_10,stock_11,stock_12,stock_13,stock_14,stock_15,stock_16,stock_17,stock_18,stock_19,stock_21,stock_22,stock_23,stock_24,stock_25,stock_26,stock_27,stock_28,stock_29,stock_30,stock_31,stock_32,stock_33,stock_34,stock_35,stock_36,stock_37)
rm(Stock)

#credit
#jährlich
#Serie wird invertiert, damit pos. Werte einen Anstieg der Kreditaufnahme und negative Werte einen Anstieg der Kreditvergabe anzeigen
#Nr.12 fehlt (Island)

credit <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/Probit/Formated/credit.xlsx")

library(anytime)
credit$time = anydate(credit$time)

size = ncol(credit)

for (i in 2:size){
  t = credit[1]
  t[2] = credit[i]
  id = as.numeric(colnames(t[2]))
  t_td <- td(t ~ 1, conversion = "mean", to = "quarterly", method = "denton-cholette", criterion = "proportional", h = 2)
  t <- predict(t_td)
  remove(t_td)
  t_td <- td(t ~ 1, conversion = "mean", to = "monthly", method = "denton-cholette", criterion = "proportional", h = 2)
  t <- predict(t_td)
  remove(t_td)
  t[3] = rep(c(id))
  colnames(t)[2] <- "credit"
  colnames(t)[3] <- "ID"
  t = na.omit(t)
  t <- arrange(t,ID)
  d = diff(t$credit)
  e = t$credit[-length(t$credit)]
  t[4] = c(NA,(d/e))
  colnames(t)[4] <- "delta_credit"
  assign(paste("credit",id,sep="_"),t)
  rm(t,d,e)
}

credit_panel <- rbind(credit_1,credit_2,credit_3,credit_4,credit_5,credit_6,credit_7,credit_8,credit_9,credit_10,credit_11,credit_13,credit_14,credit_15,credit_16,credit_17,credit_18,credit_19,credit_20,credit_21,credit_22,credit_23,credit_24,credit_25,credit_26,credit_27,credit_28,credit_29,credit_30,credit_31,credit_32,credit_33,credit_34,credit_35,credit_36,credit_37)
rm(credit_1,credit_2,credit_3,credit_4,credit_5,credit_6,credit_7,credit_8,credit_9,credit_10,credit_11,credit_13,credit_14,credit_15,credit_16,credit_17,credit_18,credit_19,credit_20,credit_21,credit_22,credit_23,credit_24,credit_25,credit_26,credit_27,credit_28,credit_29,credit_30,credit_31,credit_32,credit_33,credit_34,credit_35,credit_36,credit_37)
rm(credit)

##account to gdp
##quartalsweise

acc <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/Probit/Formated/account_to_gdp.xlsx")

library(anytime)
acc$time = anydate(acc$time)

size = ncol(acc)

for (i in 2:size){
  t = acc[1]
  t[2] = acc[i]
  id = as.numeric(colnames(t[2]))
  t_td <- td(t ~ 1, conversion = "mean", to = "monthly", method = "denton-cholette", criterion = "proportional", h = 2)
  t <- predict(t_td)
  remove(t_td)
  t[3] = rep(c(id))
  colnames(t)[2] <- "acc"
  colnames(t)[3] <- "ID"
  t = na.omit(t)
  assign(paste("acc",id,sep="_"),t)
  rm(t,d,e)
}

acc_panel <- rbind(acc_1,acc_2,acc_3,acc_4,acc_5,acc_6,acc_7,acc_8,acc_9,acc_10,acc_11,acc_12,acc_13,acc_14,acc_15,acc_16,acc_17,acc_18,acc_19,acc_20,acc_21,acc_22,acc_23,acc_24,acc_25,acc_26,acc_27,acc_28,acc_29,acc_30,acc_31,acc_32,acc_33,acc_34,acc_35,acc_36,acc_37)
acc_panel <- arrange(acc_panel,ID)
rm(acc_1,acc_2,acc_3,acc_4,acc_5,acc_6,acc_7,acc_8,acc_9,acc_10,acc_11,acc_12,acc_13,acc_14,acc_15,acc_16,acc_17,acc_18,acc_19,acc_20,acc_21,acc_22,acc_23,acc_24,acc_25,acc_26,acc_27,acc_28,acc_29,acc_30,acc_31,acc_32,acc_33,acc_34,acc_35,acc_36,acc_37)
rm(acc)

##LPM

panel <- merge(merge(merge(merge(merge(merge(merge(gsadf,GDP_Panel,by=c("time","ID")),Int_Panel,by=c("time","ID")),inc_Panel,by=c("time","ID")),alq_panel,by=c("time","ID")),stock_panel,by=c("time","ID")),credit_panel,by=c("time","ID")),acc_panel,by=c("time","ID")) 
panel <- arrange(panel,ID)
drops <- c("short","inc","stock","credit")
panel <- panel[ , !(names(panel) %in% drops)]
colnames(panel)[4] <- "GDP"
colnames(panel)[5] <- "Long"
colnames(panel)[6] <- "Spread"
colnames(panel)[7] <- "Delta_Income"
colnames(panel)[8] <- "Unempl"
colnames(panel)[9] <- "Delta_Stock"
colnames(panel)[10] <- "Delta_Credit"
colnames(panel)[11] <- "Balance"
panel$Delta_Income = panel$Delta_Income*100
panel$Delta_Credit = panel$Delta_Credit*100
panel$Delta_Credit = panel$Delta_Credit*(-1)
panel$Delta_Stock = panel$Delta_Stock*100

setwd("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Programme/R")

lpm <- lm(b ~ GDP + Long + Spread + Delta_Income + Unempl + Delta_Stock + Delta_Credit + Balance, data = panel)
robust <- coeftest(lpm, vcov = vcovHC(lpm, type="HC0"))
robust

stargazer(panel,titel="Deskription der länerübergreifenden Einflussindikatoren",type="text",out="vars.txt",omit=c("time","ID","b"),omit.summary.stat=c("p75","p25"),digits=2)

stargazer(lpm,title="Das lineare Wahrscheinlichkeitsmodell",type="text",out="lpm.txt" ,digits= 2 ,dep.var.caption="")

