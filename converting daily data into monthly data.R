# Load required libraries
library(tidyverse)
library(readxl)
library(openxlsx)

# Set the working directory to the location of your Excel file
setwd("D:/Nepal/Narayani DEM/Narayani hydrological station/Full data from 1980 to 2014/All in one")

# Define the input Excel file path
input_file_path <- "Discharge_Data_filled_values_filled_O.xlsx"

# Define the output Excel file name
output_file_name <- "Monthly_m_day_volume.xlsx"

# Function to group daily data into monthly data and save to Excel
group_daily_to_monthly <- function(input_file_path, output_file_name) {
  # Read the Excel file
  df <- read_excel(input_file_path)
  
  # Convert the date column to a date format
  df$Date <- as.Date(df$Date, format = "%Y-%m-%d")
  
  # Extract the year and month from the date
  df$Year <- format(df$Date, "%Y")
  df$Month <- format(df$Date, "%m")
  
  # Group the data by year, month, and calculate the monthly total rainfall for each station
  monthly_rainfall <- df %>%
    group_by(Year, Month) %>%
    summarise(across(starts_with("P"), ~sum(.x, na.rm = TRUE)))
  
  # Save the monthly data to a new Excel file
  write.xlsx(monthly_rainfall, file = output_file_name, row.names = FALSE)
}

# Call the function to group daily data into monthly data and save to Excel
group_daily_to_monthly(input_file_path, output_file_name)

