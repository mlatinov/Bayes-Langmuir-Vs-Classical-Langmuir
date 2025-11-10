
#### Function to run a Diagnostics Checks of the Bayesian models ####
bayes_diagnose <- function(model){

  #### Libraries ####
  library(bayesplot)
  library(brms)
  library(posterior)
  library(priorsense)

  #### Model Specifications  ####

  # Collect Posterior Draws
  post_draws <- as_draws(model)

  # Collect model specification in a list
  model_specification <- list(
    posterior_draws = post_draws,
    model_summary = summary(model)
  )

  #### CONVERGENCE DIAGNOSTICS ####

  # Trace plots
  trace_plot <- mcmc_plot(model,type = "trace")+
    ggtitle("MCMC Chains Trace Plot")+
    theme_minimal()

  # Autocorrection of the Chains
  auto_chains <- mcmc_acf(model)+
    ggtitle("MCMC Autocorrection of the Chains ")+
    theme_minimal()

  # Effective Sample Size Ratio
  effect_sample_ratio <- mcmc_neff(neff_ratio(model))+
    ggtitle(" Effective Sample Size Ratio")+
    theme_minimal()

  # Collect Convergent Diagnostics in a list
  convergence_diagnostics <- list(
    trace_plot = trace_plot,
    autocorrelation_chain  = auto_chains,
    effective_sample_ration = effect_sample_ratio
  )

  #### PRIOR Sensitivity Analysis ####

  # Prior Sensitivity Table
  sens_table <-
    powerscale_sensitivity(model)

  # Posterior density sensitivity under prior perturbations
  sens_density <-
    powerscale_plot_dens(model,params = "b_Amol_Intercept")+
    theme_minimal()+
    theme(
      title = element_blank(),
      plot.subtitle = element_blank()
      )

  # Collect in a list
  prior_sensitivity <- list(
    summary_table = sens_table,
    posterior_density = sens_density
  )

  # Return a list
  return(list(
    model_specification = model_specification,
    convergence_diagnostics = convergence_diagnostics,
    prior_sensitivity = prior_sensitivity
  ))
}
