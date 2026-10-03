## Environment by individual

## Create environment by individual for top 4 uncorrelated variables

library(dplyr)
library(raster)
library(sp)

# extract data points from each individual's location for each environ --------
##extract for specific lat/long
btbw_samp <- read.csv(file = "data/BTBW_whole_specimen_Image_Analysis_measurements_averaged_allpop.csv") %>% 
  dplyr::select(ID, lon, lat) %>% 
  group_by(ID) %>% 
  summarise(lon = mean(lon), lat = mean(lat))


# ClimateNA -----------------------------------------------------------------

library(sf)

setwd("~/Documents/Cornell/BTBW_geographic_coloration/BTBW_plumage/data_raw/monthly_bioclim_normal_1971_2000/")

#load in one file for CRS
PPT06 <- raster("PPT06.tif")
coords <- btbw_samp[,2:3]
# Convert the coordinates to a SpatialPoints object
coordwgs <- SpatialPoints(coords, proj4string = CRS("+proj=longlat +datum=WGS84"))

# Transform the coordinates to match the raster CRS (if necessary)
coordclimNAcrs <- spTransform(coordwgs, crs(PPT06))

#make list of all climna files
climna_files <- list.files(pattern = "")

## create a loop to make climNA df
for (i in 1:length(climna_files)){
  climname <- sub(climna_files, pattern=".tif", replacement = "")[i]
  clim <- raster(climna_files[i])
  climNA <- raster::extract(x = clim, y = coordclimNAcrs, method = "bilinear", fun = mean)
  btbw_samp[[climname]] <- climNA
}


climna_sum <- btbw_samp %>%
  group_by(ID) %>%
  summarise(
    PPT_br = mean(c_across(starts_with("PPT")), na.rm = TRUE),
    Rad_br = mean(c_across(starts_with("Rad")), na.rm = TRUE),
    RH_br = mean(c_across(starts_with("RH")), na.rm = TRUE),
    Tave_br = mean(c_across(starts_with("Tave")), na.rm = TRUE),
    Tmax_br = max(c_across(starts_with("Tmax")), na.rm = TRUE),
    Tmin_br = min(c_across(starts_with("Tmin")), na.rm = TRUE)
  )


# SRTM --------------------------------------------------------------------
list.files(path = "~/Documents/Cornell/Genoscape BTBW/BTBW-GEA/data_raw/environ_data/srtm/")
srtm=raster("~/Documents/Cornell/Genoscape BTBW/BTBW-GEA/data_raw/environ_data/srtm/srtm.tif")
coord <- btbw_samp[,2:3]
srtm_btbw<-raster::extract(srtm,coord,fun=mean)


# NDVI --------------------------------------------------------------------
list.files("~/Documents/Cornell/Genoscape BTBW/BTBW-GEA/data_raw/environ_data/LandCover/")
ndvi=raster("~/Documents/Cornell/Genoscape BTBW/BTBW-GEA/data_raw/environ_data/LandCover/ndvimax.tif")
coord <- btbw_samp[,2:3]
ndvi_btbw<-raster::extract(ndvi,coord,fun=mean)


# combine all together ----------------------------------------------------
#reset wd
setwd("~/Documents/Cornell/BTBW_geographic_coloration/BTBW_plumage/")

biona <- merge(btbw_samp, climna_sum, all= T)

btbw_env <- cbind(biona, ndvi_M = ndvi_btbw, srtm = srtm_btbw)

write.table(btbw_env, "data/Env_by_individual_specimen_samples.txt",
            row.names = F, quote = F, col.names = T)

