rm(list = ls()) 
install.packages('tempdisagg')
install.packages("anytime")
install.packages("MultipleBubbles")
install.packages("writexl")

### Interpolation ###

library(readxl)
prr <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/PRR/Schweitz.xlsx", col_types = c("text", "numeric"))

library(anytime)
prr$Time = anydate(prr$Time)

prr = na.omit(prr)

library(tempdisagg)
prr_td <- td(prr ~ 1, conversion = "mean", to = "month", method = "denton-cholette", criterion = "proportional", h = 2)
prr <- predict(prr_td)
remove(prr_td)

### BSADFS-Sequenz + kritische Werte ###

library(MultipleBubbles)
stat <- sadf_gsadf(prr$value,1,1,2)
bsadfs <- stat$bsadfs
remove(stat)
gsadfs <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/CV/CV_Schweitz.xlsx", col_names = FALSE, col_types = c("numeric"))
gsadfs = gsadfs$...1

### Tabelisierung & Grafik ###

prr$bsadfs <- c(rep(0))
prr$gsadfs <- c(rep(0))

d = length(prr$value)
f = length(bsadfs)

while (f > 0){
  prr$bsadfs[d] = bsadfs[f]
  prr$gsadfs[d] = gsadfs[f]
  d = d-1
  f = f-1
}

prr$bsadfs[1:d] = NaN
prr$gsadfs[1:d] = NaN
table = na.omit(prr)
remove(prr)
remove(bsadfs)

library(Metrics)

t <- as.numeric(1:2000)
test = 1:100

for (k in 1:90){
  smooth = lm(gsadfs ~ poly(t, k, raw=TRUE))
  test[k] = mse(gsadfs,smooth$fitted.values)
}

remove(k)

poly = which.min(test)

smooth = lm(gsadfs ~ poly(t, poly, raw=TRUE))

table$cv <- c(rep(0))

f = length(table$bsadfs)

while (f > 0){
  table$cv[f] = smooth$fitted.values[f]
  f = f-1
}

table$b <- c(rep(0))

for (i in 1:length(table$gsadfs)){
  if (table$bsadfs[i] > table$cv[i]){
    table$b[i] = 1
  }
}

bubble = table[(table$b) == 1,1,1]


library(ggplot2)
scl = ceiling(max(table$value)/max(table$bsadfs))
ggplot(table,aes(x=time)) + 
  geom_line(aes(y=bsadfs), colour="blue", size= 0.5) + 
  geom_line(aes(y=cv), colour="red", size= 0.5) +
  geom_line(aes(y=value/scl), colour="black", size= 0.5) +
  scale_y_continuous( sec.axis = sec_axis(~.*scl)) +
  geom_vline(xintercept = bubble, colour="yellow", size = 4, alpha = 1/20) +
  labs(x="",y="", color="", title="Schweiz") +
  theme(plot.margin = margin(0,0,-12,-12), plot.title = element_text(face = "bold",size = 11), axis.text.y = element_text(size = 8))

ggsave("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Programme/Grafiken/Schweitz.jpg", plot= last_plot(),scale = 1.5, units = "cm", width = 7, height = 7, dpi = 300)

##JPEG Skalierung: 300x300

##Min. Blasenlänge soll 6 Monate sein!

table$delta <- c(rep(0))
table$delta = 6/log(length(table$time))

library("writexl")
write_xlsx(table,"C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/GSADF/GSADF_Schweitz.xlsx", col_names = TRUE)

,"H1","H2","H3","H4","H5","H6","H7","H8")

,USA[USA$Date == "2020-12-13" & USA$RegionName == states[i],27],USA[USA$Date == "2020-12-13" & USA$RegionName == states[i],29],USA[USA$Date == "2020-12-13" & USA$RegionName == states[i],30],USA[USA$Date == "2020-12-13" & USA$RegionName == states[i],31],USA[USA$Date == "2020-12-13" & USA$RegionName == states[i],32],USA[USA$Date == "2020-12-13" & USA$RegionName == states[i],33],USA[USA$Date == "2020-12-13" & USA$RegionName == states[i],35],USA[USA$Date == "2020-12-13" & USA$RegionName == states[i],37])


geom_line(aes(y=H1_Public.information.campaigns,color="H1_Public.information.campaigns"),size=1)+
  geom_line(aes(y=H2_Testing.policy,color="H2_Testing.policy"),size=1)+
  geom_line(aes(y=H3_Contact.tracing,color="H3_Contact.tracing"),size=1)+
  geom_line(aes(y=H4_Emergency.investment.in.healthcare,color="H4_Emergency.investment.in.healthcare"),size=1)+
  geom_line(aes(y=H5_Investment.in.vaccines,color="H5_Investment.in.vaccines"),size=1)+
  geom_line(aes(y=H6_Facial.Coverings,color="H6_Facial.Coverings"),size=1)+
  geom_line(aes(y=H7_Vaccination.policy,color="H7_Vaccination.policy"),size=1)+
  geom_line(aes(y=H8_Protection.of.elderly.people,color="H8_Protection.of.elderly.people"),size=1)+
  