install.packages("ggplot2")
library(ggplot2)

library(readxl)
credit <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/Probit/Formated/credit.xlsx")

library(anytime)
credit$time = anydate(credit$time)

uber = credit[1]
k=2

for (i in 2:37){
  id = as.numeric(colnames(credit[i]))
  if (id == 5|id == 6|id == 9|id == 14|id == 15|id == 16|id == 37) {
    uber[k] = credit[i]
    k = k+1
  }
}

colnames(uber)[2] <- "Kanada"
colnames(uber)[3] <- "Frankreich"
colnames(uber)[4] <- "Deutschland"
colnames(uber)[5] <- "Italien"
colnames(uber)[6] <- "Japan"
colnames(uber)[7] <- "UK"
colnames(uber)[8] <- "USA"

##Serie wird von ursp. Mio. $ auf Mrd. $ skaliert
for (i in 2:8) {
  uber[i] = uber[i]/-1000
}

ggplot(uber,aes(x=time)) + 
  geom_line(aes(y=Deutschland, colour="Deutschland"), size= 0.5) + 
  geom_line(aes(y=Frankreich, colour="Frankreich"), size= 0.5) +
  geom_line(aes(y=Italien, colour="Italien"), size= 0.5) +
  geom_line(aes(y=Japan, colour="Japan"), size= 0.5) +
  geom_line(aes(y=Kanada, colour="Kanada"), size= 0.5) +
  geom_line(aes(y=UK, colour="UK"), size= 0.5) +
  geom_line(aes(y=USA, colour="USA"), size= 0.5) +
  labs(x="",y="Netto Kreditvergabe/-aufnahme in Mrd. USD", color="", title="Kreditentwicklung der G7 Staaten") +
  scale_y_continuous(limits=c(-500,1000),breaks=c(-500,-250,0,250,500,750,1000))+
  theme(plot.title = element_text(face = "bold",size = 11), axis.text.y = element_text(size = 9), axis.title.y = element_text(size = 11, margin = margin(0,8,0,0)), legend.position = "right", legend.text = element_text(size = 11))

ggsave("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Programme/Grafiken/Kredit.jpg", plot= last_plot(),scale = 1.25, units = "cm", width = 15, height = 8, dpi = 500)

