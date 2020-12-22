library(sp)
library(rgdal)

sfpc_extract <- function(xySFPC_CRS_sp){
  ## extract sfpc at the geo-locations of xySFPC_CRS_sp
  sfpc1atPoints = raster::extract(x=sfpc1, y=xySFPC_CRS_sp, method="simple") # method="bilinear"
  sfpc2atPoints = raster::extract(x=sfpc2, y=xySFPC_CRS_sp, method="simple") # method="bilinear"
  sfpc3atPoints = raster::extract(x=sfpc3, y=xySFPC_CRS_sp, method="simple") # method="bilinear"
  result = cbind(sfpc1atPoints,sfpc2atPoints,sfpc3atPoints) # result is a n*3 matrix, where n is length of the lat or lon
  #View(result)
  return(result)
  
}
