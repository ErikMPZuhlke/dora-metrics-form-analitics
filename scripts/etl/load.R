load_data <- function(data) {
  dora_metrics <- data.frame(
    row.names = c("Elite", "High", "Medium", "Low", "Zühlke"),
    deployment_frequency = c(1:4, median(data$deployment_frequency)),
    lead_time_for_changes = c(1:4, median(data$lead_time_for_changes)),
    change_failure_rate = c(.05, .10, .15, .64, median(data$change_failure_rate)),
    mean_time_to_restore = c(1:4, median(data$mean_time_to_restore))
  )
  
  return(dora_metrics)
}