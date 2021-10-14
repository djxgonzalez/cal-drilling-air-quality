##============================================================================##
## 1.1 - this function prepares data from US EPA Air Quality System (AQS) #

#............................................................................
# function for criteria air pollutants

tidyAirQualityData <- function(data, 
                               pollutant_name, 
                               pollutant_input) {
  
  data <- data %>%
    mutate(monitor_id        = as.factor(`Site ID`),
           date              = as.Date(Date, format = "%m/%d/%Y"),
           cbsa_name         = as.factor(CBSA_NAME),
           county            = as.factor(COUNTY),
           state             = as.factor(STATE),
           !!pollutant_name := !!(as.name(pollutant_input)),
           parameter_code    = as.factor(AQS_PARAMETER_CODE),
           latitude          = SITE_LATITUDE,
           longitude         = SITE_LONGITUDE) %>%
    dplyr::select(monitor_id:longitude) %>%
    mutate(month_year        = as.Date(paste(month(date), "01", year(date),
                                             sep = "/"),
                                       format = "%m/%d/%Y"),
           monitor_day       = as.factor(paste(monitor_id, date, sep = "_")),
           monitor_month     = as.factor(paste(monitor_id, month_year, sep = "-")))
  
  return(data)
}


#............................................................................
# modified function for HAPs

tidyHAPsData <- function(data) {
  
  data <- data %>%   
    mutate(`Site Num`     = stringr::str_pad(`Site Num`, width = 4,
                                             side = "left", pad = "0")) %>%
    mutate(monitor_id     = as.factor(paste(`State Code`, `County Code`,
                                            `Site Num`, sep = "")),
           date           = as.Date(`Date Local`, format = "%Y/%m/%d"),
           cbsa_name         = as.factor(`CBSA Name`),
           county         = as.factor(`County Name`),
           state          = as.factor(`State Name`),
           pollutant_name = as.factor(`Parameter Name`),
           parameter_code = as.factor(`Parameter Code`),
           observation    = `Arithmetic Mean`,
           latitude       = Latitude,
           longitude      = Longitude) %>%
    dplyr::select(monitor_id:longitude) %>%
    mutate(month_year        = as.Date(paste(month(date), "01", year(date),
                                             sep = "/"),
                                       format = "%m/%d/%Y"),
           monitor_day       = as.factor(paste(monitor_id, date, sep = "_")),
           monitor_month     = as.factor(paste(monitor_id, month_year, sep = "-")))
  
  return(data)
}

##============================================================================##