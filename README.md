Title: Combined Drought Index (CDI) Code

Description:
This repository contains R scripts developed during my master's research to calculate the Combined Drought Index (CDI). The CDI is computed using the formula:

CDI = (w_LST × LST) + (w_SC × SC) + (w_NDVI × NDVI) + (w_Std prec × Std prec)

Where,
- w_LST, w_SC, w_NDVI, w_Std prec: Weightage for respective variables.
- LST, SC, NDVI, Std prec: Input variables as gridded raster maps (e.g., Land Surface Temperature, Snow Cover, Normalized Difference Vegetation Index, and Standardized Precipitation).
  
The code:
1. Generates weightage raster maps for the variables.
2. Generates eigen values
3. Multiplies the weightage maps with the corresponding input variables.
4. Sums the resulting raster products to compute the CDI map for a given time and space.

Usage:
1. Update the directory paths in the code to match your file locations.
2. Ensure that your input raster maps (e.g., LST, SC, NDVI, Std prec) are properly formatted and correspond to the variables mentioned in the formula.
3. Run the scripts to generate the CDI maps for your study area.
   
Directory Customization
- The directory paths in the code are tailored to the original project structure. Please update the directory paths according to your preferences and data locations before running the code.
