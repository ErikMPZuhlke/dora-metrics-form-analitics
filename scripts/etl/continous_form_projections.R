compute_deployment_frequency <- function(data) {
  # Ensure start_time is in Date format
  data <- data %>%
    mutate(end_of_week_date = as.Date(end_of_week_date, format = "%m/%d/%y %H:%M:%S"))
  
  # Filter out rows where there were no deployments in the week for handling categories 1 and 2
  deployed_data <- data %>%
    filter(deployed_last_week == "Yes") %>%
    group_by(vertec_code, year_month = lubridate::floor_date(end_of_week_date, "month")) %>%
    summarise(total_deployments = sum(deployments_last_week, na.rm = TRUE)) %>%
    mutate(deployment_frequency = case_when(
      total_deployments >= 30 ~ 1,  # On demand (multiple deploys per day)
      total_deployments >= 4 & total_deployments < 30 ~ 2,  # Between once per day and once per week
      TRUE ~ NA_integer_  # Default case for any other scenarios
    )) %>%
    ungroup()
  
  # Handle rows where there were no deployments in the week for categories 3 and 4
  not_deployed_data <- data %>%
    filter(deployed_last_week == "No") %>%
    mutate(deployment_frequency = 4)  # Less than once per month
  
  # Combine the results
  combined_data <- bind_rows(
    deployed_data %>%
      select(vertec_code, year_month, deployment_frequency),
    not_deployed_data %>%
      mutate(year_month = lubridate::floor_date(end_of_week_date, "month")) %>%
      select(vertec_code, year_month, deployment_frequency)
  ) %>%
    group_by(vertec_code) %>%
    summarise(deployment_frequency = mean(deployment_frequency, na.rm = TRUE)) %>%
    ungroup()
  
  # Join the computed deployment frequency back to the original data
  data <- data %>%
    left_join(combined_data, by = "vertec_code")
  
  return(data)
}

normalize_lead_time_for_changes <- function(data) {
  # Ensure end_of_week_date is in Date format and create year_month for grouping
  data <- data %>%
    mutate(end_of_week_date = as.Date(end_of_week_date, format = "%m/%d/%y %H:%M:%S"),
           year_month = lubridate::floor_date(end_of_week_date, "month"))  # Create year_month column
  
  # Group by vertec_code and year_month, calculate average lead time for changes
  monthly_lead_times <- data %>%
    #mutate(lead_time_for_changes = ifelse(is.na(lead_time_for_changes), 0, lead_time_for_changes)) %>%
    group_by(vertec_code, year_month) %>%
    summarise(average_lead_time = mean(lead_time_for_changes, na.rm = TRUE), .groups = 'drop')  # Add .groups = 'drop' to avoid grouping warning
  
  # Map average lead time to specified categories
  monthly_lead_times <- monthly_lead_times %>%
    mutate(lead_time_for_changes = case_when(
      average_lead_time < 24 ~ 1,  # Less than one day
      average_lead_time >= 24 & average_lead_time < 168 ~ 2,  # Between one day and one week
      average_lead_time >= 168 & average_lead_time < 720 ~ 3,  # Between one week and one month
      TRUE ~ 4  # More than one month
    )) %>% 
    select(vertec_code, year_month, lead_time_for_changes)
  
  # Join the computed lead time back to the original data
  data <- data %>%
    select(-lead_time_for_changes) %>%
    left_join(monthly_lead_times, by = c("vertec_code", "year_month")) %>%
    # Optionally, drop the year_month column if not needed in the final output
    select(-year_month)
  
  return(data)
}

compute_change_failure_rate <- function(data) {
  # Calculate change failure rate for each entry
  data <- data %>%
    mutate(change_failure_rate = ifelse(
      is.na(deployments_last_week) | deployments_last_week == 0,
      NA,
      service_degradations / deployments_last_week
    ))
  
  # Group by vertec_code and calculate the global average change failure rate
  average_change_failure_rate <- data %>%
    group_by(vertec_code) %>%
    summarise(average_change_failure_rate = mean(change_failure_rate, na.rm = TRUE)) %>%
    ungroup()
  
  # Join the computed change failure rate back to the original data
  data <- data %>%
    left_join(average_change_failure_rate, by = "vertec_code") %>%
    mutate(change_failure_rate = average_change_failure_rate) %>%
    select(-average_change_failure_rate)
  
  return(data)
}

normalize_mean_time_to_restore <- function(data) {
  # Ensure end_of_week_date is in Date format and create year_month for grouping
  data <- data %>%
    mutate(end_of_week_date = as.Date(end_of_week_date, format = "%m/%d/%y %H:%M:%S"),
           year_month = lubridate::floor_date(end_of_week_date, "month"))  # Create year_month column
  
  # Group by vertec_code and year_month, calculate mean time to restore
  monthly_mean_restore_times <- data %>%
    group_by(vertec_code, year_month) %>%
    summarise(mean_time_to_restore = mean(mean_time_to_restore), .groups = 'drop')  # Add .groups = 'drop' to avoid grouping warning
  
  # Map mean time to restore to specified categories
  monthly_mean_restore_times <- monthly_mean_restore_times %>%
    mutate(mean_time_to_restore = case_when(
      mean_time_to_restore < 60 ~ 1,  # Less than one hour
      mean_time_to_restore >= 60 & mean_time_to_restore < 1440 ~ 2,  # Less than one day
      mean_time_to_restore >= 1440 & mean_time_to_restore < 10080 ~ 3,  # Between one day and one week
      mean_time_to_restore >= 10080 & mean_time_to_restore < 40320 ~ 4,  # Between one month and six months
      TRUE ~ 4  # Default case
    ))
  
  # Join the computed mean restore times back to the original data
  data <- data %>%
    select(-mean_time_to_restore) %>%
    left_join(monthly_mean_restore_times %>% select(vertec_code, year_month, mean_time_to_restore), 
              by = c("vertec_code", "year_month")) %>%
    select(-year_month)  # Optionally, drop the year_month column if not needed in the final output
  
  return(data)
}