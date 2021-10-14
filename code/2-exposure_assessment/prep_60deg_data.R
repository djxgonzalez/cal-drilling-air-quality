aqs_daily_annuli_exposure <- 
  readRDS("data/processed/aqs_daily_annuli_exposure.rds")


## preprod count, 60°

preprod_60deg_a <- readRDS("data/processed/aqs_daily_annuli_preproduction_upwind_60deg_a.rds")
preprod_60deg_b <- readRDS("data/processed/aqs_daily_annuli_preproduction_upwind_60deg_b.rds")
preprod_60deg_c <- readRDS("data/processed/aqs_daily_annuli_preproduction_upwind_60deg_c.rds")

preprod_60deg <- preprod_60deg_a %>%
  bind_rows(preprod_60deg_b) %>%
  bind_rows(preprod_60deg_c) %>%
  rename(preprod_count_uw_60deg_0to1km = wells_prod_upwind_60deg_0to1km,
         preprod_count_uw_60deg_1to2km = wells_prod_upwind_60deg_1to2km,
         preprod_count_uw_60deg_2to3km = wells_prod_upwind_60deg_2to3km,
         preprod_count_uw_60deg_3to4km = wells_prod_upwind_60deg_3to4km,
         preprod_count_uw_60deg_4to5km = wells_prod_upwind_60deg_4to5km,
         preprod_count_uw_60deg_5to6km = wells_prod_upwind_60deg_5to6km,
         preprod_count_uw_60deg_6to7km = wells_prod_upwind_60deg_6to7km,
         preprod_count_uw_60deg_7to8km = wells_prod_upwind_60deg_7to8km,
         preprod_count_uw_60deg_8to9km = wells_prod_upwind_60deg_8to9km,
         preprod_count_uw_60deg_9to10km = wells_prod_upwind_60deg_9to10km)


#d <- aqs_daily_annuli_exposure %>%
aqs_daily_annuli_exposure <- aqs_daily_annuli_exposure %>%
  # select(-(preprod_count_uw_60deg_0to1km:preprod_count_uw_60deg_9to10km)) %>%
  # left_join(preprod_60deg) %>%
  # mutate(preprod_count_uw_60deg_0to1km = 
  #          replace_na(preprod_count_uw_60deg_0to1km, 0),
  #        preprod_count_uw_60deg_1to2km = 
  #          replace_na(preprod_count_uw_60deg_1to2km, 0),
  #        preprod_count_uw_60deg_2to3km = 
  #          replace_na(preprod_count_uw_60deg_2to3km, 0),
  #        preprod_count_uw_60deg_3to4km = 
  #          replace_na(preprod_count_uw_60deg_3to4km, 0),
  #        preprod_count_uw_60deg_4to5km = 
#          replace_na(preprod_count_uw_60deg_4to5km, 0),
#        preprod_count_uw_60deg_5to6km = 
#          replace_na(preprod_count_uw_60deg_5to6km, 0),
#        preprod_count_uw_60deg_6to7km = 
#          replace_na(preprod_count_uw_60deg_6to7km, 0),
#        preprod_count_uw_60deg_7to8km = 
#          replace_na(preprod_count_uw_60deg_7to8km, 0),
#        preprod_count_uw_60deg_8to9km = 
#          replace_na(preprod_count_uw_60deg_8to9km, 0),
#        preprod_count_uw_60deg_9to10km = 
#          replace_na(preprod_count_uw_60deg_9to10km, 0)) %>%
mutate(preprod_count_lateral_60deg_0to1km = 
         (preprod_count_nowind_0to1km -
            (preprod_count_uw_60deg_0to1km + preprod_count_dw_0to1km)),
       preprod_count_lateral_60deg_1to2km = 
         (preprod_count_nowind_1to2km -
            (preprod_count_uw_60deg_1to2km + preprod_count_dw_1to2km)),
       preprod_count_lateral_60deg_2to3km = 
         (preprod_count_nowind_2to3km -
            (preprod_count_uw_60deg_2to3km + preprod_count_dw_2to3km)),
       preprod_count_lateral_60deg_3to4km = 
         (preprod_count_nowind_3to4km -
            (preprod_count_uw_60deg_3to4km + preprod_count_dw_3to4km)),
       preprod_count_lateral_60deg_4to5km = 
         (preprod_count_nowind_4to5km -
            (preprod_count_uw_60deg_4to5km + preprod_count_dw_4to5km)),
       preprod_count_lateral_60deg_5to6km = 
         (preprod_count_nowind_5to6km -
            (preprod_count_uw_60deg_5to6km + preprod_count_dw_5to6km)),
       preprod_count_lateral_60deg_6to7km = 
         (preprod_count_nowind_6to7km -
            (preprod_count_uw_60deg_6to7km + preprod_count_dw_6to7km)),
       preprod_count_lateral_60deg_7to8km = 
         (preprod_count_nowind_7to8km -
            (preprod_count_uw_60deg_7to8km + preprod_count_dw_7to8km)),
       preprod_count_lateral_60deg_8to9km = 
         (preprod_count_nowind_8to9km -
            (preprod_count_uw_60deg_8to9km + preprod_count_dw_8to9km)),
       preprod_count_lateral_60deg_9to10km = 
         (preprod_count_nowind_9to10km -
            (preprod_count_uw_60deg_9to10km + preprod_count_dw_9to10km)))

d %>% 
  select(monitor_day,
         preprod_count_dw_1to2km, 
         preprod_count_uw_1to2km, 
         preprod_count_uw_60deg_1to2km,
         preprod_count_nowind_1to2km)  %>%
  View()



## preprod count, 120°

preprod_120deg <- 
  readRDS("data/processed/aqs_daily_annuli_preproduction_upwind_120deg_a.rds") %>%
  bind_rows(readRDS("data/processed/aqs_daily_annuli_preproduction_upwind_120deg_b.rds")) %>%
  bind_rows(readRDS("data/processed/aqs_daily_annuli_preproduction_upwind_120deg_c.rds")) %>%
  bind_rows(readRDS("data/processed/aqs_daily_annuli_preproduction_upwind_120deg_d.rds")) %>%
  bind_rows(readRDS("data/processed/aqs_daily_annuli_preproduction_upwind_120deg_e.rds")) %>%
  bind_rows(readRDS("data/processed/aqs_daily_annuli_preproduction_upwind_120deg_f.rds"))

preprod_120deg <- preprod_120deg %>%
  rename(preprod_count_uw_120deg_0to1km = wells_prod_upwind_120deg_0to1km,
         preprod_count_uw_120deg_1to2km = wells_prod_upwind_120deg_1to2km,
         preprod_count_uw_120deg_2to3km = wells_prod_upwind_120deg_2to3km,
         preprod_count_uw_120deg_3to4km = wells_prod_upwind_120deg_3to4km,
         preprod_count_uw_120deg_4to5km = wells_prod_upwind_120deg_4to5km,
         preprod_count_uw_120deg_5to6km = wells_prod_upwind_120deg_5to6km,
         preprod_count_uw_120deg_6to7km = wells_prod_upwind_120deg_6to7km,
         preprod_count_uw_120deg_7to8km = wells_prod_upwind_120deg_7to8km,
         preprod_count_uw_120deg_8to9km = wells_prod_upwind_120deg_8to9km,
         preprod_count_uw_120deg_9to10km = wells_prod_upwind_120deg_9to10km)


#d <- aqs_daily_annuli_exposure %>%
aqs_daily_annuli_exposure <- aqs_daily_annuli_exposure %>%
  #select(-(preprod_count_uw_120deg_0to1km:preprod_count_uw_120deg_9to10km)) %>%
  left_join(preprod_120deg) %>%
  mutate(preprod_count_uw_120deg_0to1km =
           replace_na(preprod_count_uw_120deg_0to1km, 0),
         preprod_count_uw_120deg_1to2km =
           replace_na(preprod_count_uw_120deg_1to2km, 0),
         preprod_count_uw_120deg_2to3km =
           replace_na(preprod_count_uw_120deg_2to3km, 0),
         preprod_count_uw_120deg_3to4km =
           replace_na(preprod_count_uw_120deg_3to4km, 0),
         preprod_count_uw_120deg_4to5km =
           replace_na(preprod_count_uw_120deg_4to5km, 0),
         preprod_count_uw_120deg_5to6km =
           replace_na(preprod_count_uw_120deg_5to6km, 0),
         preprod_count_uw_120deg_6to7km =
           replace_na(preprod_count_uw_120deg_6to7km, 0),
         preprod_count_uw_120deg_7to8km =
           replace_na(preprod_count_uw_120deg_7to8km, 0),
         preprod_count_uw_120deg_8to9km =
           replace_na(preprod_count_uw_120deg_8to9km, 0),
         preprod_count_uw_120deg_9to10km =
           replace_na(preprod_count_uw_120deg_9to10km, 0)) %>%
  mutate(preprod_count_lateral_120deg_0to1km = 
           (preprod_count_nowind_0to1km -
              (preprod_count_uw_120deg_0to1km + preprod_count_dw_0to1km)),
         preprod_count_lateral_120deg_1to2km = 
           (preprod_count_nowind_1to2km -
              (preprod_count_uw_120deg_1to2km + preprod_count_dw_1to2km)),
         preprod_count_lateral_120deg_2to3km = 
           (preprod_count_nowind_2to3km -
              (preprod_count_uw_120deg_2to3km + preprod_count_dw_2to3km)),
         preprod_count_lateral_120deg_3to4km = 
           (preprod_count_nowind_3to4km -
              (preprod_count_uw_120deg_3to4km + preprod_count_dw_3to4km)),
         preprod_count_lateral_120deg_4to5km = 
           (preprod_count_nowind_4to5km -
              (preprod_count_uw_120deg_4to5km + preprod_count_dw_4to5km)),
         preprod_count_lateral_120deg_5to6km = 
           (preprod_count_nowind_5to6km -
              (preprod_count_uw_120deg_5to6km + preprod_count_dw_5to6km)),
         preprod_count_lateral_120deg_6to7km = 
           (preprod_count_nowind_6to7km -
              (preprod_count_uw_120deg_6to7km + preprod_count_dw_6to7km)),
         preprod_count_lateral_120deg_7to8km = 
           (preprod_count_nowind_7to8km -
              (preprod_count_uw_120deg_7to8km + preprod_count_dw_7to8km)),
         preprod_count_lateral_120deg_8to9km = 
           (preprod_count_nowind_8to9km -
              (preprod_count_uw_120deg_8to9km + preprod_count_dw_8to9km)),
         preprod_count_lateral_120deg_9to10km = 
           (preprod_count_nowind_9to10km -
              (preprod_count_uw_120deg_9to10km + preprod_count_dw_9to10km)))

d %>% 
  select(monitor_day,
         preprod_count_dw_1to2km, 
         preprod_count_uw_1to2km, 
         preprod_count_uw_120deg_1to2km,
         preprod_count_nowind_1to2km)  %>%
  View()



### prod volume

prod_60deg_2006 <- readRDS("data/processed/aqs_daily_annuli_production_upwind_60deg_2006.rds")
prod_60deg_2007 <- readRDS("data/processed/aqs_daily_annuli_production_upwind_60deg_2007.rds")
prod_60deg_2008 <- readRDS("data/processed/aqs_daily_annuli_production_upwind_60deg_2008.rds")
prod_60deg_2009 <- readRDS("data/processed/aqs_daily_annuli_production_upwind_60deg_2009.rds")
prod_60deg_2010 <- readRDS("data/processed/aqs_daily_annuli_production_upwind_60deg_2010.rds")
prod_60deg_2011 <- readRDS("data/processed/aqs_daily_annuli_production_upwind_60deg_2011.rds")
prod_60deg_2012 <- readRDS("data/processed/aqs_daily_annuli_production_upwind_60deg_2012.rds")
prod_60deg_2013 <- readRDS("data/processed/aqs_daily_annuli_production_upwind_60deg_2013.rds")
prod_60deg_2014 <- readRDS("data/processed/aqs_daily_annuli_production_upwind_60deg_2014.rds")
prod_60deg_2015 <- readRDS("data/processed/aqs_daily_annuli_production_upwind_60deg_2015.rds")
prod_60deg_2016 <- readRDS("data/processed/aqs_daily_annuli_production_upwind_60deg_2016.rds")
prod_60deg_2017 <- readRDS("data/processed/aqs_daily_annuli_production_upwind_60deg_2017.rds")
prod_60deg_2018 <- readRDS("data/processed/aqs_daily_annuli_production_upwind_60deg_2018.rds")
prod_60deg_2019 <- readRDS("data/processed/aqs_daily_annuli_production_upwind_60deg_2019.rds")
prod_60deg <- prod_60deg_2006 %>%
  bind_rows(prod_60deg_2007) %>%
  bind_rows(prod_60deg_2008) %>%
  bind_rows(prod_60deg_2009) %>%
  bind_rows(prod_60deg_2010) %>%
  bind_rows(prod_60deg_2011) %>%
  bind_rows(prod_60deg_2012) %>%
  bind_rows(prod_60deg_2013) %>%
  bind_rows(prod_60deg_2014) %>%
  bind_rows(prod_60deg_2015) %>%
  bind_rows(prod_60deg_2016) %>%
  bind_rows(prod_60deg_2017) %>%
  bind_rows(prod_60deg_2018) %>%
  bind_rows(prod_60deg_2019)

aqs_daily_annuli_exposure <- aqs_daily_annuli_exposure %>%
  left_join(prod_60deg) %>%
  mutate(prod_volume_upwind_60deg_0to1km =
           replace_na(prod_volume_upwind_60deg_0to1km, 0),
         prod_volume_upwind_60deg_1to2km =
           replace_na(prod_volume_upwind_60deg_1to2km, 0),
         prod_volume_upwind_60deg_2to3km =
           replace_na(prod_volume_upwind_60deg_2to3km, 0),
         prod_volume_upwind_60deg_3to4km =
           replace_na(prod_volume_upwind_60deg_3to4km, 0),
         prod_volume_upwind_60deg_4to5km =
           replace_na(prod_volume_upwind_60deg_4to5km, 0),
         prod_volume_upwind_60deg_5to6km =
           replace_na(prod_volume_upwind_60deg_5to6km, 0),
         prod_volume_upwind_60deg_6to7km =
           replace_na(prod_volume_upwind_60deg_6to7km, 0),
         prod_volume_upwind_60deg_7to8km =
           replace_na(prod_volume_upwind_60deg_7to8km, 0),
         prod_volume_upwind_60deg_8to9km =
           replace_na(prod_volume_upwind_60deg_8to9km, 0),
         prod_volume_upwind_60deg_9to10km =
           replace_na(prod_volume_upwind_60deg_9to10km, 0)) %>%
  mutate(prod_volume_upwind_60deg_0to1km =  (prod_volume_upwind_60deg_0to1km / 
                                               (month_length_days * 100)),
         prod_volume_upwind_60deg_1to2km =  (prod_volume_upwind_60deg_1to2km / 
                                               (month_length_days * 100)),
         prod_volume_upwind_60deg_2to3km =  (prod_volume_upwind_60deg_2to3km / 
                                               (month_length_days * 100)),
         prod_volume_upwind_60deg_3to4km =  (prod_volume_upwind_60deg_3to4km / 
                                               (month_length_days * 100)),
         prod_volume_upwind_60deg_4to5km =  (prod_volume_upwind_60deg_4to5km / 
                                               (month_length_days * 100)),
         prod_volume_upwind_60deg_5to6km =  (prod_volume_upwind_60deg_5to6km / 
                                               (month_length_days * 100)),
         prod_volume_upwind_60deg_6to7km =  (prod_volume_upwind_60deg_6to7km / 
                                               (month_length_days * 100)),
         prod_volume_upwind_60deg_7to8km =  (prod_volume_upwind_60deg_7to8km / 
                                               (month_length_days * 100)),
         prod_volume_upwind_60deg_8to9km =  (prod_volume_upwind_60deg_8to9km / 
                                               (month_length_days * 100)),
         prod_volume_upwind_60deg_9to10km =  (prod_volume_upwind_60deg_9to10km / 
                                                (month_length_days * 100))) %>%
  mutate(prod_volume_lateral_60deg_0to1km = 
           (prod_volume_nowind_0to1km -
              (prod_volume_upwind_60deg_0to1km + prod_volume_downwind_0to1km)),
         prod_volume_lateral_60deg_1to2km = 
           (prod_volume_nowind_1to2km -
              (prod_volume_upwind_60deg_1to2km + prod_volume_downwind_1to2km)),
         prod_volume_lateral_60deg_2to3km = 
           (prod_volume_nowind_2to3km -
              (prod_volume_upwind_60deg_2to3km + prod_volume_downwind_2to3km)),
         prod_volume_lateral_60deg_3to4km = 
           (prod_volume_nowind_3to4km -
              (prod_volume_upwind_60deg_3to4km + prod_volume_downwind_3to4km)),
         prod_volume_lateral_60deg_4to5km = 
           (prod_volume_nowind_4to5km -
              (prod_volume_upwind_60deg_4to5km + prod_volume_downwind_4to5km)),
         prod_volume_lateral_60deg_5to6km = 
           (prod_volume_nowind_5to6km -
              (prod_volume_upwind_60deg_5to6km + prod_volume_downwind_5to6km)),
         prod_volume_lateral_60deg_6to7km = 
           (prod_volume_nowind_6to7km -
              (prod_volume_upwind_60deg_6to7km + prod_volume_downwind_6to7km)),
         prod_volume_lateral_60deg_7to8km = 
           (prod_volume_nowind_7to8km -
              (prod_volume_upwind_60deg_7to8km + prod_volume_downwind_7to8km)),
         prod_volume_lateral_60deg_8to9km = 
           (prod_volume_nowind_8to9km -
              (prod_volume_upwind_60deg_8to9km + prod_volume_downwind_8to9km)),
         prod_volume_lateral_60deg_9to10km = 
           (prod_volume_nowind_9to10km -
              (prod_volume_upwind_60deg_9to10km + prod_volume_downwind_9to10km)))


aqs_daily_annuli_exposure %>% #mutate(prod_volume_upwind_60deg_1to2km = 
                              #         (prod_volume_upwind_60deg_1to2km / 
                              #            (month_length_days * 100))) %>%
  select(monitor_day, 
         prod_volume_upwind_1to2km, 
         prod_volume_upwind_60deg_1to2km) %>% View()


## map

ggplot() +
  geom_sf(data = st_geometry(monitor_mask)) +
  geom_sf(data = st_geometry(annulus0to1), fill = NA) +
  geom_sf(data = st_geometry(annulus1to2), fill = NA) +
  geom_sf(data = st_geometry(annulus2to3), fill = NA) +
  geom_sf(data = st_geometry(annulus3to4), fill = NA) +
  geom_sf(data = st_geometry(annulus4to5), fill = NA) +
  geom_sf(data = st_geometry(annulus5to6), fill = NA) +
  geom_sf(data = st_geometry(annulus6to7), fill = NA) +
  geom_sf(data = st_geometry(annulus7to8), fill = NA) +
  geom_sf(data = st_geometry(annulus8to9), fill = NA) +
  geom_sf(data = st_geometry(annulus9to10), fill = NA) +
  geom_sf(data = st_geometry(monitor)) +
  geom_sf(data = st_geometry(wells_within_10km), color = "red") +
  theme_bw()



## exports processed dataset

aqs_daily_annuli_exposure %>% 
  saveRDS("data/processed/aqs_daily_annuli_exposure.rds")
