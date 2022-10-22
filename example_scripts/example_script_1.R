#example_script_1 - Data Quality Reporting--------------------------------------


#==============================================================================#
#Library Load in----------------------------------------------------------------
#==============================================================================#
library(readr) #For reading in CSVs
library(stringr) #For string work
library(dplyr) #For data wrangling
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
  col_vals_in_set(., state, state.name ) %>% #Only valid states in the column?
  col_is_numeric(.,total_patients) %>% #Is column type numeric?
  col_vals_gte(.,total_patients,0) %>% #Only values greater than 0 in the column?
  col_is_date(., report_date) #Is column type date?

#==============================================================================#
#Step 3 Interrogate the agent to see some quick information---------------------
#==============================================================================#

#Use the interrogate() and  function to extract data that fails your rules#
patient_agent %>%
  interrogate()

