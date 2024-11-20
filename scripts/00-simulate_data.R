#### Preamble ####
# Purpose: Simulates  dataset of sakura blossom
# Author: Shanjie Jiao
# Date: 18 November 2024 
# Contact: Shanjie.Jiao@mail.utoronto.ca
# License: MIT
# Pre-requisites: Download data
# Any other information needed? No


#### Workspace setup ####
set.seed(522)

library(dplyr)
library(readr)
library(lubridate)
library(here)

#### Read the datasets ####
sakura_data <- read_csv(here("data", "01-raw_data", "raw_modern_sakura_data.csv"))
temperature_data <- read_csv(here("data", "01-raw_data", "temperatures_with_station_names.csv"))
historical_data <- read_csv(here("data", "01-raw_data", "raw_historical_sakura_data.csv"))

#### Process sakura data ####
# Convert flower_date and full_bloom_date to Date type and extract the corresponding month
sakura_data <- sakura_data %>%
  mutate(
    flower_month = month(as.Date(flower_date, format = "%Y-%m-%d"), label = TRUE),
    full_bloom_month = month(as.Date(full_bloom_date, format = "%Y-%m-%d"), label = TRUE)
  )

# Merge with temperature data based on flower_month and full_bloom_month
sakura_full_bloom_temp <- sakura_flower_temp %>%
  left_join(
    temperature_data %>% rename(full_bloom_month = month),
    by = c("station_id", "year", "full_bloom_month")
  ) %>%
  rename(month_mean_temp = mean_temp_c)

# Select and rename final columns
simulate_data_of_modern_sakura <- sakura_full_bloom_temp %>%
  select(
    station_id, station_name, latitude, longitude, year,
    flower_date, full_bloom_date, month_mean_temp
  )

#### Save the processed data ####
write_csv(simulate_data_of_modern_sakura, here("data", "00-simulate_data", "simulate_combined_sakura_data.csv"))
write_csv(temperature_data, here("data", "00-simulate_data", "simulate_temperature_data.csv"))
write_csv(historical_data, here("data", "00-simulate_data", "simulate_historical_data.csv"))