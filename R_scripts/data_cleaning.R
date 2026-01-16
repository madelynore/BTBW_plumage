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

# Cleaning raw output from LAS X reports ----------------------------------


library(tidyverse)
library(conflicted)

feather_files <- list.files(path= "data_raw/",pattern = "^BW.*$")
# Initialize an empty data frame
IDs_df <- data.frame(file = character(), BW_ID = character(), feather_ID = character(), stringsAsFactors = FALSE)

# Extract "ID" and "classA_classB" from each file name
for (file_name in feather_files) {
  file_name <- file_name
  # Extract "ID" using regular expression
  id <- sub("_.*", "", file_name)
  
  # Extract "classA_classB" using regular expression
  classA_classB <- sub("^[^_]*_", "", sub("\\.csv$", "", file_name))
  
  # Add the extracted values to the data frame
  IDs_df <- rbind(IDs_df, data.frame(file = file_name, BW_ID = id, feather_ID = classA_classB, stringsAsFactors = FALSE))
}

# Output the result data frame
IDs_df

F_measures <- data.frame()

# Iterate over each row in the IDs_df data frame
for (i in 1:nrow(IDs_df)) {
  # Read the file for the current iteration
  file_path <- paste0("data_raw/", IDs_df$file[i])
  measures <- read.csv(file = file_path, skip = 8)
 
  
  # Remove rows where "Class" is "barb length"
  measures <- measures[measures$Class != "barb length", ]
  
  #remove count measures
  tool_rm <- which(!(measures$Tool == "Count"))
  measures <- measures[tool_rm,]

  
  # Identify the column name for line length
  line_length_col <- grep("Line", names(measures), ignore.case = TRUE, value = TRUE)
  if (length(line_length_col) == 0) {
    print("Line length column not found.")
    next  # Skip the current iteration and proceed to the next one
  }
  
  # Assign values to additional columns
  measures$ID <- rep(IDs_df$BW_ID[i], times = nrow(measures))
  measures$feather_ID <- rep(IDs_df$feather_ID[i], nrow(measures))
  measures[[line_length_col]] <- as.numeric(measures[[line_length_col]])
  
  
  # Perform calculations on the measures data
  l_segments <- measures %>% 
    group_by(ID, feather_ID, Comments, Class) %>% 
    summarize(length_segment = sum(!!sym(line_length_col))) %>% 
    pivot_wider(names_from = Class, values_from = length_segment)
  
  total_l <- measures %>% 
    group_by(ID, feather_ID, Comments) %>% 
    summarize(sum_length = sum(!!sym(line_length_col)))
 
  
  comb_l <- merge(l_segments, total_l, by = c("ID", "feather_ID", "Comments"))

  
  # Check if the required columns are present in comb_l
  required_columns <- c("black segment", "clear segment")
  missing_columns <- required_columns[!(required_columns %in% colnames(comb_l))]
  
  if (length(missing_columns) > 0) {
    # Add missing columns with NA values
    for (col in missing_columns) {
      comb_l[[col]] <- NA
    }
  }
  
  # Append the current comb_l to the combined_df using rbind
  F_measures <- merge(F_measures, comb_l, by = intersect(names(F_measures), names(comb_l)),
                      all = T)
}

F_measures$perc_black <- F_measures$`black segment`/F_measures$sum_length
F_measures$perc_clear <- F_measures$`clear segment`/F_measures$sum_length

write.csv(F_measures, "data/feather_measurements.csv", row.names = F)




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
allimg_rmrow$pl_code[which(allimg_rmrow$photo == "dorsal" & allimg_rmrow$pl_code != "d")] <-  "d"

allimg_rmrow$pl_code[which(allimg_rmrow$photo == "crown" & allimg_rmrow$pl_code != "c")] <- "c"

#calculating mm2 area - standardized to 36.5px/mm
allimg_rmrow$area_mm2 <- allimg_rmrow$area/(36.5^2)

## add metadata
meta <- read.csv("data/NMNH_specimen_metadata.csv") 

#merging WI forest into the rest
meta$pop[which(meta$pop == "WI.Forest")] <-  "WI.All"

allimg_meta <-  merge(allimg_rmrow, meta, by.x = "ID", by.y = "USNM.no.", all.x = T, all.y = T)

# identify IDs missing metadata
unique(allimg_meta$ID[which(is.na(allimg_meta$pop))])
unique(allimg_meta$ID[which(is.na(allimg_meta$lat))])

write.csv(allimg_meta, "data/BTBW_whole_specimen_Image_Analysis_measurements_raw_allpop.csv", row.names = F)

avg_img <- allimg_rmrow %>%
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

avgimg_wide <- avg_img %>% 
  pivot_wider(names_from = pl_code, values_from = c(lumMean, lumSD,
                                                    lwMean, lwSD, mwMean, mwSD,
                                                    swMean, swSD,
                                                    uvMean, uvSD,
                                                    dblMean, dblSD, area_mm2), names_sep = "_" )

#calculate PC scores for color of each patch - see PCA.R for plots
dorsum <- avgimg_wide %>% 
  dplyr::select(ID, ends_with("_d"), -lumSD_d,-lumMean_d, -area_mm2_d) %>% 
  na.omit()

d_pca <- prcomp(~ ., data = dorsum[-1])

dorsum_pc <- data.frame(ID = dorsum$ID, PC1_d = predict(d_pca)[,1])

crown <- avgimg_wide %>% 
  dplyr::select(ID, ends_with("_c"), -lumSD_c,-lumMean_c, -area_mm2_c) %>% 
  na.omit()

c_pca <- prcomp(~ ., data = crown[-1])

crown_pc <- data.frame(ID = crown$ID, PC1_c = predict(c_pca)[,1])

dcpc <- merge(dorsum_pc, crown_pc, all = T)

covert <- avgimg_wide %>% 
  dplyr::select(ID, ends_with("_o"), -lumSD_o,-lumMean_o, -area_mm2_o) %>% 
  na.omit()

o_pca <- prcomp(~ ., data = covert[-1])

covert_pc <- data.frame(ID = covert$ID, PC1_o = predict(o_pca)[,1])

dcopc <- merge(dcpc, covert_pc, all = T)

belly <- avgimg_wide %>% 
  dplyr::select(ID, ends_with("_b"), -lumSD_b,-lumMean_b, -area_mm2_b) %>% 
  na.omit()

b_pca <- prcomp(~ ., data = belly[-1])

belly_pc <- data.frame(ID = belly$ID, PC1_b = predict(b_pca)[,1])

dcobpc <- merge(dcopc, belly_pc, all = T)

throat <- avgimg_wide %>% 
  dplyr::select(ID, ends_with("_t"), -lumSD_t,-lumMean_t, -area_mm2_t) %>% 
  na.omit()

t_pca <- prcomp(~ ., data = throat[-1])

#flipping orientation so that darkest are smaller values and lightest are larger values
throat_pc <- data.frame(ID = throat$ID, PC1_t = predict(t_pca)[,1]*-1)

dcobtpc <- merge(dcobpc, throat_pc, all = T)

wingspot <- avgimg_wide %>% 
  dplyr::select(ID, ends_with("_w"), -lumSD_w,-lumMean_w, -area_mm2_w) %>% 
  na.omit()

w_pca <- prcomp(~ ., data = wingspot[-1])

#flipping orientation so that darkest are smaller values and lightest are larger values
wingspot_pc <- data.frame(ID = wingspot$ID, PC1_w = predict(w_pca)[,1]*-1)

allplpc <- merge(dcobtpc, wingspot_pc, all = T)

#merge wide img with pcscores and meta data
avgimgwide_pc <- merge(avgimg_wide, allplpc, all = T)

avgimgwide_meta <-  merge(avgimgwide_pc, meta, by.x = "ID", by.y = "USNM.no.", all.x = T, all.y = T)

write.csv(avgimgwide_meta, "data/BTBW_whole_specimen_Image_Analysis_measurements_allpop_avgimg_wide.csv", row.names = F)

# confirming that smaller PC scores == darker colors
plot(avgimgwide_meta$lumMean_d, avgimgwide_meta$PC1_d)
plot(avgimgwide_meta$lumMean_c, avgimgwide_meta$PC1_c)
plot(avgimgwide_meta$lumMean_o, avgimgwide_meta$PC1_o)
plot(avgimgwide_meta$lumMean_b, avgimgwide_meta$PC1_b)
plot(avgimgwide_meta$lumMean_t, avgimgwide_meta$PC1_t)
plot(avgimgwide_meta$lumMean_w, avgimgwide_meta$PC1_w)

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
fam_img <- merge(fam_id, img_wide, by.x = "V2", by.y = "ID", all.x = F, all.y = F) %>% 
  dplyr::select(V1, V2, Age, V4, V5, PC1_d)

head(fam_img)

fam_img_noNA <- fam_img %>%
  filter(!(is.na(fam_img$PC1_d)))

fam_img_noNA$rand_d <- sample(fam_img_noNA$PC1_d)

famcol <- colnames(fam_img_noNA)
write.table(fam_img_noNA, "data/BTBW_n155_allages_forGWAS_PC1_d_rand.fam",
            quote = F, col.names = F, row.names = F)

# select only the ASY
asyfam <- fam_img_noNA %>% 
  filter(Age == "ASY") 

write.table(asyfam, 
            "data/BTBW_n95_ASY_forGWAS_PC1_d_rand.fam",
            quote = F, col.names = F, row.names = F)


# prep data to compare sullivan NY  ----------------------------------------------------

library(tidyverse)
# load file names
snyfiles <- list.files(path = "data_raw/", pattern = "Sullivan.*Image*")

imgnm <- paste0("data_raw/", snyfiles[1])
## extract name of the population
pop_name <- sub(x = snyfiles[1],
                pattern = "_Image Analysis Results Samsung NX1000 Nikkor EL 80mm D65 to Bluetit D65.*",
                replacement = "")

#read in file
sny1 <- read.csv(file = imgnm)

head(sny1)

## change label to more informative labels
sny1_ID <- sny1 %>% 
  separate(Label, into = c("ID", "photo", "plumage_patch"), sep = "_")

# separate plumage patch from replicate
sny1_plid <- sny1_ID %>% 
  separate(plumage_patch, into = c("pl_code", "rep"), sep = "(?<=[A-Za-z])(?=[0-9])")

## reviewing how many patches measured
summary(as.factor(sny1_plid$pl_code))

# add pop name
sny1_plid$pop <- rep(pop_name, nrow(sny1_plid))

##### second file
imgnm <- paste0("data_raw/", snyfiles[2])
## extract name of the population
pop_name <- sub(x = snyfiles[2],
                pattern = "_Image Analysis Results Samsung NX1000 Nikkor EL 80mm D65 to Bluetit D65.*",
                replacement = "")

#read in file
sny2 <- read.csv(file = imgnm)

head(sny2)

## change label to more informative labels
sny2_ID <- sny2 %>% 
  separate(Label, into = c("ID", "photo", "plumage_patch"), sep = "_")

# separate plumage patch from replicate
sny2_plid <- sny2_ID %>% 
  separate(plumage_patch, into = c("pl_code", "rep"), sep = "(?<=[A-Za-z])(?=[0-9])")

## reviewing how many patches measured
summary(as.factor(sny2_plid$pl_code))

# add pop name
sny2_plid$pop <- rep(pop_name, nrow(sny2_plid))



snybothimg <- rbind(sny1_plid, sny2_plid)

avgsny_img <- snybothimg %>% 
  group_by(ID, photo, pl_code, pop) %>% 
  summarise(across(starts_with("lum") | starts_with("lw") | starts_with("mw") | starts_with("sw") | starts_with("uv") | starts_with("dbl") | area | contains("Power") | contains("Freq"), mean),
            N = n_distinct(rep))



# how many specimens photographed and sequenced? --------------------------

#read in fam file
fam <- read.table("data_raw/BTBW_wgs_ds2x_mergedthenfiltered_maxmiss0.8_minQ30_maf.05_rmrelatedind5_impute4.1_GWAS_bed.fam")
# make column with just IDs
fam_id <- fam %>% 
  separate(V2, into = c("V2", NA), sep = "_", remove = F )

meta <- read.csv("data/NMNH_specimen_metadata.csv") %>% 
  dplyr::select("USNM.no.", "Age")

meta$ID <- paste0("Z", meta$USNM.no.)

fam_meta <- merge(fam_id, meta, by.x = "V2", by.y = "ID", all = F)
# 156 sequenced and in nmnh specimen data

# which not in the avg_img
avg_img <- read.csv(here("data/BTBW_whole_specimen_Image_Analysis_measurements_averaged_allpop.csv"))

img_ID <- unique(avg_img$ID)

setdiff(fam_meta$USNM.no., img_ID) # 606627 606663 have sequences but no photo data
missing_IDs <- setdiff(meta$USNM.no., img_ID)

write.table(missing_IDs, file = "data/IDs_w_photos_but_no_measurements.txt", quote = F)

## which photos views are missing
meta <- read.csv("data/NMNH_specimen_metadata.csv") %>% 
  dplyr::select("USNM.no.", "Age", "pop")

# all files on harddrive
img_files <- list.files(path = "/Volumes/G-DRIVE/NMNH specimen photos/all_photos_measured/", pattern = ".*mspec$")

img_df <- data.frame(file.path = img_files)

img_df_sep <- img_df %>% 
  separate(file.path, into = c("ID", "view"), sep = "_", remove = T)

img_df_sep$view <- sub(x = img_df_sep$view, pattern = "\\.mspec", replacement = "")

img_df_wide <- img_df_sep %>%
  mutate(value = 1) %>%  # Add a column with value 1
  pivot_wider(names_from = view, values_from = value, values_fill = list(value = 0))


img_meta <- merge(meta, img_df_wide, by.x = "USNM.no.", by.y = "ID", all = T)

img_missing <- img_meta %>% 
  filter(crown == 0 | is.na(crown) |
           dorsal == 0 | is.na(dorsal) |
           side == 0 | is.na(side) |
           ventral == 0 | is.na(ventral))

write.csv(img_missing, "results/images_missing_from_analyses.csv", row.names = F)


# Make NGSadmix file ------------------------------------------------------

k2 <- read.table("data_raw/NGS_admix_K2_from_GEA.txt")

k2$ID <- rownames(k2)

fam <- read.table("data/BTBW_n95_ASY_forGWAS_PC1_d_rand.fam") %>% 
  select(ID = V2)

k2_pl <- merge(k2, fam, all.y = T)


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
