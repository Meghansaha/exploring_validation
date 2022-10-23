#example_script_2 - Pipeline Data Validation-----------------------------------#

#==============================================================================#
#Library Load in----------------------------------------------------------------
#==============================================================================#
library(readr) #For reading in CSVs
library(pointblank) #For validation help

#==============================================================================#
#Data Load-in-------------------------------------------------------------------
#==============================================================================#
example_data <- read_csv("./data/example_data.csv", show_col_types = FALSE)

#==============================================================================#
#Step 1 Get a table-------------------------------------------------------------
#==============================================================================#
#View the data if desired#
View(example_data)

#==============================================================================#
#Step 2 Give it validation rules and action levels------------------------------
#==============================================================================#
#Use previous validation rules and action levels directly on the table#
#Use warn_on_fail() and stop_on_fail to create direct action levels#

#Make an action levels object if desired#
al <- action_levels(warn_at = 0.2, 
                    stop_at = 0.5,
                    notify_at = 1)

#Or create manual action options in certain rules#
example_data %>%
  col_vals_in_set(state, state.name,
                  actions = warn_on_fail(warn_at = .6)) %>%
  col_is_numeric(total_patients,
                 actions = stop_on_fail(stop_at = 1)) %>% 
  col_vals_gte(total_patients,-0,
               actions = al) %>%
  col_is_date(report_date)

#If there's no errors/fails, the table prints normally.#
#This is a way to build validation into existing workflows#
example_data %>%
  col_is_numeric(total_patients,
                 actions = stop_on_fail(stop_at = 1)) 

