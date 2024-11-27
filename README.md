# Starter folder

## Overview

This study developed a Bayesian hierarchical model to predict sakura flowering dates using climate and geographic predictors such as latitude, longitude, and mean monthly temperature, while accounting for regional and temporal variations through random effects. The model demonstrated strong predictive accuracy with low errors and meaningful insights into the sensitivity of sakura phenology to climate factors. Validation through posterior predictive checks and convergence diagnostics confirmed the model's reliability. Broader implications include its utility for climate change studies, tourism planning, and regional conservation, with potential for further enhancement by incorporating additional predictors and dynamic modeling techniques.

## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from Alex Cookson's.
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `model` contains fitted models. 
-   `other` contains relevant literature, details about LLM chat interactions, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data.


## Statement on LLM usage

LLM is being used for this paper, the detail could be find in `other`.
## Some checks

- [ ] Change the rproj file name so that it's not starter_folder.Rproj
- [ ] Change the README title so that it's not Starter folder
- [ ] Remove files that you're not using
- [ ] Update comments in R scripts
- [ ] Remove this checklist