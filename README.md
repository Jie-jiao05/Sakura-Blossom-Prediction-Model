# Starter folder

## Overview

This study developed a Bayesian hierarchical model to predict sakura flowering dates using climate and geographic predictors such as latitude, longitude, and mean monthly temperature, while accounting for regional and temporal variations through random effects. The model demonstrated strong predictive accuracy with low errors and meaningful insights into the sensitivity of sakura phenology to climate factors. Validation through posterior predictive checks and convergence diagnostics confirmed the model's reliability. Broader implications include its utility for climate change studies, tourism planning, and regional conservation, with potential for further enhancement by incorporating additional predictors and dynamic modeling techniques.


## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from Alex Cookson's.
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `data/model_data` contains the data that used to train and test model.
-   `model` contains fitted models. 
-   `other` contains relevant literature, details about LLM chat interactions, datasheet, and sketches.
-   `other/matched_station_id_with_station_name` contain all scraped staion id and name information.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download, scrape and clean data.



## Statement on LLM usage

This project utilized the assistance of ChatGPT 4.0, the detail could be find in `other`.
