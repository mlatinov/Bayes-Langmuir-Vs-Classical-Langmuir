
##### Function to Calculate molecular surface ####
calc_molecular_surface <- function(data){

  # Find the point with max pressure
  max_pressure_point <- data[which.max(data$surface_pressure_mN_m),]

  # Take the surface_area_mm2 and surface_pressure_mN_m
  min_surface_area_mm2 <- max_pressure_point$surface_area_mm2
  max_surface_pressure_mN_m <- max_pressure_point$surface_pressure_mN_m

  # Calculate the molecular count
  mass_lipids <- 6e-6 # 6 μg in grams
  mw <- 750           # molecular weight

  moles <- mass_lipids / mw # Moles
  molecules <- moles * 6.022e23 # Molecular count

  # Convert from mm2 to A2
  min_area_A2 <- min_surface_area_mm2 * 1e14
  area_per_molecule <- min_area_A2 / molecules

  # Return tibble with measures
  return(tibble(
    max_pressure_point = max_pressure_point,
    min_surface_area_mm2 = min_surface_area_mm2,
    max_surface_pressure_mN_m = max_surface_pressure_mN_m,
    area_per_molecule = area_per_molecule
  ))







}
