
#### Function to diagnose the model for Prior Predictive Simulation ####
prior_sim_diagnose <- function(simulation_model){

  #### Check Plausibility of predictions (Prior Predictive Distribution) ####

  # Dens Overlay
  dens_overlay <- pp_check(prior_sim,type = "dens_overlay" )+
    theme_minimal()+
    ggtitle("Prior Predictive Distribution")

  # Statistics Table
  hist <- pp_check(prior_sim,type = "hist")+
    ggtitle("Histogram of Prior Predictive Distribution ")+
    theme_minimal()

  # Collect in a list
  plausibility_of_predictions <- list(
    dens_overlay = dens_overlay,
    hist = hist
  )
  # Return the plot
  return(plausibility_of_predictions)

}
