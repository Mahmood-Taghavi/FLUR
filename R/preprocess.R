## extract region_regnames and region_colnames from region_nameInfo:
region_regnames = region_nameInfo[,"region_regnames"]
# print(region_regnames)
region_colnames = region_nameInfo[,"region_colnames"]
# print(region_colnames)
rm(region_nameInfo)


## make seqQuarters and namesQuarters for one day per hours' quarters
seqQuarters =   1:96
timeQuarters = rep(NA, length(seqQuarters))
namesQuarters = rep(NA, length(seqQuarters))
counter = 1
for(h in 0:23) for(m in c(0,15,30,45)){
  timeQuarters[counter] = h + (m/60)
  strH = as.character(h); if(h<10) strH=paste("0", strH, sep="")
  strM = as.character(m); if(m<10) strM=paste("0", strM, sep="")
  namesQuarters[counter] = paste(strH, strM, sep=":")
  counter = counter + 1
}
# View(cbind(seqQuarters, timeQuarters, namesQuarters))
rm(counter, h, m, strH, strM)


## make seqMinutes and namesMinutes for one day per hours and minutes
seqMinutes = 1:1440
timeMinutes = rep(NA, length(seqMinutes))
namesMinutes = rep(NA, length(seqMinutes))
counter = 1
for(h in 0:23) for(m in 0:59){
  timeMinutes[counter] = h + (m/60)
  strH = as.character(h); if(h<10) strH=paste("0", strH, sep="")
  strM = as.character(m); if(m<10) strM=paste("0", strM, sep="")
  namesMinutes[counter] = paste(strH, strM, sep=":")
  counter = counter + 1
}
# View(cbind(seqMinutes, timeMinutes, namesMinutes))
rm(counter, h, m, strH, strM)





## extract estimation scale from string value of sfpc_dir variable
est_scale = "50 meters"
# if (sfpc_dir=="SFPC_05m" | sfpc_dir=="SFPC_5m"){
#   est_scale = "5 meters"
# } else if (sfpc_dir=="SFPC_10m"){
#   est_scale = "10 meters"
# } else if (sfpc_dir=="SFPC_15m"){
#   est_scale = "15 meters"
# } else if (sfpc_dir=="SFPC_20m"){
#   est_scale = "20 meters"
# } else if (sfpc_dir=="SFPC_30m"){
#   est_scale = "30 meters"
# } else if (sfpc_dir=="SFPC_50m"){
#   est_scale = "50 meters"
# } else {
#   est_scale = "X meters"
# }

#headerLabel = "Functional LUR model for spatial estimation of long-term PM2.5 in the mega-city of Tehran. Estimation Scale:"
headerLabel = "Spatial Estimation of long-term PM2.5 Diurnal Variation Curves in Tehran using FLUR model. Scale:"
headerText = '$(document).ready(function() {$("header").find("nav").append(\'<span class="myClass"> Text Here </span>\');})'
headerText = gsub('Text Here', paste(headerLabel, est_scale), headerText)

