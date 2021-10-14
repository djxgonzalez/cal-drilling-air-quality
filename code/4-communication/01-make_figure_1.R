##============================================================================##
## Generates Figure 1: (a) Map of study sites; (b) Wells completed by month;
# (c) Oil and gas production by month

##----------------------------------------------------------------------------
## Figure 1a. Map of the study sites

#...........................................................................
# sets up environment

# loads packages
library("ggspatial")

# data input
aqs_sites         <- readRDS("data/interim/aqs_sites.rds") %>%
  st_as_sf()
cal_counties      <- st_read("data/raw/us_census/cal_counties.shp")
calgem_production <- readRDS("data/interim/calgem_production_monthly.rds")
carb_basins       <- st_read("data/raw/cal_epa/carb_air_basins/CaAirBasin.shp")
wells_interim     <- readRDS("data/interim/wells_interim.rds")


#...........................................................................
# data preparation

# layer - California state boundary, made by merging 'cal_counties'
lyr_california <- carb_basins %>%
  st_geometry() %>%
  st_union()
# layer - buffer (10 km) around wells drilled during the study period
lyr_preprod_wells <- wells_interim %>%
  filter(latitude > 0) %>%  # drops non-sensical points
  # filters to wells drilled during study period
  filter(preprod_2006_to_2019 == 1) %>%
  # selects only columns with lat/long
  select(longitude, latitude) %>%
  # convert into sf object
  st_as_sf(coords = c("longitude", "latitude"),
           crs    = crs_nad83) %>%
  # transform to projected CRS, necessary before making  buffer
  st_transform(crs_projected) %>%
  # makes 10 km buffer
  st_buffer(dist = 1000) %>%
  #st_buffer(dist = 10000) %>%  # distance in meters (equivalent to 10 km)
  # merges overlapping polygons
  st_union() %>%
  # converts back to unprojected NAD83 CRS for plotting
  st_transform(crs_nad83)
# layer - buffer (10 km) around wells productive during the study period
lyr_prod_wells <- calgem_production %>%
  filter(latitude > 0) %>%  # drops non-sensical points
  # filters to wells drilled during study period
  filter(total_oil_gas_produced > 0) %>%
  # keeps only the wells with 
  distinct(pwt_id, .keep_all = TRUE) %>%
  # selects only columns with lat/long
  select(longitude, latitude) %>%
  # convert into sf object
  st_as_sf(coords = c("longitude", "latitude"),
           crs = crs_nad83) %>%
  # transform to projected CRS, necessary before making  buffer
  st_transform(crs_projected) %>%
  # makes 10 km buffer
  st_buffer(dist = 1000) %>%
  #st_buffer(dist = 10000) %>%  # distance in meters (equivalent to 10 km)
  # merges overlapping polygons
  st_union() %>%
  # converts back to unprojected NAD83 CRS for plotting
  st_transform(crs_nad83)
buffer_3km <- st_union(lyr_preprod_wells, lyr_prod_wells)
buffer_1km <- st_union(lyr_preprod_wells, lyr_prod_wells)
# layer - AQS sites
lyr_monitors <- aqs_sites %>% 
  st_as_sf(coords = c("longitude", "latitude"), crs = crs_nad83) %>%
  st_geometry()

#............................................................................
# generates Figure 1a

panel_1a <- ggplot() +
  geom_sf(data = lyr_california, 
          fill = NA, color = "black", lwd = 1.2) +
  geom_sf(data = carb_basins, 
          fill = "white", color = "black", lwd = 0.2) +
  geom_sf(data = lyr_prod_wells,    aes(alpha = 0.3), fill = "#8A2BE2") + # purple
  geom_sf(data = lyr_preprod_wells, aes(alpha = 0.3), fill = "#FF7F00") + # orange
  geom_sf(data = lyr_monitors, size = 2.5, shape = 17, color = "#000000") +
  #xlim(-124.6, -114.0) + ylim(32.5, 42.1) +
  #labs(x = "", y = "") +
  theme_void() +
  theme(panel.background = element_rect(fill = "white"),  # black for Powerpoint,
        panel.grid = element_line(color = "white"),       # white bg for Word
        legend.position = "none")

# exports Figure 1a
ggsave(filename = "figure_1a.png", plot = panel_1a, device = "png",
       height = 12.96, width = 11.38,
       path = "output/figures/")

##----------------------------------------------------------------------------
## Figure 1b. Plot of wells spudded and completed by month

# generates Figure 1b

wells_spudded <- wells_interim %>%
  # makes new variable with combined month_year in date format
  mutate(month_year = paste(month(date_spudded), "01",
                            year(date_spudded),  sep = "/")) %>%
  # converts to date
  mutate(month_year = as.Date(month_year, format = "%m/%d/%Y")) %>%
  # restricts to study period
  filter(month_year >= as.Date("2006-01-01") &  
           month_year <= as.Date("2019-12-31")) %>% 
  # sums new completions by month
  group_by(month_year) %>%
  summarize(Spudded = n())
wells_completed <- ells_interim %>%
  # makes new variable with combined month_year in date format
  mutate(month_year = paste(month(date_completed), "01",
                            year(date_completed),  sep = "/")) %>%
  # converts to date
  mutate(month_year = as.Date(month_year, format = "%m/%d/%Y")) %>%
  # restricts to study period
  filter(month_year >= as.Date("2006-01-01") &  
           month_year <= as.Date("2019-12-31")) %>% 
  # sums new completions by month
  group_by(month_year) %>%
  summarize(Completed = n()) #%>%

data_figure_1b <- wells_spudded %>% left_join(wells_completed) %>%
  pivot_longer(cols = Spudded:Completed)#, names_to = "event")

  # makes plot
figure_1b <- data_figure_1b %>%
  ggplot() + 
  geom_area(aes(month_year, value, fill = name), alpha = 0.8) + 
  scale_fill_manual(values = c("#FF7F00", "#FFCFA0")) +
  xlim(c(as.Date("2006-01-01"), as.Date("2019-12-31"))) +
  labs(x = "", y = "") + 
  theme_classic() +
  theme(axis.line.x  = element_blank(),  # removes x-axis
        axis.ticks.x = element_blank(),
        axis.text.x  = element_blank(),
        axis.text.y  = element_blank(),
        legend.position = "none")
        #legend.title = element_blank())

# exports Figure 1b
ggsave(filename = "figure_1b.png", plot = figure_1b, device = "png",
       height = 1.3, width = 5.8,
       path = "output/figures/")

##----------------------------------------------------------------------------
## Figure 1c. Histogram of oil production by month

# generates Figure 1b
figure_1c <- calgem_production %>%
  group_by(prod_month_year) %>%
  summarize(sum_oil_produced = sum(oil_produced, na.rm = TRUE)) %>%
  ggplot() +
  geom_area(aes(prod_month_year, sum_oil_produced), fill = "#8A2BE2", alpha = 0.8) +
  xlim(c(as.Date("2006-01-01"), as.Date("2019-12-31"))) + 
  labs(x = "", y = "") + 
  theme_classic() #+
  theme(axis.text.y  = element_blank())

# exports Figure 1c
ggsave(filename = "figure_1c.png", plot = figure_1c, device = "png",
       height = 1.5, width = 5.8,
       path = "output/figures/")

##============================================================================##

# presentation figure
pres_fig1 <- ggplot() +
  geom_sf(data = cal_counties, fill = "white", color = "black", lwd = 0.1) +
  theme_void() +
  theme(panel.background = element_rect(fill = "black"),
        panel.grid = element_line(color = "black"),
        legend.position = "none")
pres_fig1
ggsave(filename = "pres_fig1.png", plot = pres_fig1, device = "png",
       height = 12.96, width = 11.38, path = "output/figures/")

pres_fig2 <- ggplot() +
  geom_sf(data = cal_counties, fill = "white", color = "black", lwd = 0.1) +
  geom_sf(data = buffer_1km, fill = "red", color = NA, alpha = 0.8) +
  #geom_sf(data = buffer_3km, fill = "red", color = NA, alpha = 0.1) +
  theme_void() +
  theme(panel.background = element_rect(fill = "black"),
        panel.grid = element_line(color = "black"),
        legend.position = "none")
pres_fig2
ggsave(filename = "pres_fig2.png", plot = pres_fig2, device = "png",
       height = 12.96, width = 11.38, path = "output/figures/")



##============================================================================##