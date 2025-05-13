## get LRT median and compare to null distribution
#adapted from https://github.com/lucasrocmoreira/Moreira-Smith_SciAdv_2023
library(data.table)
library(windowscanr)

PC1_d <- fread("data_raw/Btbw_n95_ASY_mergethenfilter_maxmiss20_minQ30_maf05_ds2x_minInd40_maxd400_asso6.lrt0.gz")
x <- PC1_d[PC1_d$beta!="NaN",]
rol_win <- winScan(x = x,
                     groups = "Chromosome",
                     position = NULL,
                     values = "LRT",
                     win_size = 50,
                     win_step = 10,
                     funs = "median",
                     cores = 32)
write.table(rol_win,"data/Btbw_n95_ASY_mergethenfilter_maxmiss20_minQ30_maf05_ds2x_minInd40_maxd400_asso6.lrt0.rol_win",row.names = F)

lrt_rand <- fread("data_raw/LRT_threshold_0.00001.tsv") %>% 
  rename(LRT = V1)
pos <- PC1_d %>% 
  dplyr::select(Chromosome, Position)
rand_pos <- cbind(pos, lrt_rand)

x <- rand_pos[rand_pos$LRT > -999 ,]
rol_win <- winScan(x = x,
                   groups = "Chromosome",
                   position = NULL,
                   values = "LRT",
                   win_size = 50,
                   win_step = 10,
                   funs = "median",
                   cores = 32)
write.table(rol_win,"data/LRT_threshold_0.00001_median.tsv",row.names = F)
