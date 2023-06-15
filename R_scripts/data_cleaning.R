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
            