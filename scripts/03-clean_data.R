#### Preamble ####
# Purpose: Cleans the data 
# Author: Shanjie Jiao
# Date: 18 November 2024 
# Contact: Shanjie.Jiao@mail.utoronto.ca
# License: MIT
# Pre-requisites: Download data
# Any other information needed? No

#### Workspace setup ####
library(dplyr)
library(readr)
library(here)

#### Load data ####
temperature_data <- read_csv(here("data", "00-simulate_data", "simulate_temperature_data.csv"))
detailed_sakura_data <- read_csv(here("data", "00-simulate_data", "simulate_combined_sakura_data.csv"))
historical_data <- read_csv(here("data", "00-simulate_data", "simulate_historical_data.csv"))

#### Clean data ####

# Filter for March to May and remove rows with NA in 'mean_temp_c'
cleaned_temperature_data <- temperature_data %>%
  filter(month %in% c('Mar', 'Apr', 'May')) %>%
  na.omit()

# Remove rows with NA in combined sakura data
cleaned_sakura_data <- detailed_sakura_data %>%
  drop_na()

# Clean historical data: Remove specific columns and rows with NAs
historical_data_cleaned <- historical_data %>%
  select(-flower_source, -flower_source_name, -study_source, -temp_c_obs) %>%  # Remove specified columns
  filter(!is.na(temp_c_recon) & !is.na(flower_doy) & !is.na(flower_date))  # Remove rows with NAs in specific columns

#### Save data ####
write_csv(cleaned_temperature_data, here("data", "02-analysis_data", "analysis_temperature_data.csv"))
write_csv(cleaned_sakura_data, here("data", "02-analysis_data", "analysis_modern_sakura_data.csv"))
write_csv(historical_data_cleaned, here("data", "02-analysis_data", "analysis_historical_sakura_data.csv"))
