
##### Function to Make Bayesian Hierarchical Model ####
hierarchical_modeling <- function(data,priors){

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
  bayes_model_h <- brm(
    formula = formula,
    data = data,
    family = gaussian,
    prior = priors,
    chains =  4,
    iter = 2000,
    seed = 123,
    backend = "cmdstanr"
  )

  # Return the model
  return(bayes_model_h)
}
