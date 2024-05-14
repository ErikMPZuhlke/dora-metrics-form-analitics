normalize_time_scale <- function(reported_time) {
  # Convert time values to integers representing different time intervals
  normalized_time <- case_when(
    reported_time == "More than 6 months" ~ 4,
    reported_time == "One to six months" ~ 3,
    reported_time == "One week to one month" ~ 2,
    reported_time == "One day to one week" ~ 2,
    reported_time == "Less than one day" ~ 1,
    reported_time == "Less than one hour" ~ 1,
    TRUE ~ NA_integer_  # Return NA for other values
  )
  
  return(normalized_time)
}

map_deployment_frequency <- function(frequency) {
  # Convert deployment frequency values to intervals
  interval <- case_when(
    frequency == "Fewer than once per six months" ~ 4,
    frequency == "Between once per month and once every six months" ~ 3,
    frequency == "Between once per week and once per month" ~ 2,
    frequency == "Between once per day and once per week" ~ 2,
    frequency == "Between once per hour and once per day" ~ 1,
    frequency == "On demand (multiple deploys per day)" ~ 1,
    TRUE ~ NA_integer_  # Return NA for other values
  )
  
  return(interval)
}

map_range <- function(x, from_min, from_max, to_min, to_max) {
  x <- min(max(x, from_min), from_max)
  return ((x - from_min) / (from_max - from_min)) * (to_max - to_min) + to_min
}
