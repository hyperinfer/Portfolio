install.packages('stargazer')
library(stargazer)
install.packages('anytime')
library(anytime)
library(readxl)

#g7 PRR Summary Housdata

Deutschland <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/PRR/Deutschland.xlsx",col_types = c("text", "numeric"))
Deutschland$Time = anydate(Deutschland$Time)
colnames(Deutschland)[2] <- "Deutschland"

Frankreich <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/PRR/Frankreich.xlsx",col_types = c("text", "numeric")) 
Frankreich$Time = anydate(Frankreich$Time)
colnames(Frankreich)[2] <- "Frankreich"

Italien <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/PRR/Italien.xlsx",col_types = c("text", "numeric")) 
Italien$Time = anydate(Italien$Time)
colnames(Italien)[2] <- "Italien"

Japan <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/PRR/Japan.xlsx",col_types = c("text", "numeric"))
Japan$Time = anydate(Japan$Time)
colnames(Japan)[2] <- "Japan"

Kanada <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/PRR/Kanada.xlsx",col_types = c("text", "numeric"))
Kanada$Time = anydate(Kanada$Time)
colnames(Kanada)[2] <- "Kanada"

Vereinigtes_Königreich <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/PRR/England.xlsx",col_types = c("text", "numeric"))
Vereinigtes_Königreich$Time = anydate(Vereinigtes_Königreich$Time)
colnames(Vereinigtes_Königreich)[2] <- "Vereinigtes_Königreich"

Vereinigten_Staaten <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/PRR/USA.xlsx",col_types = c("text", "numeric"))
Vereinigten_Staaten$Time = anydate(Vereinigten_Staaten$Time)
colnames(Vereinigten_Staaten)[2] <- "Vereinigte Staaten"
Vereinigten_Staaten <- na.omit(Vereinigten_Staaten)

Panel <- merge(merge(merge(merge(merge(merge(Vereinigtes_Königreich, Frankreich, by='Time', all=TRUE), Italien, by="Time", all=TRUE), Japan, by="Time", all=TRUE), Kanada, by="Time", all=TRUE), Deutschland, by="Time", all=TRUE), Vereinigten_Staaten, by="Time", all=TRUE)

stargazer(Panel, omit.summary.stat=c("p75","p25"),titel="Deskription der Daten zum Miet-Preis-Verhältniss der G7-Staaten",type="text",out="table1.txt",digits=1)

Übersicht <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/Probit/Übersicht.xlsx")

stargazer(Übersicht,titel="Übersicht aller verwendeter Einflussindikatoren",type="html",out="table2.htm", summary=FALSE)
