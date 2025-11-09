
#### Global Libraries  ####
library(targets)
library(tidyverse)

### Source function ###
tar_source("scripts/functions/")

#### Targets Pipeline ####
list(

  #### Load the data ####
  tar_target(
    name = data_iso,
    command = read_excel("data/iso 1.xlsx"),
    packages = "readxl"
  ),

  ##### Clean the data ####
  tar_target(
    name = clean_iso,
    command = clean_iso_data(data_iso)
    ),

  #### Classical approach ####

  ##### Plot the isotherm ####
  tar_target(
    name = iso_plot,
    command = plot_iso(clean_iso),
    packages = "ggpmisc"
  ),

  ##### Calculate molecular surface ####
  tar_target(
    name = molecular_surface,
    command = calc_molecular_surface(clean_iso)
  )

)
