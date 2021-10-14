##============================================================================##
## 1.3 - prepares monthly oil and gas production data from CalGEM for analysis 

# this function returns a tidied dataset for monthly oil production by well,
# which can be linked to the Enverus/DrillingInfo dataset with the API; this is 
# for the 1999-2017 data, which are formatted differently than the 2018-19 data
tidyProductionData <- function(data_production) {
  
  # preps DrillingInfo data
  data_production <- read_csv(data_production) %>%
    #data_production <- calgem_production_1999_raw %>%
    
    # renames variables of interest
    # this *is not* the API number, I'm still working on matching the
    # PWT ID with API number in some way
    mutate(pwt_id             = as.factor(PWT__ID),
           api_gravity_of_oil = APIGravityOfOil, 
           days_producing     = DaysProducing,
           gas_produced_boe   = (`GasProduced(MCF)` / 6),  # converts MCF to BOE
           gas_produced_btu   = BTUofGasProduced,
           oil_produced       = OilorCondensateProduced,
           operation_method   = MethodOfOperation,
           prod_report_date   = as.Date(ProductionDate,
                                        format = "%m/%d/%y"),
           water_disposition  = WaterDisposition,
           water_produced     = `WaterProduced(BBL)`,
           well_status_calgem = as.character(ProductionStatus),
           # may be diff. than well type
           well_type_calgem   = as.character(MethodOfOperation)) %>%  
    
    # replaces NAs with zeros and replaces negative observations with 0
    mutate(gas_produced_boe = replace_na(gas_produced_boe, 0)) %>%
    mutate(gas_produced_boe = case_when(gas_produced_boe  < 0 ~ 0,
                                        gas_produced_boe >= 0 ~ 
                                          gas_produced_boe)) %>%
    
    # replaces NAs with zeros and replaces negative observations with 0
    mutate(oil_produced = replace_na(oil_produced, 0)) %>%
    mutate(oil_produced = case_when(oil_produced  < 0 ~ 0,
                                    oil_produced >= 0 ~ oil_produced)) %>%
    
    # adds variable for total oil and gas produced
    mutate(total_oil_gas_produced = oil_produced + gas_produced_boe) %>%
    
    # keeps only the columns we need
    select(pwt_id:well_type_calgem) %>%
    
    # adds month-year of reporting, making variable with combined month_year
    mutate(prod_month_year = paste(month(prod_report_date), 
                                   "01", 
                                   year(prod_report_date), 
                                   sep = "/")) %>%
    
    # converts to date
    mutate(prod_month_year = as.Date(prod_month_year, format = "%m/%d/%Y"))
  
  return(data_production)
}


# this function returns a tidied dataset for monthly oil production by well,
# which can be linked to the Enverus/DrillingInfo dataset with the API; this is 
# for the 2018-19 data, which are formatted differently than the pre-2018 data
tidyProductionData1819 <- function(data_production) {
  
  # preps DrillingInfo data
  data_production <- read_csv(data_production) %>%
    
    # renames variables of interest
    mutate(api_number         = as.factor(APINumber),
           api_gravity_of_oil = APIGravityofOil, 
           days_producing     = DaysProducing,
           #gas_produced       = GasProduced,
           gas_produced_boe   = (`GasProduced` / 6),  # converts MCF to BOE
           gas_produced_btu   = BTUofGasProduced,
           oil_produced       = OilorCondensateProduced,
           operation_method   = MethodOfOperation,
           prod_report_date   = as.Date(ProductionReportDate,
                                        format = "%Y/%m/%d"),
           water_disposition  = WaterDisposition,
           water_produced     = WaterProduced,
           well_status_calgem = as.character(ProductionStatus),
           well_type_calgem   = as.character(WellTypeCode)) %>%
    
    # adds variable for total oil and gas produced
    mutate(total_oil_gas_produced = oil_produced + gas_produced_boe) %>%
    
    # keeps only the columns we need
    select(api_number:well_type_calgem) %>%
    
    # removes extraneous first 2 and last 2 digits from api_number
    mutate(api_number = str_sub(api_number, 3, str_length(api_number) - 2)) %>%
    
    # adds month-year of reporting, making variable with combined month_year
    mutate(prod_month_year = paste(month(prod_report_date), 
                                   "01", 
                                   year(prod_report_date), 
                                   sep = "/")) %>%
    
    # replaces NAs with zeros and replaces negative observations with 0
    mutate(gas_produced_boe = replace_na(gas_produced_boe, 0)) %>%
    mutate(gas_produced_boe = case_when(gas_produced_boe  < 0 ~ 0,
                                        gas_produced_boe >= 0 ~ 
                                          gas_produced_boe)) %>%
    
    # replaces NAs with zeros and replaces negative observations with 0
    mutate(oil_produced = replace_na(oil_produced, 0)) %>%
    mutate(oil_produced = case_when(oil_produced  < 0 ~ 0,
                                    oil_produced >= 0 ~ oil_produced)) %>%
    
    # adds variable for total oil and gas produced
    mutate(total_oil_gas_produced = (oil_produced + gas_produced_boe)) %>%
    
    # converts to date
    mutate(prod_month_year = as.Date(prod_month_year, format = "%m/%d/%Y")) %>%
    
    # adds variabel with month length in days
    mutate(month_length_days  = lubridate::days_in_month(prod_month_year))
  
  return(data_production)
}

##============================================================================##