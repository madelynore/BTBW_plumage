## Make bioclim vars

library(dismo)
library(raster)
library(tidyverse)


list.files("data_raw/monthly_bioclim/breeding")

# List all the raster files
raster_files <- list.files("data_raw/monthly_bioclim/breeding", full.names = T)

# Initialize an empty list to store the raster objects
breed_month_raster <- list()

# Loop through each file and read the raster
for (file in raster_files) {
  # Extract the name for the raster
  raster_nm <- str_extract(file, "(?<=5m_)[^.]+(?=\\.tif)")
  
  # Read the raster file
  raster_obj <- raster(file)
  
  # Add the raster to the list with the extracted name
  breed_month_raster[[raster_nm]] <- raster_obj
}

# Combine the rasters into one stack
breed_month_stack <- stack(breed_month_raster)

##extract for specific lat/long
btbw_samp <- read.csv(file = "data/BTBW_whole_specimen_Image_Analysis_measurements_averaged_allpop.csv") %>% 
  dplyr::select(ID, lon, lat) %>% 
  group_by(ID) %>% 
  summarise(lon = mean(lon), lat = mean(lat))

breedmonth_btbw <-raster::extract(breed_month_stack,btbw_samp[,2:3],fun=mean)

vars <- colnames(breedmonth_btbw)

# summarize across years for precip ---------------------------------------

precipcols <- c(grep(vars, pattern = "prec.*05"),
                grep(vars, pattern = "prec.*06"),
                grep(vars, pattern = "prec.*07"),
                grep(vars, pattern = "prec.*08"))

precip_btbw <- as.data.frame(breedmonth_btbw[,precipcols]) %>% 
  cbind(btbw_samp[,1])

# Reshape the data frame to long format
precip_long <- precip_btbw %>%
  pivot_longer(cols = -ID , names_to = "variable", values_to = "precip")

# Extract year and month from the variable column
precip_long <- precip_long %>%
  mutate(
    year = as.numeric(str_extract(variable, "(?<=prec_)[0-9]{4}")),
    month = as.numeric(str_extract(variable, "(?<=\\.)[0-9]{2}"))
  ) %>%
  dplyr::select(ID, year, month, precip)

monthly_precip_btbw <- precip_long %>% 
  group_by(ID, month) %>% 
  summarise(precip = mean(precip))

# Pivot the data frame to wide format
precip_wide <- monthly_precip_btbw %>%
  pivot_wider(names_from = month, values_from = precip, names_prefix = "precip_1987-1996_0")


# summarize across years for tmax ---------------------------------------

tmaxcol <- c(grep(vars, pattern = "tmax.*05"),
             grep(vars, pattern = "tmax.*06"),
             grep(vars, pattern = "tmax.*07"),
             grep(vars, pattern = "tmax.*08"))

tmax_btbw <- as.data.frame(breedmonth_btbw[,tmaxcol]) %>% 
  cbind(btbw_samp[,1])

# Reshape the data frame to long format
tmax_long <- tmax_btbw %>%
  pivot_longer(cols = -ID , names_to = "variable", values_to = "tmax")

# Extract year and month from the variable column
tmax_long <- tmax_long %>%
  mutate(
    year = as.numeric(str_extract(variable, "(?<=prec_)[0-9]{4}")),
    month = as.numeric(str_extract(variable, "(?<=\\.)[0-9]{2}"))
  ) %>%
  dplyr::select(ID, year, month, tmax)

monthly_tmax_btbw <- tmax_long %>% 
  group_by(ID, month) %>% 
  summarise(tmax = mean(tmax))

# Pivot the data frame to wide format
tmax_wide <- monthly_tmax_btbw %>%
  pivot_wider(names_from = month, values_from = tmax, names_prefix = "t_max_1987-1996_0")

# summarize across years for tmin ---------------------------------------

tmincol <- c(grep(vars, pattern = "tmin.*05"), 
          grep(vars, pattern = "tmin.*06"),
          grep(vars, pattern = "tmin.*07"),
          grep(vars, pattern = "tmin.*08") )


tmin_btbw <- as.data.frame(breedmonth_btbw[,tmincol]) %>% 
  cbind(btbw_samp[,1])

# Reshape the data frame to long format
tmin_long <- tmin_btbw %>%
  pivot_longer(cols = -ID , names_to = "variable", values_to = "tmin")

# Extract year and month from the variable column
tmin_long <- tmin_long %>%
  mutate(
    year = as.numeric(str_extract(variable, "(?<=prec_)[0-9]{4}")),
    month = as.numeric(str_extract(variable, "(?<=\\.)[0-9]{2}"))
  ) %>%
  dplyr::select(ID, year, month, tmin)

monthly_tmin_btbw <- tmin_long %>% 
  group_by(ID, month) %>% 
  summarise(tmin = mean(tmin))

# Pivot the data frame to wide format
tmin_wide <- monthly_tmin_btbw %>%
  pivot_wider(names_from = month, values_from = tmin, names_prefix = "tmin_1987-1996_0")


## recombine into one df

preciptmax <- merge(precip_wide, tmax_wide)

ptmaxtmin <- merge(preciptmax, tmin_wide)

bioclims <- biovars(precip_wide, tmax_wide, tmin_wide)
