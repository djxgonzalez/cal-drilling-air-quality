## Oil and gas production and ambient air quality in California

Authors: David J.X. Gonzalez, Christina Francis, Mike Baiocchi, Mark Cullen, Gary Shaw, Marshall Burke

*Contact: David J.X. Gonzalez, Postdoctoral Fellow, djxgonz@berkeley.edu

*Updated 10.13.2021*

### Description
In this project we investigate to what extent oil and gas preproduction and/or production activities affects ambient air pollution in California.

### Data Sources
Datasets necessary for this analysis are included in this repo. The raw datasets are publicly available from these sources:
- California Air Resources Board (CARB)
  - Administrative shapefiles for air basins
- California Geologic Energy Management Division (CalGEM)
  - [All wells](https://www.conservation.ca.gov/calgem/maps/Pages/GISMapping2.aspx) dataset, with coordinates and covariates for all wells in the state
  - Oil and gas production data at the well-month level
- North American Regional Reanalysis (NARR)
  - Daily observations of wind direction and speed
- PRISM
  - Daily observations of temperature and precipitation
- US Census Bureau
  - Administrative shapefiles for counties, census tracts
- US Environmental Protection Agency (EPA)
  - Air Quality System - air quality and meteorological data

### Contents
- **code/** - R scripts for all stages of the project, arranged in order of the workflow
  - *0-setup/* - a script to set up the R environment
  - *1-tidying/* - imports raw data, tidies the data, and exports interim and processed datasets as .Rds files
  - *2-exposure_assessment/* - imports interim data, assesses exposure of monitoring sites to new, active, and inactive wells
  - *3-analysis/* - imports processed data, defines and calls functions to conduct final analysis
  - *4-communication/* - generates and exports figures and tables
  - *run_all.R* - this script sets up the R environment and calls all scripts to fully conduct the analysis, from setup to communication
- **data/** - stores all data affiliated with the project
  - *raw/* - raw data
  - *interim/* - interim datasets generated during the analysis
  - *processed/* - datasets processed and finalized from analysis
- **output/** - products of interim and final analyses
  - *figures/* - destination for figures, with subdirectories for figures formatted for presentations and the manuscript
  - *reports/* - finalized reports on discrete elements of the analysis, e.g., data exploration, figures (iteratively constructed), and model output
  - *tables/* - destination for results tables
- **references/** - documents relevant to the project
