
#### Function to clean data_iso ####
clean_iso_data <- function(data){

  # CLean the data and save the results in clean_data_iso
  clean_data_iso <- data %>%

    # Change the names
    rename(
      surface_area_mm2 = Area_mm2,
      surface_pressure_mN_m = `pi_ mN_m`
    ) %>%

    # Remove the negative numbers for surface_pressure_mN_m
    filter(surface_pressure_mN_m > 0)

  # Return the Cleaned data
  return(
    clean_data_iso
  )
}
