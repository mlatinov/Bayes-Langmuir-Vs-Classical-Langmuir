
#### Function to plot the Isoterm ####
plot_iso <- function(data){

  min_area <- max_point$area_per_molecule_A2
  max_pressure <- max_point$surface_pressure_mN_m

  isotherm_plot <-
    ggplot(data, aes(x = area_per_molecule_A2, y = surface_pressure_mN_m)) +

    # Main isotherm line
    geom_line(color = "blue", linewidth = 1) +

    # Titles and labels
    labs(
      title = "Компресионна изотерма на липиден екстракт от белодробна тъкан",
      subtitle = "Червеният маркер показва точката на максимална компресия",
      x = expression("Молекулна площ (Å"^2*"/молекула)"),
      y = "Повърхностно налягане (mN/m)"
    ) +

    # Theme
    theme_minimal() +
    theme(
      plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
      plot.subtitle = element_text(hjust = 0.5, size = 11),
      axis.title = element_text(size = 12),
      axis.text = element_text(size = 10),
      panel.grid.minor = element_blank()
    )

  # Return the plot
  return(isotherm_plot)
}
