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
library(tidyverse)
library(lubridate)

#### Load data ####
temperature_data <- read_csv(here("data", "00-simulate_data", "simulate_temperature_data.csv"))
detailed_sakura_data <- read_csv(here("data", "00-simulate_data", "simulate_combined_sakura_data.csv"))
historical_data <- read_csv(here("data", "00-simulate_data", "simulate_historical_data.csv"))

### transform date###
sakura_data <- detailed_sakura_data %>%
  mutate(
    flower_date = as.Date(flower_date, format = "%Y-%m-%d"),          # Convert flower_date to Date
    full_bloom_date = as.Date(full_bloom_date, format = "%Y-%m-%d"), # Convert full_bloom_date to Date
    flower_day_in_numeric = yday(flower_date),                          # Day of the year for flower_date
    full_bloom_day_in_numeric = yday(full_bloom_date)                   # Day of the year for full_bloom_date
  )
#### Clean data ####

# Filter for March to May and remove rows with NA in 'mean_temp_c'
cleaned_temperature_data <- temperature_data %>%
  filter(month %in% c('Mar', 'Apr', 'May')) %>%  # Keep only spring months
  na.omit()     
# Remove rows with NA in combined sakura data
cleaned_sakura_data <- sakura_data %>%
  drop_na() %>%                        # Remove rows with any NA values
  select(
    station_id, station_name, latitude, longitude,                   # Retain original order
    flower_date, flower_day_in_numeric,                                 # Place flower_day_of_year after flower_date
    full_bloom_date, full_bloom_day_in_numeric,                         # Place full_bloom_day_of_year after full_bloom_date
    everything(), -year                                              # Remove year and keep remaining columns
  )
# Clean historical data: Remove specific columns and rows with NAs
historical_data_cleaned <- historical_data %>%
  select(-flower_source, -flower_source_name, -study_source, -temp_c_obs) %>%  # Remove specified columns
  filter(!is.na(temp_c_recon) & !is.na(flower_doy) & !is.na(flower_date))  # Remove rows with NAs in specific columns

#### Save data ####
write_csv(cleaned_temperature_data, here("data", "02-analysis_data", "analysis_temperature_data.csv"))
write_csv(cleaned_sakura_data, here("data", "02-analysis_data", "analysis_modern_sakura_data.csv"))
write_csv(historical_data_cleaned, here("data", "02-analysis_data", "analysis_historical_sakura_data.csv"))
