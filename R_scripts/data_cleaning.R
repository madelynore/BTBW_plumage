##Data cleaning for plumage project

# combining banding records for 2021 and 2022 -----------------------------
library(tidyverse)

bw2021 <- readxl::read_xlsx(path =  "data_raw/BTBW_banding_record.xlsx")

bw2022 <- readxl::read_xlsx(path =  "data_raw/2022_banding_record.xlsx")

## fix column names, so they don't have `` and match each other
colnames(bw2021)
bw2021_rn <- bw2021 %>% 
  #  columns that dont need changing    "Date"           "Species"        "Locality"         
 # "Age"            "Sex"             "Bander"
  rename(USGS_band = `USGS Band`, GPS_N = `GPS N`, GPS_E = `GPS E`, tissue_type = `Tissue Sampled`)

colnames(bw2022)
bw2022_rn <- bw2022 %>% 
  rename(USGS_band = `Aluminum Band`, GPS_E = UTM_Easting, GPS_N = UTM_Northing,
         Count_State = `County and State/Province`, Date = `Date Banded`, Bander = Banders,
         Bill_depth = `Bill Depth`,Bill_length_culmen = `Bill Length_culmen`,
         Bill_length_nares = `Bill Length_nares`, Bill_width = `Bill Width`,
         Wing_L = `Wing LEFT`,Wing_R = `Wing RIGHT`)
  ### columns that dont need changing "Species" "Age" "Sex"              
  ## "Bled?" ""Fat" "Tail" "Tarsus" Notes"    

band_record <- merge(bw2021_rn, bw2022_rn, by = intersect(names(bw2021_rn), names(bw2022_rn)),
      all = T)

write.csv(band_record, "data/BTBW_banding_record_2021_22.csv", row.names = F)


# specimen metadata -------------------------------------------------------


library(tidyverse)

specimen <- read.csv("data_raw/NMNH_specimen_data_from_Box.csv")

#sort the final DataFrame by ID for better readability
specimen_sort <- specimen %>%
  arrange(USNM.no., GRG.no.)

## check that each row is a unique ID
# Count entries per USNM.no.
entries_per_usnm <- specimen_sort %>%
  group_by(USNM.no.) %>%
  summarise(Entries = n(), .groups = 'drop')

# Check for any USNM.no. with more than one entry
duplicates <- filter(entries_per_usnm, Entries > 1)

# Print duplicates, if any
print(duplicates)

#fix wrong ID in metadata -  618610 doesn't even exist
specimen_sort$USNM.no.[which(specimen_sort$USNM.no. == "618610")] <- "613610"

#add age to missing age class - aged via photos
specimen_sort$Age[which(specimen_sort$USNM.no. == "608329")] <- "ASY"
specimen_sort$Age[which(specimen_sort$USNM.no. == "608328")] <- "SY"

## combining USNM data with lat/lon from GEA

meta <- read.csv("~/Documents/Cornell/Genoscape BTBW/BTBW-GEA/data/Genoscape_locations.csv") %>% 
  dplyr::select(USNM, pop, Region, lat, lon)

specimen_latlon <- merge(specimen_sort, meta, by.x = "USNM.no.", by.y = "USNM", all.x = T, all.y = F)


###adding in lat/lon for those missing
nocoords <- specimen_latlon[is.na(specimen_latlon$lat),]

## removing them from df
coords <- anti_join(specimen_latlon, nocoords, by = c("USNM.no.", "GRG.no."))


## manually adding lat lon based on locality
unique(nocoords$Locality)

nocoords$lat[which(nocoords$Locality == "Jefferson Nat'l Forest, 4mi SE Norton, Bark Camp Branch; 920m")] <- 36.879
nocoords$lon[which(nocoords$Locality == "Jefferson Nat'l Forest, 4mi SE Norton, Bark Camp Branch; 920m")] <- -82.574

nocoords$lat[which(nocoords$Locality == "Old Tyrone Pike, 0.6mi N Mountain Road above Bright Run; 560m")] <- 40.761
nocoords$lon[which(nocoords$Locality == "Old Tyrone Pike, 0.6mi N Mountain Road above Bright Run; 560m")] <- -78.204

nocoords$lat[which(nocoords$Locality == "Old Tyrone Pike, 0.95mi N Mountain Road above Bright Run; 610m")] <- 40.764
nocoords$lon[which(nocoords$Locality == "Old Tyrone Pike, 0.95mi N Mountain Road above Bright Run; 610m")] <- -78.198

nocoords$lat[which(nocoords$Locality == "Nicolet Nat'l Forest, North Branch Pine River on FS Rd 2174; 505m")] <- 45.929
nocoords$lon[which(nocoords$Locality == "Nicolet Nat'l Forest, North Branch Pine River on FS Rd 2174; 505m")] <- -88.861

nocoords$lat[which(nocoords$Locality == "Frenchtown Township; 2 mi SE Kokadjo on S. shore First Roach Lake")] <- 45.617
nocoords$lon[which(nocoords$Locality == "Frenchtown Township; 2 mi SE Kokadjo on S. shore First Roach Lake")] <- -69.332

nocoords$lat[which(nocoords$Locality ==  "Frenchtown Township; 5.5 mi ESE Kokadjo on S. shore First Roach Lake")] <- 45.617
nocoords$lon[which(nocoords$Locality ==  "Frenchtown Township; 5.5 mi ESE Kokadjo on S. shore First Roach Lake")] <- -69.332

nocoords$lat[which(nocoords$Locality ==  "Frenchtown Township; east end First Roach Lake")] <- 45.617
nocoords$lon[which(nocoords$Locality ==  "Frenchtown Township; east end First Roach Lake")] <- -69.332

nocoords$lat[which(nocoords$Locality ==  "Beaver Cave Township, east end of Beaver Cove of Moosehead Lake")] <- 45.54339
nocoords$lon[which(nocoords$Locality ==  "Beaver Cave Township, east end of Beaver Cove of Moosehead Lake")] <- -69.54654

nocoords$lat[which(nocoords$Locality ==  "State Game Lands No. 33, 2.2 mi W Hwy 322 On Sandy Ridge Road")] <- 40.83201
nocoords$lon[which(nocoords$Locality ==  "State Game Lands No. 33, 2.2 mi W Hwy 322 On Sandy Ridge Road")] <- -78.14412

nocoords$lat[which(nocoords$Locality ==  "State Game Lands No. 33, 3.6 mi W Hwy 322 On Sandy Ridge Road")] <- 40.83201
nocoords$lon[which(nocoords$Locality ==  "State Game Lands No. 33, 3.6 mi W Hwy 322 On Sandy Ridge Road")] <- -78.14412

nocoords$lat[which(nocoords$Locality ==  "1.5mi NE Lyman Lake on Rock Run Rd., Susquehannock State Forest; 650m" )] <- 41.72457
nocoords$lon[which(nocoords$Locality ==  "1.5mi NE Lyman Lake on Rock Run Rd., Susquehannock State Forest; 650m" )] <- -77.75484

nocoords$lat[which(nocoords$Locality ==  "SE Flank of Fawn Lake Mountain, Adirondack State Park; 650m" )] <- 43.71678
nocoords$lon[which(nocoords$Locality ==  "SE Flank of Fawn Lake Mountain, Adirondack State Park; 650m" )] <- -74.75517

nocoords$lat[which(nocoords$Locality ==  "ca 9mi SW Davis on Red Run (10.5mi W Hwy 32 on Forest Service Road 13), Monongahela Nat'l Forest; 1000m")] <- 39.06175
nocoords$lon[which(nocoords$Locality ==  "ca 9mi SW Davis on Red Run (10.5mi W Hwy 32 on Forest Service Road 13), Monongahela Nat'l Forest; 1000m")] <- -79.51135

nocoords$lat[which(nocoords$Locality ==  "ca 9mi SW Davis on Red Run (10mi W Hwy 32 on Forest Service Road 13), Monongahela Nat'l Forest; 990m" )] <- 39.06175
nocoords$lon[which(nocoords$Locality ==  "ca 9mi SW Davis on Red Run (10mi W Hwy 32 on Forest Service Road 13), Monongahela Nat'l Forest; 990m" )] <- -79.51135

nocoords$lat[which(nocoords$Locality ==  "E. Fork Chattooga River at Hwy 107; Sumter Nat'l Forest; 885m" )] <- 35.00284
nocoords$lon[which(nocoords$Locality ==  "E. Fork Chattooga River at Hwy 107; Sumter Nat'l Forest; 885m" )] <- -83.05467

nocoords$lat[which(nocoords$Locality == "E. Fork Chattooga River at Hwy 107; Sumter Nat'l Forest; 880m" )] <- 35.00284
nocoords$lon[which(nocoords$Locality == "E. Fork Chattooga River at Hwy 107; Sumter Nat'l Forest; 880m" )] <- -83.05467

nocoords$lat[which(nocoords$Locality == "George Creek, 1mi S Ripshin Lake, Cherokee Nat'l Forest; 1100m" )] <- 36.16526
nocoords$lon[which(nocoords$Locality == "George Creek, 1mi S Ripshin Lake, Cherokee Nat'l Forest; 1100m" )] <- -82.13095

nocoords$lat[which(nocoords$Locality == "George Creek, 1mi SE Ripshin Lake, Cherokee Nat'l Forest; 1090m" )] <- 36.16526
nocoords$lon[which(nocoords$Locality == "George Creek, 1mi SE Ripshin Lake, Cherokee Nat'l Forest; 1090m" )] <- -82.13095

nocoords$lat[which(nocoords$Locality == "Right prong Rock Creek; 4mi SE Erwin, Cherokee Nat'l Forest; 960m")] <- 36.13790
nocoords$lon[which(nocoords$Locality == "Right prong Rock Creek; 4mi SE Erwin, Cherokee Nat'l Forest; 960m")] <- -82.35464

nocoords$lat[which(nocoords$Locality == "Ottawa Nat'l Forest; 0.5mi NE Killdeer Ave on FS Rd 3346")] <- 46.35368
nocoords$lon[which(nocoords$Locality == "Ottawa Nat'l Forest; 0.5mi NE Killdeer Ave on FS Rd 3346")] <- -88.95335

nocoords$lat[which(nocoords$Locality == "Ottawa Nat'l Forest; 0.5mi E Bela Lake on FS rd 3614" )] <- 46.37799
nocoords$lon[which(nocoords$Locality == "Ottawa Nat'l Forest; 0.5mi E Bela Lake on FS rd 3614" )] <- -88.91712

## create populations for this group
nocoords$pop <- paste0(nocoords$State.Province, ".", nocoords$County)

## add region for this group
nocoords$Region[which(nocoords$State.Province == "VA" | nocoords$State.Province == "SC" |
                        nocoords$State.Province == "TN" | nocoords$State.Province == "VA" )] <- "South"

nocoords$Region[which(nocoords$State.Province == "PA" | nocoords$State.Province == "WV"  )] <- "Central"

nocoords$Region[which(nocoords$State.Province == "NY")] <- "North Central"

nocoords$Region[which(nocoords$State.Province == "MI" | nocoords$State.Province == "WI")] <- "North West"

nocoords$Region[which(nocoords$State.Province == "ME")] <- "North East"


specimen_coords <- bind_rows(coords, nocoords)

# check no missing coords or population info
which(is.na(specimen_coords$lat))

which(is.na(specimen_coords$pop))

which(is.na(specimen_coords$Region))

## manually fix York NB coords for 614261 
specimen_coords$lat[which(specimen_coords$USNM.no. == "614261")] <- 45.794
specimen_coords$lon[which(specimen_coords$USNM.no. == "614261")] <- -66.854

## add tarsus measurements
tarsus <- read.csv("data_raw/Tarsometatarsus.csv") %>% 
  dplyr::select(USNM.no., Tarsometatarsus)

specimen_tar <- merge(specimen_coords, tarsus, all.x = T)

## make column for Year
specimen_yr <- specimen_tar %>% 
  separate(date.d.m.y, into = c("Day", "Month", "Year"), sep = "-", remove = F)

write.csv(specimen_yr, "data/NMNH_specimen_metadata.csv", row.names = F) 

# cleaning raw output from micatoolbox ------------------------------------

library(tidyverse)

# Initialize an empty dataframe
allimg <- data.frame()

# Load file names
imgfiles <- list.files(path = "data_raw/by_pop_batch_mspec/", pattern = "*Image*")

# Loop through each file
for (i in 1:length(imgfiles)) {
  imgnm <- paste0("data_raw/by_pop_batch_mspec/", imgfiles[i])
  
  # Read in file
  img <- read.csv(file = imgnm)
  
  # Change label to more informative labels
  img_ID <- img %>% 
    separate(Label, into = c("ID", "photo", "plumage_patch"), sep = "_")
  
  # Separate plumage patch from replicate
  img_plid <- img_ID %>% 
    separate(plumage_patch, into = c("pl_code", "rep"), sep = "(?<=[A-Za-z])(?=[0-9])") 
  
  # Bind to the dataframe
  allimg <- rbind(allimg, img_plid)
}

# Print the dataframe
print(allimg)

#confirm number IDs -should be ~187
length(unique(allimg$ID))

## clean up some things from this dataframe
#remove scalebar calculations and "whole"
# whole was for the comparison between taking 3 square subsets versus the whole area
notplrows <- c(grep(allimg$pl_code, pattern = "Scale Bar.*"), grep(allimg$pl_code, pattern = "whole.*"))

allimg_rmnotpl_code <- allimg[-notplrows,]

allimg_rmrow <- subset(allimg_rmnotpl_code, select = -X)

#fixing wrong plcodes
# mantle is the only plumage patch measured on the dorsal surface, so fixing the 'b's because they are just genuine errors and 
# replacing the d because in the manuscript we opted to use "mantle" to describe the plumage patch
allimg_rmrow$pl_code[which(allimg_rmrow$photo == "dorsal")] <-  "m"

allimg_rmrow$pl_code[which(allimg_rmrow$photo == "crown" & allimg_rmrow$pl_code != "c")] <- "c"


#calculating mm2 area - standardized to 36.5px/mm
allimg_rmrow$area_mm2 <- allimg_rmrow$area/(36.5^2)

#removing belly measurements because of potential contamination of specimens makes measurements unreliable
allimg_rmb <- allimg_rmrow |> 
  filter(pl_code != "b")

## add metadata
meta <- read.csv("data/NMNH_specimen_metadata.csv") 

#merging WI forest into the rest
meta$pop[which(meta$pop == "WI.Forest")] <-  "WI.All"

allimg_meta <-  merge(allimg_rmb, meta, by.x = "ID", by.y = "USNM.no.", all.x = T, all.y = T)

# check if IDs missing metadata
unique(allimg_meta$ID[which(is.na(allimg_meta$pop))])
unique(allimg_meta$ID[which(is.na(allimg_meta$lat))])

write.csv(allimg_meta, "data/BTBW_whole_specimen_Image_Analysis_measurements_raw_allpop.csv", row.names = F)

allimg_meta <- read.csv("data/BTBW_whole_specimen_Image_Analysis_measurements_raw_allpop.csv")
avg_img <- allimg_rmb %>%
  group_by(ID, pl_code) %>%
  summarise(
    across(
      c(lumMean, lumSD, lwMean, lwSD,
        mwMean, mwSD, swMean, swSD, uvMean, uvSD, dblMean, dblSD, area_mm2),
      ~ mean(.x, na.rm = TRUE)  # Calculate the mean, ignoring NA values
    )
  )

avgimg_meta <-  merge(avg_img, meta, by.x = "ID", by.y = "USNM.no.", all.x = T, all.y = T)

write.csv(avgimg_meta, "data/BTBW_whole_specimen_Image_Analysis_measurements_averaged_allpop.csv", row.names = F)
avgimg_meta <- read.csv("data/BTBW_whole_specimen_Image_Analysis_measurements_averaged_allpop.csv")

avgimg_wide <- avg_img %>% 
  pivot_wider(names_from = pl_code, values_from = c(lumMean, lumSD,
                                                    lwMean, lwSD, mwMean, mwSD,
                                                    swMean, swSD,
                                                    uvMean, uvSD,
                                                    dblMean, dblSD, area_mm2), names_sep = "_" )

avgimg_widemeta <-  merge(avgimg_wide, meta, by.x = "ID", by.y = "USNM.no.", all.x = T, all.y = T)

write.csv(avgimg_widemeta, "data/BTBW_whole_specimen_Image_Analysis_measurements_allpop_avgimg_wide.csv", row.names = F)



# make fam file for GWAS --------------------------------------------------
library(tidyverse)

#read in fam file
fam <- read.table("data_raw/BTBW_wgs_ds2x_mergedthenfiltered_maxmiss0.8_minQ30_maf.05_rmrelatedind5_impute4.1_GWAS_bed.fam")
# make column with just IDs
fam_id <- fam %>% 
  separate(V2, into = c("V2", NA), sep = "_", remove = F )

#get phenotype data
img_wide <- read.csv("data/BTBW_whole_specimen_Image_Analysis_measurements_allpop_avgimg_wide.csv")

#match ID
img_wide$ID <- paste0("Z",img_wide$ID)

#merge the two dfs
# phenotype = mean mantle luminance (double-cone catch)
fam_img <- merge(fam_id, img_wide, by.x = "V2", by.y = "ID", all.x = F, all.y = F) %>% 
  dplyr::select(V1, V2, Age, V4, V5, lumMean_m)

head(fam_img)

fam_img_noNA <- fam_img %>%
  filter(!(is.na(fam_img$lumMean_m)))

# permuted phenotype for a null GWAS; seed so the permutation can be reproduced
set.seed(20260929)
fam_img_noNA$rand_m <- sample(fam_img_noNA$lumMean_m)

famcol <- colnames(fam_img_noNA)

# select only the ASY
asyfam <- fam_img_noNA %>% 
  filter(Age == "ASY") 

write.table(asyfam, 
            "data/BTBW_n95_ASY_forGWAS_lumMean_m_rand.fam",
            quote = F, col.names = F, row.names = F)


# clean up keratin table --------------------------------------------------
library(tidyverse)

kgenes <- read.csv("data_raw/Keratin_related_genes.csv")

kgenes_u <- distinct(kgenes, Gene.Symbol, .keep_all = T)

write.csv(kgenes_u, "data/Keratin_related_genes.csv", row.names = F)



# make table of samples for supplement ------------------------------------
library(tidyverse)
meta <- read.csv("data/BTBW_whole_specimen_Image_Analysis_measurements_allpop_avgimg_wide.csv") 

supptable <- meta %>% 
  dplyr::select(ID, GRG.no., Species, date.d.m.y, Locality, County, State.Province, Collector,
                prepartor, Sex, Age, Latitude = lat, Longitude = lon)

write.table(supptable, file = "results/Supplemental_table_samples_photo.csv", row.names = F)
