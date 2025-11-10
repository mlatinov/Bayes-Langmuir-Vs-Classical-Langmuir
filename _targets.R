
#### Global Libraries  ####
library(targets)
library(tidyverse)

### Source function ###
tar_source("scripts/functions/")

#### Targets Pipeline ####
list(

  #### Load the data ####
  tar_target(
    name = data_iso,
    command = read_excel("data/iso 1.xlsx"),
    packages = "readxl"
  ),

  ##### Clean the data ####
  tar_target(
    name = clean_iso,
    command = clean_iso_data(data_iso)
    ),

  #### Classical approach ####--------------------------------

  ##### Plot the isotherm ####
  tar_target(
    name = iso_plot,
    command = plot_iso(clean_iso),
    packages = "ggpmisc"
  ),

  ##### Calculate molecular surface ####
  tar_target(
    name = molecular_surface,
    command = calc_molecular_surface(clean_iso)
  ),

  #### Bayesian approach ####--------------------------------

  ##### Prior Predictive simulation ####
  tar_target(
    name = pp_model_simulation,
    command = prior_simulation(
      data = clean_iso,
      mu_pimax = 50, # Mean parameter for  max pressure
      sd_pimax = 10, # SD parameter for max pressure
      lb_pimax = 40, # Lowest possible point
      mu_amol = 45,  # Mean parameter for molecular surface area
      sd_amol = 10,  # SD parameter for molecular surface area
      lb_amol = 20,  # Lowest possible point  for molecular surface area
      sigma_delta = 1 # Delta parameter for the error
      )
    ),

  ##### Diagnostics of Prior Predictive simulation ####
  tar_target(
    name = prior_simulation_diagnostics,
    command = prior_sim_diagnose(pp_model_simulation)
  ),

  ##### Bayesian model ####
  tar_target(
    name = bayesian_model,
    command = bayesian_modeling(
      data = clean_iso,
      mu_pimax = 50, # Mean parameter for  max pressure
      sd_pimax = 10, # SD parameter for max pressure
      lb_pimax = 40, # Lowest possible point
      mu_amol = 45,  # Mean parameter for molecular surface area
      sd_amol = 10,  # SD parameter for molecular surface area
      lb_amol = 20,  # Lowest possible point  for molecular surface area
      sigma_delta = 1 # Delta parameter for the error
      )
  ),

  ##### Bayesian model diagnostics ####
  tar_target(
    name = bayesian_model_diagnostics,
    command = bayes_diagnose(bayesian_model)
  ),

  ##### Bayesian Model Insights ####
  tar_target(
    name = bayesian_results,
    command = bayes_insights(bayesian_model)
  ),

  #### Comparing the Results ####------------------------------
  tar_target(
    name = comparison_methods,
    command = compare_methods(bayesian_results,molecular_surface)
  )
)
