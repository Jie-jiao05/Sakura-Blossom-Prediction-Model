#### Preamble ####
# Purpose: test  data and train data
# Author: Shanjie Jiao
# Date: 18 November 2024 
# Contact: Shanjie.Jiao@mail.utoronto.ca
# License: MIT
# Pre-requisites: Download data
# Any other information needed? No

#load data
data <- read_csv(here("data", "02-analysis_data", "analysis_modern_sakura_data.csv"))

# Load necessary libraries
library(dplyr)
library(rsample)

# Split data into 80:20 ratio
set.seed(522) # Setting seed for reproducibility
split <- initial_split(sakura_data, prop = 0.8)

# Extract training and testing datasets
train_data <- training(split)
test_data <- testing(split)

# Save training and testing data as CSV files
write_csv(train_data, here("data", "03-model_data", "train_data.csv"))
write_csv(test_data, here("data", "03-model_data", "test_data.csv"))
