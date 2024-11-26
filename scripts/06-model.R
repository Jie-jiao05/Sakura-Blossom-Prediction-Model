#### Preamble ####
# Purpose:model
# Author: Shanjie Jiao
# Date: 18 November 2024 
# Contact: Shanjie.Jiao@mail.utoronto.ca
# License: MIT
# Pre-requisites: Download data
# Any other information needed? No

train_data <- here("data", "03-model_data", "train_data.parquet")
test_data <- here("data", "03-model_data", "test_data.parquet")
train <- read_parquet(train_data)
test <- read_parquet(test_data)

# Load necessary libraries
library(rstanarm)
library(here)

# Fit the Bayesian Hierarchical Model with Region and Climate as Random Effects
# Fit the Bayesian Hierarchical Model with Station and Year as Random Effects
flower_model <- stan_glmer(
  flower_day_in_numeric ~ month_mean_temp + latitude + longitude + 
    (1 | station_name) + (1 | year),  # Random effects for station and year
  data = train,
  family = gaussian(),  # Continuous outcome
  prior_intercept = normal(0, 10),  # Weakly informative prior for intercept
  prior = normal(0, 10),  # Weakly informative priors for coefficients
  prior_aux = exponential(1),  # Prior for residual standard deviation
  adapt_delta = 0.95,  # Increase for better convergence
  iter = 2000,  # Number of iterations
  chains = 4  # Number of MCMC chains
)



# Ensure the 'models' directory exists
if (!dir.exists(here::here("models"))) {
  dir.create(here::here("models"), recursive = TRUE)
}

# Save the model
saveRDS(flower_model, file = here::here("models", "bayesian_hierarchical_model.rds"))

# Confirm save
cat("Model saved to:", here::here("models", "bayesian_hierarchical_model.rds"), "\n")

