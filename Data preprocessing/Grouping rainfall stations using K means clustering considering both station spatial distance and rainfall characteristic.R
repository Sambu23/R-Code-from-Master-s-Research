install.packages("geosphere")

library(geosphere)
library(tidyverse)
library(openxlsx)
library(readxl)
library(stats)
library(dplyr)
library(ggplot2)  # Corrected package name
library(ggfortify)
library(factoextra)
library(openxlsx)

file_path <- "Your folder path/C_1 example excel file.xlsx"
data <- read_excel(file_path)

coordinates <- data %>%
  select(Lat, Long) %>%
  as.matrix()

distance_matrix <- distm(coordinates)

file_path2 <- "Your folder path/C_2 example excel file.xlsx"
data0 <- read_excel(file_path2)

data2<-data0 %>% select(-Rain_Station)
combined_data <- cbind(data2, distance_matrix)

wssplot <- function(data2, nc = 15, seed = 1234) {
  wss <- (nrow(data2) - 1) * sum(apply(data2, 2, var))
  for (i in 2:nc) {
    set.seed(seed)
    wss[i] <- sum(kmeans(data2, centers = i)$withinss)
  }
  plot(1:nc, wss, type = "b", xlab = "Number of Clusters",
       ylab = "Within groups sum of squares")
  wss
}

wssplot(combined_data)

KM2 <- kmeans(combined_data, 30)


str(combined_data)
char_columns <- sapply(combined_data, is.character)
combined_data[char_columns] <- lapply(combined_data[char_columns], as.numeric)

cluster_colors <- c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd", "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf", "#aec7e8", "#ffbb78", "#98df8a", "#ff9896", "#c5b0d5", "#c49c94", "#f7b6d2", "#c7c7c7", "#dbdb8d", "#9edae5", "#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd", "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf")

# Create a custom color scale for clusters
color_scale <- scale_color_manual(values = cluster_colors)
autoplot(KM2,combined_data,frame=TRUE) + color_scale+
  labs(title = "K-means Clustering of Rainfall Stations") #this not working because dimension of the data are less than 2

#fviz_cluster(KM2, data = as.data.frame(combined_data))

View(KM2)

plot(KM2)

KM2$centers

data_with_clusters2 <- data2 %>%
  mutate(Cluster = KM2$cluster)

ggplot(data_with_clusters2, aes(x = Cluster, y = 1980, color = factor(Cluster))) +
  geom_point() +
  labs(title = "K-means Clustering of Rainfall Stations")

output_file <- "Your output path/K means clustering result.xlsx"

openxlsx::write.xlsx(data_with_clusters2, output_file, row.names = TRUE)  # Corrected function call
