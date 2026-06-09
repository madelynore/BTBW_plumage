## get LRT null distribution
#adapted from https://github.com/lucasrocmoreira/Moreira-Smith_SciAdv_2023
library(data.table)
library(windowscanr)

lrt_rand <- fread("data_raw/LRT_threshold_0.00001.tsv") %>% 
  dplyr::rename(LRT = V1)
pos <- PC1_d %>% 
  dplyr::select(Chromosome, Position)
rand_pos <- cbind(pos, lrt_rand)

x <- rand_pos[rand_pos$LRT > -999 ,]

write.table(x,"data/LRT_threshold_0.00001.tsv",row.names = F)

