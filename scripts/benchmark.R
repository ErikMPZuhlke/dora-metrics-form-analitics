library(dplyr)
source("scripts/etl/extract.R")
source("scripts/etl/transform.R")
source("scripts/etl/load.R")
source("scripts/graphics/plotting.R")

classification_by_restrospective <- "data/dora_quickCheck_retrospective.csv" %>%
  extract_retrospective_data() %>%
  transform_retrospective_data() %>%
  load_data()

classification_by_continous <- "data/dora_quickCheck_continuous.csv" %>%
  extract_continuous_data() %>%
  transform_continuous_data() %>%
  load_data()

classification_by_restrospective %>%
  plot_dora_metrics_radar(title = "Comparison based on retrospective data",
                          color = c("#00AFBB", "#E7B800", "purple"))

classification_by_continous %>%
  plot_dora_metrics_radar(title = "Comparison based on continous data",
                          color = c("#1f77b4", "#ff7f0e", "violet"))
