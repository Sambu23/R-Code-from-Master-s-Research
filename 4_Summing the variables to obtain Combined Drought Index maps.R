library(raster)

# Define input and output directories
input_dir <- "D:/Nepal/Narayani DEM/input values/2004_2014/Clipped and pixeled input/CDI hope regain/multipled with input parameters"
output_dir <- "D:/Nepal/Narayani DEM/input values/2004_2014/Clipped and pixeled input/CDI hope regain/summed"

# Ensure the output directory exists
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# Years and months to process
years <- 2004:2013
months_abbr <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
parameters <- c("LST", "Snowcover", "NDVI", "Stdprec")

# Sum the rasters for each month and year
for (year in years) {
  for (month_abbr in months_abbr) {
    rasters_to_sum <- list()
    
    # Load the rasters for each parameter
    for (parameter in parameters) {
      # Adjust the file name to match the provided pattern
      file_name <- paste0(parameter, "_", year, month_abbr, "_multiplied", ".tif")
      file_path <- file.path(input_dir, file_name)
      
      if (file.exists(file_path)) {
        rasters_to_sum <- c(rasters_to_sum, raster(file_path))
      } else {
        cat("File not found:", file_name, "for", month_abbr, year, "\n")
      }
    }
    
    # Check if we have all four rasters
    if (length(rasters_to_sum) == 4) {
      # Sum the rasters
      summed_raster <- sum(stack(rasters_to_sum), na.rm = TRUE)
      
      # Save the summed raster
      output_file_name <- paste0("Composite_", year, month_abbr, ".tif")
      writeRaster(summed_raster, filename = file.path(output_dir, output_file_name), 
                  format = "GTiff", overwrite = TRUE)
      cat("Saved composite raster for:", month_abbr, year, "\n")
    } else {
      cat("Incorrect number of rasters for:", month_abbr, year, "\n")
    }
  }
}

cat("All composite rasters have been saved.\n")
