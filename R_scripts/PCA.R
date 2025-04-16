# PCA genetics----------------------------------------------------------------

# library(devtools)
# install_github("zhengxwen/gdsfmt")
# install_github("zhengxwen/SNPRelate")

library(RColorBrewer)
library(SNPRelate)
library(gdsfmt)
library(scales)
library(rmote)
library(tidyverse)

## run this in a new terminal window!!
#ssh -L 4111:localhost:4111 mjo234@cbsumma04.biohpc.cornell.edu
rmote::start_rmote(server_dir = "/workdir/mjo234/rmote_server", port = 4111)

vcf <- "btbw_n91_ASY_mergethenfilter_maxmiss20_minQ30_maf05_ds2x_impute.vcf.gz" 
gds <- sub("\\.vcf\\.gz$", ".gds", vcf)
### in terminal
snpgdsVCF2GDS(vcf.fn=vcf,
              out.fn=gds,
              method = c("biallelic.only"),
              compress.annotation="ZIP.max", snpfirstdim=FALSE, verbose=TRUE)
snpgdsSummary(gds)
#####The total number of samples: 94 
#####The total number of SNPs: 1585583

# Running based on missing ----------------------------
genofile <- snpgdsOpen(gds)
miss <- snpgdsSampMissRate(genofile, sample.id=NULL, snp.id=NULL, with.id=TRUE)
miss
pca <- snpgdsPCA(gdsobj = genofile,autosome.only=FALSE)
pc.percent <- pca$varprop*100
head(round(pc.percent, 2))
tab <- data.frame(sample.id = pca$sample.id,
                  EV1 = pca$eigenvect[,1],    # the first eigenvector
                  EV2 = pca$eigenvect[,2],    # the second eigenvector
                  stringsAsFactors = FALSE)
head(tab)
tab
plot(tab$EV1, tab$EV2, xlab="eigenvector 1", ylab="eigenvector 2")
# Add text labels
text(tab$EV2, tab$EV1, labels=tab$sample.id, pos=3, cex=0.8)
plot_done()

tab2 <- cbind(tab, miss)

ggplot(tab2, aes(x = EV1, y = EV2, color = miss)) +
  geom_point(size = 3) +
  scale_color_gradient(low = "blue", high = "red") +
  ggtitle(gds)
plot_done()



# PCA for angsd -----------------------------------------------------------
## Principal components analysis
## PCangsd of ds2x 

library(tidyverse)
library(RcppCNPy)
library(here)

C <- as.matrix(read.table("data_raw/btbw_n94_ASY_mergethenfilter_maxmiss20_minQ30_maf05_ds2x_minInd40_maxd400.covMat"))
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

#  bind to relevant metadata -------------------------------------------------------------------------
#determine which ids to keep from metadata
fam <- read.table("data/BTBW_n94_ASY_forGWAS_lum_d_rand.fam") %>% 
  select(ID = V2, lumMean_d = V6)

tabfam <- cbind(fam, tab)

meta <- read.csv("data/NMNH_specimen_metadata.csv")
meta$seqID <- paste0("Z", meta$USNM.no.)

tab2 <- merge(tabfam, meta, by.x = "ID", by.y = "seqID", all.x = T, all.y = F)



ggplot(tab2, aes(x = EV1, y = EV2, color = lat, shape = Region))+
  #use this line if you want to label individuals. and add label=ID to the aes above
  #geom_text_repel(nudge_x = 0.05, nudge_y = 0.05, size = 4, max.overlaps = 8) +
  geom_point(size = 6.5)+
  xlab(paste0("PC1 (", pc1perc ,"% explained)")) +
  ylab(paste0("PC2 (", pc2perc,"% explained)")) +
  #lims(y=c(0,0.075))+
  theme_classic()+
  theme(
    text = element_text(size = 24),          # Overall text size
    axis.text = element_text(size = 20),     # Axis tick labels
    axis.title = element_text(size = 20),    # Axis title
    plot.title = element_text(size = 20)     # Plot title
  )

#looks good, using pc scores to account for population structure

pccov <- tab2 %>% 
  dplyr::select(EV1, EV2, EV3)


write.table(pccov, file = "data/PCscores_btbw_n94_ASY_mergethenfilter_maxmiss20_minQ30_maf05_ds2x_minInd40_maxd400.cov",
            quote = F, row.names = F, col.names = F)



# PCA color ---------------------------------------------------------------

library(RColorBrewer)
library(tidyverse)
library(ggbiplot)


avg_img <- read.csv("data/BTBW_whole_specimen_Image_Analysis_measurements_allpop_avgimg_wide.csv")

## select only brightness for ASY males
asy <- avg_img %>% 
  filter(Age == "ASY", ID != "614283")

#filtering for just dorsum measures, removing lum bc redundant with dbl and area bc it's not relevant for this patch
dorsum <- avg_img %>% 
  dplyr::select(ends_with("_d"), -lumSD_d,-lumMean_d, -area_mm2_d) %>% 
  na.omit()


d_pca <- prcomp(~ ., data = dorsum)

screeplot(d_pca, type="lines")

ggbiplot(d_pca, choices = c(1,2))+
  theme_classic()

dorsum_pcs <- cbind(dorsum, predict(d_pca))

plot(dorsum_pcs$dblMean_d, dorsum_pcs$PC1)

#filtering for just throat measures, removing lum bc redundant with dbl and area bc it's not relevant for this patch
throat <- asy %>% 
  dplyr::select(ends_with("_t"), -lumSD_t,-lumMean_t, -area_mm2_t) %>% 
  na.omit()


t_pca <- prcomp(~ ., data = throat)

screeplot(t_pca, type="lines")

ggbiplot(t_pca, choices = c(1,2))+
  theme_classic()

throat_pcs <- cbind(throat, predict(t_pca))

plot(throat_pcs$dblMean_t, throat_pcs$PC1)

#filtering for just covert measures, removing lum bc redundant with dbl and area bc it's not relevant for this patch
covert <- asy %>% 
  dplyr::select(ends_with("_o"), -lumSD_o,-lumMean_o, -area_mm2_o) %>% 
  na.omit()


o_pca <- prcomp(~ ., data = covert)

screeplot(o_pca, type="lines")

ggbiplot(o_pca, choices = c(1,2))+
  theme_classic()

covert_pcs <- cbind(covert, predict(o_pca))

plot(covert_pcs$dblMean_o, covert_pcs$PC1)

#filtering for just belly measures, removing lum bc redundant with dbl and area bc it's not relevant for this patch
belly <- asy %>% 
  dplyr::select(ends_with("_b"), -lumSD_b,-lumMean_b, -area_mm2_b) %>% 
  na.omit()


b_pca <- prcomp(~ ., data = belly)

screeplot(b_pca, type="lines")

ggbiplot(b_pca, choices = c(1,2))+
  theme_classic()

belly_pcs <- cbind(belly, predict(b_pca))

plot(belly_pcs$dblMean_b, belly_pcs$PC1)

#filtering for just crown measures, removing lum bc redundant with dbl and area bc it's not relevant for this patch
crown <- asy %>% 
  dplyr::select(ends_with("_c"), -lumSD_c,-lumMean_c, -area_mm2_c) %>% 
  na.omit()


c_pca <- prcomp(~ ., data = crown)

screeplot(c_pca, type="lines")

ggbiplot(c_pca, choices = c(1,2))+
  theme_classic()

crown_pcs <- cbind(crown, predict(c_pca))

plot(crown_pcs$dblMean_c, crown_pcs$PC1)


#filtering for just wingspot measures, removing lum bc redundant with dbl and area bc i just want color
wingspot <- asy %>% 
  dplyr::select(ends_with("_w"), -lumSD_w,-lumMean_w, -area_mm2_w) %>% 
  na.omit()


w_pca <- prcomp(~ ., data = wingspot)

screeplot(w_pca, type="lines")

ggbiplot(w_pca, choices = c(1,2))+
  theme_classic()

wingspot_pcs <- cbind(wingspot, predict(w_pca))

plot(wingspot_pcs$dblMean_w, wingspot_pcs$PC1)
