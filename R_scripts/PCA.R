# PCA----------------------------------------------------------------

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