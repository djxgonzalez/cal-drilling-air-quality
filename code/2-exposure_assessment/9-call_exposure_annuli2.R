##============================================================================##
## 2.9 - Imports interim data, identifies monitors within 15 km of wells, splits
## data by county, calls the 1-km annuli exposure assessment, assigns 0s to 
## births outside the 15 km wells buffer, and saves the data as a .rds file;
## this is done separately for new, active, and idle/abandoned wells

##------------------------------------------------------------------------------
## Sets up the environment

# attaches the exposure assessment functions
#source("code/2-exposure_assessment/6-assess_exposure_annuli_count_wind.R")
source("code/2-exposure_assessment/8-assess_exposure_annuli_volume_wind.R")

# imports interim data, converts monitors and wells tibbles to sf objects
aqs_monitor_day    <- readRDS("data/interim/aqs_monitor_day.rds")
aqs_monitor_day_sf <- aqs_monitor_day %>%
  drop_na(longitude) %>%
  dplyr::select(monitor_day, monitor_id, date, longitude, latitude) %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83)
calgem_production  <- readRDS("data/interim/calgem_production_monthly.rds")
narr_wind          <- readRDS("data/interim/narr_wind.rds")
#wells_interim      <- readRDS("data/interim/wells_interim.rds")
#wells_sf           <- wells_interim %>%
#  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83)

##### SKIP THE SECTIONS BELOW ************************************************

##-----------------------------------------------------------------------------
# Preps data for the preproduction wells exposure assessment using 1-km annuli

# makes 15 km buffer around new wells
wells_new_buffer <- wells_sf %>%
  # restricts to new wells, i.e., in preproduction during the study period
  filter(preprod_1999_to_2019 == 1) %>%
  # transforms into projected CRS for buffering
  st_transform(crs_projected) %>%
  # makes 15,000 m (15 km) buffer
  st_buffer(dist = 15000) %>%
  # merges polygons into one
  st_union() %>%
  # transforms back to primary project CRS
  st_transform(crs_nad83)

# filters to monitors within 15 km of at least one new well
aqs_sites_new <- readRDS("data/interim/aqs_sites.rds") %>% 
  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83) %>%
  st_intersection(wells_new_buffer)

# drops monitors that are far from new wells
#aqs_monitor_day_new_sf <- aqs_monitor_day_sf %>%
#  filter(monitor_id %in% aqs_sites_new$monitor_id) %>%
#  mutate(year = year(date))

# filters to wells that were in preproduction (new) during the study period  
wells_sf_new <- wells_sf %>%
  # restricts to new wells, i.e., in preproduction during the study period
  filter(preprod_1999_to_2019 == 1)

##------------------------------------------------------------------------------
## Annuli Upwind Preproduction Wells

aqs_data_in <- aqs_monitor_day_new_sf %>% 
  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83) %>%
  left_join(narr_wind, by = c("monitor_id", "date"))

nrow(aqs_data_in) # check length, then choose/edit options below as needed
#### e.g., if nrow(aqs_data_in) < 50000, change the second line as noted below

# initiates tibble to capture exposure data
aqs_daily_exp_annuli_wind <- list()

# loops through each birth, calls function to assesses exposure by trimester,
# and joins output to births dataset
#for (i in c(1:nrow(aqs_data_in))) {  #### activate the appropriate line here
#for (i in c(1:40000)) {  #### activate the appropriate line here
for (i in c(40001:nrow(aqs_data_in))) {  
  
  aqs_daily_exp_annuli_wind[[i]] <- 
    assessExposureAnnuliCountWind(aqs_data_in[i, ], 
                                  wells_sf_new,
                                  "new", 
                                  "wells_new_")
  
  # prints the index value to track progress of the loop
  print(i)
  
}

##### NOTE: remember to edit the row numbers before you export!
aqs_data_out <- do.call("rbind", aqs_daily_exp_annuli_wind)

saveRDS(aqs_data_out,
        "data/interim/aqs_daily_annuli_wind_preproduction.rds")

##------------------------------------------------------------------------------
## Placebo - Exposure to *downwind* new wells

aqs_data_in <- aqs_monitor_day_new_sf %>% 
  #filter(year == 2019) %>% ### change year every time, i.e., to 1999, 2001, etc.
  left_join(narr_wind, by = c("monitor_id", "date")) %>%
  # adds 180 degrees to wind direction to make it the inverse direction
  mutate(narr_wind_direction = narr_wind_direction + 180) %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83)

# verify dates
summary(aqs_data_in$date)

# initiates tibble to capture exposure data
aqs_daily_exp_annuli_downwind <- list()

# loops through each birdth, calls function to assesses exposure by trimester,
# and joins output to births dataset
#for (i in c(1:nrow(aqs_data_in))) {  #### activate the appropriate line here
#for (i in c(1:40000)) {  #### activate the appropriate line here
#### still need to run this!
for (i in c(40001:nrow(aqs_data_in))) {  
  
  aqs_daily_exp_annuli_downwind[[i]] <- 
    assessExposureAnnuliCountWind(aqs_data_in[i, ], 
                                  wells_sf_new,
                                  "new", 
                                  "wells_new_")
  
  # prints the index value to track progress of the loop
  print(i)
}

aqs_data_out <- do.call("rbind", aqs_daily_exp_annuli_downwind)

saveRDS(aqs_data_out,
        "data/interim/aqs_daily_annuli_downwind_preproduction.rds")


##------------------------------------------------------------------------------
# Preps data for the producing wells exposure assessment using 1-km annuli

##### PICK UP HERE ***********************************************************

# makes 10 km buffer around producing wells
wells_production_buffer <- calgem_production %>%
  drop_na(longitude) %>%
  filter(latitude > 0) %>%
  distinct(pwt_id, .keep_all = TRUE) %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83) %>%
  st_transform(crs_projected) %>%  # projected for buffering
  st_buffer(dist = 10000) %>%
  st_union() %>%
  st_transform(crs_nad83)

# filters to monitors within 10 km of at least one producing well
aqs_sites_production <- readRDS("data/interim/aqs_sites.rds") %>% 
  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83) %>%
  st_intersection(wells_production_buffer)

# drops monitors that are far from producing wells
aqs_monitor_day_production_sf <- aqs_monitor_day_sf %>%
  filter(monitor_id %in% aqs_sites_production$monitor_id) %>%
  mutate(year = year(date))

# filters to wells with any production volume (active), 1999-2017
wells_production_sf <- calgem_production %>%
  drop_na(longitude) %>%
  filter(latitude > 0) %>%
  filter(total_oil_gas_produced > 0) %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83)

##------------------------------------------------------------------------------
## Annuli Upwind Production Wells

##### START FORM HERE EACH TIME YOU START ASSESSING A NEW YEAR OF DATA
##### WE'RE PRIORITIZING YEARS 2001-2013, WHICH HAVE MOST RELIABLE 

aqs_data_in <- aqs_monitor_day_production_sf %>% 
  filter(year == 2015) %>%  # verify year
  mutate(month_year = as.Date(paste(month(date), "01", year(date),
                                    sep = "/"),
                              format = "%m/%d/%Y")) %>%
  left_join(narr_wind, by = c("monitor_id", "date"))
aqs_data_in <- aqs_data_in %>%
  mutate(latitude  = st_coordinates(aqs_data_in)[, 2],
         longitude = st_coordinates(aqs_data_in)[, 1]) %>%
  select(-geometry) %>%
  as.data.frame()

prod_data_in <- wells_production_sf %>%
  select(pwt_id, prod_month_year, total_oil_gas_produced) %>%
  filter(year(prod_month_year) == 2015)  ##### VERIFY YEAR

# verify timeframe and length of the datasets
nrow(prod_data_in)
summary(prod_data_in$prod_month_year)
nrow(aqs_data_in) ##### check length, then choose/edit options below as needed
summary(aqs_data_in$date)

# removes large datasets that don't go into the exposure assessment function
# to improve efficiency
rm(aqs_monitor_day, aqs_monitor_day_production_sf, aqs_monitor_day_sf,
   aqs_sites_production, calgem_production, narr_wind,
   wells_production_buffer, wells_production_sf)

##### START FROM HERE EACH FOR EACH SLICE OF THE PRODUCTION CODE
##### I SUGGEST DOING 10000 ROWS AT A TIME, BUT FEEL FREE TO MODIFY!

# converts the dataframe to a list object necessary to feed into lapply()
aqs_data_in2 <- split(aqs_data_in[c(70001:nrow(aqs_data_in)), ],  ##### EDIT HERE
                      seq(nrow(aqs_data_in[c(70001:nrow(aqs_data_in)), ])))  ##### AND HERE

aqs_daily_annuli_upwind_production <-
  mclapply(aqs_data_in2, 
           FUN = assessExposureAnnuliVolumeWind,
           production = prod_data_in,
           exp_variable_root = "wells_prod_upwind_")

aqs_data_out <- do.call("rbind", aqs_daily_annuli_upwind_production)

##### NOTE: remember to edit the suffix (a, b, c, etc.) before you export!
saveRDS(aqs_data_out,                                 #### VERIFY YEAR + SUFFIX
        "data/processed/aqs_daily_annuli_upwind_production_2015h.rds")



##------------------------------------------------------------------------------
## Annuli Downwind Preproduction Wells

aqs_data_in <- aqs_monitor_day_production_sf %>% 
  filter(year == 2013) %>% ##### VERIFY YEAR; CF DOES ODD, DG DOES EVEN; 2001-2013
  mutate(month_year = as.Date(paste(month(date), "01", year(date),
                                    sep = "/"),
                              format = "%m/%d/%Y")) %>%
  left_join(narr_wind, by = c("monitor_id", "date")) %>%
  # adds 180 degrees to wind direction to make it the inverse direction
  mutate(narr_wind_direction = narr_wind_direction + 180)
aqs_data_in <- aqs_data_in %>%
  mutate(latitude  = st_coordinates(aqs_data_in)[, 2],
         longitude = st_coordinates(aqs_data_in)[, 1]) %>%
  select(-geometry) %>%
  as.data.frame()

prod_data_in <- wells_production_sf %>%
  select(pwt_id, prod_month_year, total_oil_gas_produced) %>%
  filter(year(prod_month_year) == 2013)  ##### VERIFY YEAR

# verify timeframe and length of the datasets
nrow(prod_data_in)
summary(prod_data_in$prod_month_year)
nrow(aqs_data_in) ##### check length, then choose/edit options below as needed
summary(aqs_data_in$date)

# removes large datasets that don't go into the exposure assessment function
# to improve efficiency
rm(aqs_monitor_day, aqs_monitor_day_production_sf, aqs_monitor_day_sf,
   aqs_sites_production, calgem_production, narr_wind,
   wells_production_buffer, wells_production_sf)

##### START FROM HERE EACH FOR EACH SLICE OF THE PRODUCTION CODE
# converts the dataframe to a list object necessary to feed into lapply()
aqs_data_in2 <- split(aqs_data_in[c(30001:40000), ],  #nrow(aqs_data_in)
                      seq(nrow(aqs_data_in[c(30001:40000), ])))  

aqs_daily_annuli_downwind_production <-
  mclapply(aqs_data_in2, 
           FUN = assessExposureAnnuliVolumeWind,
           production = prod_data_in,
           exp_variable_root = "prod_volume_downwind_")

aqs_data_out <- do.call("rbind", aqs_daily_annuli_downwind_production)

##### NOTE: remember to edit the suffix (a, b, c, etc.) before you export!
saveRDS(aqs_data_out,                                 #### VERIFY YEAR + SUFFIX
        "data/processed/aqs_daily_annuli_downwind_production_2013d.rds")


##============================================================================##
