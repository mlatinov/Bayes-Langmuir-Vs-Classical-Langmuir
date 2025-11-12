
#### Function to clean data_iso ####
clean_iso_data <- function(datasets){

  # Loop over every dataset in the list datasets and clean the data
  datasets_clean <- map(
    datasets, ~ .x %>%

      # Standardize the names from the excel random names
    clean_names() %>%

      # Give more descriptive names
    rename_with(~ "surface_area_mm2", matches("area_mm2")) %>%
    rename_with(~ "surface_pressure_mn_m", matches("p.*m_n_m")) %>%

      # Delete every negative number for the pressure
    filter(surface_pressure_mn_m > 0)
  )

  # Return the Cleaned data
  return(
    datasets_clean
  )
}
