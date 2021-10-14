##============================================================================##
## Figure S5. Bar plot of number of monitors in operation by year

#...........................................................................
# sets up environment
library("patchwork")

# data input
aqs_daily_annuli_exposure <- readRDS("data/processed/aqs_daily_annuli_exposure.rds")

#............................................................................
# generates Figure S5

figure_s5_all <- aqs_daily_annuli_exposure %>%
  filter(year >= 2006) %>%
  distinct(monitor_id, year) %>%
  group_by(year) %>%
  summarize(n_monitors = n()) %>%
  ggplot() +
  geom_bar(aes(year, n_monitors), stat = "identity") +
  labs(title = "All Monitors", x = "", y = "n monitors") +
  ylim(0, 250) +
  theme_classic()

figure_s5_pm25 <- aqs_daily_annuli_exposure %>%
  filter(pm25_mean >= 0) %>%
  filter(year >= 2006) %>%
  distinct(monitor_id, year) %>%
  group_by(year) %>%
  summarize(n_monitors = n()) %>%
  ggplot() +
  geom_bar(aes(year, n_monitors), stat = "identity") +
  labs(title = "PM2.5 Monitors", x = "", y = "") +
  ylim(0, 250) +
  theme_classic() +
  theme(axis.line.y  = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.y  = element_blank())

figure_s5_co <- aqs_daily_annuli_exposure %>%
  filter(co_max >= 0) %>%
  filter(year >= 2006) %>%
  distinct(monitor_id, year) %>%
  group_by(year) %>%
  summarize(n_monitors = n()) %>%
  ggplot() +
  geom_bar(aes(year, n_monitors), stat = "identity") +
  labs(title = "CO Monitors", x = "", y = "n monitors") +
  ylim(0, 250) +
  theme_classic()

figure_s5_no2 <- aqs_daily_annuli_exposure %>%
  filter(no2_max >= 0) %>%
  filter(year >= 2006) %>%
  distinct(monitor_id, year) %>%
  group_by(year) %>%
  summarize(n_monitors = n()) %>%
  ggplot() +
  geom_bar(aes(year, n_monitors), stat = "identity") +
  labs(title = "NO2 Monitors", x = "Year", y = "") +
  ylim(0, 250) +
  theme_classic() +
  theme(axis.line.y  = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.y  = element_blank())

figure_s5_o3 <- aqs_daily_annuli_exposure %>%
  filter(o3_max >= 0) %>%
  filter(year >= 2006) %>%
  distinct(monitor_id, year) %>%
  group_by(year) %>%
  summarize(n_monitors = n()) %>%
  ggplot() +
  geom_bar(aes(year, n_monitors), stat = "identity") +
  labs(title = "O3 Monitors", x = "Year", y = "n monitors") +
  ylim(0, 250) +
  theme_classic()

figure_s5_vocs <- aqs_daily_annuli_exposure %>%
  filter(vocs_total >= 0) %>%
  #filter(year >= 2006) %>%
  distinct(monitor_id, year) %>%
  group_by(year) %>%
  summarize(n_monitors = n()) %>%
  ggplot() +
  geom_bar(aes(year, n_monitors), stat = "identity") +
  labs(title = "VOC Monitors", x = "Year", y = "") +
  ylim(0, 250) +
  theme_classic() +
  theme(axis.line.y  = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.y  = element_blank())

# exports Figure 1a

figure_s5 = 
  (figure_s5_all + figure_s5_pm25 ) /
  (figure_s5_co  + figure_s5_no2) /
  (figure_s5_o3 + figure_s5_vocs)

ggsave(filename = "figure_s5.png", plot = figure_s5, device = "png",
       height = 7, width = 7,
       path = "output/figures/")

##============================================================================##