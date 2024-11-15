library(raster)
library(stats)
library(writexl)

# Set the working directory and define output folders
setwd("D:/Nepal/Narayani DEM/input values/2004_2014/Clipped and pixeled input/polished rename input parameters/Standardized and billinear try 3")
output_folder <- "D:/Nepal/Narayani DEM/input values/2004_2014/Clipped and pixeled input/CDI hope regain"
eigenvector_output_folder <- "D:/Nepal/Narayani DEM/input values/2004_2014/Clipped and pixeled input/CDI hope regain/Eigenvectors"
weight_maps_output_folder <- "D:/Nepal/Narayani DEM/input values/2004_2014/Clipped and pixeled input/CDI hope regain/PCA Weight Maps"

# Check and create output folders
dir.create(output_folder, recursive = TRUE, showWarnings = FALSE)
dir.create(eigenvector_output_folder, recursive = TRUE, showWarnings = FALSE)
dir.create(weight_maps_output_folder, recursive = TRUE, showWarnings = FALSE)
print("Output folders checked and created.")

# Define years, months, and parameters
years <- 2004:2013
months_abbr <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
parameters <- c("LST", "Snowcover", "NDVI", "Stdprec")
print("Years, months, and parameters defined.")

# Functions to load and clean rasters
load_raster <- function(year, month, parameter) {
  filename_pattern <- paste0(parameter, "_", year, month, ".tif")
  files <- list.files(pattern = filename_pattern)
  if (length(files) == 0) {
    warning(paste("No files found for", parameter, "in", month, year))
    return(NULL)
  }
  raster_file <- raster(files[1])
  return(raster_file)
}

clean_raster <- function(raster_data) {
  values <- getValues(raster_data)
  finite_values <- values[is.finite(values)]
  mean_value <- mean(finite_values, na.rm = TRUE)
  values[!is.finite(values)] <- mean_value
  cleaned_raster <- setValues(raster_data, values)
  return(cleaned_raster)
}

# Initialize data frame for average variability
monthly_variability <- data.frame(Month = character(), Average_Variability = numeric())

# Perform multivariate PCA for each month
for (month_abbr in months_abbr) {
  combined_param_rasters <- list()
  
  # Aggregate rasters for all parameters
  for (parameter in parameters) {
    for (year in years) {
      raster <- load_raster(year, month_abbr, parameter)
      if (!is.null(raster)) {
        cleaned_raster <- clean_raster(raster)
        combined_param_rasters <- c(combined_param_rasters, list(cleaned_raster))
      }
    }
  }
  
  # Check if enough data is available for PCA
  if (length(combined_param_rasters) == length(years) * length(parameters)) {
    # Perform PCA
    raster_stack <- stack(combined_param_rasters)
    pca_result <- prcomp(as.data.frame(raster_stack), scale. = TRUE)
    
    # Calculate the squared loadings of the eigenvectors
    loadings_squared <- pca_result$rotation[,1]^2
    # Convert squared loadings to percentage contribution
    percent_contribution <- (loadings_squared / sum(loadings_squared)) * 100
    
    # Save the percentage contributions to Excel
    contributions_df <- data.frame(Parameter = parameters, Percent_Contribution = percent_contribution)
    write_xlsx(contributions_df, file.path(output_folder, paste0("percent_contribution_", month_abbr, ".xlsx")))
    
    # Use the percent contributions as weights to generate weight maps
    for (parameter_index in 1:length(parameters)) {
      weight_map <- raster_stack[[parameter_index]] * percent_contribution[parameter_index]
      for (year_index in 2:length(years)) {
        raster_index <- (year_index - 1) * length(parameters) + parameter_index
        weight_map <- weight_map + raster_stack[[raster_index]] * percent_contribution[parameter_index]
      }
      weight_map_file_path <- file.path(weight_maps_output_folder, paste0(parameters[parameter_index], "_", month_abbr, "_weight_map.tif"))
      writeRaster(weight_map, filename = weight_map_file_path, format = "GTiff", overwrite = TRUE)
    }
    
    # Calculate and store average variability
    eigenvalues <- (pca_result$sdev)^2
    variance_explained <- eigenvalues / sum(eigenvalues)
    avg_variability <- mean(variance_explained) * 100
    monthly_variability <- rbind(monthly_variability, data.frame(Month = month_abbr, Average_Variability = avg_variability))
  } else {
    warning(paste("Incomplete data for PCA in", month_abbr))
  }
}

# Save eigenvectors and average variability to Excel files
write_xlsx(monthly_variability, file.path(output_folder, "monthly_average_variability.xlsx"))

print("PCA analysis complete and results saved.")
