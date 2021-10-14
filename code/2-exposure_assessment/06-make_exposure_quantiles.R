##============================================================================##
##

# determines exposure quantiles for each 1-km distance bin period, using the
# sum of total production volume for each; appends vectors for the exposure 
# quartiles to the input dataset, using 'input' prod volume vector and producing
# an 'output' quantile column

makeExposureQuantiles <- function(data_in, input, output, quantiles) {
  # captures original dataset so we can join new column to it later
  data_in_raw <- data_in
  # for each quantilem makes 0 the lowest qunrtile, then divides the remaining 
  # into n quantiles defined by user (with 0 as lowest quantile)
  data_in %>%
    select(monitor_day, !!input) %>%  # !! is unquote so input evaluated, not quoted 
    # remove rows with 0 production volume (i.e., no exposure); this may not be 
    # necessary when working with data from the exposure assessment function,
    # which removes monitor-days with 0 exposure
    filter((!!as.name(input)) > 0) %>%
    # find cutoffs for tertiles of the remaining rows
    # := necessaary, but don't remember why...
    mutate(!!output := ntile((!!as.name(input)), quantiles)) %>%  
    select(-!!input) %>%
    # joins with full dataset, adding new exp_quartile columns 
    right_join(data_in_raw, by = "monitor_day") %>%
    # replaces NA values with 0
    mutate(!!output := replace_na((!!as.name(output)), 0)) %>%
    return()
}

##============================================================================##