
#### Function to Combine all Cleaned Datasets ####
combine_datasets <- function(datasets){

  combined_datasets <-
    datasets %>%
    imap_dfr(~ .x %>%
               mutate(
                   experiment_id = as.factor(paste0("experiment_", .y))
                 )
             )

  # Return the data
  return(combined_datasets)
}
