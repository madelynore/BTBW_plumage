library(gdm)
library(tidyverse)
library(viridis)


avg_img <- read.csv("data/BTBW_whole_specimen_Image_Analysis_measurements_allpop_avgimg_wide.csv")

## select only brightness for ASY males
asy <- avg_img %>% 
  filter(Age == "ASY", ID != "614283")
# lum is wrong but need to go back to source files

# combine w environment data  
env <- read.table(here("data/Env_by_individual_specimen_samples.txt"), header = T)

lum_env <- merge(asy, env) %>% 
  dplyr::select(ID, lat, lon, pop, lumMean_d, lumMean_c, lumMean_o, lumMean_t, 
                bio_10, bio_18, qscat, ndvi_M, srtm) %>% 
  na.omit()


phenoTab <- lum_env %>% 
  dplyr::select(starts_with("lumMean")) %>% 
  as.data.frame()

lumDist <- dist(phenoTab$lumMean_d, diag = T)
# Convert the distance matrix to a data frame
lumDist_df <- as.data.frame(as.matrix(lumDist))

# Add the ID column as the first column
lumDist_df <- cbind(ID = lum_env$ID, lumDist_df)


envTab <- lum_env %>% 
  dplyr::select(ID, bio_10, bio_18, qscat, ndvi_M, srtm, lat, lon,) %>% 
  as.data.frame()

gdmTab <- formatsitepair(bioData = lumDist_df, 
                         bioFormat = 3, 
                         XColumn = "lon",
                         YColumn = "lat", 
                         siteColumn = "ID", 
                         predData = envTab)

gdm.1 <- gdm(gdmTab, geo = T)
