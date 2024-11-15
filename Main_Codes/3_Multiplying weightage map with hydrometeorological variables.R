library(raster)
# Set the input and output folders
weight_maps_folder <- "D:/Nepal/Narayani DEM/input values/2004_2014/Clipped and pixeled input/CDI hope regain/PCA Weight Maps"
input_parameters_folder <- "D:/Nepal/Narayani DEM/input values/2004_2014/Clipped and pixeled input/polished rename input parameters/Standardized and billinear try 3"
output_folder <- "D:/Nepal/Narayani DEM/input values/2004_2014/Clipped and pixeled input/CDI hope regain/multipled with input parameters"

# Check and create the output folder
dir.create(output_folder, recursive = TRUE, showWarnings = FALSE)
print("Output folder checked and created.")

# Define the years and months abbreviations
years <- 2004:2013
months_abbr <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
parameters <- c("LST", "Snowcover", "NDVI", "Stdprec")

# Function to multiply weight map with input parameter file
multiply_rasters <- function(weight_map, input_raster) {
  return(weight_map * input_raster)
}

# Process the weight maps and input parameter files
for (year in years) {
  for (month_abbr in months_abbr) {
    for (parameter in parameters) {
      # Define file paths
      weight_map_file <- file.path(weight_maps_folder, paste0(parameter, "_", month_abbr, "_weight_map.tif"))
      input_parameter_file <- file.path(input_parameters_folder, paste0(parameter, "_", year, month_abbr, ".tif"))
      output_file_path <- file.path(output_folder, paste0(parameter, "_", year, month_abbr, "_multiplied.tif"))
      
      # Check if both files exist
      if (file.exists(weight_map_file) && file.exists(input_parameter_file)) {
        # Load the weight map and input parameter raster
        weight_map_raster <- raster(weight_map_file)
        input_parameter_raster <- raster(input_parameter_file)
        
        # Multiply the rasters
        result_raster <- multiply_rasters(weight_map_raster, input_parameter_raster)
        
        # Save the result raster
        writeRaster(result_raster, filename = output_file_path, format = "GTiff", overwrite = TRUE)
        print(paste("Result raster saved for", parameter, year, month_abbr))
      } else {
        warning(paste("Files not found for multiplication:", parameter, year, month_abbr))
      }
    }
  }
}

print("All multiplications completed.")
