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

v <- cov(temp)
diag(v)
temppca <- prcomp( ~ ., data = temp, , na.action = na.exclude, scale.=T)

biplot(temppca, cex = 0.5, las = 1) 

# Biplot for PC3 and PC4
biplot(temppca$x[,3:4], temppca$rotation[,3:4], cex = 0.5, las = 1)

cormat <- cor(temp)

length(which(cormat > abs(0.7)))
dim(cormat)

car::vif(temp)

# ClimateNA -----------------------------------------------------------------

library(climatenaR)
library(sf)

setwd("~/Documents/Cornell/Genoscape BTBW/BTBW-GEA/data_raw/environ_data/Normal_1981_2010_bioclim/")

file <- "Normal_1981_2010_Tave_sm.tif"
setwd("~/Documents/Cornell/Genoscape BTBW/BTBW-GEA/data_raw/environ_data/Normal_1981_2010_bioclim/")
list.files()
PPT_sm=raster("Normal_1981_2010_PPT_sm.tif")
PPT_sp=raster("Normal_1981_2010_PPT_sp.tif")
Tave_sm=raster("Normal_1981_2010_Tave_sm.tif")
Tave_sp=raster("Normal_1981_2010_Tave_sp.tif")

##Combine rasters into one stack
climNA=stack(PPT_sm, PPT_sp,Tave_sm, Tave_sp)

coords <- btbw_samp[,2:3]
# Convert the coordinates to a SpatialPoints object
coordwgs <- SpatialPoints(coords, proj4string = CRS("+proj=longlat +datum=WGS84"))

# Transform the coordinates to match the raster CRS (if necessary)
coordclimNAcrs <- spTransform(coordwgs, crs(PPT_sm))

# Extract values from the raster
climNA_ind <- raster::extract(x = climNA, y = coordclimNAcrs, method = "bilinear", fun = mean)

climNAind_nm <- as.data.frame(climNA_ind) %>% 
  rename(PPT_sm = bigfile...varname..1, PPT_sp = bigfile...varname..2 ,
         Tave_sm = bigfile...varname..3, Tave_sp = bigfile...varname..4)

v <- cov(climNAind_nm)
diag(v)
temppca <- prcomp( ~ ., data = climNAind_nm, , na.action = na.exclude, scale.=T)

biplot(temppca, cex = 0.5, las = 1) 

# Biplot for PC3 and PC4
biplot(temppca$x[,3:4], temppca$rotation[,3:4], cex = 0.5, las = 1)

btbw_samp <- cbind(btbw_samp, climNAind_nm)

# SRTM --------------------------------------------------------------------
setwd("~/Documents/Cornell/Genoscape BTBW/BTBW-GEA/data_raw/environ_data/srtm/")
list.files()
srtm=raster("srtm.tif")
coord <- btbw_samp[,2:3]
srtm_btbw<-raster::extract(srtm,coord,fun=mean)

btbw_samp$srtm <- srtm_btbw

#reset wd
setwd("~/Documents/Cornell/BTBW_geographic_coloration/BTBW_plumage/")

write.table(btbw_samp, "data/EnvClimNA_by_individual_specimen_samples.txt",
            row.names = F, quote = F)

