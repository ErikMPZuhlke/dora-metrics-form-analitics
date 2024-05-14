extract_data <- function(file_path, column_names = NULL) {
  data <- read.csv(file_path, sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8")
  
  if (!is.null(column_names)) {
    colnames(data) <- column_names
  }
  
  return(data)
}

extract_retrospective_data <- function(file_path) {
  retro_column_names <- c(
    "id", 
    "start_time", 
    "completion_time", 
    "email", 
    "name", 
    "last_modified", 
    "vertec_code", 
    "industry_sector", 
    "lead_time_for_changes", 
    "deployment_frequency", 
    "change_failure_rate", 
    "mean_time_to_restore"
  )
  
  extracted <- file_path %>% extract_data(retro_column_names)
  
  return(extracted)
}

extract_continuous_data <- function(file_path) {
  continuous_data_colnames <- c("id", "start_time", "completion_time", "email", "name", "last_modified_time", 
                                "end_of_week_date", "vertec_code", "industry_sector", "deployed_last_week", 
                                "deployments_last_week", "lead_time_for_changes", "service_degradations", 
                                "remediations_completed", "mean_time_to_restore")
  
  continuous <- file_path %>% extract_data(continuous_data_colnames)
  
  return(continuous)
}