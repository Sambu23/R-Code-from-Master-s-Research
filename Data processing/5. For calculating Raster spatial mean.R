library(raster)
library(openxlsx)

# Set the working directory to your folder path
setwd("Your folder path containing raster(.tif) files")

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
write.xlsx(result_df, "Spatial average value of raster.xlsx")

