# Loading necessary libraries
library(raster)

# Set input and output directories
input_dir <- "D:/Nepal/Narayani DEM/input values/2004_2014/Eawag Research/Single pixel calculation 445 basin/3. All single pixel raster_projection defined"
output_dir <- "D:/Nepal/Narayani DEM/input values/2004_2014/Eawag Research/Single pixel calculation 445 basin/4. Standardization and bilinear interpolation"

# List all raster files in the input directory
raster_files <- list.files(input_dir, pattern = "\\.tif$", full.names = TRUE)

# Function to standardize and resample raster
process_raster <- function(file_path) {
  # Read the raster file
  raster_obj <- raster(file_path)
  
  # Standardize the raster values (mean = 0, sd = 1)
  raster_std <- (raster_obj - cellStats(raster_obj, 'mean')) / cellStats(raster_obj, 'sd')
  
  # Assuming there is a reference raster to match the extent and resolution
  # This should be one of the rasters from the input folder or a separately defined raster
  reference_raster <- raster(raster_files[1]) # Example, using the first raster as reference
  
  # Resample using bilinear interpolation to match the extent and resolution
  raster_resampled <- resample(raster_std, reference_raster, method = "bilinear")
  
  # Create output file name
  output_file_name <- gsub(input_dir, output_dir, file_path)
  
  # Ensure the output directory exists
  output_file_path <- dirname(output_file_name)
  if (!dir.exists(output_file_path)) {
    dir.create(output_file_path, recursive = TRUE)
  }
  
  # Write the processed raster to the output directory
  writeRaster(raster_resampled, output_file_name, format = "GTiff", overwrite = TRUE)
}

# Apply the function to all raster files
lapply(raster_files, process_raster)

print("All rasters have been processed and saved.")
