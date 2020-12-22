## R Shiny app for FLUR (Functional LUR) model results ##
## Seyed Mahmood Taghavi Shahri © 2020
## http://mahmood-taghavi.github.io/
## License: GPL version 3.

if(!require("rgdal")){install.packages("rgdal"); library(rgdal)}
if(!require("raster")){install.packages("raster"); library(raster)}

source("ui.R")
source("server.R")
source("helpers.R")

shinyApp(ui, server)
