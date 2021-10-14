##============================================================================##
## Makes Figure S2 - Results without wind taken into account

##----------------------------------------------------------------------------
# data input and tidying

library("patchwork")  # for binding panels

# point estimates and 95% CIs, preproduction
results_preprod_pm25_nowind <-
  read_csv("output/results/point_estimates/daily_annuli_preproduction_pm25_nowind.csv") 
results_preprod_co_nowind <- 
  read_csv("output/results/point_estimates/daily_annuli_preproduction_co_nowind.csv")
results_preprod_no2_nowind  <- 
  read_csv("output/results/point_estimates/daily_annuli_preproduction_no2_nowind.csv")
results_preprod_o3_nowind  <- 
  read_csv("output/results/point_estimates/daily_annuli_preproduction_o3_nowind.csv")
results_preprod_vocs_nowind  <- 
  read_csv("output/results/point_estimates/daily_annuli_preproduction_vocs_nowind.csv")

# point estimates and 95% CIs, production
results_prod_pm25_nowind <-
  read_csv("output/results/point_estimates/daily_annuli_production_pm25_nowind.csv") 
results_prod_co_nowind <- 
  read_csv("output/results/point_estimates/daily_annuli_production_co_nowind.csv")
results_prod_no2_nowind  <- 
  read_csv("output/results/point_estimates/daily_annuli_production_no2_nowind.csv")
results_prod_o3_nowind  <- 
  read_csv("output/results/point_estimates/daily_annuli_production_o3_nowind.csv")
results_prod_vocs_nowind  <- 
  read_csv("output/results/point_estimates/daily_annuli_production_vocs_nowind.csv")


##----------------------------------------------------------------------------
# Row A: PM2.5

panel_a1 <- results_preprod_pm25_nowind %>%
  mutate(distance_ordinal = c(1:5)) %>%
  ggplot() + 
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_ribbon(aes(x     = distance_ordinal,
                  y     = point_est,
                  ymin  = ci_lower, 
                  ymax  = ci_upper),
              fill = "#FF7F00", 
              alpha = 0.5) +
  geom_pointrange(aes(x     = distance_ordinal,
                      y     = point_est,
                      ymin  = ci_lower, 
                      ymax  = ci_upper),
                  color = "black") + 
  ylim(c(-0.3, 2.6)) +
  labs(x = "", y = expression(PM[2.5]*" "*(µg*" "*m^-3))) +
  scale_x_discrete(name = "", limits = c("0-1", "1-2", "2-3", "3-4", "4-5")) +
  #scale_x_reverse(breaks = c(5:1), labels = c("5-4", "4-3", "3-2", "2-1", "1-0")) +
  theme_classic() +
  theme(legend.position = "none",
        axis.line.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.line.y = element_blank()) +
  ggtitle("a")

panel_a2 <- results_prod_pm25_nowind %>%
  mutate(distance_ordinal = c(1:5)) %>%
  ggplot() + 
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_ribbon(aes(x     = distance_ordinal,
                  y     = point_est, 
                  ymin  = ci_lower, 
                  ymax  = ci_upper),
              fill = "#8A2BE2", 
              alpha = 0.5) +
  geom_pointrange(aes(x     = distance_ordinal, 
                      y     = point_est, 
                      ymin  = ci_lower, 
                      ymax  = ci_upper),
                  color = "black") + 
  #ylim(c(-0.3, 1.2)) +
  labs(x = "", y = "") +
  scale_x_discrete(name = "", limits = c("0-1", "1-2", "2-3", "3-4", "4-5")) +
  scale_y_continuous(position = "right", limits = c(-0.3, 2.6)) +  
  theme_classic() +
  theme(legend.position = "none",
        axis.line.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.line.y = element_blank(),
        axis.text.y = element_blank()) +
  ggtitle("")


##----------------------------------------------------------------------------
# Row B: CO

panel_b1 <- results_preprod_co_nowind %>%
  mutate(distance_ordinal = c(1:5)) %>%
  ggplot() + 
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_ribbon(aes(x     = distance_ordinal, 
                  y     = point_est, 
                  ymin  = ci_lower, 
                  ymax  = ci_upper),
              fill = "#FF7F00",
              alpha = 0.5) +
  geom_pointrange(aes(x     = distance_ordinal, 
                      y     = point_est, 
                      ymin  = ci_lower, 
                      ymax  = ci_upper),
                  color = "black") + 
  ylim(c(-0.05, 0.065)) +
  labs(x = "", y = expression(CO*" "*(ppm))) +
  scale_x_discrete(name = "", limits = c("0-1", "1-2", "2-3", "3-4", "4-5")) +
  theme_classic() +
  theme(legend.position = "none",
        axis.line.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.line.y  = element_blank()) +
  ggtitle("b")

panel_b2 <- results_prod_co_nowind %>%
  mutate(distance_ordinal = c(1:5)) %>%
  ggplot() + 
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_ribbon(aes(x     = distance_ordinal, 
                  y     = point_est, 
                  ymin  = ci_lower, 
                  ymax  = ci_upper),
              fill = "#8A2BE2", 
              alpha = 0.5) +
  geom_pointrange(aes(x     = distance_ordinal, 
                      y     = point_est, 
                      ymin  = ci_lower, 
                      ymax  = ci_upper),
                  color = "black") + 
  labs(x = "", y = "") +
  scale_x_discrete(name = "", limits = c("0-1", "1-2", "2-3", "3-4", "4-5")) +
  scale_y_continuous(position = "right", limits = c(-0.05, 0.065)) +
  theme_classic() +
  theme(legend.position = "none",
        axis.line.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.line.y = element_blank(),
        axis.text.y = element_blank()) +
  ggtitle("")


##----------------------------------------------------------------------------
# Row C: NO2 

panel_c1 <- results_preprod_no2_nowind %>%
  mutate(distance_ordinal = c(1:5)) %>%
  ggplot() + 
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_ribbon(aes(x     = distance_ordinal, 
                  y     = point_est, 
                  ymin  = ci_lower, 
                  ymax  = ci_upper),
              fill = "#FF7F00", 
              alpha = 0.5) +
  geom_pointrange(aes(x     = distance_ordinal, 
                      y     = point_est, 
                      ymin  = ci_lower, 
                      ymax  = ci_upper),
                  color = "black") + 
  ylim(c(-0.4, 4.3)) +
  labs(x = "", y = expression(NO[2]*" "*(ppb))) +
  scale_x_discrete(name = "", 
                   limits = c("0-1", "1-2", "2-3", "3-4", "4-5")) +
  theme_classic() +
  theme(legend.position = "none",
        axis.line.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.line.y = element_blank()) +
  ggtitle("c")

panel_c2 <- results_prod_no2_nowind %>%
  mutate(distance_ordinal = c(1:5)) %>%
  ggplot() + 
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_ribbon(aes(x     = distance_ordinal, 
                  y     = point_est, 
                  ymin  = ci_lower, 
                  ymax  = ci_upper),
              fill = "#8A2BE2", 
              alpha = 0.5) +
  geom_pointrange(aes(x     = distance_ordinal, 
                      y     = point_est, 
                      ymin  = ci_lower, 
                      ymax  = ci_upper),
                  color = "black") + 
  labs(y = "") +
  scale_x_discrete(name = "", limits = c("0-1", "1-2", "2-3", "3-4", "4-5")) +
  scale_y_continuous(position = "right", limits = c(-0.4, 4.3)) +
  theme_classic() +
  theme(legend.position = "none",
        axis.line.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.line.y = element_blank(),
        axis.text.y = element_blank()) +
  ggtitle("")


##----------------------------------------------------------------------------
# Row D: O3

panel_d1 <- results_preprod_o3_nowind %>%
  mutate(distance_ordinal = c(1:5)) %>%
  ggplot() + 
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_ribbon(aes(x     = distance_ordinal, 
                  y     = point_est, 
                  ymin  = ci_lower, 
                  ymax  = ci_upper),
              fill = "#FF7F00", 
              alpha = 0.5) +
  geom_pointrange(aes(x     = distance_ordinal, 
                      y     = point_est, 
                      ymin  = ci_lower, 
                      ymax  = ci_upper),
                  color = "black") + 
  ylim(c(-0.2, 0.3)) +
  labs(x = "", y = expression(O[3]*" "*(ppb))) +
  scale_x_discrete(name = "", 
                   limits = c("0-1", "1-2", "2-3", "3-4", "4-5")) +
  theme_classic() +
  theme(legend.position = "none",
        axis.line.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.line.y = element_blank()) +
  ggtitle("d")

panel_d2 <- results_prod_o3_nowind %>%
  mutate(distance_ordinal = c(1:5)) %>%
  ggplot() + 
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_ribbon(aes(x     = distance_ordinal, 
                  y     = point_est, 
                  ymin  = ci_lower, 
                  ymax  = ci_upper),
              fill = "#8A2BE2", 
              alpha = 0.5) +
  geom_pointrange(aes(x     = distance_ordinal, 
                      y     = point_est, 
                      ymin  = ci_lower, 
                      ymax  = ci_upper),
                  color = "black") + 
  labs(y = "") +
  scale_x_discrete(name = "", 
                   limits = c("0-1", "1-2", "2-3", "3-4", "4-5")) +
  scale_y_continuous(position = "right", limits = c(-0.2, 0.3)) +
  theme_classic() +
  theme(legend.position = "none",
        axis.line.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.line.y = element_blank(),
        axis.text.y = element_blank()) +
  ggtitle("")


##----------------------------------------------------------------------------
# Row E: VOCs (non-methane organic carbon)

panel_e1 <- results_preprod_vocs_nowind %>%
  mutate(distance_ordinal = c(1:5)) %>%
  ggplot() + 
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_ribbon(aes(x     = distance_ordinal, 
                  y     = point_est, 
                  ymin  = ci_lower, 
                  ymax  = ci_upper),
              fill = "#FF7F00", 
              alpha = 0.5) +
  geom_pointrange(aes(x     = distance_ordinal, 
                      y     = point_est, 
                      ymin  = ci_lower, 
                      ymax  = ci_upper),
                  color = "black") + 
  ylim(c(-11, 25)) +
  labs(y = "VOCs (ppb C)") +
  scale_x_discrete(name = "Distance to well (km)", 
                   limits = c("0-1", "1-2", "2-3", "3-4", "4-5")) +
  theme_classic() +
  theme(legend.position = "none",
        axis.line.y = element_blank()) +
  ggtitle("e")

panel_e2 <- results_prod_vocs_nowind %>%
  mutate(distance_ordinal = c(1:5)) %>%
  ggplot() + 
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_ribbon(aes(x     = distance_ordinal, 
                  y     = point_est, 
                  ymin  = ci_lower, 
                  ymax  = ci_upper),
              fill = "#8A2BE2", 
              alpha = 0.5) +
  geom_pointrange(aes(x     = distance_ordinal, 
                      y     = point_est, 
                      ymin  = ci_lower, 
                      ymax  = ci_upper),
                  color = "black") + 
  labs(y = "") +
  scale_x_discrete(name = "Distance to well (km)", 
                   limits = c("0-1", "1-2", "2-3", "3-4", "4-5")) +
  scale_y_continuous(position = "right", limits = c(-11, 25)) +
  theme_classic() +
  theme(legend.position = "none",
        axis.line.y = element_blank(),
        axis.text.y = element_blank()) +
  ggtitle("")


##----------------------------------------------------------------------------
# Combines and exports figure

# binds panels using patchwork package
figure_s2 <-
  (panel_a1 + panel_a2) /  
  (panel_b1 + panel_b2) /
  (panel_c1 + panel_c2) /
  (panel_d1 + panel_d2) /
  (panel_e1 + panel_e2)

figure_s2

# exports figure
ggsave(filename = "figure_s2.png", plot = figure_s2, device = "png",
       height = 10, width = 8, # change width to 8 once we have prod vol
       path = "output/figures/")

##============================================================================##
