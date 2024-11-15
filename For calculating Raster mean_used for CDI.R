library(raster)
library(openxlsx)

# Set the working directory to your folder path
setwd("D:/Nepal/Narayani DEM/input values/2004_2014/Potential Evapotranspiration 2004_2013/Resampled to desired pixel size after clip")

# List all raster files in the directory
raster_files <- list.files(pattern = "\\.tif$") # Assuming the files are TIFF format

# Initialize vectors to store file names and mean values
file_names <- c()
mean_values <- c()

# Loop through each file, calculate mean, and store results
for (file in raster_files) {
  raster_data <- raster(file)
  mean_val <- cellStats(raster_data, stat = 'mean')
  file_names <- c(file_names, file)
  mean_values <- c(mean_values, mean_val)
}

# Create a data frame
result_df <- data.frame(FileName = file_names, MeanValue = mean_values)

# Write to Excel file
write.xlsx(result_df, "PET average value 2004 to 2013.xlsx")

