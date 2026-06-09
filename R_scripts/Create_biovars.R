## NOTE: ClimateNAr only works on Windows

library(ClimateNAr)
library(tidyverse)

# extract data points from each individual's location for each environ --------
##extract for specific lat/long
btbw_samp <- read.table(file = "data/Env_by_individual_specimen_samples.txt")

#change first row to colnames and remove duplicated ID col
colnames(btbw_samp) <- btbw_samp[1,]
btbw_samp <- btbw_samp[-1,-41]

btbw_climna <- btbw_samp %>% 
  dplyr::select(ID1= ID, ID2 = ID, lat, lon, elevation = srtm) 

write.csv(btbw_climna, "data/BTBW_specimen_coords.csv", row.names = F)

csv <- "data/BTBW_specimen_coords.csv"
var <- c("Tave06", "Tave07", "Tave08")

period <- c(1961:1990)

clim <- ClimateNAr(inputFile = csv, periodList = period, varList = 'M', outDir = "data_raw/ClimateNArdl/")


