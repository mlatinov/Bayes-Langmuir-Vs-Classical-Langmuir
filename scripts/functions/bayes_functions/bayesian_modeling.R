
#### Function Bayesian Model ####
bayesian_modeling <- function(data,priors){

  #### Libraries ####
  library(brms)

  #### Formula ####
  formula <- brmsformula(
    surface_pressure_mN_m ~ pimax * (1 - Amol / (Amol + surface_area_mm2)),
    pimax ~ 1, # Constant our maximum possible pressure
    Amol ~ 1,  # Constant Molecular surface area
    nl = TRUE, # Non linear model
    family = gaussian()
  )

  #### Bayesian Model ####
  bayes_model <-
    brm(
      formula = formula,
      data = data,
      family = gaussian,
      prior = priors,
      chains = 4,
      iter = 2000,
      seed = 123
    )

  # Return the model
  return(bayes_model)
}
