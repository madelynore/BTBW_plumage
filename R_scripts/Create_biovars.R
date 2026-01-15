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

period <- c(1987, 1988, 1989, 1990, 1991, 1992, 1993, 1995) # 1961:1990

clim <- ClimateNAr(inputFile = csv, periodList = period, varList = 'M', outDir = "data_raw/ClimateNArdl/")


# combine data and extract climate data from molt year ------------------------------------------------------------
samp <- read.csv("data/NMNH_specimen_metadata.csv") %>% 
  dplyr::select("USNM.no.", Year, lat, lon)

years <- list.files("data_raw/climateNArdl/",full.names = T)

climname <- c("Tmin", "Tmax", "Tave", "PPT", "Rad", "RH", "CMI")
mnths <- c("08")

climvar <- paste0(rep(climname, each = length(mnths)), mnths)
selvar <- c("ID1", climvar)

molt_clim <- data.frame()

for(i in 1:nrow(samp)){
  molt_yr <- samp$Year[i]-1
  molt_allclim <- read.csv(paste0("data_raw/climateNArdl//BTBW_specimen_coords_Year_19", molt_yr, ".csv"))
  molt_selclim <- molt_allclim[which(molt_allclim$ID1 == samp$USNM.no.[i]),colnames(molt_allclim) %in% selvar]
  molt_selclim$moltYear <- molt_yr
  molt_clim <- rbind(molt_clim, molt_selclim)
}

molt_env <- merge(samp, molt_clim, by.x = "USNM.no.", by.y = "ID1") %>% 
  rename_at(vars(ends_with("08")), ~ str_c( ., "_molt")) 

write.csv(molt_env, "data/Env_by_individual_moltyear.csv", row.names = F)
