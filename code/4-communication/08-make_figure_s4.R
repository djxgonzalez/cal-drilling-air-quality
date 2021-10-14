##============================================================================##
## Makes Figure S4 - Results from models accounting for exposure to both
## preproduction wells and production volume

##----------------------------------------------------------------------------
# data input and tidying

library("patchwork")  # for binding panels

# point estimates and 95% CIs, preproduction
results_preprod_pm25 <-
  read_csv("output/results/point_estimates/daily_annuli_preprod_prod_upwind_pm25.csv")  %>%
  filter(stage == "preprod")
results_preprod_co <- 
  read_csv("output/results/point_estimates/daily_annuli_preprod_prod_upwind_co.csv") %>%
  filter(stage == "preprod")
results_preprod_no2  <- 
  read_csv("output/results/point_estimates/daily_annuli_preprod_prod_upwind_no2.csv") %>%
  filter(stage == "preprod")
results_preprod_o3  <- 
  read_csv("output/results/point_estimates/daily_annuli_preprod_prod_upwind_o3.csv") %>%
  filter(stage == "preprod") %>%
  mutate(point_est = (point_est * 1000),
         ci_lower  = (ci_lower  * 1000),
         ci_upper  = (ci_upper  * 1000))
results_preprod_vocs  <- 
  read_csv("output/results/point_estimates/daily_annuli_preprod_prod_upwind_vocs.csv") %>%
  filter(stage == "preprod")

# point estimates and 95% CIs, production
results_prod_pm25 <-
  read_csv("output/results/point_estimates/daily_annuli_preprod_prod_upwind_pm25.csv") %>%
  filter(stage == "prod")
results_prod_co <- 
  read_csv("output/results/point_estimates/daily_annuli_preprod_prod_upwind_co.csv") %>%
  filter(stage == "prod")
results_prod_no2  <- 
  read_csv("output/results/point_estimates/daily_annuli_preprod_prod_upwind_no2.csv") %>%
  filter(stage == "prod")
results_prod_o3  <- 
  read_csv("output/results/point_estimates/daily_annuli_preprod_prod_upwind_o3.csv") %>%
  filter(stage == "prod") %>%
  mutate(point_est = (point_est * 1000),
         ci_lower  = (ci_lower  * 1000),
         ci_upper  = (ci_upper  * 1000))
results_prod_vocs  <- 
  read_csv("output/results/point_estimates/daily_annuli_preprod_prod_upwind_vocs.csv") %>%
  filter(stage == "prod")


##----------------------------------------------------------------------------
# Row A: PM2.5

panel_a1 <- results_preprod_pm25 %>%
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
  ylim(c(-1, 5)) +
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

panel_a2 <- results_prod_pm25 %>%
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
  scale_y_continuous(position = "right", limits = c(-1, 5)) +  
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

panel_b1 <- results_preprod_co %>%
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
  ylim(c(-0.05, 0.2)) +
  labs(x = "", y = expression(CO*" "*(ppm))) +
  scale_x_discrete(name = "", limits = c("0-1", "1-2", "2-3", "3-4", "4-5")) +
  theme_classic() +
  theme(legend.position = "none",
        axis.line.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.line.y  = element_blank()) +
  ggtitle("b")

panel_b2 <- results_prod_co %>%
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
  scale_y_continuous(position = "right", limits = c(-0.05, 0.2)) +
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

panel_c1 <- results_preprod_no2 %>%
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
  ylim(c(-1, 5)) +
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

panel_c2 <- results_prod_no2 %>%
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
  scale_y_continuous(position = "right", limits = c(-1, 5)) +
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

panel_d1 <- results_preprod_o3 %>%
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
  ylim(c(-0.4, 0.4)) +
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

panel_d2 <- results_prod_o3 %>%
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
  scale_y_continuous(position = "right", limits = c(-0.4, 0.4)) +
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

panel_e1 <- results_preprod_vocs %>%
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
  ylim(c(-22, 51)) +
  labs(y = "VOCs (ppb C)") +
  scale_x_discrete(name = "Distance to well (km)", 
                   limits = c("0-1", "1-2", "2-3", "3-4", "4-5")) +
  theme_classic() +
  theme(legend.position = "none",
        axis.line.y = element_blank()) +
  ggtitle("e")

panel_e2 <- results_prod_vocs %>%
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
  scale_y_continuous(position = "right", limits = c(-22, 51)) +
  theme_classic() +
  theme(legend.position = "none",
        axis.line.y = element_blank(),
        axis.text.y = element_blank()) +
  ggtitle("")


##----------------------------------------------------------------------------
# Combines and exports figure

# binds panels using patchwork package
figure_s4 <-
  (panel_a1 + panel_a2) /  
  (panel_b1 + panel_b2) /
  (panel_c1 + panel_c2) /
  (panel_d1 + panel_d2) /
  (panel_e1 + panel_e2)

figure_s4

# exports figure
ggsave(filename = "figure_s4.png", plot = figure_s4, device = "png",
       height = 10, width = 8, # change width to 8 once we have prod vol
       path = "output/figures/")

##============================================================================##
