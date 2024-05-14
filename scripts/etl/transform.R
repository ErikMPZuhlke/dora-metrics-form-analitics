source("scripts/etl/retrospective_form_projections.R")
source("scripts/etl/continous_form_projections.R")

transform_retrospective_data <- function(data) {
  #Normalize against to the DORA Report 2023 Benchmarks
  retrospective = data %>%
    mutate(
      lead_time_for_changes = normalize_time_scale(lead_time_for_changes),
      deployment_frequency = map_deployment_frequency(deployment_frequency),
      change_failure_rate = map_range(change_failure_rate, 0, 100, 0, 1),
      mean_time_to_restore = normalize_time_scale(mean_time_to_restore)
    ) %>%
    summarise(lead_time_for_changes, deployment_frequency, change_failure_rate, mean_time_to_restore)
  
  return(retrospective)
}

transform_continuous_data <- function(data) {
  #Normalize data against the DORA Report 2023 Benchmarks
  continuous <- data %>% 
    compute_deployment_frequency() %>%
    normalize_lead_time_for_changes() %>%
    compute_change_failure_rate() %>%
    normalize_mean_time_to_restore() %>%
    summarise(lead_time_for_changes, deployment_frequency, change_failure_rate, mean_time_to_restore)

  return(continuous)
}