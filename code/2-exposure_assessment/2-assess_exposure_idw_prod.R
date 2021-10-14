#### I aim to make this into one function, combine with the *_preprod script,
#### and add if/else for well stage; I have code for this elsewhere and 
#### will adapt it


# 3.01 - this script includes two functions to assess the exposure of
# air qualtity monitoring sites to oil and gas wells


##### fxn steps
assessExposureIDW() <- function(data_aqs,
                                data_wells,
                                well_stage,
                                radius,
                                data_out,
                                data_export)
#####

data_aqs <- aqs_combined
data_wells <- di_wells %>% filter(prod_1999_to_2019 == 1)
  
  # initiates a list to capture output
  idw_output <- list()

  # starts a foor loop that goes through each monitor (n = 284)
  for (i in c(1:length(unique(data_aqs$site_id)))) {
    
    # prints
    print(i)
    
    # for the well, generates at 10 km buffer around each monitor and 
    # restricts the wells to those within the buffer
      
      # make buffer around monitor i
      monitor_buffer <- data_aqs %>%
        filter(site_id == unique(data_aqs$site_id)[i]) %>%
        # converts to sf object
        st_as_sf(coords = c("longitude", "latitude"),
                 crs = crs_nad83) %>% 
        # isolates geometry
        st_geometry() %>%
        # transform to projected CRS, necessary before making buffer
        st_transform(crs_projected) %>%
        # makes 10 km buffer
        st_buffer(dist = 10000) %>%  # distance in meters
        # converts back to unprojected NAD83 CRS for plotting
        st_transform(crs_nad83) %>%
        # combines into one shapefile
        st_union()
      
      # restricts wells to those that intersect with 'monitor_buffer'
      wells_in_buffer <- data_wells %>%
        # converts to sf object
        st_as_sf(coords = c("longitude", "latitude"),
                 crs = crs_nad83) %>% 
        # restricts to wells that intersect with 'county_buffer'
        st_intersection(monitor_buffer)
      
    # assesses exposure
        
      # if there are 0 wells within 10 km of the monitor, set exposure to 0
      #  for all month_years; we're done for this monitor, exit the loop
      if (nrow(wells_in_buffer) == 0) {
        
        idw_output[i] <- list(c("zero", 0))
        #return(0) #### fix this in case we convert to a function
        
        # else if the monitor has ≥ 1 wells within 10 km of the monitor location,
        # generate a distance matrix (or vector?)  
      } else if (nrow(wells_in_buffer) >= 1) {
        
        # starts new list to capturing IDW index for each month_year for this 
        # monitor site
        data_out <- list() 
        
        # subset of data for monitor i
        data_monitor <- data_aqs %>%
          filter(site_id == unique(data_aqs$site_id)[i])
        
        # for monitor i, generates distance matrix between the monitor
        # and each well in the 10 km buffer
        
        # makes matrix of monitor coordinates
        coord_monitor <- cbind(data_monitor$longitude[1], 
                               data_monitor$latitude[1]) %>%
          as.matrix()
        
        # makes matrix of well coordinates
        coord_wells_in_buffer <- wells_in_buffer %>%
          st_coordinates() %>%
          as.matrix()
        
        distance_matrix <- apply(coord_wells_in_buffer, 1, function(x)
          #returns a numeric vector of distances in kilometers if longlat=TRUE
          spDistsN1(coord_monitor, x, longlat = TRUE))
      
      #### pick up here, run this loop and see if it works
      # (e) for each month_year, generates a timing matrix for each well
      # within 10 km of the monitor
      for (j in c(1:length(unique(data_monitor$month_year)))) {
        
        # creates "long" wells dataframes, row for each well's exposure period
        # determines exposure interval (accounts for duplicate exp periods)
        wells_in_buffer_dates <- select(wells_in_buffer, API14,
                                         prod_exp_begin, prod_exp_end) %>%
          mutate(exp_interval = interval(prod_exp_begin, prod_exp_end))
        
        # makes timing matrix for first exposure window
        timing_matrix  <- sapply(wells_in_buffer_dates$exp_interval, 
                                  function(x)
                                    # defines exposure interval for each 'month_year' as the start date
                                    # of the 'month_year' plus 30; this is not perfect, as it does not
                                    # account for February (28 days) or months with 31 days
                                    int_overlaps(interval(data_monitor$month_year[j], 
                                                          data_monitor$month_year[j] + 30), 
                                                 x))

        # set NAs from timing matrices to False
        timing_matrix[is.na(timing_matrix)]   <- F
        
        # normalizes the timing matrix so each cell in each matrix is T or F
        timing_matrix <- timing_matrix  > 0
        
        # makes exposure matrix, equal to 'distance_matrix' * 'timing_matrix'
        exposure_matrix <- distance_matrix * timing_matrix %>%
          # converts to matrix before feeding into 'apply()' function
          as.matrix()
        
        # removes 0's in the exposure matrix
        exposure_matrix <- exposure_matrix[which(rowSums(exposure_matrix) > 0), ] %>%
          as.matrix
        
        if (sum(exposure_matrix) == 0) {
          # returns 0 as the IDW value for site_id_month_year
          data_out[[j]] <- 
            cbind(as.character(data_monitor$site_id_month_year[j]),
                  0)  # sets IDW as 0
          
          # sets 0's in the exposure matrix to NA, so that they will be 
          # dropped in the 'sapply()' function call below
        } else if (length(exposure_matrix) > 1) {
          
          # determines inverse distance-squared weighted index of exposure
          idw_index <- apply(exposure_matrix, 2, function(x) {
            # identifies if at least one well within 10 km;
            # if not, assigns exposure as 'NA'
            ifelse(sum(x) > 0,
                   (sum(sapply(x, function(y) 1 / (y)^2), na.rm = TRUE)), 
                   NA)
          }
          )
          # returns IDW value for site_id_month_year
          data_out[[j]] <- 
            cbind(as.character(data_monitor$site_id_month_year[j]),
                  idw_index)
          
          # if there's one well in the matrix, calculate IDW to that well
        }  else if (length(exposure_matrix) == 1) {
          # returns 0 as the IDW value for site_id_month_year
          
          idw_index <- (1 / exposure_matrix^2)
          
          data_out[[j]] <- 
            cbind(as.character(data_monitor$site_id_month_year[j]),
                  idw_index)  # sets IDW as 0
          
          # if there are no wells in the matrix, assign 0 as exposure
        }
        
        # returns data
        idw_output[[i]] <- data_out
      }  # closes for loop
    }
  }
  
  # binds list by rows and calls function to make exposure quartiles
  
  #### key code -- so simple but it took hours to figure out!
  # restrict to list elements that themselves are lists 
  idw_output2 <- Filter(function(x) is.list(x), idw_output) 
  # makes empty dataframe to capture output
  out <- data.frame(matrix(ncol = 2, nrow = 0))
  for (k in c(1:length(idw_output2))) {
    out <- rbind(out, unname(do.call("rbind", idw_output2[[k]])))
  }
  colnames(out) <- c("site_id_month_year", "idw_index")
  
  
  out2 <- out %>%
    as_tibble() %>%
    mutate(site_id_month_year = as.factor(site_id_month_year)) %>%
    right_join(aqs_combined, by = "site_id_month_year") %>%
    # need to convert idw_index to from factor to character to numeric
    # in order to retain the decimals
    mutate(idw_index = as.numeric(as.character(idw_index.x))) %>%
    select(-c(idw_index.x, idw_index.y))
  
  out2$idw_index[is.na(out2$idw_index)] <- 0
  summary(out2$idw_index)
  
  
  out3 <- out2 %>%
    select(site_id, longitude, latitude) %>%
    unique() %>%
    as.data.frame() %>%
    st_as_sf(coords = c("longitude", "latitude"), 
             crs = crs_nad83) %>%
    # spatial join for data_births and cal_counties
    st_join(cal_counties, join = st_intersects) %>%
    # converts back to tibble
    as_tibble() %>%
    # renames NAME column (joined from cal_counties)
    mutate(county_name = NAME) %>%
    # selects site_id and name columns
    select(site_id, county_name) %>%
    right_join(out2, by = "site_id")

  
  # exports data ready for analysis
  write_csv(out3, path = "data/interim/aqs_exposure_prod.csv")

# end #