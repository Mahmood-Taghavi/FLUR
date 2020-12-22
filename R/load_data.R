data_basis = readRDS("data/basis_AtMinutes.rds")
data_means = readRDS("data/means_AtMinutes.rds")

QL_lower = readRDS("data/QL_lower_AtMinutes.rds")
QL_upper = readRDS("data/QL_upper_AtMinutes.rds")

data_q1 = readRDS("data/quartile1_AtMinutes.rds")
data_q2 = readRDS("data/quartile2_AtMinutes.rds")
data_q3 = readRDS("data/quartile3_AtMinutes.rds")

data_region = readRDS("data/region_AtQuarters.rds")
region_nameInfo = readRDS("data/region_nameInfo.rds")

round_digits = readRDS("data/round_digits.rds")

SFPC_CRS = readRDS("data/SFPC_CRS.rds")

sfpc_dir = "SFPC_50m"

library(raster)
sfpc1 = raster(paste("data", sfpc_dir, "SFPC#1.asc", sep="/"))
sfpc2 = raster(paste("data", sfpc_dir, "SFPC#2.asc", sep="/"))
sfpc3 = raster(paste("data", sfpc_dir, "SFPC#3.asc", sep="/"))
