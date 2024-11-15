library(tidyverse)
library(writexl)
library(rio)
library(openxlsx)

setwd("D:/Nepal/climate data/temp filtered/sushant/Individual stations/1030")

csv_files <- list.files(pattern = "\\.csv$")

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
write.xlsx(combined_csv, file = "1030_combined_data.xlsx", rowNames = FALSE)



