#### Preamble ####
# Purpose: Cleans the data 
# Author: Shanjie Jiao
# Date: 18 November 2024 
# Contact: Shanjie.Jiao@mail.utoronto.ca
# License: MIT
# Pre-requisites: Download data
# Any other information needed? No

#### Load data ####
library(tidyverse)
library(lubridate)
library(here)

temperature_data <- read_csv(here("data", "00-simulate_data", "simulate_temperature_data.csv"))
detailed_sakura_data <- read_csv(here("data", "00-simulate_data", "simulate_combined_sakura_data.csv"))
historical_data <- read_csv(here("data", "00-simulate_data", "simulate_historical_data.csv"))

#### Transform date ####
sakura_data <- detailed_sakura_data %>%
  mutate(
    flower_date = as.Date(flower_date, format = "%Y-%m-%d"),          # Convert flower_date to Date
    full_bloom_date = as.Date(full_bloom_date, format = "%Y-%m-%d"), # Convert full_bloom_date to Date
    flower_day_in_numeric = yday(flower_date),                       # Day of the year for flower_date
    full_bloom_day_in_numeric = yday(full_bloom_date)                # Day of the year for full_bloom_date
  )

#### Clean data ####

# Filter for March to May and remove rows with NA in 'mean_temp_c'
cleaned_temperature_data <- temperature_data %>%
  filter(month %in% c('Mar', 'Apr', 'May')) %>%  # Keep only spring months
  na.omit()

# Remove flower_date and full_bloom_date, extract year and month
cleaned_sakura_data <- sakura_data %>%
  drop_na() %>%                                      # Remove rows with any NA values
  mutate(
    year = year(flower_date),                       # Extract year from flower_date
    month = month(flower_date, label = TRUE)        # Extract month from flower_date (labeled as Jan, Feb, etc.)
  ) %>%
  select(
    station_id, station_name, latitude, longitude,  # Retain original order
    flower_day_in_numeric,                          # Day of the year for flower_date
    full_bloom_day_in_numeric,                      # Day of the year for full_bloom_date
    year, month,                                    # Include extracted year and month
    everything(), -flower_date, -full_bloom_date    # Remove flower_date and full_bloom_date
  )

# Clean historical data: Remove specific columns and rows with NAs
historical_data_cleaned <- historical_data %>%
  select(-flower_source, -flower_source_name, -study_source, -temp_c_obs) %>%  # Remove specified columns
  filter(!is.na(temp_c_recon) & !is.na(flower_doy) & !is.na(flower_date))      # Remove rows with NAs in specific columns

#### Save data ####
write_csv(cleaned_sakura_data, here("data", "02-analysis_data", "analysis_modern_sakura_data.csv"))
write_csv(historical_data_cleaned, here("data", "02-analysis_data", "analysis_historical_sakura_data.csv"))
