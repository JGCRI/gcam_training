
# ..............................................................................
# Install packages from github -------------------------------------------------
# ..............................................................................
# Uncomment these lines if you need to install the packages
# Hint: Select multiple lines and then (CTRL+SHIFT+C)
# install.packages("remotes") # If required
# install.packages("dplyr") # If required
# library(remotes)
# remotes::install_github("JGCRI/gcamextractor")
# remotes::install_github("JGCRI/rchart")
# remotes::install_github("JGCRI/rmap")
library(gcamextractor)
library(rchart)
library(rmap)
library(dplyr)

# ..............................................................................
# GCAMEXTRACTOR ----------------------------------------------------------------
# ..............................................................................
# https://jgcri.github.io/gcamextractor/articles/vignette_readgcam.html


# gcamextractor basic example
path_to_gcam_database <- "C:/gcam/gcam-v6.0-Windows-Release-Package/output/database_basexdb_ssp235"
gcamextractor::params # view available parameters
dataGCAM <- gcamextractor::readgcam(gcamdatabase = path_to_gcam_database,
                                    paramsSelect = c("pop","elecByTechTWh"),
                                    folder = "test_folder")


# View your data
df <- dataGCAM$data; df
dfParam <- dataGCAM$dataAggParam; dfParam
dfClass1 <- dataGCAM$dataAggClass1; dfClass1

# rchart
data_chart <- dfClass1 %>%
  dplyr::filter(subRegion %in% c("Argentina", "Colombia"))

charts <- rchart::chart(data_chart)
charts$chart_param_Argentina
charts$chart_param_Argentina
charts$chart_class_GCAM_SSP2

# rmap
data_map <-  dfClass1 %>%
  dplyr::filter(x %in% c(2100), param %in% c("pop"))

maps <- rmap::map(data_map)


# Get example data (dataAggClass1) from gcamextractor
View(gcamextractor::exampleDataAggClass1)

# choose a couple parameters of interest
exampleData <- dplyr::filter(gcamextractor::exampleDataAggClass1,
                             param %in% c("emissCO2BySectorNoBio",
                                          "elecByTechTWh"))


# ..............................................................................
# RCHART -----------------------------------------------------------------------
# ..............................................................................
# https://jgcri.github.io/rchart/articles/vignette_userguide.html


# ..............................................................................
# Generate a set of charts -----------------------------------------------------
# ..............................................................................
my_charts <- rchart::chart(data = exampleData,
                           chart_type = "all",
                           save = F,
                           folder = "figures")


# view line charts (parameter totals)
my_charts$chart_param_India
my_charts$chart_param_USA
my_charts$chart_region_absolute


# view bar charts (parameters by class)
my_charts$chart_class_India
my_charts$chart_class_USA
my_charts$chart_class_Reference
my_charts$chart_class_RCP_2.6


# ..............................................................................
# generate a set of charts including scenario comparison charts ----------------
# ..............................................................................

my_charts <- rchart::chart(dplyr::filter(exampleData),
                           scenRef = "Reference",
                           chart_type = "all",
                           save = F,
                           folder = "figures")


# view scenario comparison charts

# parameter totals
my_charts$chart_param_diff_absolute_India
my_charts$chart_param_diff_percent_India
my_charts$chart_param_diff_absolute_USA
my_charts$chart_param_diff_percent_USA

# by class
my_charts$chart_class_diff_absolute_India
my_charts$chart_class_diff_percent_India
my_charts$chart_class_diff_absolute_USA
my_charts$chart_class_diff_percent_USA


# waterfall charts
my_charts$chart_class_waterfall_India
my_charts$chart_class_waterfall_USA


# ..............................................................................
# Additional options -----------------------------------------------------------
# ..............................................................................


## custom palette ==============================================================

# define a custom palette
my_pal <- c("industry" = "lightgreen",
            "hydrogen" = "yellow",
            "nuclear" = "purple",
            "USA" = "orange")

# generate charts using custom palette
custom_pal_charts <- rchart::chart(data = dplyr::filter(exampleData,
                                                        param != "pop"),
                                   chart_type = "all",
                                   palette = my_pal,
                                   save = F)
# old bar charts
my_charts$chart_class_India
# new bar charts
custom_pal_charts$chart_class_India

# old line charts
my_charts$chart_region_absolute
# new line charts
custom_pal_charts$chart_region_absolute


## Add summary line to bar charts ==============================================

my_bar_chart <- rchart::chart(data = dplyr::filter(exampleData,
                                                   param != "pop"),
                              chart_type = "class_absolute",
                              save = F,
                              summary_line = T)

my_bar_chart$chart_class_USA


## Add points to line charts ===================================================
my_line_chart <- rchart::chart(data = dplyr::filter(exampleData),
                               chart_type = "param_absolute",
                               save = F,
                               include_points = T)

my_line_chart$chart_param_India


# ..............................................................................
# RMAP -------------------------------------------------------------------------
# ..............................................................................
# https://jgcri.github.io/rmap/articles/vignette_map.html


# Pre-loaded maps
#------------------------------------------
rmap::map(mapUS49)
rmap::map(mapUS52)
rmap::map(mapUS52Compact)
rmap::map(mapUS49County)
rmap::map(mapUS52County)
rmap::map(mapUS52CountyCompact)
rmap::map(mapCountries)
rmap::map(mapCountriesUS52)
rmap::map(mapGCAMReg32)
rmap::map(mapGCAMReg32US52)
rmap::map(mapGCAMBasins)
rmap::map(mapGCAMBasinsUS49)
rmap::map(mapGCAMBasinsUS52)
rmap::map(mapStates)

# Save & Show
#------------------------------------------
rmap::map(mapUS49)
rmap::map(mapUS49, save=F)
m1 <- rmap::map(mapUS49, save=F, show=F)
m1$map
class(m1$map)

# Projection
#------------------------------------------
rmap::map(mapUS49,
          crs="+proj=aeqd +lat_0=0 +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m no_defs")


# Map Find
#------------------------------------------
data = data.frame(subRegion = c("CA","FL","ID","MO","TX","WY"),
                  value = c(5,10,15,34,2,7)); data

map_chosen <- rmap::map_find(data)
map_chosen # Will give a dataframe for the chosen map
rmap::map(save=F,map_chosen)


# Format & Themes
#------------------------------------------

# Create data table with a few US states
data = data.frame(subRegion = c("CA","FL","ID","MO","TX","WY"),
                  value = c(5,10,15,34,2,7)); data

# Will choose the contiguous US map and plot this data for you as the only layer
rmap::map(save=F,data)

# Will add an underlayer of the US49 map zoomed in to your data set
rmap::map(save=F,data,
          underLayer=rmap::mapUS49)

# will add GCAM basins ontop of the previous map
rmap::map(save=F,data,
          underLayer=rmap::mapUS49,
          overLayer=rmap::mapGCAMBasinsUS49)

# Will adjust the borders of the different layers to highlight them.
rmap::map(save=F,mapUS49,
          fill = "black",
          color = "white",
          lwd = 1.5)

# Will adjust the borders of the different layers to highlight them.
rmap::map(save=F,data,
          color = "blue",
          lwd = 1.5)

# Modify the fill and outline of the different layers
# Will adjust the borders of the different layers to highlight them.
rmap::map(save=F,data,
          underLayer=rmap::mapUS49,
          underLayerFill = "black",
          underLayerColor = "green",
          underLayerLwd = 0.5,
          overLayer=rmap::mapGCAMBasinsUS49,
          overLayerColor = "red",
          overLayerLwd = 2)

# Add Blue Labels
rmap::map(save=F,data,
          labels = T,
          labelSize = 10,
          labelColor = "blue")

# Add labels with a transparent background box
rmap::map(save=F,data,
          labels = T,
          labelSize = 10,
          labelColor = "black",
          labelFill = "white",
          labelAlpha = 0.8,
          labelBorderSize = 1)

# Repel the labels out with a leader line for crowded labels
rmap::map(save=F,data=rmap::mapUS49,
          labels = T,
          labelSize = 6,
          labelColor = "black",
          labelFill = "white",
          labelAlpha = 0.8,
          labelBorderSize = 1,
          labelRepel = 1)

# UnderLayer Labels Examples
rmap::map(save=F,data,
          underLayer = rmap::mapUS49,
          underLayerLabels = T)

# OverLayer Examples
rmap::map(save=F,data,
          underLayer = rmap::mapUS49,
          overLayer = rmap::mapGCAMBasinsUS49,
          overLayerColor = "red",
          overLayerLabels = T,
          labelSize = 3,
          labelColor = "red",
          labelFill = "white",
          labelAlpha = 0.8,
          labelBorderSize = 0.1,
          labelRepel = 0)


# Crop Example
rmap::map(save=F,data,
          underLayer = rmap::mapUS49,
          underLayerLabels = T,
          labels = T,
          crop = F,
          title = "crop = F")

# Set different zoom levels
rmap::map(save=F,data,underLayer = rmap::mapUS49,zoom = 0)
rmap::map(save=F,data,underLayer = rmap::mapUS49,zoom = 3)

# Custom Subset Existing
#------------------------------------------
shapeSubset <- rmap::mapStates # Read in World States shape file
shapeSubset <- shapeSubset[shapeSubset$region %in% c("Colombia"),] # Subset the shapefile to Colombia
rmap::map(shapeSubset) # View custom shape

head(shapeSubset) # review data
unique(shapeSubset$subRegion) # Get a list of the unique subRegions

# Plot data on subset
data = data.frame(subRegion = c("Cauca","Valle del Cauca","Antioquia","Córdoba","Bolívar","Atlántico"),
                  x = c(2050,2050,2050,2050,2050,2050),
                  value = c(5,10,15,34,2,7))

rmap::map(save=F,data,
          shape = shapeSubset,
          underLayer = shapeSubset,
          crop=F) # Must rename the states column to 'subRegion'


# Subset Crop to another
#------------------------------------------
shapeSubRegions <- rmap::mapUS49County
shapeCropTo <- rmap::mapUS49
shapeCropTo <- shapeCropTo[shapeCropTo$subRegion %in% c("TX"),]
shapeCrop<- sf::st_transform(shapeCropTo,sf::st_crs(shapeSubRegions))
shapeCrop <-sf::st_as_sf(raster::crop(as(shapeSubRegions,"Spatial"),as(shapeCropTo,"Spatial")))
rmap::map(shapeCrop)

unique(shapeCrop$subRegion) # Get a list of the unique subRegions


# Plot data on subset
data = data.frame(subRegion = c("Wise_TX","Scurry_TX","Kendall_TX","Frio_TX","Hunt_TX","Austin_TX"),
                  value = c(5,10,15,34,2,7))
rmap::map(save=F,data,
          shape = shapeCrop,
          underLayer = shapeCrop,
          crop=F)



# Multi-Year
#------------------------------------------
data = data.frame(subRegion = c("Austria","Spain", "Italy", "Germany","Greece",
                                "Austria","Spain", "Italy", "Germany","Greece",
                                "Austria","Spain", "Italy", "Germany","Greece",
                                "Austria","Spain", "Italy", "Germany","Greece"),
                  year = c(rep(2025,5),
                           rep(2050,5),
                           rep(2075,5),
                           rep(2100,5)),
                  value = c(32, 38, 54, 63, 24,
                            37, 53, 23, 12, 45,
                            23, 99, 102, 85, 75,
                            12, 76, 150, 64, 90))
rmap::map(data = data,
          underLayer = rmap::mapCountries,
          ncol=4,
          background = T) -> m1;


m1$map_param_KMEANS
m1$map_param_MEAN_KMEANS


# Multi-Year DIff
#------------------------------------------
data = data.frame(subRegion = c("Austria","Spain", "Italy", "Germany","Greece",
                                "Austria","Spain", "Italy", "Germany","Greece",
                                "Austria","Spain", "Italy", "Germany","Greece"),
                  year = c(rep(2010,5),rep(2020,5),rep(2030,5)),
                  value = c(32, 38, 54, 63, 24,
                            37, 53, 23, 12, 45,
                            40, 45, 12, 50, 63))


mapx <- rmap::map(save=F,data = data,
                  background = T,
                  underLayer = rmap::mapCountries,
                  xRef = 2010,
                  xDiff = c(2020,2030))

mapx$map_param_2030_KMEANS_xDiffAbs
mapx$map_param_KMEANS_xDiffAbs
mapx$map_param_KMEANS_xDiffPrcnt


# Multi-Class
#------------------------------------------
data = data.frame(subRegion = c("Austria","Spain", "Italy", "Germany","Greece",
                                "Austria","Spain", "Italy", "Germany","Greece",
                                "Austria","Spain", "Italy", "Germany","Greece",
                                "Austria","Spain", "Italy", "Germany","Greece"),
                  class = c(rep("municipal",5),
                            rep("industry",5),
                            rep("agriculture",5),
                            rep("transport",5)),
                  value = c(32, 38, 54, 63, 24,
                            37, 53, 23, 12, 45,
                            23, 99, 102, 85, 75,
                            12, 76, 150, 64, 90))
rmap::map(save=F,data = data,
          underLayer = rmap::mapCountries,
          background = T )

rmap::map(save=F,data = data,
          underLayer = rmap::mapCountries,
          background = T, ncol=4)

rmap::map(save=F,data = data,
          underLayer = rmap::mapCountries,
          background = T, ncol=1)

# Multi-Scenario
#------------------------------------------
data = data.frame(subRegion = c("Austria","Spain", "Italy", "Germany","Greece",
                                "Austria","Spain", "Italy", "Germany","Greece",
                                "Austria","Spain", "Italy", "Germany","Greece"),
                  scenario = c("scen1","scen1","scen1","scen1","scen1",
                               "scen2","scen2","scen2","scen2","scen2",
                               "scen3","scen3","scen3","scen3","scen3"),
                  year = rep(2010,15),
                  value = c(32, 38, 54, 63, 24,
                            37, 53, 23, 12, 45,
                            40, 44, 12, 30, 99))

mapx <- rmap::map(save=F,data = data,
                  underLayer = rmap::mapCountries,
                  background = T)

mapx$map_param_KMEANS


# Multi-Scenario Class Diff
#------------------------------------------
data = data.frame(subRegion = c("Austria","Spain", "Italy", "Germany","Greece",
                                "Austria","Spain", "Italy", "Germany","Greece",
                                "Austria","Spain", "Italy", "Germany","Greece"),
                  scenario = c("scen1","scen1","scen1","scen1","scen1",
                               "scen2","scen2","scen2","scen2","scen2",
                               "scen3","scen3","scen3","scen3","scen3"),
                  value = c(32, 38, 54, 63, 24,
                            37, 53, 23, 12, 45,
                            40, 44, 12, 30, 99))
mapx <- rmap::map(save=F,data = data,
                  underLayer = rmap::mapCountries,
                  scenRef = "scen1",
                  scenDiff = c("scen2","scen3"), # Can omit this to get difference against all scenarios
                  background = T)

mapx$map_param_KMEANS_DiffAbs
mapx$map_param_KMEANS_DiffPrcnt

# Scale Range
#------------------------------------------
# For Scenario Diff plots
data = data.frame(subRegion = c("Austria","Spain", "Italy", "Germany","Greece",
                                "Austria","Spain", "Italy", "Germany","Greece"),
                  scenario = c("scen1","scen1","scen1","scen1","scen1",
                               "scen2","scen2","scen2","scen2","scen2"),
                  value = c(32, 38, 54, 63, 24,
                            37, 53, 23, 12, 45))
rmap::map(save=F, data = data,
          background = T,
          underLayer = rmap::mapCountries,
          scenRef = "scen1") -> m1

rmap::map(save=F, data = data,
          background = T,
          underLayer = rmap::mapCountries,
          scenRef = "scen1",
          scaleRange = c(30,40),
          scaleRangeDiffAbs = c(-100,100),
          scaleRangeDiffPrcnt = c(-60,60)) -> m2

m1$map_param_KMEANS
m2$map_param_KMEANS

m1$map_param_KMEANS_DiffAbs
m2$map_param_KMEANS_DiffAbs

m1$map_param_KMEANS_DiffPrcnt
m2$map_param_KMEANS_DiffPrcnt

# Color Palettes
#------------------------------------------

data = data.frame(subRegion = c("Austria","Spain", "Italy", "Germany","Greece",
                                "Austria","Spain", "Italy", "Germany","Greece"),
                  scenario = c("scen1","scen1","scen1","scen1","scen1",
                               "scen2","scen2","scen2","scen2","scen2"),
                  year = rep(2010,10),
                  value = c(32, 38, 54, 63, 24,
                            37, 53, 23, 12, 45))
rmap::map(save=F,data = data,
          underLayer = rmap::mapCountries,
          background = T,
          scenRef = "scen1",
          palette = "pal_wet",
          paletteDiff = "pal_div_BrGn") -> m1

m1$map_param_KMEANS
m1$map_param_KMEANS
m1$map_param_KMEANS_DiffAbs

# https://www.nceas.ucsb.edu/sites/default/files/2020-04/colorPaletteCheatsheet.pdf
# https://jgcri.github.io/jgcricolors/articles/vignette_examples.html

# Legends
#-------------------------------

data = data.frame(subRegion = c("Austria","Spain", "Italy", "Germany","Greece"),
                  value = c(32, 38, 54, 63, 24))

# fixed breaks
rmap::map(save=F, data = data,
          background = T,
          underLayer = rmap::mapCountries,
          legendFixedBreaks=c(30,32,1000))
# Will append 24 to these breaks because they are part of the data.

# kmeans
rmap::map(save=F, data = data,
          background = T,
          underLayer = rmap::mapCountries,
          legendType = "kmeans")

# pretty
rmap::map(save=F, data = data,
          background = T,
          underLayer = rmap::mapCountries,
          legendType = "pretty")

# continuous
rmap::map(save=F, data = data,
          background = T,
          underLayer = rmap::mapCountries,
          legendType = "continuous")

# With legendSingelValue = 38 and set to "green"
rmap::map(data = data,
          background = T,
          underLayer = rmap::mapCountries,
          legendSingleValue = 54,
          legendSingleColor = "green")



# Numeric2Cat
#------------------------------------------
library(rmap);library(jgcricolors)

jgcricolors::jgcricol()$pal_scarcityCat

# Create a list of ranges and categorical color scales for each parameter
numeric2Cat_param <- list("param1")
numeric2Cat_breaks <- list(c(-Inf, 0.1, 0.2, 0.4,Inf))
numeric2Cat_labels <- list(c(names(jgcricolors::jgcricol()$pal_scarcityCat)))
numeric2Cat_palette <- list(c("pal_scarcityCat")) # Can be a custom scale or an R brewer palette or an rmap palette
numeric2Cat_legendTextSize <- list(c(0.7))
numeric2Cat_list <-list(numeric2Cat_param = numeric2Cat_param,
                        numeric2Cat_breaks = numeric2Cat_breaks,
                        numeric2Cat_labels = numeric2Cat_labels,
                        numeric2Cat_palette = numeric2Cat_palette,
                        numeric2Cat_legendTextSize = numeric2Cat_legendTextSize); numeric2Cat_list

data = data.frame(subRegion = c("CA","AZ","TX","NH","ID","OH"),
                  x = c(2050,2050,2050,2050,2050,2050),
                  value = c(0,1,3,20,2,1),
                  param = c(rep("param1",6)))

rmap::map(save=F, data = data,
          background = T,
          underLayer = rmap::mapCountries,
          numeric2Cat_list = numeric2Cat_list)


# Comprehensive GCAM Example
#------------------------------------------

dfClass <- rmap::exampleMapDataClass %>%
  dplyr::filter(region %in% c("India","China","Pakistan"),
                param %in% c("watWithdrawBySec","pop"),
                x %in% c(2010),
                scenario %in% c("GCAM_SSP3")); dfClass

rmap::map(data = dfClass,
          background = T,
          underLayer = rmap::mapGCAMReg32,
          save=F) -> m1

m1$map_pop_KMEANS
m1$map_watWithdrawBySec_KMEANS
