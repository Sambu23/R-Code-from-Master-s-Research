library(tidyverse)
library(writexl)
library(rio)
library(openxlsx)

setwd("Your folder path")

csv_files <- list.files(pattern = "\\.csv$") #use .xlsx extension for excel files

# Initialize an empty data frame to store the combined data
combined_csv <- data.frame()

# Loop through each CSV file and combine the data
for (file in csv_files) {
  # Read the data from the current CSV file
  data <- read.csv(file, header = TRUE)
  
  # Vertically stack the data (append to the combined_csv)
  combined_csv <- rbind(combined_csv, data)
}

# Save the combined data as an Excel file
write.xlsx(combined_csv, file = "Resulting excel file.xlsx", rowNames = FALSE)



