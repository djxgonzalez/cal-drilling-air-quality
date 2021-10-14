##============================================================================##
## 3.1 Fits preliminary regression models on the 1999-2016 data with exp assessed
## using annuli + wind


##------------------------------------------------------------------------------
## sets up the environment

# imports the monitors data + covariates
aqs_monitor_day <- readRDS("data/interim/aqs_monitor_day.rds")
narr_precip     <- readRDS("data/interim/narr_precipitation.rds")
narr_temp       <- readRDS("data/interim/narr_temperature.rds")

#............................................................................
# imports the exposure data
#aqs_monitor_day_exp_annuli_wind <- 
  #readRDS("data/processed/aqs_daily_annuli_1999.rds") %>%
  #bind_rows(readRDS("data/processed/aqs_daily_annuli_2000.rds")) %>%
  #bind_rows(readRDS("data/processed/aqs_daily_annuli_2001.rds")) %>%
  #bind_rows(readRDS("data/processed/aqs_daily_annuli_2002.rds")) %>%
  #bind_rows(readRDS("data/processed/aqs_daily_annuli_2003.rds")) %>%
  #bind_rows(readRDS("data/processed/aqs_daily_annuli_2004.rds")) %>%
  #bind_rows(readRDS("data/processed/aqs_daily_annuli_2005.rds")) %>%
  #bind_rows(readRDS("data/processed/aqs_daily_annuli_2006.rds")) %>%
  #bind_rows(readRDS("data/processed/aqs_daily_annuli_2007.rds")) %>%
  #bind_rows(readRDS("data/processed/aqs_daily_annuli_2008.rds")) %>%
  #bind_rows(readRDS("data/processed/aqs_daily_annuli_2009.rds")) %>%
  #bind_rows(readRDS("data/processed/aqs_daily_annuli_2010.rds")) %>%
  #bind_rows(readRDS("data/processed/aqs_daily_annuli_2011.rds")) %>%
  #bind_rows(readRDS("data/processed/aqs_daily_annuli_2012.rds")) %>%
  #bind_rows(readRDS("data/processed/aqs_daily_annuli_2013.rds")) %>%
  #bind_rows(readRDS("data/processed/aqs_daily_annuli_2014.rds")) %>%
  #bind_rows(readRDS("data/processed/aqs_daily_annuli_2015.rds")) %>%
  #bind_rows(readRDS("data/processed/aqs_daily_annuli_2016.rds")) %>% 
  #mutate(monitor_day = as.factor(paste(site_id, date, sep = "_"))) %>%
  #distinct(monitor_day, .keep_all = TRUE)

saveRDS(aqs_monitor_day_exp_annuli_wind, 
        "data/processed/aqs_monitor_day_exp_annuli_wind.rds")

#.........................................................................
# identifies wells *not* within 15 km of new wells
#### Note: This could use some cleaning, but it works!

# makes buffer around new wells
wells_new_buffer <- readRDS("data/interim/wells_interim.rds") %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83) %>%
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

# AQS sites as an SF with one row per monitor
aqs_sites_sf <- read_csv("data/interim/aqs_sites.csv") %>% 
  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83)

# filters to births within 15 km of at least one new well
aqs_sites_unexp <- aqs_sites_sf %>%
  st_difference(wells_new_buffer)

# make a dataset of monitor-days monitors > 15 km away the nearest new well
aqs_monitor_day_unexp <- aqs_monitor_day %>%
  # restricts to the years we have exposure data for right now
  filter(year(month_year) %in% c(1999:2016)) %>%
  filter(site_id %in% aqs_sites_unexp$site_id) %>%
  as_tibble() %>%
  select(site_id, date) %>%
  # adds exposure variables and assigns 0 to all values
  mutate(wells_new_0to1km   = 0,
         wells_new_1to2km   = 0,
         wells_new_2to3km   = 0,
         wells_new_3to4km   = 0,
         wells_new_4to5km   = 0,
         wells_new_5to6km   = 0,
         wells_new_6to7km   = 0,
         wells_new_7to8km   = 0,
         wells_new_8to9km   = 0,
         wells_new_9to10km  = 0,
         wells_new_10to11km = 0,
         wells_new_11to12km = 0,
         wells_new_12to13km = 0,
         wells_new_13to14km = 0,
         wells_new_14to15km = 0)

# imports air basin data
carb_basin <- st_read("data/raw/cal_epa/carb_air_basins/CaAirBasin.shp") %>%
  st_transform(crs_nad83)

# adds air basin to aqs_sites_sf
aqs_basins <- aqs_sites_sf %>%
  st_join(carb_basin) %>%
  as_tibble() %>%
  select(site_id, NAME) %>%
  rename(carb_basin = NAME)

# drops duplicates; we still need to find out why we have duplicates
aqs_monitor_day_unexp <- aqs_monitor_day_unexp %>% 
  mutate(monitor_day = as.factor(paste(site_id, date, sep = "_"))) %>%
  distinct(monitor_day, .keep_all = TRUE) 

#............................................................................
# makes the final analytic dataset
data_analytic <- aqs_monitor_day_exp_wind %>%
  # adds unexposed monitors data
  bind_rows(aqs_monitor_day_unexp) %>%
  mutate(site_id = as.factor(site_id),
         monitor_day = as.factor(monitor_day)) %>%
  # adds NARR meteorological covariates
  left_join(narr_precip, by = c("site_id", "date")) %>%
  # adds monitor-level covariates
  left_join(aqs_monitor_day, by = c("monitor_day", "site_id", "date")) %>%
  # adds air basins
  left_join(aqs_basins, by = "site_id")  %>%
  distinct(monitor_day, .keep_all = TRUE) 

data_analytic2 <- data_analytic %>%
  drop_na(pm2.5_concentration_daily_mean)
#drop_na(pm2.5_concentration_daily_mean)
#drop_na(o3_concentration_daily_max)



##------------------------------------------------------------------------------
## 

# visualize the distribution of 'pm2.5_concentration_daily_mean'
# make a histogram of month-years to see if we're well represented temporally
# see how many monitor-days we have within each air basin
# look at the distribution of precip
# explore the exposure data to get a better sense of how to factor it into our FELM


##------------------------------------------------------------------------------
## fits model

# model 1 - naive model, i.e., we don't control for anything
model_fit1 <- 
  felm(
    #o3_concentration_daily_max ~ 
    pm2.5_concentration_daily_mean ~
      wells_new_0to1km +
      wells_new_1to2km + 
      wells_new_2to3km +
      wells_new_3to4km + 
      wells_new_4to5km +
      wells_new_5to6km +
      wells_new_6to7km + 
      wells_new_7to8km + 
      wells_new_8to9km +
      wells_new_9to10km,
    data = data_analytic2
  )
summary(model_fit1)

# model 2 - FE basin:month + basin-year, adj. precip.
model_fit2 <- 
  felm(
    #o3_concentration_daily_max ~ 
    pm2.5_concentration_daily_mean ~
      wells_new_0to1km +
      wells_new_1to2km +
      wells_new_2to3km +
      wells_new_3to4km + 
      wells_new_4to5km + 
      wells_new_5to6km +
      wells_new_6to7km + 
      wells_new_7to8km + 
      wells_new_8to9km +
      wells_new_9to10km + 
      narr_precip 
    | as.factor(year(month_year)):as.factor(carb_basin) +
      as.factor(month(month_year)),
    data = data_analytic2
  )
summary(model_fit2)

# model 2 - FE monitor + basin:month + basin-year, adj. for precip.
model_fit3 <- 
  felm(#
    #o3_concentration_daily_max ~ 
    pm2.5_concentration_daily_mean ~
      wells_new_0to1km +
      wells_new_1to2km +
      wells_new_2to3km + 
      wells_new_3to4km + 
      wells_new_4to5km + 
      wells_new_5to6km +
      wells_new_6to7km + 
      wells_new_7to8km + 
      wells_new_8to9km +
      wells_new_9to10km +
      narr_precip 
    | as.factor(year(month_year)):as.factor(carb_basin) +
      as.factor(month(month_year)):as.factor(carb_basin) +
      site_id,
    data = data_analytic2
  )
summary(model_fit3)

model3_results <- tidy(model_fit3, conf.int = TRUE, conf.level = 0.95) %>%
  replace_na(list(estimate = 0, conf.low = 0, conf.high = 0)) %>%
  mutate(term = as.factor(term)) %>%
  #mutate(Distance = case_when(term == "wells_new_0to1" ~ "0-1")) %>%
  filter(term != "narr_precip") %>% 
  #mutate(Distance = as.factor(Distance)) %>%
  as_tibble()
model3_results

model3_results %>%
  ggplot() +
  geom_pointrange(aes(x    = term, 
                      y    = estimate,
                      ymin = conf.low,
                      max  = conf.high)) +
  labs(x = "Distance (km)", 
       y = "Marginal change in PM2.5 concentration (µg/m^3)") +
  geom_hline(yintercept = 0, linetype = "dashed") +
  theme_classic()


##============================================================================##
