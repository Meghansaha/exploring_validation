library(tidyverse)
library(pointblank)

data <- read_csv("data/example_data.csv")

data_agent <- create_agent(tbl = data %>% mutate(state = str_to_title(state)),
                           tbl_name = "Test Data")


data_agent %>%
  col_vals_in_set(., state, state.name ) %>%
  col_is_numeric(.,total_patients) %>%
  col_vals_gte(.,total_patients,0) %>%
  col_is_date(., report_date) %>%
  interrogate() %>%
  get_data_extracts() 

