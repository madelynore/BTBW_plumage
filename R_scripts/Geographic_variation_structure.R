## Geographic variation in Feather structure

library(tidyverse)

f <- read.csv("data/feather_measurements.csv")

## add location identifiers
unique(f$ID)

GA_ids <- c("BW15002", "BW15004", "BW15005")
MI_ids <- c("BW15110", "BW15112", "BW15113","BW15114")
## create a column that corresponds to  IDs 
State <- c()

for (i in 1:length(GA_ids)){
  a <- f$ID[which(f$ID == GA_ids[i])]
  st <- rep("GA", length(a))
  State <- c(State, st)
}
for (i in 1:length(MI_ids)){
  a <- f$ID[which(f$ID == MI_ids[i])]
  st <- rep("MI", length(a))
  State <- c(State, st)
}

f_st <- cbind(f, State)

## select only b2, b6 and b10
repBarbs <- c(which(f_st$Comments == "b2"), which(f_st$Comments == "b6"),which(f_st$Comments == "b10"))  

f_rep <- f_st[repBarbs,]
head(f_rep)

## remove L feathers to avoid duplicates from symmetry test
L <- grep("^L.*",f_rep$feather_ID)
fRm <- f_rep[-L,]

## clean feather_ID col to be able to use as a random factor in model
f_fid <- fRm %>% 
  separate(feather_ID, into= c("Side","feather_ID"), sep = "_", fill = "left")

# make NAs 0 
#change NAs to 0 for calc mean and sd
f_fid$perc_clear[is.na(f_fid$perc_clear)] <- 0
f_fid$perc_black[is.na(f_fid$perc_black)] <- 0

mean_se_data <- f_fid %>% 
  group_by(ID, State, feather_ID) %>% 
  summarise(
    count = n(),
    avg_black = mean(perc_black),
    se_black = sd(perc_black) / sqrt(length(perc_black)),
    avg_clear = mean(perc_clear),
    se_clear = sd(perc_clear) / sqrt(length(perc_clear))
  ) %>% 
  ungroup()

ggplot(data = mean_se_data, aes(y = avg_black, x = State, fill = ID, color = ID)) + 
  geom_pointrange(aes(ymin = avg_black - se_black, ymax = avg_black + se_black), position = position_dodge(width = 0.2), fatten = 1.5) +
  labs(x = "Location", y = "Percent Black per barb") +
  theme_classic() +
  theme(
    aspect.ratio = 0.75,
    text = element_text(size = 16),
    axis.text = element_text(size = 14)
  )

# Perform t-test for comparing perc_black between states
t_test_result <- t.test(perc_black ~ State, data = f_fid)

# Print the test results
print(t_test_result)


# Welch Two Sample t-test
# 
# data:  perc_black by State
# t = 5.2796, df = 54.954, p-value = 2.273e-06
# alternative hypothesis: true difference in means between group GA and group MI is not equal to 0
# 95 percent confidence interval:
#   0.2669750 0.5936655
# sample estimates:
#   mean in group GA mean in group MI 
# 0.5673848        0.1370645 

