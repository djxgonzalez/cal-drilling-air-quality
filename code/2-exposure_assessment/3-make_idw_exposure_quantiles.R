# 3.4 - makes exposure quantiles based on IDW index

# determines exposure quantiles (based on user input) for each gestational 
# period, using the exposure indices for each; appends vectors for the exposure
# quartiles  to the aqs monitor dataset, using 'input' idw_index column and 
# producing an 'output' exp_quartile column

makeExposureQuantiles <- function(data_in, input, output, quantiles) {
  
  # captures original dataset so we can join new column to it later
  data_in_raw <- data_in
  # for each time interval, this function makes 0 the lowest quartile, 
  # then divides the remaining into tertiles (resulting in quantiles
  # with 0 as lowest)
  data_in %>%
    # keeps only the ID and IDW index columns
    # note: !! means unquote, so that input is evaluated, not quoted
    dplyr::select(site_id_month_year, !!input) %>% 
    # remove rows with IDW index of 0 (i.e., no exposure); this may not be 
    # necessary when working with data from the exposure assessment function,
    # which removes monitor-months with 0 exposure
    filter((!!as.name(input)) > 0) %>%
    # find cutoffs for tertiles of the remaining rows
    # note: ':=' is assignment by reference, seems necessary when using '!!'
    mutate(!!output := ntile((!!as.name(input)), quantiles)) %>%  
    # drops idw_index column
    dplyr::select(-!!input) %>%
    # joins with full dataset, adding new exp_quartile columns 
    right_join(data_in_raw, by = "site_id_month_year") %>%
    # replaces NA values with 0
    mutate(!!output := replace_na((!!as.name(output)), 0)) %>%
    # returns the data
    return()
}

# end