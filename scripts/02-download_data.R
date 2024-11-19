#### Preamble ####
# Purpose: Downloads and saves the data from Alex Github
# Author: Shanjie Jiao
# Date: 18 November 2024 
# Contact: Shanjie.Jiao@mail.utoronto.ca
# License: MIT
# Pre-requisites: Download From Github
# Any other information needed? No


#### Workspace setup ####
library(here)



#### Download data ####
file_historical_sakura_data <- here("other", "Origional_Data_Extract_From_Alex", "sakura-historical.csv")
historical_sakura_data <- read_csv(file_historical_sakura_data)

file_modern_sakura_data <- here("other", "Origional_Data_Extract_From_Alex", "sakura-modern.csv")
modern_sakura_data <- read_csv(file_modern_sakura_data)

#### Save data ####
write_csv(historical_sakura_data, "~/Sakura-Blossom-Prediction-Model/data/01-raw_data/raw_historical_sakura_data.csv") 
write_csv(modern_sakura_data, "~/Sakura-Blossom-Prediction-Model/data/01-raw_data/raw_modern_sakura_data.csv") 


