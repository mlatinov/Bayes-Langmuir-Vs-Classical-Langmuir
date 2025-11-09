
#### Prior Predictive simulation function ####
prior_simulation <- function(
    data,
    mu_pimax = 50,
    sd_pimax = 10,
    lb_pimax = 40,
    mu_amol = 45,
    sd_amol = 15,
    lb_amol = 20,
    sigma_delta = 1
    ){

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

  #### Priors ####
  priors <- c(
    prior(normal(mu_pimax, sd_pimax), nlpar = "pimax", lb = lb_pimax), # Prior for max pressure
    prior(normal(mu_amol, sd_amol), nlpar = "Amol", lb = lb_amol),     # Prior for molecular surface area
    prior(exponential(sigma_delta), class = "sigma")                   # Prior for the error
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
