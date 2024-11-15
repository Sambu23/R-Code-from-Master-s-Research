library(raster)
library(stats)
library(writexl)

# Set the working directory
setwd("D:/Nepal/Narayani DEM/input values/2004_2014/Clipped and pixeled input/polished rename input parameters/Standardized and billinear try 3")

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

# Initialize data frame for PCA summary
pca_summary_all <- data.frame()

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
    
    # Calculate eigenvalues and explained variance
    eigenvalues <- pca_result$sdev^2
    total_variance <- sum(eigenvalues)
    variance_explained <- eigenvalues / total_variance * 100
    
    # Combine into a data frame
    pca_summary <- data.frame(Month = rep(month_abbr, length(eigenvalues)),
                              Principal_Component = seq_along(eigenvalues),
                              Eigenvalues = eigenvalues,
                              Variance_Percent = variance_explained)
    
    # Combine with previous results
    pca_summary_all <- rbind(pca_summary_all, pca_summary)
    
  } else {
    warning(paste("Incomplete data for PCA in", month_abbr))
  }
}

# Print the PCA summary to console
print(pca_summary_all)

# Optionally, write the PCA summary to an Excel file
write_xlsx(pca_summary_all, file.path("D:/Nepal/Narayani DEM/input values/2004_2014/Clipped and pixeled input/CDI hope regain", "pca_summary_all.xlsx"))

print("PCA analysis complete.")
