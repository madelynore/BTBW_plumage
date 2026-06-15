# PCA genetics----------------------------------------------------------------
## Principal components analysis
## PCangsd of ds2x 

library(tidyverse)
library(RcppCNPy)
library(here)

C <- as.matrix(read.table("btbw_n95_ASY_mergethenfilter_maxmiss20_minQ30_maf05_ds2x_minInd40_maxd400.covMat"))
# Plot PCA plot
## get eigenvalues + vectors
e <- eigen(C, symmetric = T)
## extract just eigenvalues
evalues <- e$values
prop.expl <- evalues/sum(evalues)*100
#For % explained
pc1perc <- as.character(round(prop.expl[1], 2))
pc2perc <- as.character(round(prop.expl[2], 2))
pc3perc <- as.character(round(prop.expl[3], 2))
pc4perc <- as.character(round(prop.expl[4], 2))
## make table of eigen vectors
tab <- data.frame(EV1 = e$vectors[,1], EV2 = e$vectors[,2], EV3 = e$vectors[,3], 
                  EV4 = e$vectors[,4])

str(e)
head(tab)
print(prop.expl[1:4])

plot(x = tab$EV1, y = tab$EV2)
plot_done()
# bind to relevant metadata
#determine which ids to keep from metadata
fam <- read.table("BTBW_n95_ASY_forGWAS_PC1_d_rand.fam") %>% 
  select(ID = V2, lumMean_d = V6)

tabfam <- cbind(fam, tab)

meta <- read.csv("NMNH_specimen_metadata.csv")
meta$seqID <- paste0("Z", meta$USNM.no.)

tab2 <- merge(tabfam, meta, by.x = "ID", by.y = "seqID", all.x = T, all.y = F)



ggplot(tab2, aes(x = EV1, y = EV2, color = lat, shape = Region))+
  #use this line if you want to label individuals. and add label=ID to the aes above
  #geom_text_repel(nudge_x = 0.05, nudge_y = 0.05, size = 4, max.overlaps = 8) +
  geom_point(size = 6.5)+
  xlab(paste0("PC1 (", pc1perc ,"% explained)")) +
  ylab(paste0("PC2 (", pc2perc,"% explained)")) +
  #lims(y=c(0,0.075))+
  title("cov matrix ASY n95")+
  theme_classic()+
  theme(
    text = element_text(size = 24),          # Overall text size
    axis.text = element_text(size = 20),     # Axis tick labels
    axis.title = element_text(size = 20),    # Axis title
    plot.title = element_text(size = 20)     # Plot title
  )
plot_done()
#looks good, using pc scores to account for population structure

pccov <- tab2 %>% 
  dplyr::select(EV1, EV2, EV3)


write.table(pccov, file = "PCscores_btbw_n95_ASY_mergethenfilter_maxmiss20_minQ30_maf05_ds2x_minInd40_maxd400.cov",
            quote = F, row.names = F, col.names = F)

