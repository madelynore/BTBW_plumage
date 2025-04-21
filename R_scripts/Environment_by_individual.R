## Environment by individual

## Create environment by individual for top 4 uncorrelated variables

library(dplyr)
library(raster)
library(sp)
library(rgdal)

# extract data points from each individual's location for each environ --------
##extract for specific lat/long
btbw_samp <- read.csv(file = "~/Documents/Cornell/BTBW_geographic_coloration/BTBW_plumage/data/BTBW_whole_specimen_Image_Analysis_measurements_averaged_allpop.csv") %>% 
  dplyr::select(ID, lon, lat) %>% 
  group_by(ID) %>% 
  summarise(lon = mean(lon), lat = mean(lat))

# Bioclim -----------------------------------------------------------------

setwd("~/Documents/Cornell/Genoscape BTBW/BTBW-GEA/data_raw/environ_data/wc2.1_30s_bio/")
bioclim_files <- list.files(pattern = "wc.*")

## create a loop to make bioclim df
for (i in 1:length(bioclim_files)){
  climname <- str_extract(bioclim_files, "bio_\\d+")[i]
  bio <- raster(bioclim_files[i])
  bioclim <-raster::extract(bio,btbw_samp[,2:3],fun=mean)
  btbw_samp[[climname]] <- bioclim
  }

temp <- btbw_samp %>% 
  dplyr::select(bio_1, bio_2, bio_3, bio_4, bio_5, bio_6, bio_7, bio_8, bio_9, bio_10, bio_11,
                bio_12, bio_13, bio_14, bio_15, bio_16, bio_17, bio_18, bio_19)

cormat <- cor(temp)

length(which(cormat > abs(0.7)))
dim(cormat)

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
setwd("~/Documents/Cornell/Genoscape BTBW/BTBW-GEA/data_raw/environ_data/srtm/")
list.files()
srtm=raster("srtm.tif")
coord <- btbw_samp[,2:3]
srtm_btbw<-raster::extract(srtm,coord,fun=mean)


# NDVI --------------------------------------------------------------------
setwd("~/Documents/Cornell/Genoscape BTBW/BTBW-GEA/data_raw/environ_data/LandCover/")
list.files()
ndvi=raster("ndvimax.tif")
coord <- btbw_samp[,2:3]
ndvi_btbw<-raster::extract(ndvi,coord,fun=mean)


# surface moisture --------------------------------------------------------

setwd("~/Documents/Cornell/Genoscape BTBW/BTBW-GEA/data_raw/environ_data/Qscat_SurfaceMoisture/")
list.files()
qscat=raster("qscat.tif")
coord <- btbw_samp[,2:3]
qscat_btbw<-raster::extract(qscat,coord,fun=mean)

      
# extracting Tave08 for year prior to collection (temp during molt) -------
setwd("~/Documents/Cornell/BTBW_geographic_coloration/BTBW_plumage/")


idy <- read.csv("data/BTBW_whole_specimen_Image_Analysis_measurements_allpop_avgimg_wide.csv") %>% 
  dplyr::select(ID, Year)

idy$Year <- as.numeric(paste0(19,idy$Year))

idy$Tave08_molt <- NA

## 606619 is missing from the climateNA files for some reason, but it's the same coords as 606621, so just going to remove it and duplicate 606621 at end
id606619 <- idy[which(idy$ID == 606619),]
idy <- idy[-which(idy$ID == 606619),]
# 613610 is duplicated and one row doesn't have a year
idy <- idy[-which(idy$ID == 613610 & is.na(idy$Year)),]


# Loop through each row of the data frame
for (i in 1:nrow(idy)) {
  #pull out ID
  sample_id <- idy$ID[i]
  year <- idy$Year[i]
  
  # Calculate the Year - 1
  year_minus_1 <- year - 1
  
  # Construct the file name for the corresponding CSV
  file_name <- paste0("data_raw/climateNArdl/BTBW_specimen_coords_Year_", year_minus_1, ".csv")
  csv_data <- read.csv(file_name)
  
  # Find the row in the CSV that matches the SampleID
  Tave08 <- csv_data$Tave08[which(csv_data$ID1 == sample_id)]
  
  idy$Tave08_molt[i] <- Tave08
}

id606619$Tave08_molt <- idy$Tave08_molt[which(idy$ID == 606621)]

idy_all <- rbind(id606619, idy)

# combine all together ----------------------------------------------------
#reset wd
setwd("~/Documents/Cornell/BTBW_geographic_coloration/BTBW_plumage/")

biona <- merge(btbw_samp, climna_sum, all= T)

bionamolt <- merge(biona, idy_all, all = T)

btbw_env <- cbind(bionamolt, qscat = qscat_btbw, ndvi_M = ndvi_btbw, srtm = srtm_btbw)

write.table(btbw_env, "data/Env_by_individual_specimen_samples.txt",
            row.names = F, quote = F, col.names = T)

