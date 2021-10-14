##============================================================================##
## 1.4 - function to tidy the CalGEM 'All Wells' data

# cleans and prepares raw DOGGR input data for further analysis
tidyCalgemWellsData <- function(wells, di_wells) {
  
  # captures well coordinates so we can re-join them later
  well_coords <- wells %>%
    select(API, Longitude, Latitude) %>%
    rename(api_number = "API",
           longitude  = "Longitude",
           latitude   = "Latitude")
  
  di_wells <- di_wells %>% 
    mutate(api_number     = as.factor(api_number))
  
  # tidies wells data
  wells <- wells %>%
    
    # converts api_number from character to factor
    mutate(api_number = as.factor(API)) %>%
    
    # joins the prod start/end dates and cumulative amnt to the CalGEM wells
    left_join(di_wells, by = "api_number") #%>%
    
    # merges wells, which comes from CalGEM/DOGGR raw data, with
    # wells_prod_dates, which comes from processed Enverus/Drilling info data
    #left_join(wells_prod_dates, by = "api_number") %>%
    
    # renames lat/long columns
    #rename(latitude  = Latitude,
    #       longitude = Longitude)
  
  # converts dates columns to date class
  wells$date_spudded <-
    wells$SpudDate %>%   # don't use select(), causes error
    gsub(pattern = " 0:00:00", replacement = "") %>%  # drops time
    as.Date(format = "%m/%d/%Y")  # forms date
  
  # defines exposure period
  wells <- wells %>%
    
    # assume exposure period starts 7 days before spudding / after completion,
    # or 14 days before completion if no spud date,
    # or 14 days after spudding if no completion date
    
    # duration of development period, in days
    mutate(dev_time   = date_completed - date_spudded) %>%
    
    # beginning of first exposure period (applies to all wells)
    mutate(preprod_exp1_begin = if_else(is.na(date_spudded),
                                        date_completed - 14, # if no spud date
                                        date_spudded - 7),   # if spud date
           # end of first exposure period
           preprod_exp1_end   = if_else(is.na(date_completed),
                                        date_spudded + 14,
                                        date_completed + 7)) %>%
    
    # second exposure period, applies to wells with long development period
    #   defined as more than 180 days between spudding and completion
    mutate(preprod_exp2_begin = if_else(dev_time > 180,
                                        date_completed - 14,
                                        as.Date(NA)),
           preprod_exp2_end   = if_else(dev_time > 180,
                                        date_completed + 14,
                                        as.Date(NA))) %>%
    
    # adds variables with intervals for preproduction periods
    mutate(preprod_exp_interval1 = as.interval(preprod_exp1_end -
                                                 preprod_exp1_begin,
                                               preprod_exp1_begin),
           preprod_exp_interval2 = as.interval(preprod_exp2_end -
                                                 preprod_exp2_begin,
                                               preprod_exp2_begin)) %>%
    
    # keeps wells drilled during the study period; according to Wei, we have 
    # access to births data for siblings from 2006-2019; CA birth certificates 
    # with mother address linked is available for 2006-2019; for purposes of
    # this study, the study period is Jan 1 2006 to Dec 31 2019; that means
    # either the spud date, completion date, or both are in this period
    mutate(preprod_2006_to_2019_int1 = ### FIX THIS, CONVERT NA TO 0
             int_overlaps(preprod_exp_interval1, 
                          as.interval(as.Date("Dec-31-2019", 
                                              format = "%b-%d-%Y") -
                                        as.Date("Jan-01-2006", 
                                                format = "%b-%d-%Y"),
                                      as.Date("Jan-01-2006", 
                                              format = "%b-%d-%Y"))),
           preprod_2006_to_2019_int2 =
             int_overlaps(preprod_exp_interval2, 
                          as.interval(as.Date("Dec-31-2019", 
                                              format = "%b-%d-%Y") -
                                        as.Date("Jan-01-2006", 
                                                format = "%b-%d-%Y"),
                                      as.Date("Jan-01-2006",
                                              format = "%b-%d-%Y")))) %>%
    # converts NAs to 0s
    mutate(preprod_2006_to_2019_int1 =
             case_when(is.na(preprod_2006_to_2019_int1) ~ 0,  # replaces NAs
                       # below two lines necessary to pass values through
                       preprod_2006_to_2019_int1 == 0 ~ 0,
                       preprod_2006_to_2019_int1 == 1 ~ 1),
           preprod_2006_to_2019_int2 = 
             case_when(is.na(preprod_2006_to_2019_int2) ~ 0,  # replaces NAs
                       # below two lines necessary to pass values through
                       preprod_2006_to_2019_int2 == 0 ~ 0,
                       preprod_2006_to_2019_int2 == 1 ~ 1)) %>%
    
    # makes indicator for whether well was drilled during study period,
    # taking both exposure periods into account
    mutate(preprod_2006_to_2019 = if_else(preprod_2006_to_2019_int1 + 
                                            preprod_2006_to_2019_int2 >= 1,
                                          1, 0)) %>%
    
    # modifies preprod indicator to exclude wells with spud/comp dates
    # outside the study period by zeroing them out with the indicator
    #mutate(preprod_2006_to_2019 = 
    #         preprod_2006_to_2019 * preprod_include2) %>%
    
    # drops columns variables used as intermediate step
    #dplyr::select(-(preprod_exp_interval1:preprod_2006_to_2019_int2)) %>%
    
    # makes indicator for whether well was *producing* during study period
    
  # duration of production period (days)
  mutate(prod_interval = case_when(!is.na(prod_end) ~ 
                                     # if we have date for prod_end
                                     prod_end - prod_start,
                                   # if missing date for prod_end...
                                   is.na(prod_end) ~ 
                                     # ...cut off at end of study
                                     as.Date("Dec-31-2019", 
                                             format = "%b-%d-%Y") -
                                     prod_start)) %>%
    
    # beginning of first exposure period (applies to all wells)
    mutate(prod_exp_begin = if_else(is.na(prod_start),
                                    prod_end - 14, # if no spud date
                                    prod_start - 7),   # if spud date present
           # end of first exposure period
           prod_exp_end   = if_else(is.na(prod_end),
                                    prod_start + 14,
                                    prod_end + 7)) %>%
    
    # if 'prod_end' occurs *after* the study period (i.e., after 12/31/2019),
    # replace with 12/31/2019
    mutate(prod_exp_end = if_else(prod_exp_end > as.Date("Dec-31-2019", 
                                                         format = "%b-%d-%Y"),
                                  # if date after 12/31/2019, replace
                                  as.Date("Dec-31-2019", format = "%b-%d-%Y"),
                                  # else, keep originial date
                                  prod_exp_end)) %>%
    
    # makes production exposure intervals, the reported start and end dates 
    mutate(prod_exp_interval = as.interval(prod_exp_end - prod_exp_begin, 
                                           prod_exp_begin)) %>%
    
    # makes indicator for whether well was productive during study period,
    # according to Wei, we have access to births data for siblings from 
    # 2006-2019; CA birth certificates with mother address linked is available 
    # for 2006-2019; for purposes of this study, the study period is 
    # Jan 1 2006 to Dec 31 2019; that means either the spud date, 
    # completion date, or both are in this period
    mutate(prod_2006_to_2019 =
             int_overlaps(prod_exp_interval, 
                          as.interval(as.Date("Dec-31-2019", 
                                              format = "%b-%d-%Y") -
                                        as.Date("Jan-01-2006",
                                                format = "%b-%d-%Y"),
                                      as.Date("Jan-01-2006", 
                                              format = "%b-%d-%Y")))) %>%
    
    # drops unneeded 'prod_exp_interval' column
    dplyr::select(-prod_exp_interval) %>%
    
    # converts NAs to 0s
    mutate(prod_2006_to_2019 =
             case_when(is.na(prod_2006_to_2019) ~ 0,  # replaces NAs
                       # below two lines necessary to pass values through
                       prod_2006_to_2019 == 0 ~ 0,
                       prod_2006_to_2019 == 1 ~ 1)) %>%
    
    # drops non-sensical lat/long
    #subset(Latitude > 20) %>%
    
    # renames necessary additional columns
    mutate(well_status   = WellStatus,
           well_type     = WellType,
           field_name    = FieldName,
           district_name = District,
           county_name   = CountyName) %>%
    
    # keeps only variables we need
    select(api_number:county_name) %>%
    
    # joins with well coordinates
    left_join(well_coords, by = "api_number")
  
  # returns processed dataset
  return(wells)
}

##============================================================================##