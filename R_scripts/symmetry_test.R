## testing symmetry of feathers
library(tidyverse)

m <- read.csv(file = "data/feather_measurements_symmetry_test.csv")

head(m)

repBarbs <- c(which(m$Comments == "b2"), which(m$Comments == "b6"),which(m$Comments == "b10"))  

m_rep <- m[repBarbs,]
head(m_rep)

# prep data to have two groups to compare between
m_rep_t <- m_rep %>% 
  separate(feather_ID, into= c("side", "feather_no."), sep = "_")

#change NAs to 0 for calc mean and sd
m_rep_t$perc_clear[is.na(m_rep_t$perc_clear)] <- 0
m_rep_t$perc_black[is.na(m_rep_t$perc_black)] <- 0


m_rep_t %>% 
  group_by( side) %>% 
  summarise(
    count = n(),
    avg_black = mean(perc_black),
    sd_black = sd(perc_black),
    avg_clear = mean(perc_clear),
    sd_clear = sd(perc_clear)
  )

boxplot(m_rep_t$perc_black~m_rep_t$side)
boxplot(m_rep_t$perc_clear~m_rep_t$side)


## test data is normally distributed
differences <- with(m_rep_t, perc_clear[side == "L"] - perc_clear[side == "R"])
## b10 missing on L f3 BW15113, going to remove R f3 for symmetry
r_f3_b10 <- which(m_rep_t$ID == "BW15113" & m_rep_t$side == "R" & m_rep_t$feather_no. == "f3" &
        m_rep_t$Comments == "b10")

M <- m_rep_t[-r_f3_b10,]
#check
which(M$ID == "BW15113" & M$side == "R" & M$feather_no. == "f3" &
        M$Comments == "b10")

differences <- with(M, perc_clear[side == "L"] - perc_clear[side == "R"])
shapiro.test(differences)

## not normally distributed, so need to do wilcoxon test 
L_percClear <- M$perc_clear[M$side == "L"]
R_percClear <- M$perc_clear[M$side == "R"]

wilcox.test(L_percClear, R_percClear, paired = T)
## not statistically different between L and R !! 

table(side~feather, data = m_rep_t)
