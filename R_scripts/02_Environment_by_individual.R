## Environment by individual

## Create environment by individual for top 4 uncorrelated variables

library(dplyr)
library(raster)
library(sp)

# extract data points from each individual's location for each environ --------
##extract for specific lat/long
btbw_samp <- read.csv(file = "data/photos/BTBW_whole_specimen_Image_Analysis_measurements_averaged_allpop.csv") %>% 
  dplyr::select(ID, lon, lat) %>% 
  group_by(ID) %>% 
  summarise(lon = mean(lon), lat = mean(lat))


# ClimateNA -----------------------------------------------------------------

library(sf)

setwd("~/Documents/Work/PhD/BTBW_geographic_coloration/BTBW_plumage/data_raw/environment/monthly_bioclim_normal_1971_2000/")

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
list.files(path = "~/Documents/Work/PhD/Genoscape BTBW/BTBW-GEA/data_raw/environ_data/srtm/")
srtm=raster("~/Documents/Work/PhD/Genoscape BTBW/BTBW-GEA/data_raw/environ_data/srtm/srtm.tif")
coord <- btbw_samp[,2:3]
srtm_btbw<-raster::extract(srtm,coord,fun=mean)


# NDVI --------------------------------------------------------------------
list.files("~/Documents/Work/PhD/Genoscape BTBW/BTBW-GEA/data_raw/environ_data/LandCover/")
ndvi=raster("~/Documents/Work/PhD/Genoscape BTBW/BTBW-GEA/data_raw/environ_data/LandCover/ndvimax.tif")
coord <- btbw_samp[,2:3]
ndvi_btbw<-raster::extract(ndvi,coord,fun=mean)


# combine all together ----------------------------------------------------
#reset wd
setwd("~/Documents/Work/PhD/BTBW_geographic_coloration/BTBW_plumage/")

biona <- merge(btbw_samp, climna_sum, all= T)

btbw_env <- cbind(biona, ndvi_M = ndvi_btbw, srtm = srtm_btbw)

write.table(btbw_env, "data/environment/Env_by_individual_specimen_samples.txt",
            row.names = F, quote = F, col.names = T)



# relationship between env and latitude at site level ---------------------
# add site level info and summarize to avoid inflated n, since many individuals have very similar latitudes
pop_info <- read.csv("data/specimens/NMNH_specimen_metadata.csv") |>
  dplyr::select(USNM.no., pop)

# one row per site: mean latitude and environment of the birds collected there
envbysite <- btbw_env |>
  left_join(pop_info, by = join_by("ID" == "USNM.no.")) |>
  group_by(pop) |>
  summarize(lat = mean(lat),
            Tave_br = mean(Tave_br),
            PPT_br = mean(PPT_br),
            RH_br = mean(RH_br),
            ndvi_M = mean(ndvi_M),
            srtm = mean(srtm))
stopifnot("Some birds have no site" = !anyNA(envbysite$pop))

# chosen env variables
env_vars <- c("Tave_br", "PPT_br", "RH_br", "ndvi_M", "srtm")

# linear model of each environmental variable on latitude, site level
env_table <- list()
for (v in env_vars) {
  model <- lm(as.formula(paste(v, "~ lat")), data = envbysite)
  fit   <- summary(model)
  env_table[[v]] <- data.frame(
    Trait     = v,
    n_sites   = nrow(envbysite),
    Estimate  = fit$coefficients["lat", "Estimate"],
    SE        = fit$coefficients["lat", "Std. Error"],
    df        = fit$df[2],
    P_value   = fit$coefficients["lat", "Pr(>|t|)"],
    R2_adj    = fit$adj.r.squared)
}
env_table <- dplyr::bind_rows(env_table)
source(here::here("R_scripts/table_helpers.R"))   # fmt_p(), fmt_num()

env_table <- dplyr::bind_rows(env_table) |>
  dplyr::mutate(P_value  = fmt_p(P_value),
                Estimate = fmt_num(Estimate),
                SE       = fmt_num(SE),
                R2_adj   = fmt_num(R2_adj))
env_table