calc_fvalues <- function(sfpc_values, mean_values=data_means, basis_values=data_basis){
  
  if(length(mean_values)==1) {
    dim(mean_values) = c(1,1)
    dim(basis_values) = c(1,length(basis_values))
  }
  
  nbasis = ncol(basis_values)
  
  ## define a function to be used latter with "apply" on each row of sfpc_values
  oneGeoPoint_calc_fvalues <- function(oneGeoPoint_sfpc_values){
    dim(oneGeoPoint_sfpc_values) = c(nbasis, 1)
    result = mean_values + (basis_values %*% oneGeoPoint_sfpc_values)
    return(result)
  }
  
  ## fix "apply" when sfpc_values be vector (especial case for oneGeoPoint sfpc_values)
  if(is.null(dim(sfpc_values))) dim(sfpc_values) <- c(1, nbasis)
  
  ## calculate for each row of sfpc_values using oneGeoPoint_calc_fvalues function
  allresult = apply(sfpc_values, 1, oneGeoPoint_calc_fvalues)
  
  if(is.null(dim(allresult))) dim(allresult) = c(1,1)
  
  return(allresult)
  
}
