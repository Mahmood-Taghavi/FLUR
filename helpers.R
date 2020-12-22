## R Shiny app for FLUR (Functional LUR) model results ##
## Seyed Mahmood Taghavi Shahri © 2020
## http://mahmood-taghavi.github.io/
## License: GPL version 3.

## source R codes:
source("R/load_data.R")       # load rds data files
source("R/preprocess.R")      # preprocessing data
source("R/describe_curve.R")  # function to describe a curve
source("R/coords_conv.R")     # function to convert from latlon to SFPC_CRS cordinate system
source("R/sfpc_extract.R")    # function to etract sfpc values at geo-points with SFPC_CRS cordinate system
source("R/calc_fvalues.R")    # function to calculate functional values from spfc, mean, and basis values
source("R/calc_map.R")        # function to calculate map of functional data evaluation
source("R/save_html.R")       # function to convert obj_shiny.tag to html and save it to a file
