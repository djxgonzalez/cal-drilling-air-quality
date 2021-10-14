

new_wells_buffer <- wells_interim %>%
  filter(preprod_1999_to_2019 == 1) %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83) %>%
  st_transform(crs_projected) %>%
  st_buffer(dist = 15000) %>%
  st_transform(crs_nad83) %>%
  st_union()

monitors_near_wells <- aqs_sites %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83) %>%
  st_intersection(new_wells_buffer)

monitor_days_already_assessed <- aqs_monitor_day %>%
  distinct(monitor_day, .keep_all = TRUE) %>%
  inner_join(aqs_daily_annuli_upwind_new_raw)

monitor_days_to_assess <- aqs_monitor_day %>%
  left_join(aqs_daily_annuli_upwind_new_raw) %>%
  distinct(monitor_day, .keep_all = TRUE) %>%
  filter(monitor_id %in% monitors_near_wells$monitor_id) %>%
  filter(is.na(wells_new_0to1km)) %>%
  select(monitor_day)


saveRDS(monitor_days_to_assess, "data/interim/monitor_days_to_assess.rds")
