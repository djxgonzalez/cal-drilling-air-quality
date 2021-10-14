# 0.1 - attaches necessary packages and defines global variables

# loads necessary packages

#library("data.table")
library("lfe")
library("lubridate")
library("ncdf4") 
library("parallel")
library("raster")
library("sf")
library("tidyverse")

# defines global variables

# makes a "not in" operator, the inverse of %in%
'%!in%' <- function(x,y)!('%in%'(x,y))

# coordinate reference system (CRS) for the project
# unprojected CRS, NAD83, for geographic data
crs_nad83 <- st_crs("+init=epsg:4269 +proj=longlat +ellps=GRS80
                        +datum=NAD83 +no_defs +towgs84=0,0,0")  

# projected CRS, for creating buffers
crs_projected <- st_crs("+proj=utm +zone=11 +datum=WGS84") 

# end #