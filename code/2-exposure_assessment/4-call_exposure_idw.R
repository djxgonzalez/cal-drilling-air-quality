# this script calls functions to conduct the *primary* exposure assessment
# (10 km radius, IDW squared) and exports interim datasets


#### adapt for AQS sites

## exposure to well sites in the *preproduction*, i.e., drilling stage ##

  # i. Cumulative exposure
  # cumulative exposure only (date of conception to date of birth)
    births_exp_drilling_cumulative <- 
      assessExposureCumulative(births, 
                               subset(di_wells, drilled_1997_to_2011 == 1),
                               radius = 10, 
                               exponent = 2)
    # exports interim data
    write_csv(births_exp_drilling_cumulative, 
            path = "data/processed/idw/births_exp_cumulative.csv")
    # removes dataset from environment
    rm(births_exp_drilling_cumulative)
  

  # ii. Exposure by trimester
  # assesses exposure to drilling sites by trimester for each birth
  
    # trimester 1
    births_exp_drilling_trimester1 <-
      assessExposureTrimester(births,
                              subset(di_wells, drilled_1997_to_2011 == 1),
                              birth_interval = "T1_interval",        
                              radius         = 10,
                              exponent       = 2,
                              idw_column     = "idw_index_T1",
                              exp_quartile   = "exp_quartile_T1",
                              well_stage     = "preproduction")
    # exports interim data
    write_csv(births_exp_drilling_trimester1,
              path = "data/processed/idw/births_exp_drilling_trimester1.csv")
    # removes dataset from environment
    rm(births_exp_drilling_trimester1)

    # trimester 2
    births_exp_drilling_trimester2 <-
      assessExposureTrimester(births, 
                              subset(di_wells, drilled_1997_to_2011 == 1),
                              birth_interval = "T2_interval",
                              radius         = 10,
                              exponent       = 2,
                              idw_column     = "idw_index_T2",
                              exp_quartile   = "exp_quartile_T2",
                              well_stage     = "preproduction")
    # exports interim data
    write_csv(births_exp_drilling_trimester2,
              path = "data/processed/idw/births_exp_drilling_trimester2.csv")
    # removes dataset from environment
    rm(births_exp_drilling_trimester2)

    # trimester 3
    births_exp_drilling_last30 <-
      assessExposureTrimester(births, 
                              subset(di_wells, drilled_1997_to_2011 == 1), 
                              birth_interval = "last30_interval",     
                              radius         = 10, 
                              exponent       = 2,
                              idw_column     = "idw_index_last30",
                              exp_quartile   = "exp_quartile_last30",
                              well_stage     = "preproduction")
    # exports interim data
    write_csv(births_exp_drilling_last30,
              path = "data/processed/idw/births_exp_drilling_trimester3_last30.csv")
    # removes dataset from environment
    rm(births_exp_drilling_last30)


## exposure to well sites in the *production* stage ##

  # i. Cumulative exposure
    # cumulative exposure only (date of conception to date of birth)
    births_exp_production_cumulative <- 
      assessExposureCumulative(births, 
                               subset(di_wells, prod_1997_to_2011 == 1),
                               radius     = 10, 
                               exponent   = 2,
                               well_stage = "production")
    # exports interim data
    write_csv(births_exp_production_cumulative, 
              path = "data/processed/idw/births_exp_production_cumulative.csv")
    # removes dataset from environment
    rm(births_exp_production_cumulative)


  # ii. Exposure by trimester
  # assesses exposure to well sites in production by trimester for each birth
    
    # trimester 1
    births_exp_production_trimester1 <-
      assessExposureTrimester(births,
                              subset(di_wells, prod_1997_to_2011 == 1),
                              birth_interval = "T1_interval",        
                              radius         = 10,
                              exponent       = 2,
                              idw_column     = "idw_index_T1",
                              exp_quartile   = "exp_quartile_T1",
                              well_stage     = "production")
    # exports interim data
    write_csv(births_exp_production_trimester1,
              path = "data/processed/idw/births_exp_production_trimester1.csv")
    # removes dataset from environment
    rm(births_exp_production_trimester1)

    # trimester 2
    births_exp_production_trimester2 <-
      assessExposureTrimester(births, 
                              subset(di_wells, prod_1997_to_2011 == 1),
                              birth_interval = "T2_interval",
                              radius         = 10,
                              exponent       = 2,
                              idw_column     = "idw_index_T2",
                              exp_quartile   = "exp_quartile_T2",
                              well_stage     = "production")
    # exports interim data
    write_csv(births_exp_production_trimester2,
              path = "data/processed/idw/births_exp_production_trimester2.csv")
    # removes dataset from environment
    rm(births_exp_production_trimester2)

    # trimester 3
    births_exp_production_trimester3_last30 <-
      assessExposureTrimester(births, 
                              subset(di_wells, prod_1997_to_2011 == 1), 
                              birth_interval = "last30_interval",     
                              radius         = 10, 
                              exponent       = 2,
                              idw_column     = "idw_index_last30",
                              exp_quartile   = "exp_quartile_last30",
                              well_stage     = "production")
    # exports interim data
    write_csv(births_exp_production_trimester3_last30,
              path = "data/processed/idw/births_exp_production_trimester3_last30.csv")
    # removes dataset from environment
    rm(births_exp_production_trimester3_last30)

# end #