##graph

rm(list = ls())

library(readxl)
Zus <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/Zus.xlsx")

library(anytime)
Zus$Time = anydate(Zus$Time)


for (i in 2:15){
  x = colnames(Zus)[i]
  list <- append(list,x)
  rm(x)
}
rm(i)

library(ggplot2)
ggplot(Zus,aes(x=Time)) +
  geom_line(aes(y=Tschechien, colour="Tschechien"), size= 2) +
  geom_line(aes(y=Spanien, colour="Spanien"), size= 2) +
  geom_line(aes(y=Slowakai, colour="Slowakai"), size= 2) +
  geom_line(aes(y=Schweiz, colour="Schweiz"), size= 2) +
  geom_line(aes(y=Portugal, colour="Portugal"), size= 2) +
  geom_line(aes(y=Polen, colour="Polen"), size= 2) +
  geom_line(aes(y=Österreich, colour="Österreich"), size= 2) +
  geom_line(aes(y=Niederlande, colour="Niederlande"), size= 2) +
  geom_line(aes(y=Mexiko, colour="Mexiko"), size= 2) +
  geom_line(aes(y=Luxenburg, colour="Luxenburg"), size= 2) +
  geom_line(aes(y=Kanada, colour="Kanada"), size= 2) +
  geom_line(aes(y=Griechenland, colour="Griechenland"), size= 2) +
  geom_line(aes(y=Frankreich, colour="Frankreich"), size= 2) +
  geom_line(aes(y=Deutschland, colour="Deutschland"), size= 2) +
  labs(x="",y="", color="", title="Staaten mit einer präsenten Preisblase auf den Immobilienmärkten") +
  theme(plot.margin = margin(0,0,-12,-12), plot.title = element_text(face = "bold",size = 11), axis.text.y = element_blank(), axis.ticks.y=element_blank())

ggsave("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Programme/Grafiken/Linezzz.jpg", plot= last_plot(),scale = 1.25, units = "cm", width = 15, height = 8, dpi = 500)
