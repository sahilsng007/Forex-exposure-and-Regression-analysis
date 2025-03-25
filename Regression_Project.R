#loading data and determining data type
library(readxl)
Data_for_research_project <- read_excel("C:/Users/sahil/Git_files/Data_for_research_project.xlsx", col_types = c("date", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric","numeric"))
View(Data_for_research_project)


#Calculating log returns
Data_for_research_project$RS1LNSS = c(NA,100*diff(log(Data_for_research_project$RS1LNSS)))
Data_for_research_project$MCXSS = c(NA,100*diff(log(Data_for_research_project$MCXSS)))
Data_for_research_project$GBPUSDSS = c(NA,100*diff(log(Data_for_research_project$GBPUSDSS)))
Data_for_research_project$GBPEURSS = c(NA,100*diff(log(Data_for_research_project$GBPEURSS)))
Data_for_research_project$GBPJPYSS = c(NA,100*diff(log(Data_for_research_project$GBPJPYSS)))
Data_for_research_project$GBPZARSS = c(NA,100*diff(log(Data_for_research_project$GBPZARSS)))
Data_for_research_project$GBPCNHSS = c(NA,100*diff(log(Data_for_research_project$GBPCNHSS)))

#calculating daily risk-free rate
Data_for_research_project$RfSS = Data_for_research_project$`UKBRBASE Index` / 252


#Summary of log returns
summary(Data_for_research_project[c("RS1LNSS","MCXSS","GBPUSDSS","GBPEURSS","GBPJPYSS","GBPZARSS","GBPCNHSS")])

#Excess returns of RS shares and market index against Risk-free sec
Data_for_research_project$RSPEXSS <- Data_for_research_project$RS1LNSS - Data_for_research_project$RfSS
Data_for_research_project$MCXEXSS <- Data_for_research_project$MCXSS - Data_for_research_project$RfSS

#Regression 
lm_returns = lm(RSPEXSS ~ MCXEXSS + GBPUSDSS + GBPEURSS + GBPJPYSS + GBPZARSS + GBPCNHSS,data = Data_for_research_project)
summary(lm_returns)

#CAPM regression
par(cex.axis = 1.5, cex.lab = 1.5, lwd = 2)
plot(Data_for_research_project$Dates, Data_for_research_project$MCXEXSS, type = 'l', col = "grey", ylim = c(-30, 30), ylab = " ")
lines(Data_for_research_project$Dates, Data_for_research_project$RSPEXSS, lwd = 1, col = "black")
legend("topright",c("MCXEXSS","RSPEXSS"), col = c("grey","black"), lty = 1,cex = 1.5)

#scatter plot
plot(Data_for_research_project$MCXEXSS, Data_for_research_project$RSPEXSS,pch=20)
abline(lm_capm, col = "red",lwd = 7)

#Q-Q plot
plot(lm_returns, which = 2)

#Hypothesis testing
library(car)
linearHypothesis(lm_returns, c("MCXEXSS=0","GBPUSDSS=0","GBPEURSS=0","GBPJPYSS=0","GBPZARSS=0","GBPCNHSS=0"))

#testing for heteroscedasticity
length(Data_for_research_project$Dates[-(1:2)])
length(lm_returns$residuals)
common_length <- min(length(Data_for_research_project$Dates), length(lm_returns$residuals))
plot(Data_for_research_project$Dates[1:common_length],lm_returns$residuals[1:common_length],type = "l",xlab = "", ylab = "")

#BP test
install.packages("lmtest")
library(lmtest)
bptest(formula(lm_returns), data = Data_for_research_project, studentize = FALSE)
bptest(formula = (lm_returns), data = Data_for_research_project, studentize = TRUE)

#White's modified SE estimates
library(lmtest)
library(sandwich)
vcovHC(lm_returns)
coeftest(lm_returns, vcov. = vcovHC(lm_returns, type = "HC1"))

#Durbin Watson autocorrelation test
library(lmtest)
dwtest(lm_returns)

#BG test
bgtest(lm_returns)

#Testing for non-normality
library(moments)  
skewness(lm_returns$residuals)
kurtosis(lm_returns$residuals)
hist(lm_returns$residuals, main = " ")
box()

#Jarque test
jarque.test(lm_returns$residuals)

#D'Agostino test
agostino.test(lm_returns$residuals)

#Anscombe and Glynn test
anscombe(lm_returns$residuals)

#Dummy variable - outliers contruction 
plot(Data_for_research_project$Dates[1:common_length],lm_returns$residuals[1:common_length],type = "l", col = "grey", xlab = " ", ylab = " ")
lines(Data_for_research_project$Dates[1:common_length], lm_returns$fitted.values[1:common_length])
legend("bottomright", c("Residuals","fitted"), col = c("grey","black"), lty = 1)
sort(residuals(lm_returns))

#Dummy variables for outliers 
Data_for_research_project$Dates = as.Date(Data_for_research_project$Dates)
Data_for_research_project$NOV14dumSS = as.integer(Data_for_research_project$Dates == as.Date("2014-11-13"))
Data_for_research_project$NOV19dumSS = as.integer(Data_for_research_project$Dates == as.Date("2019-11-12"))
Data_for_research_project$MAR20dumSS = as.integer(Data_for_research_project$Dates == as.Date("2020-03-20"))

#regression with dummy variables
lm_returns_dummy = lm(RSPEXSS ~ MCXEXSS + GBPUSDSS + GBPEURSS + GBPJPYSS + GBPZARSS + GBPCNHSS + NOV14dumSS + NOV19dumSS + MAR20dumSS, data = Data_for_research_project)
summary(lm_returns_dummy)

#re-running testing for non-normality
library(moments)  
skewness(lm_returns_dummy$residuals)
kurtosis(lm_returns_dummy$residuals)
hist(lm_returns_dummy$residuals, main = " ")
box()

#multicollinearity test
cor_matrix = cor(Data_for_research_project[-(1:2), c("MCXEXSS","GBPUSDSS","GBPEURSS","GBPJPYSS","GBPZARSS","GBPCNHSS")])
library(ggcorrplot)
ggcorrplot(cor_matrix, lab = TRUE, lab_size = 3, colors = c("blue","white","red"))
library(car)
vif(lm_returns)

#RESET test
reset(lm_returns, power = 2:4)

#stability test
library(strucchange)
sbtest = Fstats(formula(lm_returns), data = Data_for_research_project)
summary(sbtest)
may18 = match(as.Date("2018-05-11"), Data_for_research_project$Dates)
summary(may18)
chow = sbtest$Fstats[may18]
1-pchisq(chow,6)
