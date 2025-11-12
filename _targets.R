
#### Global Libraries  ####
library(targets)
library(tidyverse)

### Source function ###
tar_source("scripts/functions/")

#### Targets Pipeline ####
list(

  #### Load the datasets ####

  # First Replication Used also for the Bayesian Model
  tar_target(
    name = data_iso,
    command = read_excel("data/iso 1.xlsx"),
    packages = "readxl"
  ),

  # Second Replication
  tar_target(
    name = data_iso_2,
    command = read_excel("data/iso_2.xlsx"),
    packages = "readxl"
  ),

  # Third Replication
  tar_target(
    name = data_iso_3,
    command = read_excel("data/iso_3.xlsx"),
    packages = "readxl"
  ),

  # Forth Replication
  tar_target(
    name = data_iso_4,
    command = read_excel("data/iso_4.xlsx"),
    packages = "readxl"
  ),

  ##### Clean the data ####
  tar_target(
    name = clean_iso,
    command = clean_iso_data(
      datasets = list(
        data_iso,
        data_iso_2,
        data_iso_3,
        data_iso_4
      )),
    packages = "janitor"
    ),

  ##### Combine the Clean Datasets into one with experiment id column ####
  tar_target(
    name = combined_data,
    command = combine_datasets(clean_iso)
  ),

  #### Classical approach ####--------------------------------

  ##### Calculate molecular surface ####
  tar_target(
    name = molecular_surface,
    command = calc_molecular_surface(as.data.frame(clean_iso[1]))
  ),

  ##### Plot the isotherm ####
  tar_target(
    name = iso_plot,
    command = plot_iso(molecular_surface$full_curve),
    packages = "ggpmisc"
  ),


  #### Bayesian approach ####--------------------------------

  ##### Prior Predictive simulation ####
  tar_target(
    name = pp_model_simulation,
    command = prior_simulation(
      data = as.data.frame(clean_iso[1]),
      #### Priors ####
      priors = c(
        prior(normal(50, 10), nlpar = "pimax", lb = 10,ub = 100),  # Prior for max pressure
        prior(normal(45, 10), nlpar = "Amol", lb = 10, ub = 100),  # Prior for molecular surface area
        prior(exponential(1), class = "sigma")                     # Prior for the error
      )
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
      data = as.data.frame(clean_iso[1]),
      #### Priors ####
      priors = c(
        prior(normal(50, 10), nlpar = "pimax", lb = 10, ub = 100), # Prior for max pressure
        prior(normal(45, 10), nlpar = "Amol", lb = 10, ub = 100),  # Prior for molecular surface area
        prior(exponential(1), class = "sigma")                     # Prior for the error
        )
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

  ##### Prior Predictive simulation for hierarchical model ####
  tar_target(
    name = pp_model_simulation_h,
    command = prior_simulation_h(
      data = combined_data,
      #### Priors ####
      priors = c(

        ## Residual error: typical measurement noise around 1 mN/m
        prior(exponential(1), class = "sigma"),

        ## Amol: typical molecular area ~45 mm² (range ~25-65 mm²)
        prior(normal(45,10), class = "b",nlpar = "Amol",lb = 10, ub = 100),

        ## Between-experiment variation in molecular area: ~1 mm²
        prior(exponential(1),class = "sd",nlpar = "Amol",group = "experiment_id"),

        ## pimax: typical maximum pressure ~50 mN/m (range ~30-70 mN/m)
        prior(normal(50, 10), nlpar = "pimax", lb = 10, ub = 100),

        ## Between-experiment variation in max pressure: ~1 mN/m
        prior(exponential(1),class = "sd",nlpar = "pimax",group = "experiment_id")
      )
    )
  ),

  ##### Diagnostics of Prior Predictive simulation for hierarchical model ####
  tar_target(
    name = prior_simulation_diagnostics_h,
    command = prior_sim_diagnose(pp_model_simulation_h)
  ),

  #### Bayesian hierarchical model ####
  tar_target(
    name = hierarchical_model,
    command = hierarchical_modeling(
      data = combined_data,
      #### Priors ####
      priors = c(

        ## Residual error: typical measurement noise around 1 mN/m
        prior(exponential(1), class = "sigma"),

        ## Amol: typical molecular area ~45 mm² (range ~25-65 mm²)
        prior(normal(45,10), class = "b",nlpar = "Amol",lb = 10, ub = 100),

        ## Between-experiment variation in molecular area: ~2.5 mm²
        prior(exponential(1),class = "sd",nlpar = "Amol",group = "experiment_id"),

        ## Pimax: typical maximum pressure ~50 mN/m (range ~30-70 mN/m)
        prior(normal(50, 10), nlpar = "pimax", lb = 10, ub = 100),

        ## Between-experiment variation in max pressure: ~1 mN/m
        prior(exponential(1),class = "sd",nlpar = "pimax",group = "experiment_id")
      )
    )
  ),

  ##### Bayesian model diagnostics for hierarchical model  ####
  tar_target(
    name = bayesian_model_diagnostics_h,
    command = bayes_diagnose(hierarchical_model)
  ),

  ##### Bayesian Model Insights ####
  tar_target(
    name = bayesian_results_h,
    command = bayes_insights(hierarchical_model)
    )
)
