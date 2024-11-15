# Load required libraries
library(tidyverse)
library(readxl)
library(openxlsx)

# Set the working directory to the location of your Excel file
setwd("D:/Nepal/Rainfall Data/Rainfall/For MICE/Annual_data_Narayani")

# Define the input Excel file path and output file name
input_file_path <- "Full data.xlsx"
output_file_name <- "Narayani_AD.xlsx"

# Function to calculate total annual rainfall from daily data
calculate_total_annual_rainfall <- function(input_file_path, output_file_name) {
  # Read the Excel file
  df <- read_excel(input_file_path)
  
  # Extract the year from the Date column
  df$Year <- format(as.Date(df$Date), "%Y")
  
  # Group by Year and calculate the total annual rainfall
  annual_rainfall <- df %>%
    group_by(Year) %>%
    summarise(across(-Date, ~sum(.x, na.rm = TRUE)))
  
  # Save the result as a new Excel file
  write.xlsx(annual_rainfall,
             file = output_file_name,
             row.names = FALSE)
}

# Call the function to calculate annual rainfall and save to the output file
calculate_total_annual_rainfall(input_file_path, output_file_name)
