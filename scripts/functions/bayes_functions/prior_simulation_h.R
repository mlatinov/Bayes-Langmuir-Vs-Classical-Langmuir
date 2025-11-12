
#### Function to create a Prior Simulation for Hierarchical model ####
prior_simulation_h <- function(data,priors){

  #### Libraries ####
  library(brms)

  #### Formula ####
  formula <- brmsformula(
    surface_pressure_mn_m ~ pimax * (1 - Amol / (Amol + surface_area_mm2)),
    pimax ~ 1 + (1 | experiment_id),  # Constant our maximum possible pressure for every replication
    Amol ~ 1  + (1 | experiment_id),  # Constant Molecular surface area for every replication
    nl = TRUE, # Non linaer model
    family = gaussian()
  )

  #### BRMS Prior Simulation ####
  h_prior_simulation <- brm(
    formula = formula,
    data = data,
    family = gaussian,
    prior = priors,
    sample_prior = "only",
    chains =  4,
    iter = 2000,
    seed = 123,
    backend = "cmdstanr"
    )

  # Return the model
  return(h_prior_simulation)
}
