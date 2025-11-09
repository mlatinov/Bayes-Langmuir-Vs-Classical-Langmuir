
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
      mu_pimax = 50,
      sd_pimax = 10,
      lb_pimax = 40,
      mu_amol = 45,
      sd_amol = 10,
      lb_amol = 20,
      sigma_delta = 1
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
    command = bayesian_modeling(clean_iso)
  ),

  ##### Bayesian model diagnostics ####
  tar_target(
    name = bayesian_model_diagnostics,
    command = bayes_diagnose(bayesian_model)
  ),

  ##### Bayesian Model Insights ####
  tar_target(
    name = bayesian_results,
    command = bayes_results(bayesian_model)
  ),

  #### Comparing the Results ####------------------------------
  tar_target(
    name = comparison_methods,
    command = compare_methods(bayesian_results,molecular_surface)
  )
)
