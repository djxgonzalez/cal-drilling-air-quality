##============================================================================##
## 3.1 - Combines interim datasets to 

#............................................................................
# imports data components

aqs_daily_annuli_production_nowind <- 
  readRDS("data/processed/aqs_daily_annuli_production_nowind.rds") %>%
  mutate(month_year        = as.Date(paste(month(date), "01", year(date),
                                           sep = "/"),
                                     format = "%m/%d/%Y")) %>%
  mutate(monitor_day       = as.factor(paste(monitor_id, date, sep = "_")),
         monitor_month     = as.factor(paste(monitor_id, month_year, sep = "-"))) %>%
  select(-c(date, monitor_id, monitor_day, month_year))

# exposure data
aqs_daily_annuli_production_uw <-
  readRDS("data/processed/aqs_daily_annuli_upwind_production_1999a.rds") %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_1999b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2000a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2000b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2001a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2001b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2001c.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2001d.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2001e.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2001f.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2001g.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2001h.rds")) %>%
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2002a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2002b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2002c.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2002d.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2002e.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2002f.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2002g.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2002h.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2003a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2003b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2003c.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2003d.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2003e.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2003f.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2003g.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2004a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2004b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2004c.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2004d.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2004e.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2004f.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2004g.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2005a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2005b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2005c.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2005d.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2005e.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2005f.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2005g.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2006a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2006b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2006c.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2006d.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2006e.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2006f.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2006g.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2007a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2007b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2007c.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2007d.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2007e.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2007f.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2007g.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2008a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2008b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2008c.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2008d.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2008e.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2008f.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2008g.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2009a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2009b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2009c.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2009d.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2009e.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2009f.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2009g.rds")) %>%
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2010a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2010b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2010c.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2010d.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2010e.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2010f.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2010g.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2010h.rds")) %>%  
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2011a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2011b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2011c.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2011d.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2011e.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2011f.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2011g.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2011h.rds")) %>%
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2012a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2012b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2012c.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2012d.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2012e.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2012f.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2012g.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2012h.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2013a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2013b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2013c.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2013d.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2013e.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2013f.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2013g.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2013h.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2014a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2014b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2014c.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2014d.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2014e.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2014f.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2014g.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2014h.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2015a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2015b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2015c.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2015d.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2015e.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2015f.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2015g.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2015h.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2016a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2016b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2016c.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2016d.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2016e.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2016f.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2016g.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2016h.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2017a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2017b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2018a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2018b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2019a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_upwind_production_2019b.rds")) %>% 
  rename(prod_volume_upwind_0to1km = wells_prod_upwind_0to1km,
         prod_volume_upwind_1to2km = wells_prod_upwind_1to2km,
         prod_volume_upwind_2to3km = wells_prod_upwind_2to3km,
         prod_volume_upwind_3to4km = wells_prod_upwind_3to4km,
         prod_volume_upwind_4to5km = wells_prod_upwind_4to5km,
         prod_volume_upwind_5to6km = wells_prod_upwind_5to6km,
         prod_volume_upwind_6to7km = wells_prod_upwind_6to7km,
         prod_volume_upwind_7to8km = wells_prod_upwind_7to8km,
         prod_volume_upwind_8to9km = wells_prod_upwind_8to9km,
         prod_volume_upwind_9to10km = wells_prod_upwind_9to10km) %>%
  mutate(monitor_day = as.factor(paste(monitor_id, date, sep = "_"))) %>%
  distinct(monitor_day, .keep_all = TRUE) %>%
  select(-c(date, monitor_id))

aqs_daily_annuli_production_dw_a <-
  readRDS("data/processed/aqs_daily_annuli_downwind_production_2002a.rds") %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2002b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2002c.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2002d.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2002e.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2002f.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2002g.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2002h.rds")) %>% 
  rename(prod_volume_downwind_0to1km = wells_prod_upwind_0to1km,
         prod_volume_downwind_1to2km = wells_prod_upwind_1to2km,
         prod_volume_downwind_2to3km = wells_prod_upwind_2to3km,
         prod_volume_downwind_3to4km = wells_prod_upwind_3to4km,
         prod_volume_downwind_4to5km = wells_prod_upwind_4to5km,
         prod_volume_downwind_5to6km = wells_prod_upwind_5to6km,
         prod_volume_downwind_6to7km = wells_prod_upwind_6to7km,
         prod_volume_downwind_7to8km = wells_prod_upwind_7to8km,
         prod_volume_downwind_8to9km = wells_prod_upwind_8to9km,
         prod_volume_downwind_9to10km = wells_prod_upwind_9to10km)
aqs_daily_annuli_production_dw_b <-
  readRDS("data/processed/aqs_daily_annuli_downwind_production_2003a.rds") %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2003b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2003c.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2003d.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2003e.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2003f.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2003g.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2003h.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2003i.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2004a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2004b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2004c.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2004d.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2004e.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2004f.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2004g.rds")) %>% 
  rename(prod_volume_downwind_0to1km = prod_volume_upwind_0to1km,
         prod_volume_downwind_1to2km = prod_volume_upwind_1to2km,
         prod_volume_downwind_2to3km = prod_volume_upwind_2to3km,
         prod_volume_downwind_3to4km = prod_volume_upwind_3to4km,
         prod_volume_downwind_4to5km = prod_volume_upwind_4to5km,
         prod_volume_downwind_5to6km = prod_volume_upwind_5to6km,
         prod_volume_downwind_6to7km = prod_volume_upwind_6to7km,
         prod_volume_downwind_7to8km = prod_volume_upwind_7to8km,
         prod_volume_downwind_8to9km = prod_volume_upwind_8to9km,
         prod_volume_downwind_9to10km = prod_volume_upwind_9to10km)
aqs_daily_annuli_production_dw <- aqs_daily_annuli_production_dw_a %>%
  bind_rows(aqs_daily_annuli_production_dw_b) %>%
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2001a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2001b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2001c.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2001d.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2001e.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2001f.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2001g.rds")) %>%
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2005a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2005b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2005c.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2005d.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2005e.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2005f.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2005g.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2006a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2006b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2006c.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2006d.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2006e.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2006f.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2006g.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2007a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2007b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2007c.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2007d.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2007e.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2007f.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2007g.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2008a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2008b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2008c.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2008d.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2008e.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2008f.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2008g.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2009a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2009b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2009c.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2009d.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2009e.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2009f.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2009g.rds")) %>%
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2010a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2010b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2010c.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2010d.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2010e.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2010f.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2010g.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2011a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2011b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2011c.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2011d.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2011e.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2011f.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2011g.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2011h.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2012a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2012b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2012c.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2012d.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2012e.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2012f.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2012g.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2012h.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2013a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2013b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2013c.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2013d.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2013e.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2013f.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2013g.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2013h.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2014a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2014b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2014c.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2014d.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2014e.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2014f.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2014g.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2014h.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2014i.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2015a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2015b.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2015c.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2015d.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2015e.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2015f.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2015g.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2015h.rds")) %>%  
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2016a.rds")) %>% 
  bind_rows(readRDS("data/processed/aqs_daily_annuli_downwind_production_2016b.rds")) %>%
  mutate(monitor_day = as.factor(paste(monitor_id, date, sep = "_"))) %>%
  distinct(monitor_day, .keep_all = TRUE) %>%
  select(-c(date, monitor_id))

aqs_daily_annuli_exposure <- aqs_daily_annuli_preproduction %>%
  mutate(monitor_month     = as.factor(paste(monitor_id, month_year, sep = "-"))) %>%
  left_join(aqs_daily_annuli_production_uw, by = "monitor_day") %>%
  left_join(aqs_daily_annuli_production_dw, by = "monitor_day") %>%
  left_join(aqs_daily_annuli_production_nowind, by = "monitor_month") %>%
  mutate(prod_volume_upwind_0to1km    = replace_na(prod_volume_upwind_0to1km, 0),
         prod_volume_upwind_1to2km    = replace_na(prod_volume_upwind_1to2km, 0),
         prod_volume_upwind_2to3km    = replace_na(prod_volume_upwind_2to3km, 0),
         prod_volume_upwind_3to4km    = replace_na(prod_volume_upwind_3to4km, 0),
         prod_volume_upwind_4to5km    = replace_na(prod_volume_upwind_4to5km, 0),
         prod_volume_upwind_5to6km    = replace_na(prod_volume_upwind_5to6km, 0),
         prod_volume_upwind_6to7km    = replace_na(prod_volume_upwind_6to7km, 0),
         prod_volume_upwind_7to8km    = replace_na(prod_volume_upwind_8to9km, 0),
         prod_volume_upwind_8to9km    = replace_na(prod_volume_upwind_8to9km, 0),
         prod_volume_upwind_9to10km   = replace_na(prod_volume_upwind_9to10km, 0),
         prod_volume_downwind_0to1km  = replace_na(prod_volume_downwind_0to1km, 0),
         prod_volume_downwind_1to2km  = replace_na(prod_volume_downwind_1to2km, 0),
         prod_volume_downwind_2to3km  = replace_na(prod_volume_downwind_2to3km, 0),
         prod_volume_downwind_3to4km  = replace_na(prod_volume_downwind_3to4km, 0),
         prod_volume_downwind_4to5km  = replace_na(prod_volume_downwind_4to5km, 0),
         prod_volume_downwind_5to6km  = replace_na(prod_volume_downwind_5to6km, 0),
         prod_volume_downwind_6to7km  = replace_na(prod_volume_downwind_6to7km, 0),
         prod_volume_downwind_7to8km  = replace_na(prod_volume_downwind_8to9km, 0),
         prod_volume_downwind_8to9km  = replace_na(prod_volume_downwind_8to9km, 0),
         prod_volume_downwind_9to10km = replace_na(prod_volume_downwind_9to10km, 0),
         prod_volume_nowind_0to1km    = replace_na(prod_volume_nowind_0to1km, 0),
         prod_volume_nowind_1to2km    = replace_na(prod_volume_nowind_1to2km, 0),
         prod_volume_nowind_2to3km    = replace_na(prod_volume_nowind_2to3km, 0),
         prod_volume_nowind_3to4km    = replace_na(prod_volume_nowind_3to4km, 0),
         prod_volume_nowind_4to5km    = replace_na(prod_volume_nowind_4to5km, 0),
         prod_volume_nowind_5to6km    = replace_na(prod_volume_nowind_5to6km, 0),
         prod_volume_nowind_6to7km    = replace_na(prod_volume_nowind_6to7km, 0),
         prod_volume_nowind_7to8km    = replace_na(prod_volume_nowind_8to9km, 0),
         prod_volume_nowind_8to9km    = replace_na(prod_volume_nowind_8to9km, 0),
         prod_volume_nowind_9to10km   = replace_na(prod_volume_nowind_9to10km, 0))


#............................................................................
# exports processed data
saveRDS(aqs_daily_annuli_exposure, 
        "data/processed/aqs_daily_annuli_exposure.rds")


##============================================================================##
