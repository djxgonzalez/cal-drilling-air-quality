##============================================================================##
## 2.7 - generalized function to assess exposure by taking the sum of the volume
## in 1-km radius annuli within 10 km of the monitor; takes monitor coordinates 
## ('monitor') as an sf object, generates 1-km annuli around the monitor out to
## 10 km, and sums the volume of total oil and gas production within each annulus

assessExposureAnnuliVolume <- function(monitor, 
                                       production,
                                       exp_variable_root) {
  
  #.........................................................................
  # prepares the monitor dataset
  
  # captures date for feeding into the function below
  monitor_date       <- monitor$date
  monitor_month_year <- monitor$month_year
  monitor_lat        <- monitor$latitude
  monitor_long       <- monitor$longitude
  
  # makes sf object with only 'monitor_id'
  monitor <- monitor %>%
    st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83) %>%
    select(monitor_id)
  
  #.........................................................................
  # prepares production data
  
  # generates 15 km buffer as a mask around monitor coordinates
  monitor_mask <- monitor %>% 
    st_transform(crs_projected) %>%
    st_buffer(dist = 10000) %>%
    st_transform(crs_nad83)
  
  # subsets to production that intersect with 'monitor_mask'  i.e., within 10 km of 
  # the maternal residence, and that have production period that overlaps with 
  # the date
  prod_within_10km <- production %>%
    # restricts to production within 15 km of the input monitor
    st_intersection(monitor_mask) %>%
    # adds monitor date, captured above
    mutate(monitor_month_year = monitor_month_year) %>%
    # adds indicator for whether producing well 
    mutate(exposed = (monitor_month_year == prod_month_year)) %>%    
    filter(exposed == 1) %>%
    select(total_oil_gas_produced)
  
  #.........................................................................
  # if there are production that have dates that intersect with the monitor interval,
  # counts and stores number of well sites within each annulus; otherwise, we
  # assign 0 to all annuli wihtout annuli functions to improve efficiency;
  # the variable names are flexible name to account for new, active, idle, or 
  # abandoned production
  
  if (nrow(prod_within_10km) > 0) {
    
    #.......................................................................
    # makes annuli around the maternal residence coordinates in the 'monitor' data
    annulus0to1 <- monitor %>%
      st_transform(crs_projected) %>%
      st_buffer(dist = 1000) %>%
      st_transform(crs_nad83)
    annulus1to2 <- monitor %>% 
      st_transform(crs_projected) %>%
      st_buffer(dist = 2000) %>%
      st_transform(crs_nad83)
    annulus2to3 <- monitor %>% 
      st_transform(crs_projected) %>%
      st_buffer(dist = 3000) %>%
      st_transform(crs_nad83)
    annulus3to4 <- monitor %>% 
      st_transform(crs_projected) %>%
      st_buffer(dist = 4000) %>%
      st_transform(crs_nad83)
    annulus4to5 <- monitor %>% 
      st_transform(crs_projected) %>%
      st_buffer(dist = 5000) %>%
      st_transform(crs_nad83)
    annulus5to6 <- monitor %>% 
      st_transform(crs_projected) %>%
      st_buffer(dist = 6000) %>%
      st_transform(crs_nad83)
    annulus6to7 <- monitor %>% 
      st_transform(crs_projected) %>%
      st_buffer(dist = 7000) %>%
      st_transform(crs_nad83)
    annulus7to8 <- monitor %>% 
      st_transform(crs_projected) %>%
      st_buffer(dist = 8000) %>%
      st_transform(crs_nad83)
    annulus8to9 <- monitor %>% 
      st_transform(crs_projected) %>%
      st_buffer(dist = 9000) %>%
      st_transform(crs_nad83)
    annulus9to10 <- monitor_mask
    
    #.........................................................................
    
    # finalizes annuli by successively clipping differences in reverse order
    annulus9to10  <- st_difference(annulus9to10,  annulus8to9)
    annulus8to9   <- st_difference(annulus8to9,   annulus7to8)
    annulus7to8   <- st_difference(annulus7to8,   annulus6to7)
    annulus6to7   <- st_difference(annulus6to7,   annulus5to6)
    annulus5to6   <- st_difference(annulus5to6,   annulus4to5)
    annulus4to5   <- st_difference(annulus4to5,   annulus3to4)
    annulus3to4   <- st_difference(annulus3to4,   annulus2to3)
    annulus2to3   <- st_difference(annulus2to3,   annulus1to2)
    annulus1to2   <- st_difference(annulus1to2,   annulus0to1)
    
    # takes sum of total oil/gas production for production within each 1-km annulus
    monitor <- monitor %>%  
      as_tibble() %>%
      mutate(!!as.name(paste(exp_variable_root, sep = "", "0to1km")) :=   
               ifelse(nrow(st_intersection(annulus0to1, prod_within_10km)) == 0, 0,
                      as.matrix(aggregate(x = prod_within_10km, by = annulus0to1, 
                                          FUN = sum))[[1]]),
             !!as.name(paste(exp_variable_root, sep = "", "1to2km")) := 
               ifelse(nrow(st_intersection(annulus1to2, prod_within_10km)) == 0, 0,
                      as.matrix(aggregate(x = prod_within_10km, by = annulus1to2, 
                                          FUN = sum))[[1]]),
             !!as.name(paste(exp_variable_root, sep = "", "2to3km")) := 
               ifelse(nrow(st_intersection(annulus2to3, prod_within_10km)) == 0, 0,
                      as.matrix(aggregate(x = prod_within_10km, by = annulus2to3, 
                                          FUN = sum))[[1]]),
             !!as.name(paste(exp_variable_root, sep = "", "3to4km")) :=
               ifelse(nrow(st_intersection(annulus3to4, prod_within_10km)) == 0, 0,
                      as.matrix(aggregate(x = prod_within_10km, by = annulus3to4,
                                          FUN = sum))[[1]]),
             !!as.name(paste(exp_variable_root, sep = "", "4to5km")) :=
               ifelse(nrow(st_intersection(annulus4to5, prod_within_10km)) == 0, 0,
                      as.matrix(aggregate(x = prod_within_10km, by = annulus4to5,
                                          FUN = sum))[[1]]),
             !!as.name(paste(exp_variable_root, sep = "", "5to6km")) :=
               ifelse(nrow(st_intersection(annulus5to6, prod_within_10km)) == 0, 0,
                      as.matrix(aggregate(x = prod_within_10km, by = annulus5to6, 
                                          FUN = sum))[[1]]),
             !!as.name(paste(exp_variable_root, sep = "", "6to7km")) :=
               ifelse(nrow(st_intersection(annulus6to7, prod_within_10km)) == 0, 0,
                      as.matrix(aggregate(x = prod_within_10km, by = annulus6to7, 
                                          FUN = sum))[[1]]),
             !!as.name(paste(exp_variable_root, sep = "", "7to8km")) :=
               ifelse(nrow(st_intersection(annulus7to8, prod_within_10km)) == 0, 0,
                      as.matrix(aggregate(x = prod_within_10km, by = annulus7to8, 
                                          FUN = sum))[[1]]),
             !!as.name(paste(exp_variable_root, sep = "", "8to9km")) :=
               ifelse(nrow(st_intersection(annulus8to9, prod_within_10km)) == 0, 0,
                      as.matrix(aggregate(x = prod_within_10km, by = annulus8to9,
                                          FUN = sum))[[1]]),
             !!as.name(paste(exp_variable_root, sep = "", "9to10km")) :=
               ifelse(nrow(st_intersection(annulus9to10, prod_within_10km)) == 0, 0,
                      as.matrix(aggregate(x = prod_within_10km, by = annulus9to10, 
                                          FUN = sum))[[1]])) %>%
      select(-geometry) %>%
      mutate(date = monitor_date)
    
  } else if (nrow(prod_within_10km) == 0) {
    
    monitor <- monitor %>% 
      as_tibble() %>%
      mutate(!!as.name(paste(exp_variable_root, sep = "", "0to1km"))   := 0,
             !!as.name(paste(exp_variable_root, sep = "", "1to2km"))   := 0,
             !!as.name(paste(exp_variable_root, sep = "", "2to3km"))   := 0,
             !!as.name(paste(exp_variable_root, sep = "", "3to4km"))   := 0,
             !!as.name(paste(exp_variable_root, sep = "", "4to5km"))   := 0,
             !!as.name(paste(exp_variable_root, sep = "", "5to6km"))   := 0,
             !!as.name(paste(exp_variable_root, sep = "", "6to7km"))   := 0,
             !!as.name(paste(exp_variable_root, sep = "", "7to8km"))   := 0,
             !!as.name(paste(exp_variable_root, sep = "", "8to9km"))   := 0,
             !!as.name(paste(exp_variable_root, sep = "", "9to10km"))  := 0) %>%
      select(-geometry) %>%
      mutate(date = monitor_date)
    
  }
  
  
  #.........................................................................
  # returns the processed exposure data
  
  return(monitor)
  
}

##============================================================================##