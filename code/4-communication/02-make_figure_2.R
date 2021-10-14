##============================================================================##
## Generates Figure 2: (a) Annuli exposure assessment for preproduction wells;
## (b) Annuli exposure assessment for production wells

## Note: analysis for July 1, 2009 (median date) at monitor 060290232
## with coordinates: 35.438035 N, 119.016787 W

##----------------------------------------------------------------------------
# prepares layers for all plots

library("patchwork")  # for binding panels

# selects sample site in Bakersfield 
lyr_monitor <- readRDS("data/interim/aqs_sites.rds") %>%
  filter(monitor_id == "060290232")
calgem_production <- readRDS("data/interim/calgem_production_monthly.rds")
wells_interim     <- readRDS("data/interim/wells_interim.rds")

# captures monitor lat/long as variables
monitor_lat  <- lyr_monitor$latitude
monitor_long <- lyr_monitor$longitude

# converts to sf object
lyr_monitor <- lyr_monitor %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83)

#...........................................................................
# generates buffer and annuli
lyr_annulus0to1 <- lyr_monitor %>%
  st_transform(crs_projected) %>%
  st_buffer(dist = 1000) %>%
  st_transform(crs_nad83)
lyr_annulus1to2 <- lyr_monitor %>% 
  st_transform(crs_projected) %>%
  st_buffer(dist = 2000) %>%
  st_transform(crs_nad83)
lyr_annulus2to3 <- lyr_monitor %>% 
  st_transform(crs_projected) %>%
  st_buffer(dist = 3000) %>%
  st_transform(crs_nad83)
lyr_annulus3to4 <- lyr_monitor %>% 
  st_transform(crs_projected) %>%
  st_buffer(dist = 4000) %>%
  st_transform(crs_nad83)
lyr_annulus4to5 <- lyr_monitor %>% 
  st_transform(crs_projected) %>%
  st_buffer(dist = 5000) %>%
  st_transform(crs_nad83)
lyr_annulus5to6 <- lyr_monitor %>% 
  st_transform(crs_projected) %>%
  st_buffer(dist = 6000) %>%
  st_transform(crs_nad83)
lyr_annulus6to7 <- lyr_monitor %>% 
  st_transform(crs_projected) %>%
  st_buffer(dist = 7000) %>%
  st_transform(crs_nad83)
lyr_annulus7to8 <- lyr_monitor %>% 
  st_transform(crs_projected) %>%
  st_buffer(dist = 8000) %>%
  st_transform(crs_nad83)
lyr_annulus8to9 <- lyr_monitor %>% 
  st_transform(crs_projected) %>%
  st_buffer(dist = 9000) %>%
  st_transform(crs_nad83)
lyr_annulus9to10 <- lyr_monitor %>% 
  st_transform(crs_projected) %>%
  st_buffer(dist = 10000) %>%
  st_transform(crs_nad83)

lyr_buffer10      <- lyr_annulus9to10
lyr_annulus9to10  <- st_difference(lyr_annulus9to10,  lyr_annulus8to9)
lyr_annulus8to9   <- st_difference(lyr_annulus8to9,   lyr_annulus7to8)
lyr_annulus7to8   <- st_difference(lyr_annulus7to8,   lyr_annulus6to7)
lyr_annulus6to7   <- st_difference(lyr_annulus6to7,   lyr_annulus5to6)
lyr_annulus5to6   <- st_difference(lyr_annulus5to6,   lyr_annulus4to5)
lyr_annulus4to5   <- st_difference(lyr_annulus4to5,   lyr_annulus3to4)
lyr_annulus3to4   <- st_difference(lyr_annulus3to4,   lyr_annulus2to3)
lyr_annulus2to3   <- st_difference(lyr_annulus2to3,   lyr_annulus1to2)
lyr_annulus1to2   <- st_difference(lyr_annulus1to2,   lyr_annulus0to1)


#...........................................................................
# creates upwind wedge

wind_direction <- 298  # actual wind direction on 7.1.2009 at the site

# captures monitor point from the coordinates
monitor_point <- matrix(c(monitor_long, monitor_lat),
                        ncol = 2, byrow = TRUE)
colnames(monitor_point) <- c("long", "lat") 
monitor_point <- as.tibble(monitor_point) %>%
  mutate(long = as.numeric(long), lat  = as.numeric(lat))

# calculating upwind vector and creating a matrix
upwind_point0 <- matrix(c(monitor_long + ((20/110.574) * 
                                            sin(wind_direction * (pi/180))),
                          (monitor_lat  + ((20/110.574) *  
                                             cos(wind_direction * (pi/180))))),
                        ncol = 2, byrow = TRUE)
colnames(upwind_point0) <- c("long", "lat") 
upwind_point0 <- as.tibble(upwind_point0) %>%
  mutate(long = as.numeric(long), lat  = as.numeric(lat))

# calculating upwind points on either side of the wind direction
# first point
upwind_point1 <-
  matrix(c((monitor_long + (((20 / 110.574) / cos(45 * (pi/180))) *
                              sin((wind_direction + 45) * (pi/180)))),
           (monitor_lat  + (((20 / 110.574) / cos(45 * (pi/180))) * 
                              cos((wind_direction + 45) * (pi/180))))),
         ncol = 2, byrow = TRUE)
colnames(upwind_point1) <- c("long", "lat")
upwind_point1 <- as.tibble(upwind_point1) %>%
  mutate(long = as.numeric(long), lat  = as.numeric(lat))

# second point
upwind_point2 <- 
  matrix(c((monitor_long + (((20 / 110.574) / cos(45 * (pi/180)))*
                              sin((wind_direction - 45) * (pi/180)))),
           (monitor_lat + (((20 / 110.574) / cos(45 * (pi/180))) *
                             cos((wind_direction - 45) * (pi/180))))),
         ncol = 2, byrow = TRUE)
colnames(upwind_point2) <- c("long", "lat")
upwind_point2 <- as.tibble(upwind_point2) %>%
  mutate(long = as.numeric(long), lat  = as.numeric(lat))

# makes the first half of the "wedge"
wedge1 <- full_join(upwind_point1, upwind_point0) %>% 
  full_join(y = monitor_point)
wedge1 <- st_as_sf(wedge1, coords = c("long", "lat"))
st_crs(wedge1) <- crs_nad83
wedge1 <- wedge1 %>%
  st_coordinates() %>%
  st_multipoint() %>% 
  st_cast("POLYGON") %>% 
  st_sfc(crs = crs_nad83)

# makes the second half of the "wedge"
wedge2 <- full_join(upwind_point2, upwind_point0) %>% 
  full_join(y = monitor_point) 
wedge2 <- st_as_sf(wedge2, coords = c("long", "lat"))
st_crs(wedge2) <- crs_nad83
wedge2 <- wedge2 %>% 
  st_coordinates() %>%
  st_multipoint() %>% 
  st_cast("POLYGON") %>%
  st_sfc(crs = crs_nad83)

# combines the two halves into the full wedge
upwind_wedge <- st_union(wedge1, wedge2)

lyr_upwind0to1  <- st_intersection(lyr_annulus0to1,  upwind_wedge)
lyr_upwind1to2  <- st_intersection(lyr_annulus1to2,  upwind_wedge)
lyr_upwind2to3  <- st_intersection(lyr_annulus2to3,  upwind_wedge)
lyr_upwind3to4  <- st_intersection(lyr_annulus3to4,  upwind_wedge)
lyr_upwind4to5  <- st_intersection(lyr_annulus4to5,  upwind_wedge)
lyr_upwind5to6  <- st_intersection(lyr_annulus5to6,  upwind_wedge)
lyr_upwind6to7  <- st_intersection(lyr_annulus6to7,  upwind_wedge)
lyr_upwind7to8  <- st_intersection(lyr_annulus7to8,  upwind_wedge)
lyr_upwind8to9  <- st_intersection(lyr_annulus8to9,  upwind_wedge)
lyr_upwind9to10 <- st_intersection(lyr_annulus9to10, upwind_wedge)


#...........................................................................
# creates downwind wedge

wind_direction <- 298 - 180  # inverse of wind direction on 7.1.2009 at the site

# captures monitor point from the coordinates
monitor_point <- matrix(c(monitor_long, monitor_lat),
                        ncol = 2, byrow = TRUE)
colnames(monitor_point) <- c("long", "lat") 
monitor_point <- as.tibble(monitor_point) %>%
  mutate(long = as.numeric(long), lat  = as.numeric(lat))

# calculating upwind vector and creating a matrix
downwind_point0 <- matrix(c(monitor_long + ((20/110.574) * 
                                              sin(wind_direction * (pi/180))),
                            (monitor_lat  + ((20/110.574) *  
                                               cos(wind_direction * (pi/180))))),
                          ncol = 2, byrow = TRUE)
colnames(downwind_point0) <- c("long", "lat") 
downwind_point0 <- as.tibble(downwind_point0) %>%
  mutate(long = as.numeric(long), lat  = as.numeric(lat))

# calculating upwind points on either side of the wind direction
# first point
downwind_point1 <-
  matrix(c((monitor_long + (((20 / 110.574) / cos(45 * (pi/180))) *
                              sin((wind_direction + 45) * (pi/180)))),
           (monitor_lat  + (((20 / 110.574) / cos(45 * (pi/180))) * 
                              cos((wind_direction + 45) * (pi/180))))),
         ncol = 2, byrow = TRUE)
colnames(downwind_point1) <- c("long", "lat")
downwind_point1 <- as.tibble(downwind_point1) %>%
  mutate(long = as.numeric(long), lat  = as.numeric(lat))

# second point
downwind_point2 <- 
  matrix(c((monitor_long + (((20 / 110.574) / cos(45 * (pi/180)))*
                              sin((wind_direction - 45) * (pi/180)))),
           (monitor_lat + (((20 / 110.574) / cos(45 * (pi/180))) *
                             cos((wind_direction - 45) * (pi/180))))),
         ncol = 2, byrow = TRUE)
colnames(downwind_point2) <- c("long", "lat")
downwind_point2 <- as.tibble(downwind_point2) %>%
  mutate(long = as.numeric(long), lat  = as.numeric(lat))

# makes the first half of the "wedge"
wedge1 <- full_join(downwind_point1, downwind_point0) %>% 
  full_join(y = monitor_point)
wedge1 <- st_as_sf(wedge1, coords = c("long", "lat"))
st_crs(wedge1) <- crs_nad83
wedge1 <- wedge1 %>%
  st_coordinates() %>%
  st_multipoint() %>% 
  st_cast("POLYGON") %>% 
  st_sfc(crs = crs_nad83)

# makes the second half of the "wedge"
wedge2 <- full_join(downwind_point2, downwind_point0) %>% 
  full_join(y = monitor_point) 
wedge2 <- st_as_sf(wedge2, coords = c("long", "lat"))
st_crs(wedge2) <- crs_nad83
wedge2 <- wedge2 %>% 
  st_coordinates() %>%
  st_multipoint() %>% 
  st_cast("POLYGON") %>%
  st_sfc(crs = crs_nad83)

# combines the two halves into the full wedge
downwind_wedge <- st_union(wedge1, wedge2)

lyr_downwind0to1  <- st_intersection(lyr_annulus0to1,  downwind_wedge)
lyr_downwind1to2  <- st_intersection(lyr_annulus1to2,  downwind_wedge)
lyr_downwind2to3  <- st_intersection(lyr_annulus2to3,  downwind_wedge)
lyr_downwind3to4  <- st_intersection(lyr_annulus3to4,  downwind_wedge)
lyr_downwind4to5  <- st_intersection(lyr_annulus4to5,  downwind_wedge)
lyr_downwind5to6  <- st_intersection(lyr_annulus5to6,  downwind_wedge)
lyr_downwind6to7  <- st_intersection(lyr_annulus6to7,  downwind_wedge)
lyr_downwind7to8  <- st_intersection(lyr_annulus7to8,  downwind_wedge)
lyr_downwind8to9  <- st_intersection(lyr_annulus8to9,  downwind_wedge)
lyr_downwind9to10 <- st_intersection(lyr_annulus9to10, downwind_wedge)


#...........................................................................
# makes layer with wells within 10 km of the monitor that were in preproduction
# on July 1, 2009 (the midpoint of the study)
lyr_new_wells <- wells_interim %>% 
  #lyr_wells <- readRDS("data/interim/wells_interim.rds") %>% 
  # adds indicator for whether well was in preproduction (drilling) stage
  # during the date
  mutate(exposed1 = as.Date("2009-07-01") %within% preprod_exp_interval1) %>%
  mutate(exposed2 = as.Date("2009-07-01") %within% preprod_exp_interval2) %>%
  mutate(exposed1 = replace_na(exposed1, FALSE)) %>%
  mutate(exposed2 = replace_na(exposed2, FALSE)) %>%
  mutate(exposed  = exposed1 + exposed2) %>%
  # keeps only monitors that are exposed
  filter(exposed >= 1) %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83) %>%
  # restricts to wells within 20 km of the monitor
  st_intersection(lyr_buffer10)


#...........................................................................
# makes layer with production volume within 10 km of the monitor estimated for
# July 1, 2009 (the midpoint of the study)

#calgem_production  <- readRDS("data/interim/calgem_production_monthly.rds")
lyr_prod_volume <- calgem_production %>% 
  # keeps only monitors that are exposed
  filter(prod_month_year == as.Date("2009-07-01")) %>%
  filter(total_oil_gas_produced > 0) %>%
  mutate(total_oil_gas_produced = (total_oil_gas_produced / 31)) %>%
  drop_na(longitude) %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83) %>%
  # restricts to wells within 20 km of the monitor
  st_intersection(lyr_buffer10)


#...........................................................................
# Panel B. Annuli exposure assessment w/ upwind direction for preproduction wells

panel_2a <- ggplot() +  
  geom_sf(data = lyr_annulus0to1,   fill = "#FFFFFF", color = "#FFFFFF") + 
  geom_sf(data = lyr_annulus1to2,   fill = "#F5F5F5", color = "#F5F5F5") +
  geom_sf(data = lyr_annulus2to3,   fill = "#FFFFFF", color = "#FFFFFF") + 
  geom_sf(data = lyr_annulus3to4,   fill = "#F5F5F5", color = "#F5F5F5") + 
  geom_sf(data = lyr_annulus4to5,   fill = "#FFFFFF", color = "#FFFFFF") + 
  geom_sf(data = lyr_annulus5to6,   fill = "#F5F5F5", color = "#F5F5F5") + 
  geom_sf(data = lyr_annulus6to7,   fill = "#FFFFFF", color = "#FFFFFF") + 
  geom_sf(data = lyr_annulus7to8,   fill = "#F5F5F5", color = "#F5F5F5") + 
  geom_sf(data = lyr_annulus8to9,   fill = "#FFFFFF", color = "#FFFFFF") + 
  geom_sf(data = lyr_annulus9to10,  fill = "#F5F5F5", color = "#F5F5F5") + 
  geom_sf(data = lyr_upwind0to1,    fill = "#08519c", color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_upwind1to2,    fill = "#08519c", color = NA, alpha = 0.3) +
  geom_sf(data = lyr_upwind2to3,    fill = "#08519c", color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_upwind3to4,    fill = "#08519c", color = NA, alpha = 0.3) + 
  geom_sf(data = lyr_upwind4to5,    fill = "#08519c", color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_upwind5to6,    fill = "#08519c", color = NA, alpha = 0.3) + 
  geom_sf(data = lyr_upwind6to7,    fill = "#08519c", color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_upwind7to8,    fill = "#08519c", color = NA, alpha = 0.3) + 
  geom_sf(data = lyr_upwind8to9,    fill = "#08519c", color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_upwind9to10,   fill = "#08519c", color = NA, alpha = 0.3) + 
  geom_sf(data = lyr_downwind0to1,  fill = "#9ecae1",   color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_downwind1to2,  fill = "#9ecae1",   color = NA, alpha = 0.3) +
  geom_sf(data = lyr_downwind2to3,  fill = "#9ecae1",   color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_downwind3to4,  fill = "#9ecae1",   color = NA, alpha = 0.3) + 
  geom_sf(data = lyr_downwind4to5,  fill = "#9ecae1",   color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_downwind5to6,  fill = "#9ecae1",   color = NA, alpha = 0.3) + 
  geom_sf(data = lyr_downwind6to7,  fill = "#9ecae1",   color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_downwind7to8,  fill = "#9ecae1",   color = NA, alpha = 0.3) + 
  geom_sf(data = lyr_downwind8to9,  fill = "#9ecae1",   color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_downwind9to10, fill = "#9ecae1",   color = NA, alpha = 0.3) + 
  geom_sf(data = lyr_new_wells, size = 2, shape = 4) +
  geom_sf(data = lyr_monitor,   size = 3,shape = 17) +
  theme_void()

ggsave(filename = "figure_2a.png", plot = panel_2a, device = "png",
       height = 5, width = 6,
       path = "output/figures/")


#..........................................................................
# Panel B. Annuli exposure assessment with upwind direction for production vol.

panel_2b <- ggplot() +
  geom_sf(data = lyr_annulus0to1,   fill = "#FFFFFF", color = "#FFFFFF") + 
  geom_sf(data = lyr_annulus1to2,   fill = "#F5F5F5", color = "#F5F5F5") +
  geom_sf(data = lyr_annulus2to3,   fill = "#FFFFFF", color = "#FFFFFF") + 
  geom_sf(data = lyr_annulus3to4,   fill = "#F5F5F5", color = "#F5F5F5") + 
  geom_sf(data = lyr_annulus4to5,   fill = "#FFFFFF", color = "#FFFFFF") + 
  geom_sf(data = lyr_annulus5to6,   fill = "#F5F5F5", color = "#F5F5F5") + 
  geom_sf(data = lyr_annulus6to7,   fill = "#FFFFFF", color = "#FFFFFF") + 
  geom_sf(data = lyr_annulus7to8,   fill = "#F5F5F5", color = "#F5F5F5") + 
  geom_sf(data = lyr_annulus8to9,   fill = "#FFFFFF", color = "#FFFFFF") + 
  geom_sf(data = lyr_annulus9to10,  fill = "#F5F5F5", color = "#F5F5F5") + 
  geom_sf(data = lyr_upwind0to1,    fill = "#08519c", color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_upwind1to2,    fill = "#08519c", color = NA, alpha = 0.3) +
  geom_sf(data = lyr_upwind2to3,    fill = "#08519c", color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_upwind3to4,    fill = "#08519c", color = NA, alpha = 0.3) + 
  geom_sf(data = lyr_upwind4to5,    fill = "#08519c", color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_upwind5to6,    fill = "#08519c", color = NA, alpha = 0.3) + 
  geom_sf(data = lyr_upwind6to7,    fill = "#08519c", color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_upwind7to8,    fill = "#08519c", color = NA, alpha = 0.3) + 
  geom_sf(data = lyr_upwind8to9,    fill = "#08519c", color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_upwind9to10,   fill = "#08519c", color = NA, alpha = 0.3) + 
  geom_sf(data = lyr_downwind0to1,  fill = "#9ecae1",   color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_downwind1to2,  fill = "#9ecae1",   color = NA, alpha = 0.3) +
  geom_sf(data = lyr_downwind2to3,  fill = "#9ecae1",   color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_downwind3to4,  fill = "#9ecae1",   color = NA, alpha = 0.3) + 
  geom_sf(data = lyr_downwind4to5,  fill = "#9ecae1",   color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_downwind5to6,  fill = "#9ecae1",   color = NA, alpha = 0.3) + 
  geom_sf(data = lyr_downwind6to7,  fill = "#9ecae1",   color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_downwind7to8,  fill = "#9ecae1",   color = NA, alpha = 0.3) + 
  geom_sf(data = lyr_downwind8to9,  fill = "#9ecae1",   color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_downwind9to10, fill = "#9ecae1",   color = NA, alpha = 0.3) + 
  geom_sf(data = lyr_prod_volume, aes(size = total_oil_gas_produced), 
          alpha = 0.2, shape = 1) +
  geom_sf(data = lyr_monitor, size = 3, shape = 17) +
  theme_void() +
  theme(legend.position = "none")
panel_2b

ggsave(filename = "figure_2b.png", plot = panel_2b, device = "png",
       height = 5, width = 6,
       path = "output/figures/")


#...........................................................................
# Binds panels and exports figure

figure_2 <- (panel_2a + panel_2b)

# exports figure
ggsave(filename = "figure_2.png", plot = figure_2, device = "png",
       height = 5, width = 12,
       path = "output/figures/")


##----------------------------------------------------------------------------
## Makes figure panels for presentations with dark background

#...........................................................................
# Panel 2a (presentation). Preproduction well count; done incrementally to
# illustrate the method

panel_a2_i_pres <- ggplot() +  
  geom_sf(data = lyr_annulus0to1,   fill = "#ffffff", color = NA) + 
  geom_sf(data = lyr_annulus1to2,   fill = "#d3d3d3", color = NA) +
  geom_sf(data = lyr_annulus2to3,   fill = "#ffffff", color = NA) + 
  geom_sf(data = lyr_annulus3to4,   fill = "#d3d3d3", color = NA) + 
  geom_sf(data = lyr_annulus4to5,   fill = "#ffffff", color = NA) + 
  geom_sf(data = lyr_annulus5to6,   fill = "#d3d3d3", color = NA) + 
  geom_sf(data = lyr_annulus6to7,   fill = "#ffffff", color = NA) + 
  geom_sf(data = lyr_annulus7to8,   fill = "#d3d3d3", color = NA) + 
  geom_sf(data = lyr_annulus8to9,   fill = "#ffffff", color = NA) + 
  geom_sf(data = lyr_annulus9to10,  fill = "#d3d3d3", color = NA) + 
  geom_sf(data = lyr_new_wells, size = 3, shape = 4) +
  geom_sf(data = lyr_monitor,   size = 3, shape = 17) +
  theme_void() +
  theme(panel.background = element_rect(fill = "black"),
        panel.grid = element_line(color = "black"),
        legend.position = "none")
panel_a2_i_pres
ggsave(filename = "pres_figure_2a_i.png", plot = panel_a2_i_pres, device = "png",
       height = 5, width = 6,
       path = "output/figures/")

panel_a2_ii_pres <- panel_a2_i_pres +
  geom_sf(data = lyr_upwind0to1,    fill = "#08519c", color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_upwind1to2,    fill = "#08519c", color = NA, alpha = 0.3) +
  geom_sf(data = lyr_upwind2to3,    fill = "#08519c", color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_upwind3to4,    fill = "#08519c", color = NA, alpha = 0.3) + 
  geom_sf(data = lyr_upwind4to5,    fill = "#08519c", color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_upwind5to6,    fill = "#08519c", color = NA, alpha = 0.3) + 
  geom_sf(data = lyr_upwind6to7,    fill = "#08519c", color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_upwind7to8,    fill = "#08519c", color = NA, alpha = 0.3) + 
  geom_sf(data = lyr_upwind8to9,    fill = "#08519c", color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_upwind9to10,   fill = "#08519c", color = NA, alpha = 0.3)
panel_a2_ii_pres
ggsave(filename = "pres_figure_2a_ii.png", plot = panel_a2_ii_pres, 
       device = "png", height = 5, width = 6,
       path = "output/figures/")
 
panel_a2_iii_pres <- panel_a2_ii_pres + 
  geom_sf(data = lyr_downwind0to1,  fill = "#9ecae1",   color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_downwind1to2,  fill = "#9ecae1",   color = NA, alpha = 0.3) +
  geom_sf(data = lyr_downwind2to3,  fill = "#9ecae1",   color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_downwind3to4,  fill = "#9ecae1",   color = NA, alpha = 0.3) + 
  geom_sf(data = lyr_downwind4to5,  fill = "#9ecae1",   color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_downwind5to6,  fill = "#9ecae1",   color = NA, alpha = 0.3) + 
  geom_sf(data = lyr_downwind6to7,  fill = "#9ecae1",   color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_downwind7to8,  fill = "#9ecae1",   color = NA, alpha = 0.3) + 
  geom_sf(data = lyr_downwind8to9,  fill = "#9ecae1",   color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_downwind9to10, fill = "#9ecae1",   color = NA, alpha = 0.3)
panel_a2_iii_pres
ggsave(filename = "pres_figure_2a_iii.png", plot = panel_a2_iii_pres, 
       device = "png", height = 5, width = 6,
       path = "output/figures/")

#...........................................................................
# Panel 2a (presentation). Production volume sum; not incremental

panel_2b_pres <- ggplot() +
  geom_sf(data = lyr_annulus0to1,   fill = "#ffffff", color = NA) + 
  geom_sf(data = lyr_annulus1to2,   fill = "#d3d3d3", color = NA) +
  geom_sf(data = lyr_annulus2to3,   fill = "#ffffff", color = NA) + 
  geom_sf(data = lyr_annulus3to4,   fill = "#d3d3d3", color = NA) + 
  geom_sf(data = lyr_annulus4to5,   fill = "#ffffff", color = NA) + 
  geom_sf(data = lyr_annulus5to6,   fill = "#d3d3d3", color = NA) + 
  geom_sf(data = lyr_annulus6to7,   fill = "#ffffff", color = NA) + 
  geom_sf(data = lyr_annulus7to8,   fill = "#d3d3d3", color = NA) + 
  geom_sf(data = lyr_annulus8to9,   fill = "#ffffff", color = NA) + 
  geom_sf(data = lyr_annulus9to10,  fill = "#d3d3d3", color = NA) + 
  geom_sf(data = lyr_upwind0to1,    fill = "#08519c", color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_upwind1to2,    fill = "#08519c", color = NA, alpha = 0.3) +
  geom_sf(data = lyr_upwind2to3,    fill = "#08519c", color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_upwind3to4,    fill = "#08519c", color = NA, alpha = 0.3) + 
  geom_sf(data = lyr_upwind4to5,    fill = "#08519c", color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_upwind5to6,    fill = "#08519c", color = NA, alpha = 0.3) + 
  geom_sf(data = lyr_upwind6to7,    fill = "#08519c", color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_upwind7to8,    fill = "#08519c", color = NA, alpha = 0.3) + 
  geom_sf(data = lyr_upwind8to9,    fill = "#08519c", color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_upwind9to10,   fill = "#08519c", color = NA, alpha = 0.3) + 
  geom_sf(data = lyr_downwind0to1,  fill = "#9ecae1",   color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_downwind1to2,  fill = "#9ecae1",   color = NA, alpha = 0.3) +
  geom_sf(data = lyr_downwind2to3,  fill = "#9ecae1",   color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_downwind3to4,  fill = "#9ecae1",   color = NA, alpha = 0.3) + 
  geom_sf(data = lyr_downwind4to5,  fill = "#9ecae1",   color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_downwind5to6,  fill = "#9ecae1",   color = NA, alpha = 0.3) + 
  geom_sf(data = lyr_downwind6to7,  fill = "#9ecae1",   color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_downwind7to8,  fill = "#9ecae1",   color = NA, alpha = 0.3) + 
  geom_sf(data = lyr_downwind8to9,  fill = "#9ecae1",   color = NA, alpha = 0.1) + 
  geom_sf(data = lyr_downwind9to10, fill = "#9ecae1",   color = NA, alpha = 0.3) + 
  geom_sf(data = lyr_prod_volume, aes(size = total_oil_gas_produced), 
          alpha = 0.2, shape = 1) +
  geom_sf(data = lyr_monitor, size = 3, shape = 17) +
  theme_void() +
  theme(panel.background = element_rect(fill = "black"),
        panel.grid = element_line(color = "black"),
        legend.position = "none")
panel_2b_pres

ggsave(filename = "pres_figure_2b.png", plot = panel_2b_pres, device = "png",
       height = 5, width = 6,
       path = "output/figures/")

##============================================================================##