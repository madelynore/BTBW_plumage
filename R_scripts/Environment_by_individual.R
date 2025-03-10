## Environment by individual

## Create environment by individual for top 4 uncorrelated variables

library(dplyr)
library(raster)
library(sp)
library(rgdal)

# extract data points from each individual's location for each environ --------
##extract for specific lat/long
btbw_samp <- read.csv(file = "~/Documents/Cornell/BTBW geographic coloration/BTBW_plumage/data/BTBW_whole_specimen_Image_Analysis_measurements_averaged_allpop.csv") %>% 
  dplyr::select(ID, lat, lon) %>% 
  group_by(ID) %>% 
  summarise(lat = mean(lat), lon = mean(lon))

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
  dplyr::select(bio_1, bio_2, bio_3, bio_4, bio_5, bio_6, bio_7, bio_8, bio_9, bio_10, bio_11)

v <- cov(temp)
diag(v)
temppca <- prcomp( ~ ., data = temp, , na.action = na.exclude, scale.=T)

biplot(temppca, cex = 0.5, las = 1) 

# Biplot for PC3 and PC4
biplot(temppca$x[,3:4], temppca$rotation[,3:4], cex = 0.5, las = 1)




# SRTM --------------------------------------------------------------------
setwd("~/Documents/Cornell/Genoscape BTBW/BTBW-GEA/data_raw/environ_data/srtm/")
list.files()
srtm=raster("srtm.tif")

srtm_btbw<-raster::extract(srtm,btbw_samp[,2:3],fun=mean)

btbw_samp$srtm <- srtm_btbw

#reset wd
setwd("~/Documents/Cornell/BTBW geographic coloration/BTBW_plumage/")

write.table(btbw_samp, "data/Env_by_individual_specimen_samples.txt",
            row.names = F, quote = F)

