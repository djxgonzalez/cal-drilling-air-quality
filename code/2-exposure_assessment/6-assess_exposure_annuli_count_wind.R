##============================================================================##
## 2.6 - generalized function to assess exposure by counting the number of
## upwind or downwind wells in 1-km radius annuli within 10km of the site,
## using NARR data for daily mean wind direction

# takes monitor coordinates ("monitor") as an sf object, generates 1-km annuli
# around the monitor out to 10 km, and counts the number of well sites, both
# in the preproduction and production stages, within each annulus

# test data
# monitor <- aqs_data_in %>% filter(monitor_day == "060290232_2011-11-08")
# wells <- wells_preprod_sf
# well_stage <- "new"
# angle_degrees <- 60
# exp_variable_root <- "test_"

assessExposureAnnuliCountWind <- function(monitor, 
                                          wells,
                                          well_stage, 
                                          angle_degrees, # up- or donwind angle
                                          exp_variable_root) {
  
  #.........................................................................
  # prepares the monitor dataset
  
  # captures date for feeding into the function below
  monitor_date   <- monitor$date
  wind_direction <- monitor$narr_wind_direction
  monitor_lat    <- unlist(map(monitor$geometry, 1))  ##### this may be an error
  monitor_long   <- unlist(map(monitor$geometry, 2))
  
  # keeps only 'monitor_id'
  monitor <- monitor %>% 
    st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83) %>%
    select(monitor_id)
  
  # captures date for feeding into the function below
  #monitor_id     <- monitor$monitor_id
  #monitor_date   <- monitor$date
  #monitor_lat    <- monitor$latitude
  #monitor_long   <- monitor$longitude
  #wind_direction <- monitor$narr_wind_direction
  #angle_degrees  <- (as.numeric(angle_degrees) / 2) # to create wedge, 2 halves
  
  # makes sf object with only "monitor_id"
  #monitor <- data.frame(monitor_id, monitor_long, monitor_lat) %>%
  #  st_as_sf(coords = c("monitor_long", "monitor_lat"), crs = crs_nad83)
  
  #.........................................................................
  # prepares wells data
  
  # generates 10 km buffer as a mask around monitor coordinates
  monitor_mask <- monitor %>% 
    st_transform(crs_projected) %>%
    st_buffer(dist = 10000) %>%
    st_transform(crs_nad83)
  
  # subsets to wells that intersect with "monitor_mask"  i.e., within 10 km of 
  # the maternal residence, and that have preproduction/production period 
  # that overlaps with the date
  if (well_stage == "new") {
    
    # well sites in preproduction stage
    wells_within_10km <- wells %>%
      # restricts to wells within 10 km of the input monitor
      st_intersection(monitor_mask) %>%
      mutate(monitor_date = monitor_date) %>%  # adds monitor date
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
      # restricts to wells within 10 km of the input monitor
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
    # makes annuli around the maternal residence coordinates in the "monitor" data
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
    ## creates a "wedge" facing towards the upwind origin point (point0)
    
    # captures monitor point from the coordinates
    monitor_point <- matrix(c(monitor_lat, monitor_long),
                            ncol = 2, byrow = TRUE)
    colnames(monitor_point) <- c("lat", "long") 
    monitor_point <- as_tibble(monitor_point) %>%
      mutate(lat  = as.numeric(lat), long = as.numeric(long))
    
    # calculating upwind vector and creating a matrix
    upwind_point0 <- matrix(c((monitor_lat  + ((20/110.574) *  
                                                 cos(wind_direction * (pi/180)))),
                              (monitor_long + ((20/110.574) * 
                                                 sin(wind_direction * (pi/180))))),
                            ncol = 2, byrow = TRUE)
    colnames(upwind_point0) <- c("lat", "long") 
    upwind_point0 <- as_tibble(upwind_point0) %>%
      mutate(lat  = as.numeric(lat), long = as.numeric(long))
    
    # calculating upwind points on either side of the wind direction
    
    # first point
    upwind_point1 <-
      matrix(c((monitor_lat  + (((20 / 110.574) / cos(angle_degrees * (pi/180))) * 
                                  cos((wind_direction + angle_degrees) * (pi/180)))),
               (monitor_long + (((20 / 110.574) / cos(angle_degrees * (pi/180))) *
                                  sin((wind_direction + angle_degrees) * (pi/180))))),
             ncol = 2, byrow = TRUE)
    colnames(upwind_point1) <- c("lat", "long")
    upwind_point1 <- as_tibble(upwind_point1) %>%
      mutate(lat  = as.numeric(lat), long = as.numeric(long))
    
    # second point
    upwind_point2 <- 
      matrix(c((monitor_lat + (((20 / 110.574) / cos(angle_degrees * (pi/180))) *
                                 cos((wind_direction - angle_degrees) * (pi/180)))),
               (monitor_long + (((20 / 110.574) / cos(angle_degrees * (pi/180)))*
                                  sin((wind_direction - angle_degrees) * (pi/180))))),
             ncol = 2, byrow = TRUE)
    colnames(upwind_point2) <- c("lat", "long")
    upwind_point2 <- as_tibble(upwind_point2) %>%
      mutate(lat  = as.numeric(lat), long = as.numeric(long))
    
    # makes the first half of the "wedge"
    wedge1 <- full_join(upwind_point1, upwind_point0) %>% 
      full_join(y = monitor_point)
    wedge1 <- st_as_sf(wedge1, coords = c("long", "lat"), crs = crs_nad83)
    wedge1 <- wedge1 %>%
      st_coordinates() %>%
      st_multipoint() %>% 
      st_cast("POLYGON") %>% 
      st_sfc(crs = crs_nad83)
    
    # makes the second half of the "wedge"
    wedge2 <- full_join(upwind_point2, upwind_point0) %>% 
      full_join(y = monitor_point) 
    wedge2 <- st_as_sf(wedge2, coords = c("long", "lat"), crs = crs_nad83)
    wedge2 <- wedge2 %>% 
      st_coordinates() %>%
      st_multipoint() %>% 
      st_cast("POLYGON") %>%
      st_sfc(crs = crs_nad83)
    
    # combines the two halves into the full wedge
    upwind_wedge <- st_union(wedge1, wedge2)
    
    #.........................................................................
    
    # finalizes annuli by successively clipping differences in reverse order
    annulus9to10  <- st_difference(annulus9to10,  annulus8to9) %>%
      st_intersection(upwind_wedge)
    annulus8to9   <- st_difference(annulus8to9,   annulus7to8) %>%
      st_intersection(upwind_wedge)
    annulus7to8   <- st_difference(annulus7to8,   annulus6to7) %>%
      st_intersection(upwind_wedge)
    annulus6to7   <- st_difference(annulus6to7,   annulus5to6) %>%
      st_intersection(upwind_wedge)
    annulus5to6   <- st_difference(annulus5to6,   annulus4to5) %>%
      st_intersection(upwind_wedge)
    annulus4to5   <- st_difference(annulus4to5,   annulus3to4) %>%
      st_intersection(upwind_wedge)
    annulus3to4   <- st_difference(annulus3to4,   annulus2to3) %>%
      st_intersection(upwind_wedge)
    annulus2to3   <- st_difference(annulus2to3,   annulus1to2) %>%
      st_intersection(upwind_wedge)
    annulus1to2   <- st_difference(annulus1to2,   annulus0to1) %>%
      st_intersection(upwind_wedge)
    annulus0to1   <- st_intersection(annulus0to1, upwind_wedge)
    
    # counts wells within each 1-km annulus
    monitor <- monitor %>%  
      as_tibble() %>% 
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
      select(-geometry) %>%
      mutate(date = monitor_date)
    
  } else if (nrow(wells_within_10km) == 0) {
    
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