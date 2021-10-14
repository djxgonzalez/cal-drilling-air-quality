##============================================================================##
## 2.5 - these functions import the given raw NARR data set by year, extracts 
## the raster of observations for each day in each year, stores the rasters in a 
## list, stacks them, intersects them with the AQS monitoring sites, converts 
## the resulting dataset from wide to long format, changes the day of year to 
## date, and returns a processed dataset with one observation for the given 
## meteorological variable for each monitor-day, along with the monitor_id and 
## date


##----------------------------------------------------------------------------
## this function processes one year's worth of NARR raster data from the 
## input NetCDF file

tidyNARRData <- function(narr_data_path,
                         narr_variable_name,
                         narr_year) {
  
  #.........................................................................
  # imports data from the input NetCDF file

  narr_stack <- raster::stack(narr_data_path)
  
  
  #.........................................................................
  # extracts values for each monitor-day for all monitors
  
  # extracts narr_data values for each raster at each monitor site
  narr_extract = raster::extract(narr_stack, 
                                 st_transform(aqs_sites_sf,
                                              projection(narr_stack)))
  
  # binds the narr_extract and aqs_sites_sf to bring back monitor_id
  narr_data = cbind(aqs_sites_sf, narr_extract)  %>%
    # converts the data to a tibble
    as_tibble() %>%
    # drops geometry column, which we don't need anymore
    dplyr::select(-geometry)
  
  #.........................................................................
  # tidies the extracted data
  
  # renames the columns to match the day-of-year, with option for leap year
  colnames(narr_data)[2:367] <- c(1:366)

  narr_data <- narr_data %>%
    # converts data from wide to long
    pivot_longer(-monitor_id, 
                 names_to  = "day_of_year", 
                 values_to = as.character(narr_variable_name)) %>%
    # subtract 0 from day of year to feed into as.Date fxn, which starts at 0
    mutate(day_of_year = as.numeric(day_of_year) - 1) %>%
    # converts day-of-year to date
    mutate(date = as.Date(day_of_year, origin = paste(as.character(narr_year), 
                                                      "-01-01", 
                                                      sep = ""))) %>%
    # drops variables we don't need anymore
    dplyr::select(-day_of_year)
  
  #.........................................................................
  # returns processed dataset
  return(narr_data)
  
}

##============================================================================##