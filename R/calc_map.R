calc_map <- function(oneTimePoint_mean, oneTimePoint_basis, oneTimePoint_QL_lower, oneTimePoint_QL_upper, useLatLon=FALSE){

  n_row = sfpc1@nrows
  n_col = sfpc1@ncols

  
  map_values = matrix(oneTimePoint_mean, nrow=n_row, ncol=n_col)
  
  
  map_values = map_values + oneTimePoint_basis[1] * raster::as.matrix(sfpc1)
  
  map_values = map_values + oneTimePoint_basis[2] * raster::as.matrix(sfpc2)
  
  map_values = map_values + oneTimePoint_basis[3] * raster::as.matrix(sfpc3)
  
  
  map_values[map_values < oneTimePoint_QL_lower] = oneTimePoint_QL_lower
  
  map_values[map_values > oneTimePoint_QL_upper] = oneTimePoint_QL_upper
  
  
  map_values = raster(x=map_values,
                      xmn=sfpc1@extent@xmin,
                      xmx=sfpc1@extent@xmax,
                      ymn=sfpc1@extent@ymin,
                      ymx=sfpc1@extent@ymax,
                      crs=sfpc1@crs
                      )
  
  if(useLatLon){ # convert map coordinate system to lat lon
    # fix xmin, xmax, ymin, ymax, and cell size and crs:
    
    
  }

  return(map_values)
  
}
