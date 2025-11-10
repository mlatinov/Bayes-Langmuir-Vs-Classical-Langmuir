
#### Function to produce Bayesian Insights and plot posterior distributions and summaries ####
bayes_insights <- function(model){

  #### Libraries ####
  library(bayesplot)
  library(posterior)
  library(patchwork)

  #### Posterior Summaries for Molecular surface ####

  # Take the posterior samples from the model
  posterior_samples <- as.data.frame(model)

  # Posterior distibutions of Molecular surface
  posterior_A_mol <- mcmc_areas(posterior_samples,
                                pars = "b_Amol_Intercept",
                                prob = 0.95,
                                prob_outer = 0.99,
                                point_est = "median"
                                )+
    labs(
      title = "Posterior разпределения на параметрите",
      subtitle = "Тъмно: 50% CI | Светло: 95% CI | Линии: 99% CI"
      ) +
    theme_minimal()+
    theme(plot.title = element_text(face = "bold"))

  # Credible intervals of Molecular surface Posterior
  intervals_A_mol <- mcmc_intervals(posterior_samples,
                                    pars = "b_Amol_Intercept",
                                    prob = 0.88,
                                    point_est = "median"
                                    )+
    labs(
      title = "Постериорни интервали 88% с медиана",
      y = " "
      )+
    theme_minimal()

  # Posterior Histogram of Molecular surface
  hist_A_mol <- mcmc_hist(posterior_samples,
                          pars = "b_Amol_Intercept",
                          bins = 30
                          )+
    labs(
      title = "Постериорна хистограма",
      x = "молекулярна повърхност"
      )+
    theme_minimal()

  # Combine the plots :
  final_plot <-
    hist_A_mol + intervals_A_mol

  # Return the final plot
  return(list(
    plots = list(final_plot = final_plot),
    posterior_samples = posterior_samples)
    )
}
