##============================================================================##
## 2.9 - Imports interim data, identifies monitors within 10 km of wells, splits
## data by county, calls the 1-km annuli exposure assessment, assigns 0s to 
## births outside the 10 km wells buffer, and saves the data as a .rds file;
## this is done separately for new, active, and idle/abandoned wells

##------------------------------------------------------------------------------
## Sets up the environment

# attaches the exposure assessment functions
#source("code/2-exposure_assessment/5-assess_exposure_annuli_count.R")
#source("code/2-exposure_assessment/6-assess_exposure_annuli_count_wind.R")
#source("code/2-exposure_assessment/7-assess_exposure_annuli_volume.R")
source("code/2-exposure_assessment/8-assess_exposure_annuli_volume_wind.R")

# imports interim data, converts monitors and wells tibbles to sf objects
aqs_monitor_day    <- readRDS("data/interim/aqs_monitor_day.rds")
aqs_monitor_day_sf <- aqs_monitor_day %>%
  distinct(monitor_day, .keep_all = TRUE) %>%
  drop_na(longitude) %>%
  dplyr::select(monitor_day, monitor_month, monitor_id, date, longitude, 
                latitude) %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83)
calgem_production  <- readRDS("data/interim/calgem_production_monthly.rds")
narr_wind          <- readRDS("data/interim/narr_wind.rds")
#wells_sf            <- readRDS("data/interim/wells_interim.rds") %>%
#wells_sf            <- readRDS("data/deprecated/wells_interim.rds") %>%
#   st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83)


##-----------------------------------------------------------------------------
## Preps data for the preproduction wells exposure assessment using 1-km annuli

# makes 10 km buffer around new wells
wells_preprod_buffer <- wells_sf %>%
  #filter(preprod_1999_to_2019 == 1) %>% # deprecated
  filter(preprod_2006_to_2019 == 1) %>% # wells in preproduction in study period
  st_transform(crs_projected) %>%  # transforms into projected CRS for buffering
  st_buffer(dist = 10000) %>%  # makes 10,000 m (10 km) buffer
  st_union() %>%  # merges polygons into one
  st_transform(crs_nad83)  # transforms back to primary project CRS

# filters to monitors within 15 km of at least one new well
aqs_sites_preprod <- readRDS("data/interim/aqs_sites.rds") %>% 
  st_as_sf() %>%
  st_intersection(wells_preprod_buffer)

# drops monitors that are far from new wells
aqs_monitor_day_preprod_sf <- aqs_monitor_day_sf %>%
  filter(monitor_id %in% aqs_sites_preprod$monitor_id) %>%
  mutate(year = year(date))

# filters to wells that were in preproduction (new) during the study period  
wells_preprod_sf <- wells_sf %>% filter(preprod_2006_to_2019 == 1)
#wells_preprod_sf <- wells_sf %>% filter(preprod_1999_to_2019 == 1)


##-----------------------------------------------------------------------------
## Preproduction well count - annuli - no wind

aqs_data_in <- aqs_monitor_day_preprod_sf %>% 
  filter(year %in% c(2006:2019)) %>%
  mutate(month_year = as.Date(paste(month(date), "01", year(date), sep = "/"),
                              format = "%m/%d/%Y"))
aqs_data_in <- aqs_data_in %>%
  mutate(latitude  = st_coordinates(aqs_data_in)[, 2],
         longitude = st_coordinates(aqs_data_in)[, 1]) %>%
  select(-geometry) %>%
  as.data.frame()

# verify timeframe and length of the datasets
summary(aqs_data_in$date)

# removes datasets we don't need anymore to improve efficiency
rm(aqs_monitor_day, aqs_monitor_day_sf, wells_preprod_buffer, wells_sf)

##### START FROM HERE EACH FOR EACH SLICE OF THE PRODUCTION CODE
# converts the dataframe to a list object necessary to feed into lapply()
aqs_data_in2 <- split(aqs_data_in[c(1:50000), ],
                      seq(nrow(aqs_data_in[c(1:50000), ]))) 
#aqs_data_in2 <- split(aqs_data_in[c(50001:100000), ],
#                      seq(nrow(aqs_data_in[c(1:50000), ]))) 
#aqs_data_in2 <- split(aqs_data_in[c(350001:nrow(aqs_data_in)), ],
#                      seq(nrow(aqs_data_in[c(350001:nrow(aqs_data_in)), ])))  

aqs_daily_annuli_preproduction_nowind <-
  mclapply(aqs_data_in2, 
           FUN               = assessExposureAnnuliCount,
           wells             = wells_preprod_sf,
           well_stage        = "new",
           angle_degrees     = 90,
           exp_variable_root = "preprod_count_nowind_")

aqs_data_out <- do.call("rbind", aqs_daily_annuli_preproduction_nowind)

saveRDS(aqs_data_out,                                
        "data/processed/aqs_daily_annuli_preproduction_nowind_000to050k.rds")


##-----------------------------------------------------------------------------
## Preproduction well count - annuli - upwind (90ª)

aqs_data_in <- aqs_monitor_day_preprod_sf %>% 
  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83) %>%
  left_join(narr_wind, by = c("monitor_id", "date"))

nrow(aqs_data_in) # check length, then choose/edit options below as needed
#### e.g., if nrow(aqs_data_in) < 50000, change the second line as noted below

# initiates tibble to capture exposure data
aqs_daily_exp_annuli_wind <- list()


##### NOTE: this is old code; if we need to re-do it, use mclapply instead of 
##### of a for loop to greatly improve efficiency!

# loops through each birth, calls function to assesses exposure by trimester,
# and joins output to births dataset
#for (i in c(1:nrow(aqs_data_in))) {  #### activate the appropriate line here
#for (i in c(1:40000)) {  #### activate the appropriate line here
for (i in c(40001:nrow(aqs_data_in))) {  
  
  aqs_daily_exp_annuli_wind[[i]] <- 
    assessExposureAnnuliCountWind(aqs_data_in[i, ], 
                                  wells_sf_preprod,
                                  "new", 
                                  90,
                                  "wells_preprod_")
  
  # prints the index value to track progress of the loop
  print(i)
  
}

##### NOTE: remember to edit the row numbers before you export!
aqs_data_out <- do.call("rbind", aqs_daily_exp_annuli_wind)

saveRDS(aqs_data_out,
        "data/interim/aqs_daily_annuli_wind_preproduction.rds")

##-----------------------------------------------------------------------------
## Preproduction well count - annuli - downwind (placebo)

aqs_data_in <- aqs_monitor_day_preprod_sf %>% 
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
                                  wells_sf_preprod,
                                  "new", 
                                  "wells_preprod_")
  
  # prints the index value to track progress of the loop
  print(i)
}

aqs_data_out <- do.call("rbind", aqs_daily_exp_annuli_downwind)

saveRDS(aqs_data_out,
        "data/interim/aqs_daily_annuli_downwind_preproduction.rds")

##------------------------------------------------------------------------------
## Preproduction well count - annuli - upwind (60ª) - sensitivity analysis

# removes large datasets that don't go into the fxn to improve efficiency
rm(aqs_monitor_day, aqs_monitor_day_sf, aqs_sites_preprod, wells_sf, 
   wells_preprod_buffer)

# for this assessment, we can restrict to assessing exposure only for
# monitor-days where there was upwind exposure in the 90° upwind assessment
exp_monitor_days <- readRDS("data/processed/aqs_daily_annuli_exposure.rds") %>%
  filter(preprod_count_uw_0to1km > 0 |
         preprod_count_uw_1to2km > 0 |
         preprod_count_uw_2to3km > 0 |
         preprod_count_uw_3to4km > 0 |
         preprod_count_uw_4to5km > 0 |
         preprod_count_uw_5to6km > 0 |
         preprod_count_uw_6to7km > 0 |
         preprod_count_uw_7to8km > 0 |
         preprod_count_uw_8to9km > 0 |
         preprod_count_uw_9to10km > 0) %>%
  filter(year >= 2006) %>%
  select(monitor_day)

# restricts analtyic dataset to monitor-days with potential exposure
aqs_data_in <- aqs_monitor_day_preprod_sf %>% 
  filter(monitor_day %in% exp_monitor_days$monitor_day) %>%
  # mutate(month_year = as.Date(paste(month(date), "01", year(date),
  #                                   sep = "/"),
  #                             format = "%m/%d/%Y")) %>%
  left_join(narr_wind, by = c("monitor_id", "date"))
aqs_data_in <- aqs_data_in %>%
  mutate(latitude  = st_coordinates(aqs_data_in)[, 2],
         longitude = st_coordinates(aqs_data_in)[, 1]) %>%
  dplyr::as_tibble() %>%
  dplyr::select(-geometry) %>%
  as.data.frame()

# verify timeframe and length of the datasets
nrow(aqs_data_in)
summary(aqs_data_in$date)
nrow(wells_preprod_sf)


# start each iteration here; note - i couldn't get mclapply() to work here

#aqs_data_in2 <- aqs_data_in[c(1:10000), ]
#aqs_data_in2 <- aqs_data_in[c(10001:20000), ]
aqs_data_in2 <- aqs_data_in[c(20001:nrow(aqs_data_in)), ]

aqs_daily_exp_annuli_wind <- list()

for(i in c(1:nrow(aqs_data_in2))) {
  aqs_daily_exp_annuli_wind[[i]] <- 
    assessExposureAnnuliCountWind(aqs_data_in2[i, ], 
                                  wells_preprod_sf,
                                  "new",  # well stage
                                  60,  # degrees
                                  "wells_prod_upwind_60deg_")
  print(i)
}


aqs_data_out <- do.call("rbind", aqs_daily_exp_annuli_wind)

saveRDS(aqs_data_out, 
        "data/processed/aqs_daily_annuli_preproduction_upwind_60deg_c.rds")


##------------------------------------------------------------------------------
## Preproduction well count - annuli - upwind (120ª) - sensitivity analysis

# removes large datasets that don't go into the fxn to improve efficiency
rm(aqs_monitor_day, aqs_monitor_day_sf, aqs_sites_preprod, wells_sf, 
   wells_preprod_buffer)

# for this assessment, we can restrict to assessing exposure only for
# monitor-days where there was upwind exposure in the no wind assessment
exp_monitor_days <- readRDS("data/processed/aqs_daily_annuli_exposure.rds") %>%
  filter(preprod_count_nowind_0to1km > 0 |
           preprod_count_nowind_1to2km > 0 |
           preprod_count_nowind_2to3km > 0 |
           preprod_count_nowind_3to4km > 0 |
           preprod_count_nowind_4to5km > 0 |
           preprod_count_nowind_5to6km > 0 |
           preprod_count_nowind_6to7km > 0 |
           preprod_count_nowind_7to8km > 0 |
           preprod_count_nowind_8to9km > 0 |
           preprod_count_nowind_9to10km > 0) %>%
  filter(year >= 2006) %>%
  select(monitor_day)

# restricts analtyic dataset to monitor-days with potential exposure
aqs_data_in <- aqs_monitor_day_preprod_sf %>% 
  filter(monitor_day %in% exp_monitor_days$monitor_day) %>%
  # mutate(month_year = as.Date(paste(month(date), "01", year(date),
  #                                   sep = "/"),
  #                             format = "%m/%d/%Y")) %>%
  left_join(narr_wind, by = c("monitor_id", "date"))
aqs_data_in <- aqs_data_in %>%
  mutate(latitude  = st_coordinates(aqs_data_in)[, 2],
         longitude = st_coordinates(aqs_data_in)[, 1]) %>%
  dplyr::as_tibble() %>%
  dplyr::select(-geometry) %>%
  as.data.frame()

# verify timeframe and length of the datasets
nrow(aqs_data_in)
summary(aqs_data_in$date)
nrow(wells_preprod_sf)


# start each iteration here; note - i couldn't get mclapply() to work here

#aqs_data_in2 <- aqs_data_in[c(1:10000), ]
#aqs_data_in2 <- aqs_data_in[c(10001:20000), ]
#aqs_data_in2 <- aqs_data_in[c(20001:30000), ]
#aqs_data_in2 <- aqs_data_in[c(30001:40000), ]
#aqs_data_in2 <- aqs_data_in[c(40001:50000), ]
aqs_data_in2 <- aqs_data_in[c(50001:nrow(aqs_data_in)), ]

aqs_daily_exp_annuli_wind <- list()

for(i in c(1:nrow(aqs_data_in2))) {
  aqs_daily_exp_annuli_wind[[i]] <- 
    assessExposureAnnuliCountWind(aqs_data_in2[i, ], 
                                  wells_preprod_sf,
                                  "new",  # well stage
                                  60,  # degrees
                                  "wells_prod_upwind_120deg_")
  print(i)
}


aqs_data_out <- do.call("rbind", aqs_daily_exp_annuli_wind)

saveRDS(aqs_data_out, 
        "data/processed/aqs_daily_annuli_preproduction_upwind_120deg_f.rds")

##-----------------------------------------------------------------------------
# Preps data for the producing wells exposure assessment using 1-km annuli

# makes 10 km buffer around producing wells
wells_production_buffer_a <- calgem_production %>%
  drop_na(longitude) %>%
  filter(latitude > 0) %>% 
  distinct(pwt_id, .keep_all = TRUE) %>%  ##### use for 1999-2017 data
  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83) %>%
  st_transform(crs_projected) %>%  # projected for buffering
  st_buffer(dist = 10000) %>%
  st_union() %>%
  st_transform(crs_nad83)
wells_production_buffer_b <- calgem_production %>%
  drop_na(longitude) %>%
  filter(latitude > 0) %>% 
  distinct(api_number, .keep_all = TRUE) %>%  ##### use for 2018-19 data
  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83) %>%
  st_transform(crs_projected) %>%  # projected for buffering
  st_buffer(dist = 10000) %>%
  st_union() %>%
  st_transform(crs_nad83)
wells_production_buffer <- st_union(wells_production_buffer_a,
                                    wells_production_buffer_b)

# filters to monitors within 10 km of at least one producing well
aqs_sites_production <- readRDS("data/interim/aqs_sites.rds") %>% 
  st_as_sf() %>%
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
  filter(prod_month_year >= as.Date("2006-01-01")) %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83)


##------------------------------------------------------------------------------
## Production volume sum - annuli - no wind

rm(aqs_monitor_day, aqs_monitor_day_sf, aqs_sites_production, calgem_production,
   wells_production_buffer)

aqs_data_in <- aqs_monitor_day_production_sf %>% 
  #filter(year %in% c(1999:2001)) %>%
  #filter(year %in% c(2002:2004)) %>%
  #filter(year %in% c(2005:2007)) %>%
  #filter(year %in% c(2008:2010)) %>%
  #filter(year %in% c(2011:2013)) %>%
  #filter(year %in% c(2014:2015)) %>%
  filter(year %in% c(2016:2017)) %>%
  mutate(month_year = as.Date(paste(month(date), "01", year(date),
                                    sep = "/"),
                              format = "%m/%d/%Y")) %>%
  as_tibble() %>%
  distinct(monitor_month, .keep_all = TRUE) %>%
  st_as_sf()
aqs_data_in <- aqs_data_in %>%
  mutate(latitude  = st_coordinates(aqs_data_in)[, 2],
         longitude = st_coordinates(aqs_data_in)[, 1]) %>%
  select(-geometry) %>%
  as.data.frame()

prod_data_in <- wells_production_sf %>%
  #select(pwt_id, prod_month_year, total_oil_gas_produced)
  select(api_number, prod_month_year, total_oil_gas_produced) %>%
  #filter(year(prod_month_year) %in% c(1999:2001))
  #filter(year(prod_month_year) %in% c(2002:2004))
  #filter(year(prod_month_year) %in% c(2005:2007))
  #filter(year(prod_month_year) %in% c(2008:2010))
  #filter(year(prod_month_year) %in% c(2011:2013))
  #filter(year(prod_month_year) %in% c(2014:2015))
  filter(year(prod_month_year) %in% c(2016:2017))

# verify timeframe and length of the datasets
nrow(prod_data_in)
summary(prod_data_in$prod_month_year)
nrow(aqs_data_in) 
summary(aqs_data_in$date)


# converts the dataframe to a list object necessary to feed into lapply()
aqs_data_in2 <- split(aqs_data_in[c(1:nrow(aqs_data_in)), ],  
                      seq(nrow(aqs_data_in[c(1:nrow(aqs_data_in)), ])))
aqs_daily_annuli_production_nowind <-
  mclapply(aqs_data_in2, 
           FUN = assessExposureAnnuliVolume,
           production = prod_data_in,
           exp_variable_root = "prod_volume_nowind_")
aqs_data_out <- do.call("rbind", aqs_daily_annuli_production_nowind)
saveRDS(aqs_data_out,                                 
        #"data/processed/aqs_daily_annuli_production_nowind_1999_2001.rds")
        #"data/processed/aqs_daily_annuli_production_nowind_2002_2004.rds")
        #"data/processed/aqs_daily_annuli_production_nowind_2005_2007.rds")
        #"data/processed/aqs_daily_annuli_production_nowind_2008_2010.rds")
        #"data/processed/aqs_daily_annuli_production_nowind_2011_2013.rds")
        #"data/processed/aqs_daily_annuli_production_nowind_2014_2015.rds")
        "data/processed/aqs_daily_annuli_production_nowind_2016_2017.rds")


##------------------------------------------------------------------------------
## Production volume sum - annuli - upwind (90°)

# removes extraneous datasets not used as inputs to improve efficiency
rm(aqs_monitor_day, aqs_monitor_day_sf, aqs_sites_production, calgem_production,
   wells_production_buffer)

aqs_data_in <- aqs_monitor_day_production_sf %>% 
  filter(year == 2000) %>%  # verify year
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
  filter(year(prod_month_year) == 2000)  ##### VERIFY YEAR

# verify timeframe and length of the datasets
nrow(prod_data_in)
summary(prod_data_in$prod_month_year)
nrow(aqs_data_in) ##### check length, then choose/edit options below as needed
summary(aqs_data_in$date)

# converts the dataframe to a list object necessary to feed into lapply()
#aqs_data_in2 <- split(aqs_data_in[c(1:10000), ],  
#                      seq(nrow(aqs_data_in[c(1:10000), ]))) 
aqs_data_in2 <- split(aqs_data_in[c(10001:nrow(aqs_data_in)), ],  
                      seq(nrow(aqs_data_in[c(10001:nrow(aqs_data_in)), ]))) 

aqs_daily_annuli_upwind_production <-
  mclapply(aqs_data_in2, 
           FUN = assessExposureAnnuliVolumeWind,
           production = prod_data_in,
           exp_variable_root = "wells_prod_upwind_")

aqs_data_out <- do.call("rbind", aqs_daily_annuli_upwind_production)

##### NOTE: remember to edit the suffix (a, b, c, etc.) before you export!
saveRDS(aqs_data_out,                                 #### VERIFY YEAR + SUFFIX
        "data/processed/aqs_daily_annuli_upwind_production_2000b.rds")


##------------------------------------------------------------------------------
## Production volume sum - annuli - downwind

# removes extraneous datasets not used as inputs to improve efficiency
rm(aqs_monitor_day, aqs_monitor_day_sf, aqs_sites_production, calgem_production,
   wells_production_buffer)

aqs_data_in <- aqs_monitor_day_production_sf %>% 
  filter(year == 2019) %>% ##### VERIFY YEAR; CF DOES ODD, DG DOES EVEN; 2001-2013
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
  filter(year(prod_month_year) == 2019)  ##### VERIFY YEAR

# verify timeframe and length of the datasets
nrow(prod_data_in)
summary(prod_data_in$prod_month_year)
nrow(aqs_data_in) ##### check length, then choose/edit options below as needed
summary(aqs_data_in$date)

# converts the dataframe to a list object necessary to feed into lapply()
#aqs_data_in2 <- split(aqs_data_in[c(1:10000), ],  
#                      seq(nrow(aqs_data_in[c(1:10000), ]))) 
aqs_data_in2 <- split(aqs_data_in[c(10001:nrow(aqs_data_in)), ],  
                      seq(nrow(aqs_data_in[c(10001:nrow(aqs_data_in)), ]))) 

aqs_daily_annuli_production_downwind <-
  mclapply(aqs_data_in2, 
           FUN = assessExposureAnnuliVolumeWind,
           production = prod_data_in,
           exp_variable_root = "prod_volume_downwind_")

aqs_data_out <- do.call("rbind", aqs_daily_annuli_production_downwind)

##### NOTE: remember to edit the suffix (a, b, c, etc.) before you export!
saveRDS(aqs_data_out,                                 #### VERIFY YEAR + SUFFIX
        "data/processed/aqs_daily_annuli_production_downwind_2019b.rds")


##------------------------------------------------------------------------------
## Production volume sum - annuli - upwind (60°) - sensitivity analysis

# removes extraneous datasets not used as inputs to improve efficiency
rm(aqs_monitor_day, aqs_monitor_day_sf, aqs_sites_production, calgem_production,
   wells_production_buffer_a, wells_production_buffer_b, wells_production_buffer)

# for this assessment, we can restrict to assessing exposure only for
# monitor-days where there was upwind exposure in the 90° upwind assessment
exp_monitor_days <- readRDS("data/processed/aqs_daily_annuli_exposure.rds") %>%
  filter(prod_volume_upwind_0to1km > 0 |
           prod_volume_upwind_1to2km > 0 |
           prod_volume_upwind_2to3km > 0 |
           prod_volume_upwind_3to4km > 0 |
           prod_volume_upwind_4to5km > 0 |
           prod_volume_upwind_5to6km > 0 |
           prod_volume_upwind_6to7km > 0 |
           prod_volume_upwind_7to8km > 0 |
           prod_volume_upwind_8to9km > 0 |
           prod_volume_upwind_9to10km > 0) %>%
  filter(vocs_total >= 0) %>%
  filter(year <= 2005) %>%
  select(monitor_day)



# restricts analtyic dataset to monitor-days with potential exposure
aqs_data_in <- aqs_monitor_day_production_sf %>% 
  filter(year == 2005) %>%
  filter(monitor_day %in% exp_monitor_days$monitor_day) %>%
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
  mutate(year = year(prod_month_year)) %>%
  filter(year <= 2005)

# verify timeframe and length of the datasets
nrow(aqs_data_in)
summary(aqs_data_in$date)
nrow(prod_data_in)


aqs_daily_exp_annuli_wind <- list()

for(i in c(1:nrow(aqs_data_in))) {
  aqs_daily_exp_annuli_wind[[i]] <- 
    assessExposureAnnuliVolumeWind(aqs_data_in[i, ], 
                                  prod_data_in,
                                  60,  # degrees
                                  "prod_volume_upwind_60deg_")
  print(i)
}


aqs_data_out <- do.call("rbind", aqs_daily_exp_annuli_wind)

saveRDS(aqs_data_out, 
        "data/processed/aqs_daily_annuli_production_upwind_60deg_2005.rds")


##============================================================================##