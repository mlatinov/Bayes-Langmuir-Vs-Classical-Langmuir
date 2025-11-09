
#### Function to plot the Isoterm ####
plot_iso <- function(data){

  # Find the point
  max_point <- data[which.max(data$surface_pressure_mN_m), ]
  min_area <- max_point$surface_area_mm2
  max_pressure <- max_point$surface_pressure_mN_m


  # Make a table for the graf
  point_table <- data.frame(
    Parameter = c("Площ", "Налягане"),
    Value = c(paste(round(min_area, 1), "mm²"),
              paste(round(max_pressure, 2), "mN/m"))
  )

  # Plot the isoter and save the results in isoterm plot
  isotherm_plot <-
    ggplot(data, aes(x = surface_area_mm2, y = surface_pressure_mN_m)) +

    # Line
    geom_line(color = "blue", linewidth = 1) +

    # The max point
    geom_point(data = max_point,
               color = "red", size = 4, shape = 17) +

    # Vertical line from the max point
    geom_vline(xintercept = min_area,
               color = "red", linetype = "dashed", alpha = 0.7) +

    # Horizontal line from the max point
    geom_hline(yintercept = max_pressure,
               color = "red", linetype = "dashed", alpha = 0.7) +

    # Table with the information about the max point
    geom_table(data = data.frame(x = max(data$surface_area_mm2) * 0.95,
                                 y = max(data$surface_pressure_mN_m) * 0.95),
               aes(x = x, y = y, label = list(point_table)),
               size = 4.5,
               table.theme = ttheme_gtminimal(
                 base_size = 11,
                 padding = unit(c(8, 6), "mm"),
                 core = list(
                   bg_params = list(fill = "white", alpha = 0.8)
                 )
               )) +
    # Titles
    labs(
      title = "Компресионна изотерма на липиден екстракт от белодробна тъкан",
      subtitle = "Червеният маркер показва точката на максимална компресия",
      x = expression("Площ на мономолекуления слой (mm"^2*")"),
      y = "Повърхностно налягане (mN/m)"
    ) +

    # Themes
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
