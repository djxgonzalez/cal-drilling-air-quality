# Ch. 2: Proximity to oil and gas production and ambient air quality in California

# Abstract

- **Background:**
  - Prior studies from California and elsewhere have found that residential proximity to upstream oil and gas production is associated with increased risk of adverse health outcomes
  - [Ambient air pollution has been proposed as conferring risk, but extent of ambient air pollution near upstream oil and gas production not clear]
- **Objectives:**
  - Examine the effect of oil and gas production (drilling sites, production) activities on ambient air quality in California from 1999 to 2019
- **Methods:**
  - Data from the US EPA Air Quality System for [444] monitors throughout the U.S., including daily concentrations of ambient air pollutants previously reported to be associated with oil and gas production (NO2, O3, SO2, PM2.5, VOCs)
  - We obtained data on the preproduction and production from the California Geographic Energy Management Division (CalGEM)
  - For each monitor-day, we assessed exposure to upwind wells...
  - We fit fixed effects linear regression models for each pollutants, adjusted for...
- **Results:**
  - We found higher concentrations of PM2.5, O3, SO2 with exposure to upwind drilling sites [add values]
  - We found higher concentrations of ____ with exposure to upwind drilling sites [add values]
- **Conclusion:**  Controlling for geographic, meteorological, seasonal, and temporal factors, we observed higher concentrations of O3, SO2, and PM2.5 at air quality monitors downwind of drilling sites [and active wells?]

# Introduction

**Hook**
- An estimated 17 million U.S. residents live within 1.6 km (1 mile) of an active oil or gas well (Czolowski et al. 2017).
- Recent studies have found that residing in proximity to well sites is associated with adverse reproductive, cardiovascular, psychological, and other health outcomes (Casey et al. 2016, Currie et al. 2017, Gonzalez et al. 2020, McKenzie et al. 2015, Tran et al. 2020, Whitworth et al. 2017)
- Studies in California have found higher risk of PTB and LBW with exposure to oil/gas, higher prevalence of asthma in a LA community near well (Gonzalez et al. 2020, Shamasunder et al., Tran et al. 2020)
- Several possible mechanisms have been hypothesized for the [potential] effect of proximity to well sites on health, including emissions of ambient air contaminants during various stages of oil and gas production (Adgate et al. 2014, Allshouse et al. 2017, Gonzalez et al. 2020, more)

**Context**
- Prior work has found many classes of pollutants emitted by oil/gas preproduction and production (Elliott et al. 2017, Stringfellow et al. 2017) [more refs]
  - Hundreds of classes of compounds possibly associated with adverse reproductive and developmental outcomes (Elliot et al. 2017, Stringfellow et al. 2017)
    - Criteria air pollutants, including NO2, O3, PM2.5, and SO2 [find refs for these]
    - Hazardous air pollutants, including acetaldehyde, acrolein, benzene, formaldehyde, lead
    - Also methane, BTEX [refs, including the study of Lost Hills/Ventura]
      -  "In oil fields in the South Coast Air Quality Management District, located in Southern California, operators are required to report on-site chemical use. In oil fields in this area,  operators  applied  548  chemical  additives  over  a  2-year  span, most with unknown toxicity." (Stringfellow et al. 2017)
        - Many compounds applied at oil fields in Southern California, SCAQMD only CA jurisdiction with mandated reporting

**Gap**
- Despite widespread exposure and reported health risks, the effects of oil and gas production activities on air quality have not been well characterized
  - Prior studies have used air pollution models [refs] or [small] field observations (Arbelaez and Baizel et al. 2015, McKenzie et al. 2012, Schade and Roest 2016)..., or have failed to account for geographic and environmental factors known to affect air quality (Wendt Hess et al. 2019)
- Additionally, the type and magnitude of emissions may vary by stage due to differences in activities related to preproduction and production
  - Temporal intensity of well pad activity should be taken into account (Allshouse et al. 2017)
- Distance at which potentially harmful concentrations of pollutants detected unclear
  -
  - [are there studies of this?]

**Aims**
- In this study, we examined the effect of oil and gas production activities on ambient air quality in California from 1999 to 2019.
- We leveraged the geographic and temporal variation in oil and gas production activities, as well as the U.S. Environmental Protection Agency (EPA) network of air quality monitors.
- We obtained data on mean daily concentrations of gases, particulate matter, and volatile organic compounds
  - Gases
    - Nitrogen monoxide aka nitric oxide (NO)
      - Sources:
      - Associated with:
    - Nitrogen dioxide (NO2)
      - Sources:
        - vehicle exhaust emissions, fossil fuel combustion, off-road equipment [such as diesel engines?]
        - NO2 formation results from NO [is NO primary emitted? add ref]
      - Associated with:
        - Adverse respiratory health, including asthma, susceptibility to respiratory infection
        - Indicator for nitrogen oxides (NOx) including nitrous acid and nitric acid
        - Precursor, along with NOx, for PM and O3
    - Ozone O3
      - Sources:
        - Formed by photochemical reaction involving NOx along with CO, VOCs (hydrocarbons), and methane in presence of sunlight (Mauzerall et al. 2005)
        - We have some data on VOCs analyzed here, but were not able to observe exposure to wells at < 1 km
        - Evidence of methane emissions from upstream oil and gas production, though not included in this analysis [find refs]
      - Associated with:
        - Adverse respiratory health, including impaired lung function, bronchitis, emphysema, and asthma
    - Sulfur dioxide (SO2)
      - Sources:
        - Combustion of sulfur-containing fossil fuels, including oil and use of "nonroad engines" [such as diesel engines?] (EPA)
      - Associated with:
        - Adverse respiratory health outcomes, including asthma
        - PM2.5 precursor chemical; forms sulfate particles with
  - Particulate matter
    - Fine particulate matter with an aerodynamic diameter less than 2.5 µm (PM2.5)
      - Sources:
        - include construction sites, combustion of diesel fuel, unpaved roads, secondary formation in the atmosphere (from, e.g., SO2, NOx emitted in fossil fuel combustion)
      - Associated with:
        - Adverse respiratory and cardiovascular outcomes [refs]
        - Adverse perinatal health outcomes, including maternal morbidities, preterm birth, and impaired fetal growth [that review study]
        - COVID
      - PM2.5 constituents associated with upstream oil and gas production include arsenic, chromium, lead, manganese, nickel
  - Volatile organic compounds (VOCs)
    - All non-methane VOCs
    - Acetaldehyde
    - Acetone
    - Benzene
    - Chloroform
    - Dichloromethane
    - Formaldehyde
    - Tetrachloroethylene
- We assessed exposure to wells in the preproduction stage (new wells) and production stage (active wells)
  - Wells in both stages produce emissions, but expected to be different [ref]
  - May be higher emissions during preproduction (Brown et al. 2014, Colborn et al. 2014)
- For each monitor, we assessed daily exposure to upwind new and active well sites throughout the study period.
- Then, we used a fixed effects regression approach to assess the effect of exposure to new and active wells on the concentrations of each pollutant, accounting for geography, seasonality, and inter-annual variation.

- Primary objectives: [*incorporate into paragraph above*]
  1. To determine whether exposure to new and/or active wells increases concentrations of ambient air pollutants (NO2, O3, PM2.5, SO2, HAPs, VOCs)
  2. To examine the marginal effect of additional oil and gas preproduction or production activities on ambient air concentrations
  3. To examine the distance, if any, at which we observe biologically-relevant increases in concentrations of the observed ambient air pollutants
- Secondary objectives:
  4. To compare methods of assessing exposure to oil and gas preproduction and production activities, specifically, inverse distance weighting and annuli, both with and without wind direction taken into account
  5. To differentiate the effects, of possible, between exposure to new and active wells.


# Methods

### Study design

- In this study, we leveraged geospatial and temporal variation in oil and gas extraction activities, including well preproduction (spudding to completion) and production (monthly volume, barrels of oil equivalent)
- Study period: January 1, 1999 to December 31, 2019
- We used wind direction as a source of exogenous variation
- Fixed effects regression analysis with on a panel dataset of criteria air pollutant concentrations and oil/gas production activity


### Data
- We obtained air quality data from the US Environmental Protection Agency (EPA) Air Quality System (AQS). This dataset comprised daily measurements,from 284 [confirm] monitors throughout California of three classes of air pollutants: gases, particulate matter, and volatile organic compounds [confirm these categories make sense]
  - We included data for all AQS monitors in California that were operating during the study period and that monitored for the pollutants of interest
- Data on oil and gas wells and production activity was obtained from the California Geologic Energy Management Division (CalGEM)
  - [All Wells](https://www.conservation.ca.gov/calgem/maps/Pages/GISMapping2.aspx)
  - Wells in preproduction or production during the study period. Wells in preproduction were included if the interval for preproduction (i.e., the interval between spudding and completion dates) overlapped with the study period. Wells in production were included if the reported interval of production (production start to end) intersected with the study period.
    - The study period starts in 1999, when earliest available PM2.5 data were reported [confirm]
    - For wells with missing data on spud/completion dates, the preproduction interval ends/starts 30 days after spudding/before completion.
    - We also used monthly production data from DOGGR to define the production period [*expand on this*]
  - *Note: For a full exploration of these data, see the 'explore_data_calgem_wells.Rmd' notebook in the 'output/reports' subdirectory.*
- We obtained historic meteorological data from the North American Regional Reanalysis (NARR), a data product from the National Centers for Environmental Prediction (NCEP). This included modeled daily mean wind direction and speed, reported as vectors (u and v), as well as observations of mean surface temperature and precipitation
- We also obtained administrative shapefiles for air basins across the state from the California Air Resources Board (CARB)
  - 2010 US Census Bureau urban areas shapefile to identify monitors in urban/rural areas
- Also, wildfire smoke data from NOAA; records of daily overhead plumes, 2006-2019 [requested from Anne D]

### Exposure Assessment

- We assessed exposure for each monitor-day using 1 km annuli, taking either the count of wells or the sum of oil production within each annulus (Figure 2?).  [expand]
- To assess the robustness of the findings, we conducted a placebo assessed exposure to downwind wells for each monitor-day, using the same approach  described above. In secondary analyses, we assessed exposure using inverse distance-squared weighting  for all wells within a 10 radius of the maternal residence for each monitor-month.

**1-km annuli**

$$exposure_{bt} = {d_{i}}$$

Exposure for birth $b$ in trimester $t$ is the sum of wells, $i$, within *d-1* to $d$ km of the maternal residence for all wells, $n$, in preproduction or production at the time.


**Inverse distance weighting (IDW)**

$$exposure_{bt} = \sum_{i = 1}^{n} \frac{1}{{d_{i}}^{2}}$$

where exposure for birth $b$ in trimester $t$ is the sum of the inverse-squared Euclidean distance, $d$, to each well, $i$, for all wells, $n$, in preproduction or production at the time.


### Statistical analyses

- Descriptive statistics
  - Mean concentrations of air pollutants during the study period, seasonality, time trends
- Primary model
  - For each pollutant and exposure to both the count of drilling sites and sum of oil and gas production, we the following model:

    $$Y_{md} = U_{md} + D_{md} + X_{md} + \gamma + \delta + \lambda$$

    - where...
      - Y is the observed daily concentration of the pollutant at monitor $m$ on day $d$M
      - U is a vector of either (a) the upwind count of drilling sites within each annulus or (b) the upwind sum of oil and gas production at monitor $m$ on day $d$ within each of the ten annuli bins (0-1 km, 1-2 km, etc., out to 9-10 km)
      - D is similar to U, but for downwind drilling sites or production volume
      - X is a vector of daily meteorological factors (precipitation, temperature, and wind speed) at monitor $m$ on day $d$
      - $\gamma$ is a fixed effect for month
      - $\delta$ is a fixed effect for air-basin year
      - $\lambda$ is a fixed effect for the monitor
- In addition, we stratified analyses
  - Urban/rural
    - stratifying on whether the monitor was located in an urban or rural setting, using data from the 2010 U.S. Census
    - Urban = areas ≥50,000 residents; rural, < 50,000 residents
    - 296 monitors urban, 148 rural [confirm]
  - Air basin
    - SJVAPCD, SCAQMD (+ others?)
  - Temporal
    - Moving 5-year averages: 1999-2004, 2005-2009, 2010-2014, 2015-2019
- We conducted sensitivity analyses...
  - Alternative annuli exposure assessment parameters
    - 60° upwind/downwind angles


# Results

- **Descriptive**
  - The analytic dataset comprised observations from ___ monitors in [all?] air basins
  - ...
- **Temporal and geographic trends**
  - Differences by geography?
- **Preproduction i.e. drilling sites**
  - ...
- **Production volume i.e. active wells**
  - ...


# Discussion

- Summary of findings
  - We found higher concentrations of ambient air pollutants in areas near drilling sites...
  - [add results for prod volume analysis]
- Effect modification, others
  - Stratified urban/rural, because... [Tran et al. 2020 found differential associations when stratifying that way]
  - Stratified on CARB air basins... previous air pollution studies in CA have found significant differences in pollutant concentrations between basins [cite PM2.5 study]
  - Adjusted for exposure to wildfire smoke
- Context and comparison
  - other studies, e.g., Texas studies with monitors, CARB SNAPS (if report available)
  - [add PM2.5 radon study, discuss similarity of approach and findings]
  - *see the Paperpile folder*
- Pollutants
  - Due to constraints in publicly available monitoring, we were only able to assess exposure to [four] pollutants, a small subset of the hundreds of pollutants expected to be associated with oil/gas preproduction and production
  - This analysis suggests... travel of harmful pollutants several km downwind of drilling sites... formation of secondary pollutants...
    - [*other pollutants associated with those we monitor?*]
- Limitations
  - Sparsity of monitors with relatively few monitor-days with wells within 2 km; for PM2.5, there were no observations of wells within 1 km (though we found evidence of that drilling sites up to 3 km upwind increased PM2.5 concentrations)
  - Data unavailable for many pollutants possibly associated with upstream oil and gas production (though concentrations of some unobserved pollutants may be correlated with pollutants we observed)
- Strengths
  - A large panel with temporal and geographic variation
  - Able to control for
- Future work
  - Complement with community-engaged field work, with monitoring in locations identified as important by frontline community members
  - Assess concentrations of additional pollutants of public health concern
  - Leverage novel datasets, such as network of low-cost air sensors for PM2.5
  - Examine exposures in other settings
- Conclusion


# Figures and Tables

### Figures

1. (a) Map of the study region (i.e., California) showing the locations of AQS monitors [points] and 5[?] km buffers around new and active wells, including their overlap. (b) Well completions by month, 1999-2019. (c) Oil production by month, 1999-2019. *[Already done!]*
2. Visualization of the exposure assessment methods, using data from the ___ monitor in Bakersfield, California. (a) Inverse distance-squared weighting, (b) 1-km annuli, and (c) 1-km annuli with wind taken into account
  - This may fit better as a supplemental figure
3. Primary results for exposure to drilling sites, upwind and downwind plus monthly no wind
4. Primary results for exposure to production volume, upwind an ddownwind plus monthly no wind


### Tables

1. Descriptive results
2. Regression table


# Supplemental Material

### Supplemental Figures

1.

### Supplemental Tables

1.
