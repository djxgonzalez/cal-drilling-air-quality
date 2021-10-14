##============================================================================##
## 2.5 - generalized function to assess exposure by counting the number of
## wells in 1-km radius annuli within 10 km of the monitor without wind taken
## into account

# takes monitor coordinates ('monitor') as an sf object, generates 1-km annuli
# around the monitor out to 15 km, and counts the number of well sites, both
# in the preproduction and production stages, within each annulus

assessExposureAnnuliCount <- function(monitor, 
                                      wells,
                                      well_stage, 
                                      exp_variable_root) {
  
  #.........................................................................
  # prepares the monitor dataset
  
  # captures date for feeding into the function below
  monitor_date   <- monitor$date
  monitor_lat    <- unlist(map(monitor$geometry, 1))  ##### this may be an error
  monitor_long   <- unlist(map(monitor$geometry, 2))
  
  # keeps only 'monitor_id'
  monitor <- monitor %>% 
    st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83) %>%
    select(monitor_id)
  
  #.........................................................................
  # prepares wells data
  
  # generates 10 km buffer as a mask around monitor coordinates
  monitor_mask <- monitor %>% 
    st_transform(crs_projected) %>%
    st_buffer(dist = 10000) %>%
    st_transform(crs_nad83)
  
  # subsets to wells that intersect with 'monitor_mask'  i.e., within 15 km of 
  # the maternal residence, and that have preproduction/production period 
  # that overlaps with the date
  if (well_stage == "new") {
    
    # well sites in preproduction stage
    wells_within_10km <- wells %>%
      # restricts to wells within 15 km of the input monitor
      st_intersection(monitor_mask) %>%
      # adds monitor date
      mutate(monitor_date = monitor_date) %>%
      # adds indicator for whether well was in preproduction (drilling) stage
      # during the date
      mutate(exposed1 = monitor_date %within% preprod_exp_interval1) %>%
      mutate(exposed2 = monitor_date %within% preprod_exp_interval2) %>%
      mutate(exposed1 = replace_na(exposed1, FALSE)) %>%
      mutate(exposed2 = replace_na(exposed2, FALSE)) %>%
      mutate(exposed  = exposed1 + exposed2) %>%
      # keeps only monitors that are exposed
      filter(exposed >= 1)
    
  } else if (well_stage == "active") {
    
    wells_within_10km <- wells %>%
      # restricts to wells within 15 km of the input monitor
      st_intersection(monitor_mask) %>%
      # adds monitor date
      mutate(monitor_date = monitor_date) %>%
      # adds indicator for whether well was in production (active) stage
      # during the date
      mutate(exposed = int_overlaps(monitor_date, prod_exp_interval)) %>%
      filter(exposed == 1)
    
  }
  
  
  #.........................................................................
  # if there are wells that have dates that intersect with the monitor interval,
  # counts and stores number of well sites within each annulus; otherwise, we
  # assign 0 to all annuli wihtout annuli functions to improve efficiency;
  # the variable names are flexible name to account for new, active, idle, or 
  # abandoned wells
  
  if (nrow(wells_within_10km) > 0) {
    
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
    
    # counts wells within each 1-km annulus
    monitor <- monitor %>%  
      mutate(!!as.name(paste(exp_variable_root, sep = "", "0to1km")) :=   
               sum(unlist(st_intersects(wells_within_10km, annulus0to1))),
             !!as.name(paste(exp_variable_root, sep = "", "1to2km")) := 
               sum(unlist(st_intersects(wells_within_10km, annulus1to2))),
             !!as.name(paste(exp_variable_root, sep = "", "2to3km")) := 
               sum(unlist(st_intersects(wells_within_10km, annulus2to3))),
             !!as.name(paste(exp_variable_root, sep = "", "3to4km")) := 
               sum(unlist(st_intersects(wells_within_10km, annulus3to4))),
             !!as.name(paste(exp_variable_root, sep = "", "4to5km")) := 
               sum(unlist(st_intersects(wells_within_10km, annulus4to5))),
             !!as.name(paste(exp_variable_root, sep = "", "5to6km")) := 
               sum(unlist(st_intersects(wells_within_10km, annulus5to6))),
             !!as.name(paste(exp_variable_root, sep = "", "6to7km")) := 
               sum(unlist(st_intersects(wells_within_10km, annulus6to7))),
             !!as.name(paste(exp_variable_root, sep = "", "7to8km")) := 
               sum(unlist(st_intersects(wells_within_10km, annulus7to8))),
             !!as.name(paste(exp_variable_root, sep = "", "8to9km")) := 
               sum(unlist(st_intersects(wells_within_10km, annulus8to9))),
             !!as.name(paste(exp_variable_root, sep = "", "9to10km")) := 
               sum(unlist(st_intersects(wells_within_10km, annulus9to10)))) %>%
      as_tibble() %>% 
      select(-geometry) %>%
      mutate(date = monitor_date)
    
  } else if (nrow(wells_within_10km) == 0) {
    
    monitor <- monitor %>% 
      
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
      as_tibble() %>% 
      select(-geometry) %>%
      mutate(date = monitor_date)
    
  }
  
  
  #.........................................................................
  # returns the processed exposure data
  
  return(monitor)
  
}

##============================================================================##