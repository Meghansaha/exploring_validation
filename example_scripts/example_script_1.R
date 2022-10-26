#example_script_1 - Data Quality Reporting-------------------------------------#

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
#Step 2 Create an Agent and give it validation rules----------------------------
#==============================================================================#
#Use create_agent to make an agent for the patient data#
#And pipe validation rules from the agent# 

patient_agent <- create_agent(tbl = example_data,
                              tbl_name = "Patient Totals") %>%
  col_vals_in_set(state, state.name ) %>% #Only valid states in the column?
  col_is_numeric(total_patients) %>% #Is column type numeric?
  col_vals_gte(total_patients,-0) %>% #Only values greater than 0 in the column?
  col_is_date(report_date) #Is column type date?

#==============================================================================#
#Step 3 Interrogate the agent to see some quick information---------------------
#==============================================================================#

#Use the interrogate() and  function to extract data that fails your rules#
patient_agent %>%
  interrogate() 

#==============================================================================#
#Getting Data Extracts in the console/environment-------------------------------
#==============================================================================#

#Pulling out extracts to obtain data that failed validation#
patient_agent %>%
  interrogate() %>%
  setNames(c("State Validation Fails",
             "Patient Total Validation Fails"))

#==============================================================================#
#Using action levels------------------------------------------------------------
#==============================================================================#
#Make an action levels object#
al <- action_levels(warn_at = 0.2, 
                    stop_at = 0.5,
                    notify_at = 1)


#Overwrite the old agent and add action levels#
patient_agent <- create_agent(tbl = example_data,
                              tbl_name = "Patient Totals",
                              actions = al) %>%
  col_vals_in_set(state, state.name ) %>% 
  col_is_numeric(total_patients) %>% 
  col_vals_gte(total_patients,0) %>% 
  col_is_date(report_date) 

#interrogate it#
patient_agent %>%
  interrogate()

