# Load necessary libraries
library(readxl)
library(writexl)

# Read the data from the Excel file
file_path <- " Your folder path/2. example excel file.xlsx"
data <- read_excel(file_path)

# Define the Blaney-Criddle function
calculate_PET <- function(Tmean, p) {
  # Blaney-Criddle formula to calculate PET
  PET <- ((0.46 * Tmean) + 8) * (p)
  return(PET)
}

# Apply the function to calculate PET for each row in the dataframe
data$PET <- mapply(calculate_PET, data$Tmean, data$p_value)

# Write the new dataframe with PET values to a new Excel file
output_file_path <- "Your folder path/output excel file.xlsx"
write_xlsx(data, output_file_path)

# Print a message to indicate completion
print("PET calculation is complete and the file has been saved.")
