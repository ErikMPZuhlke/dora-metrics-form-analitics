plot_radarchart <- function(data, color = "#00AFBB", 
                            vlabels = colnames(data), vlcex = 0.7,
                            caxislabels = NULL, title = NULL, ...){
  fmsb::radarchart(
    data, axistype = 1,
    # Customize the polygon
    pcol = color, pfcol = scales::alpha(color, 0.5), plwd = 2, plty = 1,
    # Customize the grid
    cglcol = "grey", cglty = 1, cglwd = 0.8,
    # Customize the axis
    axislabcol = "grey", 
    # Variable labels
    vlcex = vlcex, vlabels = vlabels,
    caxislabels = caxislabels, title = title, ...
  )
}

plot_dora_metrics_radar <- function(data, title, color) {
  max_min <- data.frame(
    deployment_frequency = c(1, 4),
    lead_time_for_changes = c(1, 4),
    change_failure_rate = c(0, 1),
    mean_time_to_restore = c(1, 4)
  )
  
  rownames(max_min) <- c("Max", "Min")
  
  # Bind the variable ranges to the data
  df <- rbind(max_min, data)
  
  selected_data <- df[c("Max", "Min", "Elite", "Low", "Zühlke"), ]
  
  # Reduce plot margin using par()
  op <- par(mar = c(1, 2, 2, 2))
  
  # Create the radar charts
  plot_radarchart(
    data = selected_data, caxislabels = NULL, title = title,
    vlabels = c("Deployment frequency", "Lead Time for Changes", "Change Failure Rate", "Mean Time to Restore"),
    color = color
  )
  
  # Add an horizontal legend
  legend(
    x = "topright", legend = rownames(selected_data[-c(1,2),]), horiz = FALSE,
    bty = "n", pch = 20 , col = color,
    text.col = "black", cex = 1, pt.cex = 1.5
  )
  
  par(op)
}