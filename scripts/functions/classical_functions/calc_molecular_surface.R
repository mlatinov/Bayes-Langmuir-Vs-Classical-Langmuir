
##### Function to Calculate molecular surface ####
calc_molecular_surface <- function(data) {

  # Constants
  mass_lipids <- 6e-6  # 6 μg in grams
  mw <- 750            # molecular weight (g/mol)

  moles <- mass_lipids / mw
  molecules <- moles * 6.022e23  # number of molecules

  # Convert all surface areas from mm² to Å²
  data <- data %>%
    mutate(
      surface_area_A2 = surface_area_mm2 * 1e14,
      area_per_molecule_A2 = surface_area_A2 / molecules
    )

  # Max pressure for reference
  max_pressure_point <- data[which.max(data$surface_pressure_mN_m),]

  # Return
  return(
  list(
    full_curve = data,
    max_point = max_pressure_point
    )
  )
}
