##============================================================================##
## Generates Figure 3 - barplot of 

##----------------------------------------------------------------------------
# data input and tidying
aqs_daily_annuli_exposure <-
  readRDS("data/processed/aqs_daily_annuli_exposure.rds")


##----------------------------------------------------------------------------
## PM2.5

# upwind
data_upwind_pm25 <- aqs_daily_annuli_exposure %>%
  filter(pm25_mean > 0) %>%
  filter(year %in% c(2006:2019)) %>%
  mutate(indicator_0_1km = case_when(preprod_count_uw_0to1km >  0 ~ 1,
                                     preprod_count_uw_0to1km == 0 ~ 0),
         indicator_1_2km = case_when(preprod_count_uw_1to2km >  0 ~ 1,
                                     preprod_count_uw_1to2km == 0 ~ 0),
         indicator_2_3km = case_when(preprod_count_uw_2to3km >  0 ~ 1,
                                     preprod_count_uw_2to3km == 0 ~ 0),
         indicator_3_4km = case_when(preprod_count_uw_3to4km >  0 ~ 1,
                                     preprod_count_uw_3to4km == 0 ~ 0),
         indicator_4_5km = case_when(preprod_count_uw_4to5km >  0 ~ 1,
                                     preprod_count_uw_4to5km == 0 ~ 0))
exposure_upwind_pm25 <- 
  tibble(order = c(1:5),
         distance = c("0-1", "1-2", "2-3", "3-4", "4-5"),
         n_wells = c(sum(data_upwind_pm25$indicator_0_1km),
                     sum(data_upwind_pm25$indicator_1_2km),
                     sum(data_upwind_pm25$indicator_2_3km),
                     sum(data_upwind_pm25$indicator_3_4km),
                     sum(data_upwind_pm25$indicator_4_5km)))
figure_3_bar_pm25_uw <- exposure_upwind_pm25 %>%
  ggplot() +
  geom_bar(aes(distance, n_wells), stat = "identity") +
  ylim(0, 3020) +
  labs(x = "", y = "") +
  theme_void()
figure_3_bar_pm25_uw
ggsave(filename = "figure_3_bar_pm25_uw.png", plot = figure_3_bar_pm25_uw, 
       device = "png", height = 0.2, width = 4, path = "output/figures/")

# downwind
data_downwind_pm25 <- aqs_daily_annuli_exposure %>%
  filter(pm25_mean > 0) %>%
  filter(year %in% c(2006:2019)) %>%
  mutate(indicator_0_1km = case_when(preprod_count_dw_0to1km >  0 ~ 1,
                                     preprod_count_dw_0to1km == 0 ~ 0),
         indicator_1_2km = case_when(preprod_count_dw_1to2km >  0 ~ 1,
                                     preprod_count_dw_1to2km == 0 ~ 0),
         indicator_2_3km = case_when(preprod_count_dw_2to3km >  0 ~ 1,
                                     preprod_count_dw_2to3km == 0 ~ 0),
         indicator_3_4km = case_when(preprod_count_dw_3to4km >  0 ~ 1,
                                     preprod_count_dw_3to4km == 0 ~ 0),
         indicator_4_5km = case_when(preprod_count_dw_4to5km >  0 ~ 1,
                                     preprod_count_dw_4to5km == 0 ~ 0))
exposure_downwind_pm25 <- 
  tibble(order = c(1:5),
         distance = c("0-1", "1-2", "2-3", "3-4", "4-5"),
         n_wells = c(sum(data_downwind_pm25$indicator_0_1km),
                     sum(data_downwind_pm25$indicator_1_2km),
                     sum(data_downwind_pm25$indicator_2_3km),
                     sum(data_downwind_pm25$indicator_3_4km),
                     sum(data_downwind_pm25$indicator_4_5km)))
figure_3_bar_pm25_dw <- exposure_downwind_pm25 %>%
  ggplot() +
  geom_bar(aes(distance, n_wells), stat = "identity") +
  ylim(0, 3020) +
  labs(x = "", y = "") +
  theme_void()
figure_3_bar_pm25_dw
ggsave(filename = "figure_3_bar_pm25_dw.png", plot = figure_3_bar_pm25_dw, 
       device = "png", height = 0.2, width = 4, path = "output/figures/")


##----------------------------------------------------------------------------
## CO

# upwind
data_upwind_co <- aqs_daily_annuli_exposure %>%
  filter(co_max > 0) %>%
  filter(year %in% c(2006:2019)) %>%
  mutate(indicator_0_1km = case_when(preprod_count_uw_0to1km >  0 ~ 1,
                                     preprod_count_uw_0to1km == 0 ~ 0),
         indicator_1_2km = case_when(preprod_count_uw_1to2km >  0 ~ 1,
                                     preprod_count_uw_1to2km == 0 ~ 0),
         indicator_2_3km = case_when(preprod_count_uw_2to3km >  0 ~ 1,
                                     preprod_count_uw_2to3km == 0 ~ 0),
         indicator_3_4km = case_when(preprod_count_uw_3to4km >  0 ~ 1,
                                     preprod_count_uw_3to4km == 0 ~ 0),
         indicator_4_5km = case_when(preprod_count_uw_4to5km >  0 ~ 1,
                                     preprod_count_uw_4to5km == 0 ~ 0))
exposure_upwind_co <- 
  tibble(order = c(1:5),
         distance = c("0-1", "1-2", "2-3", "3-4", "4-5"),
         n_wells = c(sum(data_upwind_co$indicator_0_1km),
                     sum(data_upwind_co$indicator_1_2km),
                     sum(data_upwind_co$indicator_2_3km),
                     sum(data_upwind_co$indicator_3_4km),
                     sum(data_upwind_co$indicator_4_5km)))
figure_3_bar_co_uw <- exposure_upwind_co %>%
  ggplot() +
  geom_bar(aes(distance, n_wells), stat = "identity") +
  ylim(0, 1250) +
  labs(x = "", y = "") +
  theme_void()
figure_3_bar_co_uw
ggsave(filename = "figure_3_bar_co_uw.png", plot = figure_3_bar_co_uw, 
       device = "png", height = 0.2, width = 4, path = "output/figures/")

# downwind
data_downwind_co <- aqs_daily_annuli_exposure %>%
  filter(co_max > 0) %>%
  filter(year %in% c(2006:2019)) %>%
  mutate(indicator_0_1km = case_when(preprod_count_dw_0to1km >  0 ~ 1,
                                     preprod_count_dw_0to1km == 0 ~ 0),
         indicator_1_2km = case_when(preprod_count_dw_1to2km >  0 ~ 1,
                                     preprod_count_dw_1to2km == 0 ~ 0),
         indicator_2_3km = case_when(preprod_count_dw_2to3km >  0 ~ 1,
                                     preprod_count_dw_2to3km == 0 ~ 0),
         indicator_3_4km = case_when(preprod_count_dw_3to4km >  0 ~ 1,
                                     preprod_count_dw_3to4km == 0 ~ 0),
         indicator_4_5km = case_when(preprod_count_dw_4to5km >  0 ~ 1,
                                     preprod_count_dw_4to5km == 0 ~ 0))
exposure_downwind_co <- 
  tibble(order = c(1:5),
         distance = c("0-1", "1-2", "2-3", "3-4", "4-5"),
         n_wells = c(sum(data_downwind_co$indicator_0_1km),
                     sum(data_downwind_co$indicator_1_2km),
                     sum(data_downwind_co$indicator_2_3km),
                     sum(data_downwind_co$indicator_3_4km),
                     sum(data_downwind_co$indicator_4_5km)))
figure_3_bar_co_dw <- exposure_downwind_co %>%
  ggplot() +
  geom_bar(aes(distance, n_wells), stat = "identity") +
  ylim(0, 1250) +
  labs(x = "", y = "") +
  theme_void()
figure_3_bar_co_dw
ggsave(filename = "figure_3_bar_co_dw.png", plot = figure_3_bar_co_dw, 
       device = "png", height = 0.2, width = 4, path = "output/figures/")


##----------------------------------------------------------------------------
## NO2

# upwind
data_upwind_no2 <- aqs_daily_annuli_exposure %>%
  filter(no2_max > 0) %>%
  filter(year %in% c(2006:2019)) %>%
  mutate(indicator_0_1km = case_when(preprod_count_uw_0to1km >  0 ~ 1,
                                     preprod_count_uw_0to1km == 0 ~ 0),
         indicator_1_2km = case_when(preprod_count_uw_1to2km >  0 ~ 1,
                                     preprod_count_uw_1to2km == 0 ~ 0),
         indicator_2_3km = case_when(preprod_count_uw_2to3km >  0 ~ 1,
                                     preprod_count_uw_2to3km == 0 ~ 0),
         indicator_3_4km = case_when(preprod_count_uw_3to4km >  0 ~ 1,
                                     preprod_count_uw_3to4km == 0 ~ 0),
         indicator_4_5km = case_when(preprod_count_uw_4to5km >  0 ~ 1,
                                     preprod_count_uw_4to5km == 0 ~ 0))
exposure_upwind_no2 <- 
  tibble(order = c(1:5),
         distance = c("0-1", "1-2", "2-3", "3-4", "4-5"),
         n_wells = c(sum(data_upwind_no2$indicator_0_1km),
                     sum(data_upwind_no2$indicator_1_2km),
                     sum(data_upwind_no2$indicator_2_3km),
                     sum(data_upwind_no2$indicator_3_4km),
                     sum(data_upwind_no2$indicator_4_5km)))
figure_3_bar_no2_uw <- exposure_upwind_no2 %>%
  ggplot() +
  geom_bar(aes(distance, n_wells), stat = "identity") +
  ylim(0, 2400) +
  labs(x = "", y = "") +
  theme_void()
figure_3_bar_no2_uw
ggsave(filename = "figure_3_bar_no2_uw.png", plot = figure_3_bar_no2_uw, 
       device = "png", height = 0.2, width = 4, path = "output/figures/")

# downwind
data_downwind_no2 <- aqs_daily_annuli_exposure %>%
  filter(no2_max > 0) %>%
  filter(year %in% c(2006:2019)) %>%
  mutate(indicator_0_1km = case_when(preprod_count_dw_0to1km >  0 ~ 1,
                                     preprod_count_dw_0to1km == 0 ~ 0),
         indicator_1_2km = case_when(preprod_count_dw_1to2km >  0 ~ 1,
                                     preprod_count_dw_1to2km == 0 ~ 0),
         indicator_2_3km = case_when(preprod_count_dw_2to3km >  0 ~ 1,
                                     preprod_count_dw_2to3km == 0 ~ 0),
         indicator_3_4km = case_when(preprod_count_dw_3to4km >  0 ~ 1,
                                     preprod_count_dw_3to4km == 0 ~ 0),
         indicator_4_5km = case_when(preprod_count_dw_4to5km >  0 ~ 1,
                                     preprod_count_dw_4to5km == 0 ~ 0))
exposure_downwind_no2 <- 
  tibble(order = c(1:5),
         distance = c("0-1", "1-2", "2-3", "3-4", "4-5"),
         n_wells = c(sum(data_downwind_no2$indicator_0_1km),
                     sum(data_downwind_no2$indicator_1_2km),
                     sum(data_downwind_no2$indicator_2_3km),
                     sum(data_downwind_no2$indicator_3_4km),
                     sum(data_downwind_no2$indicator_4_5km)))
figure_3_bar_no2_dw <- exposure_downwind_no2 %>%
  ggplot() +
  geom_bar(aes(distance, n_wells), stat = "identity") +
  ylim(0, 2400) +
  labs(x = "", y = "") +
  theme_void()
figure_3_bar_no2_dw
ggsave(filename = "figure_3_bar_no2_dw.png", plot = figure_3_bar_no2_dw, 
       device = "png", height = 0.2, width = 4, path = "output/figures/")



##----------------------------------------------------------------------------
## O3

# upwind
data_upwind_o3 <- aqs_daily_annuli_exposure %>%
  filter(o3_max > 0) %>%
  filter(year %in% c(2006:2019)) %>%
  mutate(indicator_0_1km = case_when(preprod_count_uw_0to1km >  0 ~ 1,
                                     preprod_count_uw_0to1km == 0 ~ 0),
         indicator_1_2km = case_when(preprod_count_uw_1to2km >  0 ~ 1,
                                     preprod_count_uw_1to2km == 0 ~ 0),
         indicator_2_3km = case_when(preprod_count_uw_2to3km >  0 ~ 1,
                                     preprod_count_uw_2to3km == 0 ~ 0),
         indicator_3_4km = case_when(preprod_count_uw_3to4km >  0 ~ 1,
                                     preprod_count_uw_3to4km == 0 ~ 0),
         indicator_4_5km = case_when(preprod_count_uw_4to5km >  0 ~ 1,
                                     preprod_count_uw_4to5km == 0 ~ 0))
exposure_upwind_o3 <- 
  tibble(order = c(1:5),
         distance = c("0-1", "1-2", "2-3", "3-4", "4-5"),
         n_wells = c(sum(data_upwind_o3$indicator_0_1km),
                     sum(data_upwind_o3$indicator_1_2km),
                     sum(data_upwind_o3$indicator_2_3km),
                     sum(data_upwind_o3$indicator_3_4km),
                     sum(data_upwind_o3$indicator_4_5km)))
figure_3_bar_o3_uw <- exposure_upwind_o3 %>%
  ggplot() +
  geom_bar(aes(distance, n_wells), stat = "identity") +
  ylim(0, 11400) +
  labs(x = "", y = "") +
  theme_void()
figure_3_bar_o3_uw
ggsave(filename = "figure_3_bar_o3_uw.png", plot = figure_3_bar_o3_uw, 
       device = "png", height = 0.2, width = 4, path = "output/figures/")

# downwind
data_downwind_o3 <- aqs_daily_annuli_exposure %>%
  filter(o3_max > 0) %>%
  filter(year %in% c(2006:2019)) %>%
  mutate(indicator_0_1km = case_when(preprod_count_dw_0to1km >  0 ~ 1,
                                     preprod_count_dw_0to1km == 0 ~ 0),
         indicator_1_2km = case_when(preprod_count_dw_1to2km >  0 ~ 1,
                                     preprod_count_dw_1to2km == 0 ~ 0),
         indicator_2_3km = case_when(preprod_count_dw_2to3km >  0 ~ 1,
                                     preprod_count_dw_2to3km == 0 ~ 0),
         indicator_3_4km = case_when(preprod_count_dw_3to4km >  0 ~ 1,
                                     preprod_count_dw_3to4km == 0 ~ 0),
         indicator_4_5km = case_when(preprod_count_dw_4to5km >  0 ~ 1,
                                     preprod_count_dw_4to5km == 0 ~ 0))
exposure_downwind_o3 <- 
  tibble(order = c(1:5),
         distance = c("0-1", "1-2", "2-3", "3-4", "4-5"),
         n_wells = c(sum(data_downwind_o3$indicator_0_1km),
                     sum(data_downwind_o3$indicator_1_2km),
                     sum(data_downwind_o3$indicator_2_3km),
                     sum(data_downwind_o3$indicator_3_4km),
                     sum(data_downwind_o3$indicator_4_5km)))
figure_3_bar_o3_dw <- exposure_downwind_o3 %>%
  ggplot() +
  geom_bar(aes(distance, n_wells), stat = "identity") +
  ylim(0, 11400) +
  labs(x = "", y = "") +
  theme_void()
figure_3_bar_o3_dw
ggsave(filename = "figure_3_bar_o3_dw.png", plot = figure_3_bar_o3_dw, 
       device = "png", height = 0.2, width = 4, path = "output/figures/")


##----------------------------------------------------------------------------
## VOCs

# upwind
data_upwind_vocs <- aqs_daily_annuli_exposure %>%
  filter(vocs_total > 0) %>%
  mutate(indicator_0_1km = case_when(preprod_count_uw_0to1km >  0 ~ 1,
                                     preprod_count_uw_0to1km == 0 ~ 0),
         indicator_1_2km = case_when(preprod_count_uw_1to2km >  0 ~ 1,
                                     preprod_count_uw_1to2km == 0 ~ 0),
         indicator_2_3km = case_when(preprod_count_uw_2to3km >  0 ~ 1,
                                     preprod_count_uw_2to3km == 0 ~ 0),
         indicator_3_4km = case_when(preprod_count_uw_3to4km >  0 ~ 1,
                                     preprod_count_uw_3to4km == 0 ~ 0),
         indicator_4_5km = case_when(preprod_count_uw_4to5km >  0 ~ 1,
                                     preprod_count_uw_4to5km == 0 ~ 0))
exposure_upwind_vocs <- 
  tibble(order = c(1:5),
         distance = c("0-1", "1-2", "2-3", "3-4", "4-5"),
         n_wells = c(sum(data_upwind_vocs$indicator_0_1km),
                     sum(data_upwind_vocs$indicator_1_2km),
                     sum(data_upwind_vocs$indicator_2_3km),
                     sum(data_upwind_vocs$indicator_3_4km),
                     sum(data_upwind_vocs$indicator_4_5km)))
figure_3_bar_vocs_uw <- exposure_upwind_vocs %>%
  ggplot() +
  geom_bar(aes(distance, n_wells), stat = "identity") +
  ylim(0, 750) +
  labs(x = "", y = "") +
  theme_void()
figure_3_bar_vocs_uw
ggsave(filename = "figure_3_bar_vocs_uw.png", plot = figure_3_bar_vocs_uw, 
       device = "png", height = 0.2, width = 4, path = "output/figures/")

# downwind
data_downwind_vocs <- aqs_daily_annuli_exposure %>%
  filter(vocs_total > 0) %>%
  mutate(indicator_0_1km = case_when(preprod_count_dw_0to1km >  0 ~ 1,
                                     preprod_count_dw_0to1km == 0 ~ 0),
         indicator_1_2km = case_when(preprod_count_dw_1to2km >  0 ~ 1,
                                     preprod_count_dw_1to2km == 0 ~ 0),
         indicator_2_3km = case_when(preprod_count_dw_2to3km >  0 ~ 1,
                                     preprod_count_dw_2to3km == 0 ~ 0),
         indicator_3_4km = case_when(preprod_count_dw_3to4km >  0 ~ 1,
                                     preprod_count_dw_3to4km == 0 ~ 0),
         indicator_4_5km = case_when(preprod_count_dw_4to5km >  0 ~ 1,
                                     preprod_count_dw_4to5km == 0 ~ 0))
exposure_downwind_vocs <- 
  tibble(order = c(1:5),
         distance = c("0-1", "1-2", "2-3", "3-4", "4-5"),
         n_wells = c(sum(data_downwind_vocs$indicator_0_1km),
                     sum(data_downwind_vocs$indicator_1_2km),
                     sum(data_downwind_vocs$indicator_2_3km),
                     sum(data_downwind_vocs$indicator_3_4km),
                     sum(data_downwind_vocs$indicator_4_5km)))
figure_3_bar_vocs_dw <- exposure_downwind_vocs %>%
  ggplot() +
  geom_bar(aes(distance, n_wells), stat = "identity") +
  ylim(0, 750) +
  labs(x = "", y = "") +
  theme_void()
figure_3_bar_vocs_dw
ggsave(filename = "figure_3_bar_vocs_dw.png", plot = figure_3_bar_vocs_dw, 
       device = "png", height = 0.2, width = 4, path = "output/figures/")


##============================================================================##