##============================================================================##
## 3.1 - Combines interim datasets to 

#............................................................................
# imports data components

#aqs_monitor_day  <- readRDS("data/interim/aqs_monitor_day.rds")
####### re-do everything that requires AQS sites; remake aqs sites based on 
####### revised full dataset below, which now has 419 since we have CO, NO, PM10
aqs_sites         <- readRDS("data/interim/aqs_sites.rds")
aqs_sites_sf      <- aqs_sites %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83)
aqs_sites_zip     <- read_csv("data/interim/aqs_sites_zip.csv") %>%
  mutate(monitor_id = paste("0", monitor_id, sep = ""),
         zip_code   = as.factor(zip_code))
cal_urban         <- readRDS("data/interim/cal_urban.rds")
narr_precip       <- readRDS("data/interim/narr_precipitation.rds") 
narr_temp         <- readRDS("data/interim/narr_temperature.rds")
narr_wind         <- readRDS("data/interim/narr_wind.rds")
wells_interim     <- readRDS("data/interim/wells_interim.rds")
wells_buffer_10km <- wells_interim %>%
  filter(latitude > 0) %>%  # drops non-sensical points
  # filters to wells drilled during study period
  filter(preprod_1999_to_2019 == 1 | prod_1999_to_2019 == 1) %>%
  # selects only columns with lat/long
  select(longitude, latitude) %>%
  # convert into sf object
  st_as_sf(coords = c("longitude", "latitude"),
           crs    = crs_nad83) %>%
  # transform to projected CRS, necessary before making  buffer
  st_transform(crs_projected) %>%
  # makes 100 km buffer
  st_buffer(dist = 10000) %>%  # distance in meters (equivalent to 10 km)
  # merges overlapping polygons
  st_union() %>%
  # converts back to unprojected NAD83 CRS for plotting
  st_transform(crs_nad83)
wells_buffer_5km <- wells_interim %>%
  filter(latitude > 0) %>%  # drops non-sensical points
  # filters to wells drilled during study period
  filter(preprod_1999_to_2019 == 1 | prod_1999_to_2019 == 1) %>%
  # selects only columns with lat/long
  select(longitude, latitude) %>%
  # convert into sf object
  st_as_sf(coords = c("longitude", "latitude"),
           crs    = crs_nad83) %>%
  # transform to projected CRS, necessary before making  buffer
  st_transform(crs_projected) %>%
  # makes 100 km buffer
  st_buffer(dist = 5000) %>%  # distance in meters (equivalent to 10 km)
  # merges overlapping polygons
  st_union() %>%
  # converts back to unprojected NAD83 CRS for plotting
  st_transform(crs_nad83)
zip_by_day_smoke <- readRDS("data/interim/zip_by_day_smoke.rds")

# exposure data
aqs_daily_annuli_preproduction_uw <-
  readRDS("data/deprecated/aqs_daily_annuli_preproduction_upwind.rds")
#aqs_daily_annuli_preproduction_dw <-
#  readRDS("data/deprecated/aqs_daily_annuli_preproduction_downwind.rds")

##### add daily preproduction with random wind, production with wind directions
##### when we have the datasets



#............................................................................
# tidies air pollution data

aqs_daily_annuli_preproduction_dw <- aqs_daily_annuli_preproduction_dw %>%
  distinct(monitor_day, .keep_all = TRUE) %>%
  select(monitor_day, wells_new_0to1km:wells_new_9to10km) %>%
  rename(preprod_count_dw_0to1km  = wells_new_0to1km,
         preprod_count_dw_1to2km  = wells_new_1to2km,
         preprod_count_dw_2to3km  = wells_new_2to3km,
         preprod_count_dw_3to4km  = wells_new_3to4km,
         preprod_count_dw_4to5km  = wells_new_4to5km,
         preprod_count_dw_5to6km  = wells_new_5to6km,
         preprod_count_dw_6to7km  = wells_new_6to7km,
         preprod_count_dw_7to8km  = wells_new_7to8km,
         preprod_count_dw_8to9km  = wells_new_8to9km,
         preprod_count_dw_9to10km = wells_new_9to10km)

# makes dataset of monitor-days with any exposure to smoke plumes; monitor-days
# without smoke plumes aren't included here, so we'll need to convert NAs to 0s
# after joining this with the analytic dataset; note that we only have smoke
# data for 2006-2019
aqs_monitor_day_smoke <- aqs_sites_zip %>%
  mutate(zip         = as.factor(zip_code)) %>% 
  inner_join(zip_by_day_smoke, by = "zip") %>%
  mutate(date = as.Date(paste(month, day, year, sep = "/"), format = "%m/%d/%Y"),
         monitor_id = as.factor(paste("0", monitor_id, sep = ""))) %>%
  select(monitor_id, date, smoke_day, n_plume, zip) %>%
  rename(zip_code = zip)
rm(aqs_sites_zip, zip_by_day_smoke)

aqs_sites_urban <- aqs_sites_sf %>%
  st_intersection(cal_urban) %>%
  as_tibble() %>%
  select(monitor_id) %>%
  mutate(is_urban = 1)

aqs_sites_wells <- aqs_sites_sf %>%
  st_intersection(wells_buffer_5km) %>%
  as_tibble() %>%
  select(monitor_id) %>%
  mutate(near_wells_5km = 1)

aqs_daily_annuli_preproduction <- aqs_daily_annuli_preproduction_uw %>%
  mutate(month = month(date),
         year  = year(date)) %>%
  select(monitor_day, monitor_id, date, month, year, month_year, 
         carb_basin, county, 
         wells_new_0to1km:wells_new_9to10km) %>%
  rename(preprod_count_uw_0to1km  = wells_new_0to1km,
         preprod_count_uw_1to2km  = wells_new_1to2km,
         preprod_count_uw_2to3km  = wells_new_2to3km,
         preprod_count_uw_3to4km  = wells_new_3to4km,
         preprod_count_uw_4to5km  = wells_new_4to5km,
         preprod_count_uw_5to6km  = wells_new_5to6km,
         preprod_count_uw_6to7km  = wells_new_6to7km,
         preprod_count_uw_7to8km  = wells_new_7to8km,
         preprod_count_uw_8to9km  = wells_new_8to9km,
         preprod_count_uw_9to10km = wells_new_9to10km) %>%
  distinct(monitor_day, .keep_all = TRUE) %>%
  left_join(aqs_daily_annuli_preproduction_dw)
aqs_daily_annuli_preproduction2 <- aqs_daily_annuli_preproduction_uw %>%
  group_by(monitor_day) %>%
  summarize(pm25_mean  = mean(pm2.5_concentration_daily_mean, na.rm = TRUE),
            pm10_mean  = mean(pm10_concentration_daily_mean, na.rm = TRUE),
            co_max     = mean(co_concentration_daily_max, na.rm = TRUE),
            no_max     = mean(no_concentration_daily_max, na.rm = TRUE),
            no2_max    = mean(no2_concentration_daily_max, na.rm = TRUE),
            o3_max     = mean(o3_concentration_daily_max, na.rm = TRUE),
            so2_max    = mean(so2_concentration_daily_max, na.rm = TRUE),
            nmoc_total = mean(total_nmoc, na.rm = TRUE)) %>%
  filter(pm25_mean   >= 0 | pm10_mean >= 0 | co_max  >= 0 | no_max     >= 0 | 
           no2_max   >= 0 | o3_max    >= 0 | so2_max >= 0 | nmoc_total >= 0) %>%
  left_join(aqs_daily_annuli_preproduction) %>%
  left_join(aqs_monitor_day_smoke) %>%
  left_join(aqs_sites_urban) %>%
  left_join(aqs_sites_near_wells) %>%
  left_join(aqs_sites_wells) %>%
  mutate(smoke_day  = replace_na(smoke_day,  0),
         n_plume    = replace_na(n_plume,    0),
         is_urban   = replace_na(is_urban,   0),
         near_wells = replace_na(near_wells, 0),
         zip_code   = as.factor(zip_code))


#aqs_daily_annuli_preproduction2 <- aqs_daily_annuli_preproduction %>%
#  select(-nmoc_total) %>%
#  left_join(d) #%>%
#  #mutate(nmoc_total = replace_na(nmoc_total, 0))

# revised analysis to add monitor-level data
aqs_daily_annuli_preproduction2 <- aqs_daily_annuli_preproduction %>%
  select(-c(smoke_day, n_plume, zip_code, is_urban, near_wells)) %>%
  left_join(aqs_daily_annuli_preproduction) %>%
  left_join(aqs_monitor_day_smoke) %>%
  left_join(aqs_sites_urban) %>%
  left_join(aqs_sites_wells) %>%
  mutate(smoke_day  = replace_na(smoke_day,  0),
         n_plume    = replace_na(n_plume,    0),
         is_urban   = replace_na(is_urban,   0),
         near_wells = replace_na(near_wells, 0),
         zip_code   = as.factor(zip_code)) %>%
  left_join(narr_precip) %>%
  left_join(narr_temp) %>%
  left_join(narr_wind) %>%
  select(-c(uwnd, vwnd, zip_code))


#............................................................................
# combines component datasets into analytic dataset

# adds no wind data
d <- aqs_daily_annuli_preproduction %>%
  left_join(aqs_daily_annuli_preproduction_nowind) %>%  #in data/processed
  mutate(preprod_count_nowind_0to1km    = replace_na(preprod_count_nowind_0to1km, 0),
         preprod_count_nowind_1to2km    = replace_na(preprod_count_nowind_1to2km, 0),
         preprod_count_nowind_2to3km    = replace_na(preprod_count_nowind_2to3km, 0),
         preprod_count_nowind_3to4km    = replace_na(preprod_count_nowind_3to4km, 0),
         preprod_count_nowind_4to5km    = replace_na(preprod_count_nowind_4to5km, 0),
         preprod_count_nowind_5to6km    = replace_na(preprod_count_nowind_5to6km, 0),
         preprod_count_nowind_6to7km    = replace_na(preprod_count_nowind_6to7km, 0),
         preprod_count_nowind_7to8km    = replace_na(preprod_count_nowind_8to9km, 0),
         preprod_count_nowind_8to9km    = replace_na(preprod_count_nowind_8to9km, 0),
         preprod_count_nowind_9to10km   = replace_na(preprod_count_nowind_9to10km, 0))

#............................................................................
# exports processed data
saveRDS(aqs_daily_annuli_preproduction2, 
        "data/processed/aqs_daily_annuli_preproduction.rds")


#............................................................................
# removes data components from the R workspace
rm()

##============================================================================##
