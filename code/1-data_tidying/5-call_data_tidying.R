##============================================================================##
## 1.6 - this script calls functions to tidy raw data before analysis

##----------------------------------------------------------------------------
## Makes tidy *daily* air quality dataset with one row for each monitor-day
## with the relevant data from the US EPA Air Quality System (AQS)

#............................................................................
# imports raw data

aqs_co_raw <- 
  readRDS("data/raw/us_epa/air_quality_system/aqs_co_1999_2019.rds")
aqs_haps_raw <- 
  readRDS("data/raw/us_epa/air_quality_system/aqs_haps_1999_2019.rds")
aqs_no2_raw <- 
  readRDS("data/raw/us_epa/air_quality_system/aqs_no2_1999_2019.rds")
aqs_nox_raw <- 
  readRDS("data/raw/us_epa/air_quality_system/aqs_nox_1999_2019.rds")
aqs_o3_raw <- 
  readRDS("data/raw/us_epa/air_quality_system/aqs_o3_1999_2019.rds")
aqs_pb_raw <- 
  readRDS("data/raw/us_epa/air_quality_system/aqs_pb_1999_2019.rds")
aqs_pm10_raw <- 
  readRDS("data/raw/us_epa/air_quality_system/aqs_pm10_1999_2019.rds")
aqs_pm25_raw <- 
  readRDS("data/raw/us_epa/air_quality_system/aqs_pm25_1999_2019.rds")
aqs_so2_raw <- 
  readRDS("data/raw/us_epa/air_quality_system/aqs_so2_1999_2019.rds")
aqs_vocs_raw <- 
  readRDS("data/raw/us_epa/air_quality_system/aqs_vocs_1999_2019.rds")

# deprecated code for importing all CSV files in a particular directory
#aqs_no2_raw <- list.files("data/raw/us_epa/air_quality_system/no2",
#                          pattern = "epa_aqs_no2", full.names = T) %>%
#  map_df(~read_csv(.))  # imports all files


#............................................................................
# attaches data tidying functions
source("code/1-data_tidying/1-tidy_aqs_pollution_data.R")

#............................................................................
# tidies air pollution data
aqs_co_daily   <- tidyAirQualityData(aqs_co_raw, 
                                     "co_concentration_daily_max", 
                                     "Daily Max 8-hour CO Concentration")
aqs_no2_daily  <- tidyAirQualityData(aqs_no2_raw, 
                                     "no2_concentration_daily_max", 
                                     "Daily Max 1-hour NO2 Concentration")
aqs_o3_daily   <- tidyAirQualityData(aqs_o3_raw, 
                                     "o3_concentration_daily_max", 
                                     "Daily Max 8-hour Ozone Concentration")
aqs_pm10_daily <- tidyAirQualityData(aqs_pm10_raw, 
                                     "pm10_concentration_daily_mean", 
                                     "Daily Mean PM10 Concentration")
aqs_pm25_daily <- tidyAirQualityData(aqs_pm25_raw, 
                                     "pm2.5_concentration_daily_mean", 
                                     "Daily Mean PM2.5 Concentration")
aqs_so2_daily  <- tidyAirQualityData(aqs_so2_raw, 
                                     "so2_concentration_daily_max", 
                                     "Daily Max 1-hour SO2 Concentration")

aqs_haps_daily <- tidyHAPsData(aqs_haps_raw) %>%
  filter(pollutant_name %in% c("Acetaldehyde", 
                               "Chloroform",
                               "Formaldehyde",
                               "Dichloromethane",
                               "Arsenic PM2.5 LC",
                               "Chromium PM2.5 LC",
                               "Lead PM2.5 LC", 
                               "Manganese PM2.5 LC",
                               "Nickel PM2.5 LC")) %>%
  mutate(monitor_id          = as.factor(monitor_id),
         monitor_day      = as.factor(monitor_day)) %>%
  pivot_wider(id_cols     = c(monitor_id, date, cbsa_name, county, state, 
                              latitude, longitude, parameter_code, month_year,
                              monitor_day, monitor_month),
              names_from  = pollutant_name, 
              values_from = observation,
              values_fn   = list(observation = mean)) %>%
  rename(acetaldehyde     = `Acetaldehyde`, 
         chloroform       = `Chloroform`,
         formaldehyde     = `Formaldehyde`,
         dichloromethane  = `Dichloromethane`,
         pm25_as          = `Arsenic PM2.5 LC`,
         pm25_cr          = `Chromium PM2.5 LC`,
         pm25_pb          = `Lead PM2.5 LC`, 
         pm25_mn          = `Manganese PM2.5 LC`,
         pm25_ni          = `Nickel PM2.5 LC`)

aqs_no_daily  <- tidyHAPsData(subset(aqs_nox_raw,
                                     `Parameter Name` == 
                                       "Nitric oxide (NO)")) %>%
  rename(no_concentration_daily_max = observation) %>%
  select(-pollutant_name)

aqs_pb_daily <- tidyHAPsData(aqs_pb_raw) %>%
  mutate(monitor_id       = as.factor(monitor_id),
         monitor_day      = as.factor(monitor_day)) %>% # reconverts chr to factor
  pivot_wider(id_cols     = c(monitor_id, date, cbsa_name, county, state, 
                              latitude, longitude, parameter_code, month_year,
                              monitor_day, monitor_month),
              names_from  = pollutant_name, 
              values_from = observation,
              # test how many have duplicate observations using this line:
              # values_fn = list(observation_mean = length)
              # if only a few, okay to drop or average
              values_fn   = list(observation = mean)) %>%
  rename(lead_tsp_lc      = `Lead (TSP) LC`,
         lead_tsp_stp     = `Lead (TSP) STP`,
         lead_pm10_lc_frm = `Lead PM10 LC FRM/FEM`)

# VOCs - for now, only NMOC (non-methane organic compound)
aqs_vocs_daily <- tidyHAPsData(aqs_vocs_raw) %>%
  # selects pollutants to include
  filter(pollutant_name %in% c("Total NMOC (non-methane organic compound)",
                               "Acetone",
                               "Benzene",
                               "Ethylbenzene",
                               "Toluene")) %>%
  mutate(monitor_id       = as.factor(monitor_id),
         monitor_day      = as.factor(monitor_day)) %>% 
  pivot_wider(id_cols     = c(monitor_id, date, cbsa_name, county, state, 
                              latitude, longitude, parameter_code, month_year,
                              monitor_day, monitor_month),
              names_from  = pollutant_name, 
              values_from = observation,
              values_fn   = list(observation = mean)) %>%
  rename(total_nmoc       = `Total NMOC (non-methane organic compound)`,
         acetone          = Acetone,
         benzene          = Benzene,
         ethylbenzene     = Ethylbenzene,
         toluene          = Toluene)


#............................................................................
# removes raw AQS air pollution data
rm("aqs_co_raw", "aqs_haps_raw", "aqs_no2_raw", "aqs_nox_raw", "aqs_o3_raw", 
   "aqs_pb_raw", "aqs_pm10_raw", "aqs_pm25_raw", "aqs_so2_raw", "aqs_vocs_raw")


#............................................................................
# merges pollutant observations across all 'aqs_sites' to make one
# combined tibble with all observations, aggregated by day
# joins air pollution and meteorology data to make analytic dataset
aqs_monitor_day <- aqs_co_daily %>%
  full_join(aqs_haps_daily) %>%
  full_join(aqs_no_daily)   %>%
  full_join(aqs_no2_daily)  %>%
  full_join(aqs_o3_daily)   %>%
  full_join(aqs_pb_daily)   %>%
  full_join(aqs_pm10_daily) %>%
  full_join(aqs_pm25_daily) %>%
  full_join(aqs_so2_daily)  %>%
  full_join(aqs_vocs_daily) %>%
  # reconverts categorical vars from chr to factor
  mutate(monitor_id     = as.factor(monitor_id),
         monitor_day    = as.factor(monitor_day),
         monitor_month  = as.factor(monitor_month),
         parameter_code = as.factor(parameter_code),
         cbsa_name      = as.factor(cbsa_name),
         county         = as.factor(county),
         state          = as.factor(state))

#............................................................................
# removes constituent AQS air pollution data
rm("aqs_co_daily", "aqs_haps_daily", "aqs_no2_daily", "aqs_no_daily", 
   "aqs_o3_daily", "aqs_pb_daily", "aqs_pm10_daily", "aqs_pm25_daily",
   "aqs_so2_daily", "aqs_vocs_daily")

#............................................................................
# exports processed data
saveRDS(aqs_monitor_day, file = "data/interim/aqs_monitor_day.rds")


##----------------------------------------------------------------------------
## Makes tidy air quality monitors dataset with 1 row for each monitor

# imports and tidies geospatial data prior to spatial merge
calgem_fields <-
  st_read("data/raw/cal_gem/field_boundaries/DOGGR_Admin_Boundaries_Master.shp") %>%
  st_transform(crs_nad83)
carb_air_basins <-
  st_read("data/raw/cal_epa/ca_air_basins 2/CaAirBasin.shp") %>%
  st_transform(crs_nad83)

# makes 'aqs_sites' dataset
aqs_sites <- aqs_daily_annuli_exposure %>% # aqs_monitor_day %>%
  distinct(monitor_id, .keep_all = TRUE) %>%
  select(monitor_id, county, latitude, longitude)



##### Christina -- start here!
##----------------------------------------------------------------------------
## Tidies NARR daily meteorology data and adds to aqs_monitor_day dataset

#............................................................................
# imports necessary interim data

aqs_sites_sf <- readRDS("data/interim/aqs_sites.rds") %>%
  dplyr::select(monitor_id, longitude, latitude) %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326)

#............................................................................
# attaches function
source("code/1-data_tidying/4-tidy_narr_data.R")

#............................................................................
# calls tidying function

# . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
# tidies mean surface air temperature data

# initializes empty tibble to capture tidied data
narr_temp <- tibble()

# loops through all years and tidies the NARR data
for (year in c(1999:2019)) {
  narr_temp <- bind_rows(narr_temp,
                         tidyNARRData(
                           paste("data/raw/narr/air_temp_daily_mean/air.sfc.",
                                 as.character(year),
                                 ".nc", 
                                 sep = ""),
                           "temp",
                           year)
  )
}

# finalizes the temperature data
narr_temp <- narr_temp %>%
  # renames variable and converts from Kelvin to Celsius
  mutate(narr_temp = temp - 273.15) %>%
  # removes variables we don't need anymore
  dplyr::select(-temp)

# exports processed data
saveRDS(narr_temp, "data/interim/narr_temperature.rds")


# . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
# tidies daily mean precipitation data

# initializes empty tibble to capture tidied data 
narr_precip <- tibble()

# loops through all years and tidies the NARR data
for (year in c(1999:2019)) {
  narr_precip <- bind_rows(narr_precip,
                           tidyNARRData(
                             paste("data/raw/narr/accumulated_precip/apcp.",
                                   as.character(year),
                                   ".nc", 
                                   sep = ""),
                             "apcp",
                             #"narr_precip",
                             year)
  )
}

# exports processed data
saveRDS(narr_precip, "data/interim/narr_precipitation.rds")


# . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
# tidies daily mean wind vector (u) data

# initializes empty tibble to capture tidied data 
narr_wind_u <- tibble()

# loops through all years and tidies the NARR data
for (year in c(1999:2019)) {
  narr_wind_u <- bind_rows(narr_wind_u,
                           tidyNARRData(paste("data/raw/narr/wind_u/uwnd.10m.",
                                              as.character(year),
                                              ".nc", 
                                              sep = ""),
                                        "uwnd",
                                        #"narr_wind_u",
                                        year)
  )
}

# exports processed data
saveRDS(narr_wind_u, "data/interim/narr_wind_u.rds")


# . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
# tidies daily mean wind vector (v) data

# initializes empty tibble to capture tidied data 
narr_wind_v <- tibble()

# loops through all years and tidies the NARR data
for (year in c(1999:2019)) {
  narr_wind_v <- bind_rows(narr_wind_v,
                           tidyNARRData(paste("data/raw/narr/wind_v/vwnd.10m.",
                                              as.character(year),
                                              ".nc", 
                                              sep = ""),
                                        "vwnd",
                                        #"narr_wind_v",
                                        year)
  )
}

# exports processed data
saveRDS(narr_wind_v, "data/interim/narr_wind_v.rds")


#  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
# finalizes wind data, adds variables for wind direction and wind speed
narr_wind <- tibble()

# combines wind u and v vectors
narr_wind <- left_join(narr_wind_u, narr_wind_v, 
                       by = c("monitor_id", "date")) %>%
  mutate(narr_wind_speed     = sqrt(narr_wind_u$uwnd^2 + narr_wind_v$vwnd^2),
         narr_wind_direction = (((180 / pi) * (atan2(narr_wind_u$uwnd, narr_wind_v$vwnd))) 
                                + 180))

# exports processed data
saveRDS(narr_wind, "data/interim/narr_wind.rds")

##### To do: join all NARR datasets with the overall aqs_monitor_day dataset


##----------------------------------------------------------------------------
## Makes tidy *monthly* air quality dataset with 1 row for each monitor-month
## NOTE -- this is a first pass and doesn't account for data missingness

aqs_monitor_month <- aqs_monitor_day %>%
  mutate(monitor_month = as.factor(paste(monitor_id, month_year, sep = "-"))) %>%
  #sample_n(10000) %>%
  group_by(monitor_month) %>%
  summarize(co_concentration_monthly_max     = mean(co_concentration_daily_max),
            no2_concentration_monthly_max    = mean(no2_concentration_daily_max),
            o3_concentration_monthly_max     = mean(o3_concentration_daily_max),
            pm2.5_concentration_monthly_mean = mean(pm2.5_concentration_daily_mean),
            pm10_concentration_monthly_mean  = mean(pm10_concentration_daily_mean),
            so2_concentration_monthly_max    = mean(so2_concentration_daily_max),
            wind_speed_monthly_mean          = mean(wind_speed_daily_mean),
            wind_direction_monthly_mean      = mean(wind_direction_daily_mean),
            barometric_pressure_monthly_mean = mean(barometric_pressure_daily_mean),
            temperature_monthly_mean         = mean(temperature_daily_mean))


##----------------------------------------------------------------------------
## Tidies CalGEM oil monthly and gas production dataset


####------------###
pwt_api_key <- readRDS("data/interim/pwt_api_key.rds")

pwt_api_key2 <- pwt_api_key %>%
  select(pwt_id, Longitude, Latitude) %>%
  mutate(pwt_id = as.factor(pwt_id))

####------------###

# initializes empty tibble to capture tidied data
calgem_production_monthly <- tibble()

# loops through 1999-2017 and tidies the CalGEM production data
for (year in c(1999:2017)) {  # change to :2017
  calgem_production_monthly <-
    bind_rows(calgem_production_monthly,
              tidyProductionData(
                paste("data/raw/cal_gem/production/calgem_production_monthly_",
                      as.character(year),
                      ".csv", 
                      sep = "")
              )
    )
}


calgem_production_monthly <- calgem_production_monthly %>%
  mutate(pwt_id = as.factor(pwt_id)) %>%
  left_join(pwt_api_key2) %>%
  rename(longitude = Longitude,
         latitude  = Latitude)

saveRDS(calgem_production_monthly, "data/interim/calgem_production_monthly.rds")


calgem_production_monthly1819 <- tibble()
# loops through 2018-2019 and tidies the CalGEM production data
for (year in c(2018:2019)) {
  calgem_production_monthly1819 <-
    bind_rows(calgem_production_monthly1819,
              tidyProductionData1819(
                paste("data/raw/cal_gem/production/calgem_production_monthly_",
                      as.character(year),
                      ".csv", 
                      sep = "")
              )
    )
}

# extracts api numbers and matching lat/long drived from CalGEM all wells dataset
wells_latlong <- wells_interim %>% 
  select(api_number, latitude, longitude)
# binds lat/long to the 2018-19 CalGEM monthly production volume dataset
calgem_production_monthly1819 <- calgem_production_monthly1819 %>%
  left_join(wells_latlong, by = "api_number") %>%
  drop_na(longitude)

# joins the 1999-2017 prod vol data with the 2018-19 prod vol data
#calgem_production_monthly <- calgem_production_monthly %>%
calgem_production_monthly <- calgem_production_monthly %>%
  bind_rows(calgem_production_monthly1819)

# exports processed data
saveRDS(calgem_production_monthly, "data/interim/calgem_production_monthly.rds")



##----------------------------------------------------------------------------
## Tidies CalGEM wells data

# imports necessary data
di_wells <- readRDS("data/raw/enverus/wells_drillinginfo_2021.rds") %>%
  # renames variables of interest
  mutate(api_number       =  str_sub(API14, 1, str_length(API14) - 4),
         date_completed   = `Completion Date`,
         prod_cumulative  = `Cum BOE`,  # barrels of oil equivalent
         prod_start       = `First Prod Date`,
         prod_end         = `Last Prod Date`) %>%
  select(api_number:prod_end)
calgem_wells_raw <- 
  read_csv("data/raw/cal_gem/well_sites/AllWells_20210210.csv")

# attaches the data cleaning function
source("code/1-data_tidying/2-tidy_calgem_wells_data.R")

# calls function to tidies CalGEM wells data
wells_interim <- tidyCalgemWellsData(calgem_wells_raw, di_wells)

# exports processed data
saveRDS(wells_interim, "data/interim/wells_interim.rds")


# makes combined dataset with oil wells and production by month, 2018-2019
wells_combined <- calgem_production_2018 %>%
  bind_rows(calgem_production_2019) %>%
  left_join(di_wells, by = "api_number")

# tidy CalGEM fields data
calgem_fields <- calgem_fields_raw %>%
  st_transform(crs_nad83) %>%
  # renames varible names
  mutate(field_name         = NAME,
         field_object_id    = OBJECTID,  # not sure what this is
         field_code         = FIELD_CODE,
         field_area_sq_mile = AREA_SQ_MI,
         field_area_acre    = AREA_ACRE,
         field_perimeter    = PERIMETER,
         field_start_date   = StartDate,
         field_end_date     = EndDate,
         district_name      = District) %>%
  # keeps only the variables we need
  select(field_name:district_name)

##============================================================================##