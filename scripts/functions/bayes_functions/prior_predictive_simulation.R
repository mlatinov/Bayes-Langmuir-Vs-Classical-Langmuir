
#### Prior Predictive simulation function ####
prior_simulation <- function(data,priors){

  #### Libraries ####
  library(brms)

  #### Formula ####
  formula <- brmsformula(
    surface_pressure_mN_m ~ pimax * (1 - Amol / (Amol + surface_area_mm2)),
    pimax ~ 1, # Constant our maximum possible pressure
    Amol ~ 1,  # Constant Molecular surface area
    nl = TRUE, # Non linaer model
    family = gaussian()
  )

  #### Prior Predictive Simulation ####
  prior_sim <-
    brm(
      formula = formula,
      data = data,
      family = gaussian,
      prior = priors,
      sample_prior = "only",
      chains = 4,
      iter = 2000,
      seed = 123
      )

  # Return Prior Predictive Simulation
  return(prior_sim)
}
