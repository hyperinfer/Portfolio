library(readxl)
PRR_Graf <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/PRR_Graf.xlsx", 
                       col_types = c("text", "numeric", "numeric", 
                                     "numeric", "numeric", "numeric", 
                                     "numeric", "numeric", "numeric", 
                                     "numeric", "numeric", "numeric", 
                                     "numeric", "numeric", "numeric", 
                                     "numeric", "numeric", "numeric", 
                                     "numeric", "numeric", "numeric", 
                                     "numeric", "numeric", "numeric", 
                                     "numeric", "numeric", "numeric", 
                                     "numeric", "numeric", "numeric", 
                                     "numeric", "numeric", "numeric", 
                                     "numeric", "numeric", "numeric", 
                                     "numeric", "numeric"))

install.packages("anytime")
library(anytime)
PRR_Graf$Time = anydate(PRR_Graf$Time)


##G7:
##Kanada
##Frankreich
##Deutschland
##Italien
##Japan
##England
##USA

library(ggplot2)
colors <- c("Deutschland" = "blue", "UK" = "red", "Frankreich" = "green", "Japan" = "black", "Italien" = "purple", "Kanada" = "yellow", "USA" = "orange")
ggplot(PRR_Graf,aes(x=Time)) + 
  geom_line(aes(y=Deutschland, color ="Deutschland"), size= 0.5) +
  geom_line(aes(y=UK, color="UK"), size= 0.5) +
  geom_line(aes(y=Frankreich, color="Frankreich" ), size= 0.5) +
  geom_line(aes(y=Italien, color="Italien"), size= 0.5) +
  geom_line(aes(y=Japan, color="Japan"), size= 0.5) +
  geom_line(aes(y=Kanada, color="Kanada"), size= 0.5) +
  geom_line(aes(y=USA, color="USA"), size= 0.5) +
  labs(x="",y="", color="", title="Preis-Miet-Verhältnis der G7 Staaten") +
  theme(plot.margin = margin(0,0,-12,-12), plot.title = element_text(face = "bold",size = 11), axis.text.y = element_text(size = 8))

ggsave("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Programme/Grafiken/PRR.jpg", plot= last_plot(),scale = 1.25, units = "cm", width = 15, height = 8, dpi = 500)
