#####===========================================================================
##### 0. Setup

# loads necessary packages and defines global variables
source("code/0-setup/1-setup.R")


#####===========================================================================
##### 1. Data Tidying

# attaches functions for tidying raw data
source("code/1-data_tidying/1-tidy_aqs_pollution_data.R")
source("code/1-data_tidying/2-tidy_aqs_meteorological_data.R")
source("code/1-data_tidying/3-tidy_calgem_wells_data.R")
source("code/1-data_tidying/4-tidy_calgem_production_data.R")

# imports raw data, calls tidying functions, exports interim data, and removes
# the raw data
source("code/1-data_tidying/5-import_raw_data.R")
source("code/1-data_tidying/6-call_data_tidying.R")
source("code/1-data_tidying/7-remove_raw_data.R")


#####===========================================================================
##### 2. Exposure Assessment

# *NOTE* This code needs some revising, I'll get to work on that! -DG

### Well count, inverse distance-weighted index ..............................
source("code/2-exposure_assessment/1-assess_exposure_idw_preprod.R")
source("code/2-exposure_assessment/2-assess_exposure_idw_prod.R")
source("code/2-exposure_assessment/3-make_idw_exposure_quantiles.R")
source("code/2-exposure_assessment/4-call_exposure_assessment_idw.R")

### Well count, inverse distance-weighted index ..............................
source("code/2-exposure_assessment/5-assess_exposure_annuli.R")
source("code/2-exposure_assessment/6-call_exposure_annuli.R")

### Sum of production, 1-km annuli .........................................
#source("code/2-exposure_assessment/7.R")  # not written yet!


#####===========================================================================
##### 3. Analysis

# *Note:* To do; I have some code to get us started here!



#####===========================================================================
##### 4. Communication

# imports raw and processed data, preps data as needed, and generates Figure 1
source("code/4-communication/1-make_figure1.R")



##============================================================================##