##============================================================================##
## Generates Figure S1: Wind roses 

##----------------------------------------------------------------------------
# data input and tidying

library("openair")
library("patchwork")

aqs_daily_annuli_exposure <- 
  readRDS("../../data/processed/aqs_daily_annuli_exposure.rds")

aqs_daily_annuli_exposure <- aqs_daily_annuli_exposure %>%
  mutate(wd = narr_wind_direction,
         ws = narr_wind_speed)

##----------------------------------------------------------------------------
# Panel A - Wind rose stratified by season

panel_s1_a <- windRose(aqs_daily_annuli_exposure,
                       type = "season",
                       paddle = FALSE)
panel_s1_a

ggsave(filename = "figure_s1_a.png", plot = figure_s1_a, device = "png",
       height = 6, width = 6,
       path = "output/figures/")


##----------------------------------------------------------------------------
# Panel B - Wind rose stratified by CARB basin

panel_s1_b <- windRose(aqs_daily_annuli_exposure,
                       type = "carb_basin",
                       paddle = FALSE)
panel_s1_b

ggsave(filename = "figure_s1_b.png", plot = figure_s1_b, device = "png",
       height = 4, width = 6,
       path = "output/figures/")


##============================================================================##