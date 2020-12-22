# convert the coordinate system from longlat to SFPC_CRS and vice versa and
# return the output as a SpatialPoints object to be used in "sfpc_extract.R"

coords_conv <- function(X, Y, projFromTo = c("l2s", "s2l","l2l","s2s")){
  
  ## set original crs and destination crs (based on the specified toCRS):
  
  if (projFromTo=="l2l" | projFromTo=="L2L" | projFromTo=="l2L" | projFromTo=="L2l"){ 
    org_crs = CRS("+proj=longlat +datum=WGS84")
    des_crs = CRS("+proj=longlat +datum=WGS84")
    
  } else if (projFromTo=="s2s" | projFromTo=="S2S" | projFromTo=="s2S" | projFromTo=="S2s"){
    org_crs = SFPC_CRS
    des_crs = SFPC_CRS
    
  } else if (projFromTo=="s2l" | projFromTo=="S2L" | projFromTo=="s2L" | projFromTo=="S2l"){
    org_crs = SFPC_CRS
    des_crs = CRS("+proj=longlat +datum=WGS84")
    
  } else {
    org_crs = CRS("+proj=longlat +datum=WGS84")
    des_crs = SFPC_CRS
  }
  
  
  ## convert from original crs to destination crs:
  
  org_xy_df <- data.frame(ID = 1:length(X), X = X, Y = Y)
  coordinates(org_xy_df) <- c("X", "Y")
  proj4string(org_xy_df) <- org_crs
  
  des_xy_df <- spTransform(org_xy_df, des_crs)
  # des_xy_df
  # des_xy_df@coords
  
  des_xy_sp = as(des_xy_df, "SpatialPoints") # just convert to SpatialPoints object rather than a SpatialPointsDataFrame object.
  # des_xy_sp
  # des_xy_sp@coords
  
  return(des_xy_sp)
  
}
