install.packages('tempdisagg')

library(readxl)
prr <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/BSc/Semester 6/Bachelorarbeit/Daten/PRR/Deutschland.xlsx", col_types = c("text", "numeric"))
price <- read_excel("C:/Users/Felix/OneDrive - Universität Hamburg/Studium VWL UHH/Semester 6/Bachelorarbeit/Daten/Price/Deutschland.xlsx", col_types = c("text", "numeric"))

library(tempdisagg)
prr_td <- td(prr ~ 1, conversion = "mean", to = "month", method = "denton-cholette", criterion = "proportional", h = 2)
prr_serie <- predict(prr_td)
price_td <- td(price ~ 1, conversion = "mean", to = "month", method = "denton-cholette", criterion = "proportional", h = 2)
price_serie <- predict(price_td)
