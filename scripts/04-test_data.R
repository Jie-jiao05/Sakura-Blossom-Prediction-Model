#### Preamble ####
# Purpose: test analysis data
# Author: Shanjie Jiao
# Date: 18 November 2024 
# Contact: Shanjie.Jiao@mail.utoronto.ca
# License: MIT
# Pre-requisites: Download data
# Any other information needed? No

# Load the datasets
temperature_data <- read_csv(here("data", "02-analysis_data", "analysis_temperature_data.csv"))
historical_sakura_data <- read_csv(here("data", "02-analysis_data", "analysis_historical_sakura_data.csv"))
modern_sakura_data <- read_csv(here("data", "02-analysis_data", "analysis_modern_sakura_data.csv"))

# Test for temperature data (March to May and NA values)
temperature_test <- all(temperature_data$month %in% c('Mar', 'Apr', 'May'))
print(temperature_test)
temperature_na_test <- sum(is.na(temperature_data$mean_temp_c)) == 0
print(temperature_na_test)
# Test for historical sakura data (NA values)
historical_sakura_na_test <- sum(is.na(historical_sakura_data)) == 0
print(historical_sakura_na_test)
# Test for modern sakura data (NA values)
modern_sakura_na_test <- sum(is.na(modern_sakura_data)) == 0
print(modern_sakura_na_test)