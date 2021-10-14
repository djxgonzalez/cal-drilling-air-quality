##============================================================================##
## 4.5 - Sets up script to


##----------------------------------------------------------------------------
# data input and tidying
aqs_daily_annuli_exposure <-
  #readRDS("data/deprecated/aqs_daily_annuli_exposure.rds")
  #readRDS("data/processed/aqs_daily_annuli_exposure.rds")

# sets up dataset
monitors_to_omit <- aqs_daily_annuli_exposure %>%
  select(monitor_id, near_wells, is_urban, carb_basin,
         pm25_mean, co_max, no2_max, o3_max, vocs_total) %>%
  group_by(monitor_id) %>%
  summarize(near_wells = near_wells,
            is_urban   = is_urban,
            carb_basin = carb_basin,
            pm25_mean  = mean(pm25_mean, na.rm = TRUE),
            co_mean    = mean(co_max, na.rm = TRUE),
            no2_mean   = mean(no2_max, na.rm = TRUE),
            o3_mean    = mean(o3_max, na.rm = TRUE),
            vocs_mean  = mean(vocs_total, na.rm = TRUE)) %>%
  subset((is.na(pm25_mean) & is.na(co_mean) & is.na(no2_mean) &
            is.na(o3_mean) & is.na(vocs_mean))) %>% 
  select(monitor_id)


##----------------------------------------------------------------------------
# explores monitor data

monitors <- aqs_daily_annuli_exposure %>%
  select(monitor_id, near_wells, near_wells_5km, is_urban, carb_basin,
         pm25_mean, co_max, no2_max, o3_max, vocs_total) %>%
  group_by(monitor_id) %>%
  summarize(near_wells = near_wells,
            is_urban   = is_urban,
            carb_basin = carb_basin,
            pm25_mean  = mean(pm25_mean, na.rm = TRUE),
            co_mean    = mean(co_max, na.rm = TRUE),
            no2_mean   = mean(no2_max, na.rm = TRUE),
            o3_mean    = mean(o3_max, na.rm = TRUE),
            vocs_mean  = mean(vocs_total, na.rm = TRUE)) %>%
  mutate(exposed_pm25 = case_when(pm25_mean >= 0   ~ 1,
                                  pm25_mean  < 0   ~ 0,
                                  is.na(pm25_mean) ~ 0),
         exposed_co   = case_when(co_mean >= 0     ~ 1,
                                  co_mean  < 0     ~ 0,
                                  is.na(co_mean)   ~ 0),
         exposed_no2  = case_when(no2_mean >= 0    ~ 1,
                                  no2_mean  < 0    ~ 0,
                                  is.na(no2_mean)  ~ 0),
         exposed_o3   = case_when(o3_mean >= 0     ~ 1,
                                  o3_mean  < 0     ~ 0,
                                  is.na(o3_mean)   ~ 0),
         exposed_vocs = case_when(vocs_mean >= 0   ~ 1,
                                  vocs_mean  < 0   ~ 0,
                                  is.na(vocs_mean) ~ 0)) %>%
  distinct(monitor_id, .keep_all = TRUE)

table_monitors1 <- table1::table1(~ factor(is_urban) +
                                    factor(exposed_pm25) +
                                    factor(exposed_co) +
                                    factor(exposed_no2) +
                                    factor(exposed_o3) +
                                    factor(exposed_vocs)
                                  | factor(near_wells),
                                  data = monitors)
table_monitors1

monitors2 <- monitors %>%
  filter(carb_basin %in% c("Sacramento Valley", "San Joaquin Valley", 
                           "South Central Coast", "South Coast"))
table_monitors2 <- table1::table1(~ factor(carb_basin)
                                  | factor(near_wells),
                                  data = monitors2)
table_monitors2




##============================================================================##