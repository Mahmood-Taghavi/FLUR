describe_curve <- function(fvalues, namesTime){
  minfvalues = min(fvalues)
  maxfvalues = max(fvalues)
  #cat(minfvalues, maxfvalues)
  
  index_minfvalues = which.min(fvalues)
  index_maxfvalues = which.max(fvalues)
  #cat(index_minfvalues, index_maxfvalues)
  
  name_minfvalues = namesTime[index_minfvalues]
  name_maxfvalues = namesTime[index_maxfvalues]
  #cat(name_minfvalues, name_maxfvalues)
  
  q1fvalues = quantile(fvalues,0.25)
  q2fvalues = quantile(fvalues,0.5)
  q3fvalues = quantile(fvalues,0.75)
  #cat(q1fvalues, q2fvalues, q3fvalues)
  
  avgfvalues = mean(fvalues)
  #cat("Average=", avgfvalues)
  sdfvalues = sd(fvalues)
  #cat("Standard Deviation=", sdfvalues)
  

  outlist = list(avgfvalues=avgfvalues, sdfvalues=sdfvalues,
               q1fvalues=q1fvalues, q2fvalues=q2fvalues, q3fvalues=q3fvalues,
               minfvalues=minfvalues, maxfvalues=maxfvalues,
               name_minfvalues=name_minfvalues, name_maxfvalues=name_maxfvalues,
               index_minfvalues=index_minfvalues, index_maxfvalues=index_maxfvalues
               )  
  
  return(outlist)
  
}


#fvalues = data_means
#namesTime = namesMinutes
#describe_curve (fvalues, namesTime)

#r = 21
#fvalues = data_region[,r]
#namesTime = namesQuarters
#describe_curve (fvalues, namesTime)
