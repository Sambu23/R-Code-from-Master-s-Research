library(VIM)
library(readxl)
library(mice)


precipitation_data <- read_excel("D:/Nepal/Rainfall Data/Rainfall/For MICE/Group 9/Group_9.xlsx")



summary(precipitation_data)

precipitation_data[precipitation_data == -99] <- NA

summary(precipitation_data)


pMiss <- function(x) {
  sum(is.na(x)) / length(x) * 100
}

missing_percentages <- apply(precipitation_data, 2, pMiss)




md.pattern(precipitation_data)


library(VIM)
aggr_plot <- aggr(precipitation_data, col=c('navyblue','red'), 
                  numbers=TRUE, sortVars=TRUE, labels=names(precipitation_data),
                  cex.axis=.5, gap=0, ylab=c("Histogram of missing data","Pattern"))


imputed_precipitation_data <- mice(precipitation_data,m = 5,maxit = 50, 
                                   method = 'pmm', seed = 500)


imputed_precipitation_data_df <- complete(imputed_precipitation_data)



library(writexl)
write_xlsx(imputed_precipitation_data_df, "D:/Nepal/Rainfall Data/Rainfall/For MICE/Group 9/Group_9_miced.xlsx")


densityplot(imputed_precipitation_data)

stripplot(imputed_precipitation_data, pch = 20, cex = 1.2,xlab = "Imputation Number",res =300)

