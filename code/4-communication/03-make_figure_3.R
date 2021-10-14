##============================================================================##
## Generates Figure 3: Results comparing upwind and downwind wells

##----------------------------------------------------------------------------
# data input and tidying

library("patchwork")  # for binding panels

# daily observations, upwind/downwind
results_preprod_pm25  <- 
  read_csv("output/results/point_estimates/daily_annuli_preproduction_pm25.csv") %>%
  filter(distance %in% c("0-1", "1-2", "2-3", "3-4", "4-5"))
results_preprod_co  <- 
  read_csv("output/results/point_estimates/daily_annuli_preproduction_co.csv") %>%
  filter(distance %in% c("0-1", "1-2", "2-3", "3-4", "4-5"))
results_preprod_no2  <- 
  read_csv("output/results/point_estimates/daily_annuli_preproduction_no2.csv") %>%
  filter(distance %in% c("0-1", "1-2", "2-3", "3-4", "4-5"))
results_preprod_o3  <- 
  read_csv("output/results/point_estimates/daily_annuli_preproduction_o3.csv") %>%
  filter(distance %in% c("0-1", "1-2", "2-3", "3-4", "4-5"))
results_preprod_vocs  <- 
  read_csv("output/results/point_estimates/daily_annuli_preproduction_vocs.csv") %>%
  filter(distance %in% c("0-1", "1-2", "2-3", "3-4", "4-5"))


##----------------------------------------------------------------------------
# Row A: PM2.5

panel_a1 <- results_preprod_pm25 %>%
  filter(direction == "Upwind") %>%
  mutate(distance_ordinal = c(1:5)) %>%
  ggplot() + 
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_ribbon(aes(x     = distance_ordinal,
                  y     = point_est,
                  ymin  = ci_lower, 
                  ymax  = ci_upper),
              fill = "#08519c", 
              alpha = 0.5) +
  geom_pointrange(aes(x     = distance_ordinal,
                      y     = point_est,
                      ymin  = ci_lower, 
                      ymax  = ci_upper),
                  color = "black") + 
  ylim(c(-1.9, 4.0)) +
  labs(x = "", y = expression(PM[2.5]*" "*(µg*" "*m^-3))) +
  scale_x_discrete(name = "", limits = c("0-1", "1-2", "2-3", "3-4", "4-5")) +
  #scale_x_reverse(breaks = c(5:1),
  #                labels = c("5-4", "4-3", "3-2", "2-1", "1-0")) +
  theme_classic() +
  theme(legend.position = "none",
        axis.line.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.line.y = element_blank()) +
  ggtitle("a")

panel_a2 <- results_preprod_pm25 %>%
  filter(direction == "Downwind") %>%
  mutate(distance_ordinal = c(1:5)) %>%
  ggplot() + 
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_ribbon(aes(x     = distance_ordinal,
                  y     = point_est, 
                  ymin  = ci_lower, 
                  ymax  = ci_upper),
              fill = "#9ecae1", 
              alpha = 0.5) +
  geom_pointrange(aes(x     = distance_ordinal, 
                      y     = point_est, 
                      ymin  = ci_lower, 
                      ymax  = ci_upper),
                  color = "black") + 
  labs(x = "", y = "") +
  scale_x_discrete(name = "", 
                   limits = c("0-1", "1-2", "2-3", "3-4", "4-5")) +
  #scale_x_reverse(breaks = c(5:1),  #### use this code to flip x-axis
  #                labels = c("5-4", "4-3", "3-2", "2-1", "1-0")) +
  scale_y_continuous(position = "right", limits = c(-1.9, 4.0)) +
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
  filter(direction == "Upwind") %>%
  mutate(distance_ordinal = c(1:5)) %>%
  ggplot() + 
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_ribbon(aes(x     = distance_ordinal, 
                  y     = point_est, 
                  ymin  = ci_lower, 
                  ymax  = ci_upper),
              fill = "#08519c",
              alpha = 0.5) +
  geom_pointrange(aes(x     = distance_ordinal, 
                      y     = point_est, 
                      ymin  = ci_lower, 
                      ymax  = ci_upper),
                  color = "black") + 
  ylim(c(-0.05, 0.18)) +
  labs(x = "", y = expression(CO*" "*(ppm))) +
  scale_x_discrete(name = "", limits = c("0-1", "1-2", "2-3", "3-4", "4-5")) +
  theme_classic() +
  theme(legend.position = "none",
        axis.line.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.line.y  = element_blank()) +
  ggtitle("b")

panel_b2 <- results_preprod_co %>%
  filter(direction == "Downwind") %>%
  mutate(distance_ordinal = c(1:5)) %>%
  ggplot() + 
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_ribbon(aes(x     = distance_ordinal, 
                  y     = point_est, 
                  ymin  = ci_lower, 
                  ymax  = ci_upper),
              fill = "#9ecae1", 
              alpha = 0.5) +
  geom_pointrange(aes(x     = distance_ordinal, 
                      y     = point_est, 
                      ymin  = ci_lower, 
                      ymax  = ci_upper),
                  color = "black") + 
  labs(x = "", y = "") +
  scale_x_discrete(name = "", limits = c("0-1", "1-2", "2-3", "3-4", "4-5")) +
  scale_y_continuous(position = "right", limits = c(-0.05, 0.18)) +
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
  filter(direction == "Upwind") %>%
  mutate(distance_ordinal = c(1:5)) %>%
  ggplot() + 
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_ribbon(aes(x     = distance_ordinal, 
                  y     = point_est, 
                  ymin  = ci_lower, 
                  ymax  = ci_upper),
              fill = "#08519c", 
              alpha = 0.5) +
  geom_pointrange(aes(x     = distance_ordinal, 
                      y     = point_est, 
                      ymin  = ci_lower, 
                      ymax  = ci_upper),
                  color = "black") + 
  ylim(c(-2.0, 8.3)) +
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

panel_c2 <- results_preprod_no2 %>%
  filter(direction == "Downwind") %>%
  mutate(distance_ordinal = c(1:5)) %>%
  ggplot() + 
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_ribbon(aes(x     = distance_ordinal, 
                  y     = point_est, 
                  ymin  = ci_lower, 
                  ymax  = ci_upper),
              fill = "#9ecae1", 
              alpha = 0.5) +
  geom_pointrange(aes(x     = distance_ordinal, 
                      y     = point_est, 
                      ymin  = ci_lower, 
                      ymax  = ci_upper),
                  color = "black") + 
  labs(y = "") +
  scale_x_discrete(name = "", 
                   limits = c("0-1", "1-2", "2-3", "3-4", "4-5")) +
  scale_y_continuous(position = "right", limits = c(-2.0, 8.3)) +
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
  mutate(point_est = point_est,
         ci_lower  = ci_lower,
         ci_upper  = ci_upper) %>%
  filter(direction == "Upwind") %>%
  mutate(distance_ordinal = c(1:5)) %>%
  ggplot() + 
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_ribbon(aes(x     = distance_ordinal, 
                  y     = point_est, 
                  ymin  = ci_lower, 
                  ymax  = ci_upper),
              fill = "#08519c", 
              alpha = 0.5) +
  geom_pointrange(aes(x     = distance_ordinal, 
                      y     = point_est, 
                      ymin  = ci_lower, 
                      ymax  = ci_upper),
                  color = "black") + 
  ylim(c(-0.53, 0.75)) +
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

panel_d2 <- results_preprod_o3 %>%
  mutate(point_est = point_est,
         ci_lower  = ci_lower,
         ci_upper  = ci_upper) %>%
  filter(direction == "Downwind") %>%
  mutate(distance_ordinal = c(1:5)) %>%
  ggplot() + 
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_ribbon(aes(x     = distance_ordinal, 
                  y     = point_est, 
                  ymin  = ci_lower, 
                  ymax  = ci_upper),
              fill = "#9ecae1", 
              alpha = 0.5) +
  geom_pointrange(aes(x     = distance_ordinal, 
                      y     = point_est, 
                      ymin  = ci_lower, 
                      ymax  = ci_upper),
                  color = "black") + 
  labs(y = "") +
  scale_x_discrete(name = "", 
                   limits = c("0-1", "1-2", "2-3", "3-4", "4-5")) +
  scale_y_continuous(position = "right", limits = c(-0.53, 0.75)) +
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
  filter(direction == "Upwind") %>%
  mutate(distance_ordinal = c(1:5)) %>%
  ggplot() + 
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_ribbon(aes(x     = distance_ordinal, 
                  y     = point_est, 
                  ymin  = ci_lower, 
                  ymax  = ci_upper),
              fill = "#08519c", 
              alpha = 0.5) +
  geom_pointrange(aes(x     = distance_ordinal, 
                      y     = point_est, 
                      ymin  = ci_lower, 
                      ymax  = ci_upper),
                  color = "black") + 
  ylim(c(-60, 50)) +
  labs(y = "VOCs (ppb carbon)") +
  scale_x_discrete(name = "Distance to well (km)", 
                   limits = c("0-1", "1-2", "2-3", "3-4", "4-5")) +
  theme_classic() +
  theme(legend.position = "none",
        axis.line.y = element_blank()) +
  ggtitle("e")

panel_e2 <- results_preprod_vocs %>%
  filter(direction == "Downwind") %>%
  mutate(distance_ordinal = c(1:5)) %>%
  ggplot() + 
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_ribbon(aes(x     = distance_ordinal, 
                  y     = point_est, 
                  ymin  = ci_lower, 
                  ymax  = ci_upper),
              fill = "#9ecae1", 
              alpha = 0.5) +
  geom_pointrange(aes(x     = distance_ordinal, 
                      y     = point_est, 
                      ymin  = ci_lower, 
                      ymax  = ci_upper),
                  color = "black") + 
  labs(y = "") +
  scale_x_discrete(name = "Distance to well (km)", 
                   limits = c("0-1", "1-2", "2-3", "3-4", "4-5")) +
  scale_y_continuous(position = "right", limits = c(-60, 50)) +
  theme_classic() +
  theme(legend.position = "none",
        axis.line.y = element_blank(),
        axis.text.y = element_blank()) +
  ggtitle("")


##----------------------------------------------------------------------------
# Combines and exports figure

# binds panels using patchwork package
figure_3 <- 
  (panel_a1 + panel_a2) /
  (panel_b1 + panel_b2) /
  (panel_c1 + panel_c2) /
  (panel_d1 + panel_d2) /
  (panel_e1 + panel_e2)

figure_3

# exports figure
ggsave(filename = "figure_3a.png", plot = figure_3, device = "png",
       height = 10, width = 8,
       path = "output/figures/")



##----------------------------------------------------------------------------
# Presentation figure - PM2.5

panel_1 <- results_preprod_pm25 %>%
  filter(direction == "Upwind") %>%
  mutate(distance_ordinal = c(1:5)) %>%
  ggplot() + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "#c0c0c0") +
  geom_ribbon(aes(x     = distance_ordinal,
                  y     = point_est,
                  ymin  = ci_lower, 
                  ymax  = ci_upper),
              fill = "#08519c",
              alpha = 0.8) +
  geom_pointrange(aes(x     = distance_ordinal,
                      y     = point_est,
                      ymin  = ci_lower, 
                      ymax  = ci_upper),
                  color = "white") + 
  ylim(c(-2.3, 4.0)) +
  labs(x = "Distance to well", y = expression(PM[2.5]*" "*(µg*" "*m^-3))) +
  scale_x_discrete(name = "", limits = c("0-1", "1-2", "2-3", "3-4", "4-5")) +
  theme_classic() +
  theme(panel.background = element_rect(fill = "black"),
        panel.grid       = element_line(color = "black"),
        plot.background  = element_rect(fill = "black"),
        axis.ticks       = element_line(color = "white"),
        axis.title       = element_text(color = "white"),
        axis.text        = element_text(color = "white"),
        axis.line.x      = element_line(color = "white"))

panel_2 <- results_preprod_pm25 %>%
  filter(direction == "Downwind") %>%
  mutate(distance_ordinal = c(1:5)) %>%
  ggplot() + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "#c0c0c0") +
  geom_ribbon(aes(x     = distance_ordinal,
                  y     = point_est, 
                  ymin  = ci_lower, 
                  ymax  = ci_upper),
              fill = "#969696", 
              alpha = 0.8) +
  geom_pointrange(aes(x     = distance_ordinal, 
                      y     = point_est, 
                      ymin  = ci_lower, 
                      ymax  = ci_upper),
                  color = "white") + 
  labs(x = "Distance to well", y = "") +
  scale_x_discrete(name = "", 
                   limits = c("0-1", "1-2", "2-3", "3-4", "4-5")) +
  scale_y_continuous(position = "right", limits = c(-2.3, 4.0)) +
  theme(panel.background = element_rect(fill = "black"),
        panel.grid       = element_line(color = "black"),
        plot.background  = element_rect(fill = "black"),
        axis.ticks       = element_line(color = "white"),
        axis.title       = element_text(color = "white"),
        axis.text.x      = element_text(color = "white"),
        axis.text.y      = element_text(color = "black"),
        axis.line.x      = element_line(color = "white"))
figure <- panel_1 + panel_2 &
  plot_annotation(theme = theme(plot.margin = margin(0, 0, 0, 0),
                                plot.background = element_rect(fill = "black")))
ggsave(filename = "pres_figure_3_pm25.png", plot = figure, device = "png",
       height = 3, width = 8,
       path = "output/figures/")

##----------------------------------------------------------------------------
# Presentation figure - CO

panel_1 <- results_preprod_co %>%
  mutate(point_est = point_est,
         ci_lower  = ci_lower,
         ci_upper  = ci_upper) %>%
  filter(direction == "Upwind") %>%
  mutate(distance_ordinal = c(1:5)) %>%
  ggplot() + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "#c0c0c0") +
  geom_ribbon(aes(x     = distance_ordinal, 
                  y     = point_est, 
                  ymin  = ci_lower, 
                  ymax  = ci_upper),
              fill = "#08519c",
              alpha = 0.8) +
  geom_pointrange(aes(x     = distance_ordinal, 
                      y     = point_est, 
                      ymin  = ci_lower, 
                      ymax  = ci_upper),
                  color = "white") + 
  ylim(c(-0.07, 0.18)) +
  labs(x = "", y = expression(CO*" "*(ppm))) +
  scale_x_discrete(name = "", 
                   limits = c("0-1", "1-2", "2-3", "3-4", "4-5")) +
  theme(panel.background = element_rect(fill = "black"),
        panel.grid       = element_line(color = "black"),
        plot.background  = element_rect(fill = "black"),
        axis.ticks       = element_line(color = "white"),
        axis.title       = element_text(color = "white"),
        axis.text        = element_text(color = "white"),
        axis.line.x      = element_line(color = "white"))

panel_2 <- results_preprod_co %>%
  mutate(point_est = point_est,
         ci_lower  = ci_lower,
         ci_upper  = ci_upper) %>%
  filter(direction == "Downwind") %>%
  mutate(distance_ordinal = c(1:5)) %>%
  ggplot() + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "#c0c0c0") +
  geom_ribbon(aes(x     = distance_ordinal, 
                  y     = point_est, 
                  ymin  = ci_lower, 
                  ymax  = ci_upper),
              fill = "#969696", 
              alpha = 0.8) +
  geom_pointrange(aes(x     = distance_ordinal, 
                      y     = point_est, 
                      ymin  = ci_lower, 
                      ymax  = ci_upper),
                  color = "white") + 
  labs(y = "") +
  scale_x_discrete(name = "", 
                   limits = c("0-1", "1-2", "2-3", "3-4", "4-5")) +
  scale_y_continuous(position = "right", limits = c(-0.07, 0.18)) +
  theme(panel.background = element_rect(fill = "black"),
        panel.grid       = element_line(color = "black"),
        plot.background  = element_rect(fill = "black"),
        axis.ticks       = element_line(color = "white"),
        axis.title       = element_text(color = "white"),
        axis.text.x      = element_text(color = "white"),
        axis.text.y      = element_text(color = "black"),
        axis.line.x      = element_line(color = "white"))

figure <- panel_1 + panel_2 &
  plot_annotation(theme = theme(plot.margin = margin(0, 0, 0, 0),
                                plot.background = element_rect(fill = "black")))
ggsave(filename = "pres_figure_3_co.png", plot = figure, device = "png",
       height = 3, width = 8,
       path = "output/figures/")


##----------------------------------------------------------------------------
# Presentation figure - NO2

panel_1 <- results_preprod_no2 %>%
  mutate(point_est = point_est,
         ci_lower  = ci_lower,
         ci_upper  = ci_upper) %>%
  filter(direction == "Upwind") %>%
  mutate(distance_ordinal = c(1:5)) %>%
  ggplot() + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "#c0c0c0") +
  geom_ribbon(aes(x     = distance_ordinal, 
                  y     = point_est, 
                  ymin  = ci_lower, 
                  ymax  = ci_upper),
              fill = "#08519c",
              alpha = 0.8) +
  geom_pointrange(aes(x     = distance_ordinal, 
                      y     = point_est, 
                      ymin  = ci_lower, 
                      ymax  = ci_upper),
                  color = "white") + 
  ylim(c(-2.5, 8.3)) +
  labs(x = "", y = expression(NO[2]*" "*(ppb))) +
  scale_x_discrete(name = "", 
                   limits = c("0-1", "1-2", "2-3", "3-4", "4-5")) +
  theme(panel.background = element_rect(fill = "black"),
        panel.grid       = element_line(color = "black"),
        plot.background  = element_rect(fill = "black"),
        axis.ticks       = element_line(color = "white"),
        axis.title       = element_text(color = "white"),
        axis.text        = element_text(color = "white"),
        axis.line.x      = element_line(color = "white"))

panel_2 <- results_preprod_no2 %>%
  mutate(point_est = point_est,
         ci_lower  = ci_lower,
         ci_upper  = ci_upper) %>%
  filter(direction == "Downwind") %>%
  mutate(distance_ordinal = c(1:5)) %>%
  ggplot() + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "#c0c0c0") +
  geom_ribbon(aes(x     = distance_ordinal, 
                  y     = point_est, 
                  ymin  = ci_lower, 
                  ymax  = ci_upper),
              fill = "#969696", 
              alpha = 0.8) +
  geom_pointrange(aes(x     = distance_ordinal, 
                      y     = point_est, 
                      ymin  = ci_lower, 
                      ymax  = ci_upper),
                  color = "white") + 
  labs(y = "") +
  scale_x_discrete(name = "", 
                   limits = c("0-1", "1-2", "2-3", "3-4", "4-5")) +
  scale_y_continuous(position = "right", limits = c(-2.5, 8.3)) +
  theme(panel.background = element_rect(fill = "black"),
        panel.grid       = element_line(color = "black"),
        plot.background  = element_rect(fill = "black"),
        axis.ticks       = element_line(color = "white"),
        axis.title       = element_text(color = "white"),
        axis.text.x      = element_text(color = "white"),
        axis.text.y      = element_text(color = "black"),
        axis.line.x      = element_line(color = "white"))

figure <- panel_1 + panel_2 &
  plot_annotation(theme = theme(plot.margin = margin(0, 0, 0, 0),
                                plot.background = element_rect(fill = "black")))
ggsave(filename = "pres_figure_3_no2.png", plot = figure, device = "png",
       height = 3, width = 8,
       path = "output/figures/")


##----------------------------------------------------------------------------
# Presentation figure - O3

panel_1 <- results_preprod_o3 %>%
  mutate(point_est = point_est,
         ci_lower  = ci_lower,
         ci_upper  = ci_upper) %>%
  filter(direction == "Upwind") %>%
  mutate(distance_ordinal = c(1:5)) %>%
  ggplot() + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "#c0c0c0") +
  geom_ribbon(aes(x     = distance_ordinal, 
                  y     = point_est, 
                  ymin  = ci_lower, 
                  ymax  = ci_upper),
              fill = "#08519c",
              alpha = 0.8) +
  geom_pointrange(aes(x     = distance_ordinal, 
                      y     = point_est, 
                      ymin  = ci_lower, 
                      ymax  = ci_upper),
                  color = "white") + 
  ylim(c(-0.6, 0.75)) +
  labs(x = "", y = expression(O[3]*" "*(ppb))) +
  scale_x_discrete(name = "", 
                   limits = c("0-1", "1-2", "2-3", "3-4", "4-5")) +
  theme(panel.background = element_rect(fill = "black"),
        panel.grid       = element_line(color = "black"),
        plot.background  = element_rect(fill = "black"),
        axis.ticks       = element_line(color = "white"),
        axis.title       = element_text(color = "white"),
        axis.text        = element_text(color = "white"),
        axis.line.x      = element_line(color = "white"))

panel_2 <- results_preprod_o3 %>%
  mutate(point_est = point_est,
         ci_lower  = ci_lower,
         ci_upper  = ci_upper) %>%
  filter(direction == "Downwind") %>%
  mutate(distance_ordinal = c(1:5)) %>%
  ggplot() + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "#c0c0c0") +
  geom_ribbon(aes(x     = distance_ordinal, 
                  y     = point_est, 
                  ymin  = ci_lower, 
                  ymax  = ci_upper),
              fill = "#969696", 
              alpha = 0.8) +
  geom_pointrange(aes(x     = distance_ordinal, 
                      y     = point_est, 
                      ymin  = ci_lower, 
                      ymax  = ci_upper),
                  color = "white") + 
  labs(y = "") +
  scale_x_discrete(name = "", 
                   limits = c("0-1", "1-2", "2-3", "3-4", "4-5")) +
  scale_y_continuous(position = "right", limits = c(-0.6, 0.75)) +
  theme(panel.background = element_rect(fill = "black"),
        panel.grid       = element_line(color = "black"),
        plot.background  = element_rect(fill = "black"),
        axis.ticks       = element_line(color = "white"),
        axis.title       = element_text(color = "white"),
        axis.text.x      = element_text(color = "white"),
        axis.text.y      = element_text(color = "black"),
        axis.line.x      = element_line(color = "white"))

figure <- panel_1 + panel_2 &
  plot_annotation(theme = theme(plot.margin = margin(0, 0, 0, 0),
                                plot.background = element_rect(fill = "black")))
ggsave(filename = "pres_figure_3_o3.png", plot = figure, device = "png",
       height = 3, width = 8,
       path = "output/figures/")

##============================================================================##
