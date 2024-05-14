# Load required libraries
library(ggplot2)
library(reshape2)  # for data manipulation

# Define the data
data <- data.frame(
  Year = c(2018, 2019, 2021, 2022),
  Elite = c(7, 20, 26, NA),
  High = c(48, 23, 40, 11),
  Medium = c(37, 44, 28, 19),
  Low = c(15, 12, 7, 19)
)

# Melt the data for plotting
data_melted <- melt(
  data, 
  id.vars = "Year",
  variable.name = "Category",
  value.name = "Percentage"
)

# Area Plot
area_plot <- ggplot(data_melted, aes(x = Year, y = Percentage, fill = Category)) +
  geom_area(position = "stack", alpha = 0.8) +
  labs(title = "Time Evolution of DORA Metrics Trends (Area Plot)",
       x = "Year",
       y = "Percentage",
       fill = "Category") +
  theme_minimal()

# Line Plot
line_plot <- ggplot(data_melted, aes(x = Year, y = Percentage, color = Category)) +
  geom_line() +
  labs(title = "Time Evolution of DORA Metrics Trends (Line Plot)",
       x = "Year",
       y = "Percentage",
       color = "Category") +
  theme_minimal()

# Bar Plot
bar_plot <- ggplot(data_melted, aes(x = as.factor(Year), y = Percentage, fill = Category)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(title = "Time Evolution of DORA Metrics Trends (Bar Plot)",
       x = "Year",
       y = "Percentage",
       fill = "Category") +
  theme_minimal()

# Heatmap
heatmap_plot <- ggplot(data_melted, aes(x = Year, y = Category, fill = Percentage)) +
  geom_tile() +
  labs(title = "Time Evolution of DORA Metrics Trends (Heatmap)",
       x = "Year",
       y = "Category",
       fill = "Percentage") +
  theme_minimal()

# Box Plot
box_plot <- ggplot(data_melted, aes(x = Category, y = Percentage, fill = Category)) +
  geom_boxplot() +
  labs(title = "Distribution of DORA Metrics Trends (Box Plot)",
       x = "Category",
       y = "Percentage",
       fill = "Category") +
  theme_minimal()

# Plotting all graphs
print(area_plot)
print(line_plot)
print(bar_plot)
print(heatmap_plot)
print(box_plot)
