## plotting GWAS results

if (!require("pacman")) install.packages("pacman")
pacman::p_load_gh("sahirbhatnagar/manhattanly")

library(manhattanly)
library(qqman)
library(tidyverse)
library(data.table)

# GEMMA BSLMM PIP ---------------------------------------------------------

#code adapted from Erica Robertson (with permission)
fileprefix <- "BSLMM_GWAS_n95_ASY_gatk_fromvcf_impute_PC1dorsum"
hypfile <- paste0("data_raw/", fileprefix,".hyp.txt")
hyp.params<-read.table(hypfile,header=T)
# Get mean, median, and 95% ETPI of hyperparameters
# pve -> proportion of phenotypic variance explained by the genotypes
pve<-c("PVE", mean(hyp.params$pve),quantile(hyp.params$pve, probs=c(0.5,0.025,0.975)))
# pge -> proportion of genetic variance explained by major effect loci
pge<-c("PGE",mean(hyp.params$pge),quantile(hyp.params$pge, probs=c(0.5,0.025,0.975)))
# pi -> proportion of variants with non-zero effects
pi<-c("pi",mean(hyp.params$pi),quantile(hyp.params$pi, probs=c(0.5,0.025,0.975)))
# n.gamma -> number of variants with major effect
n.gamma<-c("n.gamma",mean(hyp.params$n_gamma),quantile(hyp.params$n_gamma, probs=c(0.5,0.025,0.975)))

# get table of hyperparameters
hyp.params.table<-as.data.frame(rbind(pve,pge,pi,n.gamma),row.names=F)
colnames(hyp.params.table)<-c("hyperparam", "mean","median","2.5%", "97.5%")
# write table to file
write.csv(hyp.params.table, file="data/bslmm_hyperparameters_BSLMM_GWAS_n95_ASY_gatk_fromvcf_impute_PC1dorsum.csv", quote=F)

# plot traces and distributions of hyperparameters
pdf(file="results/bslmm_hyperparameters_BSLMM_GWAS_n95_ASY_gatk_fromvcf_impute_PC1dorsum.pdf", width=8.3,height=11.7)
layout(matrix(c(1,1,2,3,4,4,5,6), 4, 2, byrow = TRUE))
# PVE
plot(hyp.params$pve, type="l", ylab="PVE", main="PVE - trace")
hist(hyp.params$pve, main="PVE - posterior distribution", xlab="PVE")
plot(density(hyp.params$pve), main="PVE - posterior distribution", xlab="PVE")
# PGE
plot(hyp.params$pge, type="l", ylab="PGE", main="PGE - trace")
hist(hyp.params$pge, main="PGE - posterior distribution", xlab="PGE")
plot(density(hyp.params$pge), main="PGE - posterior distribution", xlab="PGE")

# pi
plot(hyp.params$pi, type="l", ylab="pi", main="pi")
hist(hyp.params$pi, main="pi", xlab="pi")
plot(density(hyp.params$pi), main="pi", xlab="pi")

# No gamma
plot(hyp.params$n_gamma, type="l", ylab="n_gamma", main="n_gamma - trace")
hist(hyp.params$n_gamma, main="n_gamma - posterior distribution", xlab="n_gamma")
plot(density(hyp.params$pi), main="n_gamma - posterior distribution", xlab="n_gamma")

dev.off()

#So once that's done, we can look over them and see if any need to get run again to try and have better hyperparameters.

#gamma
#identifying the significant SNPs. We're going to use Posterior Inclusion Probability as our measure of significance. We test with a bunch of different significance threshold to see what comes up. Ideally, for the final one you would use either 0.1 or 0.5, but 0.01 is acceptable too according to some papers.

library(data.table)


# Load parameters output

fileprefix <- "BSLMM_GWAS_n95_ASY_gatk_fromvcf_impute_PC1dorsum"
paramfile <- paste0("data_raw/", fileprefix,".param.txt")
if (!file.exists(paramfile)) {
  # Print message if file does not exist
  print(paste(trait, "doesn't exist"))
  next # Skip to the next iteration of the loop
}
params<-fread(paramfile,header=T,sep="\t", data.table=F)

# Get variants with high Posterior Inclusion Probability (PIP) == gamma

# PIP is the frequency a variant is estimated to have a sparse effect in the MCMC

params.pipsort<-params[order(-params$gamma),]

# sets of variants above a certain threshold
# variants with effect in 1%, 10%, 25%, 50%, MCMC samples or more
thresholds <- c(0.01,0.05,0.10,0.25,0.5)
for (i in thresholds) {
  pip<-params.pipsort[params.pipsort$gamma>=i,]
  
  if (nrow(pip) > 0) {
    write.csv(pip, file=paste0("results/bslmm_results/",fileprefix,"_pip",i,"_soft.csv"), quote=F, row.names=F)
  }
}


thresholds <- c(0.01, 0.05, 0.10)

for (i in thresholds) {
  summary_df <- data.frame()
    file_path <- paste0("results/bslmm_results/",fileprefix, "_pip", i, "_soft.csv")
    
    if (!file.exists(file_path)) {
      print(paste(fileprefix, "_pip", i, "doesn't exist"))
      next
    }
    
    pip <- read.csv(file_path)
    summary_df <- bind_rows(summary_df, pip)
  if (nrow(summary_df) > 0) {
    output_file <- paste0("results/bslmm_results/summary_pip", i, "_soft.csv")
    write_csv(summary_df, output_file)
    print(paste("Summary for threshold", i, "saved to", output_file))
  } else {
    print(paste("No data found for threshold", i))
  }
}

file.stack <- list.files(path="results/bslmm_results/",
                         pattern="^summary.*\\.csv$",
                         full.names=T)
data_list <- lapply(file.stack,read.csv)

names(data_list) <- basename(file.stack)

# Loop through the data_list
for (name in names(data_list)) {
  df <- data_list[[name]]  # Access the dataframe
  print(name)              # Print the file name
  print(nrow(df))          # Print the number of rows
}


# Load parameters output
file_path <- paramfile
if (!file.exists(file_path)) {
  # Print message if file does not exist
  print(paste(trait, "doesn't exist"))
  next # Skip to the next iteration of the loop
}
params<-fread(file_path,header=T,sep="\t", data.table=F)

# Get variants with high Posterior Inclusion Probability (PIP) == gamma

# PIP is the frequency a variant is estimated to have a sparse effect in the MCMC

params.pipsort<-params[order(-params$gamma),]

# sets of variants above a certain threshold
# variants with effect in 1%, 10%, 25%, 50%, MCMC samples or more
thresholds <- c(0.01)
for (i in thresholds) {
  pip<-params.pipsort
  
  hist(pip$gamma,
       main = paste("PIP Histogram for PC1 dorsum"),
       xlab = "Posterior Inclusion Probability (PIP)",
       ylab = "Frequency",
       breaks = 20,
       col = "steelblue")
  }




# LRT from angsd-asso -----------------------------------------------------

lrt <- read.table("data_raw/btbw_n95_ASY_gatk_maxmiss20_minQ30_maf05_ds2x_minInd66_maxd400_impute_PC1cov_asso5.lrt0.gz")
#fix col names as headers
colnames(lrt) <- lrt[1,]
lrt <- lrt[-1,] %>% 
  filter(!str_detect(Chromosome, "scaffold"), !str_detect(Chromosome, "mito"))

process_lrt <- function(lrt_df) {
  lrt_df$chr <- sub(pattern = "^chr", replacement = "", lrt_df$Chromosome)
  # Assign index values for chromosomes
  lrt_ind <- lrt_df %>%
    mutate(chr = case_when(
      chr == "1a" ~ 1.2,
      chr == "4a" ~ 4.2,
      chr == "z" ~ 30,
      TRUE ~ as.numeric(chr)
    ))
  
  lrt_ind$Position <- as.numeric(lrt_ind$Position)
  lrt_ind$LRT <- as.numeric(lrt_ind$LRTscore) 
  
  # Select relevant columns
  lrt_sub <- lrt_ind %>%
    dplyr::select(CHR = chr, BP = Position, LRT, Chromosome) %>% 
    unite(SNP, c(Chromosome, BP), sep = "_", remove = F) %>% 
    filter(LRT > -999)
  
  return(lrt_sub)
}

lrt_man <- process_lrt(lrt)

## determine threshold for sig snps
# LRT null distribution threshold
threshold <- fread("data/LRT_threshold_0.00001.tsv") 

threshLRTgw <- quantile(threshold$LRT, probs = 0.999)


# in the top percentile of LRT scores
threshLRTsug <- quantile(lrt_man$LRT, probs = 0.9999)


# looking for hits with suggestive snps -----------------------------------

# BiocManager::install("GenomicRanges")
library(tidyverse)
library(GenomicRanges)

# get SNPs above suggestive line and fix to match warbler.gff
sugSNPsbslmm <- pip %>%
  filter(gamma >= 0.01) %>%        # <- fixed missing parenthesis
  mutate(chr = sub(x = rs, pattern = ":[0-9].*", replacement = ""),
         SNP = sub(x = rs, pattern = ":", replacement = "_"),
         CHR = case_when(
           chr == "chr1a" ~ 1.2,
           grepl("^chr[0-9]+$", chr) ~ as.numeric(gsub("chr", "", chr)),
           TRUE ~ NA_real_
         ),
         source = "BSLMM") %>% 
  select(chr, CHR, BP = ps, SNP, beta, gamma, source)

sugSNPsasso <- lrt_man %>%
  filter(LRT >= quantile(LRT, probs = 0.9999)) %>%
  dplyr::rename(chr = Chromosome) %>% 
  mutate(source = "ANGSD-asso")


# Join
sugSNPsall <- bind_rows(
  sugSNPsbslmm,
  sugSNPsasso
) 

dupSNPs <- sugSNPsall[duplicated(sugSNPsall$SNP) | duplicated(sugSNPsall$SNP, fromLast = TRUE), ]

uSNPs <- sugSNPsall %>% distinct(SNP, .keep_all = TRUE)

library(dplyr)

dupSNPs_merged <- dupSNPs %>%   # replace dup_df with your dataframe
  group_by(SNP) %>%
  summarise(
    # combine source labels
    source = paste(sort(unique(na.omit(source))), collapse = "+"),
    
    # keep first non-NA for these (adjust columns as needed)
    CHR   = coalesce(na.omit(CHR)[1], NA_real_),
    BP    = coalesce(na.omit(BP)[1], NA_real_),
    pos   = coalesce(na.omit(pos)[1], NA_real_),
    chr   = coalesce(na.omit(chr)[1], NA_character_),
    
    P     = coalesce(na.omit(P)[1], NA_real_),
    logp  = coalesce(na.omit(logp)[1], NA_real_),
    gamma = coalesce(na.omit(gamma)[1], NA_real_),
    beta = coalesce(na.omit(beta)[1], NA_real_),
    
    # LRT: prefer ANGSD-asso if present, else take first non-NA
    LRT   = if (any(source == "ANGSD-asso" & !is.na(LRT))) {
      max(LRT[source == "ANGSD-asso"], na.rm = TRUE)
    } else {
      coalesce(na.omit(LRT)[1], NA_real_)
    },
    .groups = "drop"
  )


sugSNPs <- rbind(dupSNPs_merged, uSNPs)

sugSNPs$start <- sugSNPs$BP-25000
sugSNPs$end <- sugSNPs$BP+25000

head(sugSNPs) 

regions4fasta <- sugSNPs %>% 
  dplyr::select(chr, start, end)

write_tsv(regions4fasta, file = "data/suggestive_SNPs_regions_n95_ASY_allmethods_25kb.bed",
            quote = "none", col_names = F)
  
warbler.gff<-read.delim("/Users/madelynore/Documents/Cornell/Genoscape BTBW/BTBW-GEA/data/mywagenomev2.1.all.noseq.gff", header=F, comment.char="#") #full gff
warbler.gff_mrna<-warbler.gff %>% filter (V3=="protein_match") #only keep the mRNA entries since these are the tracks we are interested in
head(warbler.gff_mrna)

####use Genomic Ranges packages to extract gene names in those peaks####
#set up dataframes for the package to use
r.autooutliers<-GRanges(sugSNPs$chr, IRanges(start=sugSNPs$start, end=sugSNPs$end))
r.gff_mrna<-GRanges(warbler.gff_mrna$V1, IRanges(start=warbler.gff_mrna$V4, end=warbler.gff_mrna$V5))

#find overlaps
##Autosomal Outliers
fo.autosomal<-findOverlaps(r.autooutliers,r.gff_mrna)

AutoOutlier_genes<-warbler.gff_mrna[subjectHits(fo.autosomal),] #these are all the genes (and associated gff info) in the elevated windows

head(AutoOutlier_genes)
#rename columns
AutoOutlier_named <- AutoOutlier_genes %>% 
  dplyr::rename(Chr = V1, `dbsource` = V2, `type` = V3, `start` = V4, `end` = V5, `gene.hit` = V9)

# extract XP 
AutoOutlier_named$RefSeq.Protein.Accession <- str_extract(AutoOutlier_named$gene.hit, "(XP|NP)_[A-Za-z0-9_.]+")
# Identify rows where extraction is NA and the source is "repeatrunner"
repeatrunner_condition <- is.na(AutoOutlier_named$RefSeq.Protein.Accession ) & AutoOutlier_named$source == "repeatrunner"

# For rows meeting the condition, extract AAA, AAL, A patterns
AutoOutlier_named$RefSeq.Protein.Accession[repeatrunner_condition] <- str_extract(AutoOutlier_named$gene.hit[repeatrunner_condition], "(AAA|AAL|A)[0-9]+\\.?[0-9]*")
head(AutoOutlier_named)
length(unique(AutoOutlier_named$RefSeq.Protein.Accession))

library(data.table)
setDT(AutoOutlier_named)
setDT(sugSNPs)

setkey(AutoOutlier_named, Chr, start, end)
setkey(sugSNPs, chr, start, end)

# Use foverlaps for efficient overlap detection
AutoOutlier_merged <- foverlaps(AutoOutlier_named, sugSNPs, 
                                by.x = c("Chr", "start", "end"),
                                by.y = c("chr", "start", "end"),
                                type = "any",  # any overlap
                                nomatch = 0L)


write.csv(AutoOutlier_merged, "data/GWAS_n95_ASY_allmethods_outlier_genehits25kb.csv", row.names = F)

unique_genehits <- unique(AutoOutlier_merged$RefSeq.Protein.Accession) #417 unique gene hits

write.table(unique_genehits, "data/GWAS_n95_ASY_allmethods_outlier_unique_genehits25kb.txt", 
            row.names = F, quote = F, col.names = F)

AutoOutlier_merged$RefSeq.Protein.Accession.clean <- gsub("\\..*", "", AutoOutlier_merged$RefSeq.Protein.Accession)



##Took list of entrez IDs and coverted them to gene names - https://biodbnet-abcc.ncifcrf.gov/db/db2db.php
## RefSeq Protein Accession -> Gene Info

##Took list of entrez IDs and coverted them to gene names - https://biodbnet-abcc.ncifcrf.gov/db/db2db.php
## RefSeq Protein Accession -> Gene Info

# looking for melanogenesis genes -----------------------------------------
# had to remove spaces from col names 
genesymb <- read.csv(file = "data_raw/bioDBnet_db2db_n95_allmethods_genehits.csv")

genesymb_source <- merge(genesymb, AutoOutlier_merged, by.x = "RefSeq.Protein.Accession", by.y = "RefSeq.Protein.Accession.clean")

# Alternative version with more detailed information
ugenehits_detailed <- genesymb_source %>% 
  group_by(Gene.Symbol) %>% 
  summarise(
    # All SNPs (including duplicates if same SNP from multiple sources)
    all_SNPs = paste(SNP, collapse = "; "),
    # All sources
    all_sources = paste(source, collapse = "; "),
    # Unique SNPs only
    unique_SNPs = paste(unique(SNP), collapse = "; "),
    # Unique sources only  
    unique_sources = paste(unique(source), collapse = "; "),
    # Counts
    n_unique_SNPs = length(unique(SNP)),
    n_unique_sources = length(unique(source)),
    total_hits = n(),
    # Flags
    has_multiple_SNPs = length(unique(SNP)) > 1,
    has_multiple_sources = length(unique(source)) > 1,
    .groups = 'drop'
  )

ugenehits_detailed <- ugenehits_detailed[-which(ugenehits_detailed$Gene.Symbol == "-"),]

write.csv(ugenehits_detailed, "results/Unique_gene_hits_n95_ASY_allmethods.csv", row.names = F)

melano <- read.csv("data_raw/Melanogenesis_genes.csv")

melanoSNP <- ugenehits_detailed[which(ugenehits_detailed$Gene.Symbol %in% melano$Melanogenesis_genes),]


keratin <- read.csv("data/Keratin_related_genes_wcitations.csv", header = T) 
head(keratin)

ugene_keratin <- unique(keratin$Gene_Symbol)

keratinsnp <- ugenehits_detailed[which(ugenehits_detailed$Gene.Symbol %in% ugene_keratin),]


asso_relevantSNPs <- unique(c(ugenehits_detailed$unique_SNPs[which(ugenehits_detailed$Gene.Symbol %in% melano$Melanogenesis_genes & ugenehits_detailed$unique_sources == "ANGSD-asso")], 
  ugenehits_detailed$unique_SNPs[which(ugenehits_detailed$Gene.Symbol %in% ugene_keratin  & ugenehits_detailed$unique_sources == "ANGSD-asso")]))

gemma_relevantSNPS<- unique(c(ugenehits_detailed$unique_SNPs[which(ugenehits_detailed$Gene.Symbol %in% melano$Melanogenesis_genes & ugenehits_detailed$unique_sources == "GEMMA")], 
                              ugenehits_detailed$unique_SNPs[which(ugenehits_detailed$Gene.Symbol %in% ugene_keratin  & ugenehits_detailed$unique_sources == "GEMMA")]))



# compare to climate linked lists ----------------------------------------------

ugenehits_detailed <- read.csv("results/Unique_gene_hits_n95_ASY_allmethods.csv")

#env genes
env <- read.table("data_raw/Candidate_Genes_JustChickenGO_Renamed.Grouped.txt", 
                    sep = "\t", header = T)

envSNP <- ugenehits_detailed[which(ugenehits_detailed$Gene.Symbol %in% env$gene),]

# angsd-asso identified genes 
asso_env <- envSNP[which(envSNP$unique_sources == "ANGSD-asso"),]
asso_func <- merge(asso_env, env, by.x = "Gene.Symbol", by.y = "gene")


# make table for paper ----------------------------------------------------

ugenehits_detailed <- ugenehits_detailed[-which(ugenehits_detailed$Gene.Symbol == "-"),]

write.csv(ugenehits_detailed, "results/Unique_gene_hits_n95_ASY_allmethods.csv", row.names = F)

melano <- read.csv("data_raw/Melanogenesis_genes.csv")

melanoSNP <- merge(ugenehits_detailed, melano, by.x = "Gene.Symbol", by.y = "Melanogenesis_genes",
                   all= F)

ugenehits_detailed <- read.csv("results/Unique_gene_hits_n95_ASY_allmethods.csv")

#env genes
env <- read.table("data_raw/Candidate_Genes_JustChickenGO_Renamed.Grouped.txt", 
                  sep = "\t", header = T)

envSNP <- merge(ugenehits_detailed, env, by.x = "Gene.Symbol", by.y = "gene",
                all= F)

#all candidates
cands <- merge(melanoSNP, envSNP, all = T)

#add in LRT/pip score
scores <- sugSNPsall %>% 
  select(SNP, source, gamma, LRT)

candscores <- merge(scores, cands,
                    by.x = c("SNP", "source"),
                    by.y = c("unique_SNPs", "unique_sources")
                    )

cand_tbl <- candscores %>% 
  select(SNP, Gene.Symbol, Detection.method = source, gamma, LRT,
         FunctionList, Citation) %>% 
  filter(Detection.method == "ANGSD-asso" | Detection.method == "BSLMM")


write.csv(cand_tbl, "results/Candidate_genes_table.csv", row.names = F)

# Plot Pip ----------------------------------------------------------------

pip$CHR <- sub(pip$rs, pattern = ":[0-9].*", replacement = "")
pip_chrfix <- pip %>% 
  filter(!grepl("scaffold", CHR) & !grepl("mito", CHR)) %>% 
  mutate(chr = case_when(
    CHR == "chr1a" ~ 1.2,
    CHR == "chr4a" ~ 4.2,
    CHR == "chrz" ~ 30,
    TRUE ~ chr
  ))


pip_ord <- pip_chrfix %>%
  mutate(chr_factor = factor(CHR, levels = gtools::mixedsort(unique(CHR))),  # Convert chr to a factor for better handling
         color = ifelse(as.numeric(chr_factor) %% 2 == 0, "black", "gray70")) %>%  # Alternating color: black for even, gray for odd
  arrange(chr_factor, rs) 

pip_nonzero <- pip_ord[pip_ord$gamma > 0,]
pip_nonzero$color2 <- pip_nonzero$color
pip_nonzero$color2[pip_nonzero$rs == "chr1:23602616"] <- "green"

plot_chrs <- ggplot(pip_nonzero, aes(x = 1:nrow(pip_nonzero), y = gamma, color = color2)) +
  geom_point() +
  scale_color_identity() +  # Use the actual color values in the data
  geom_hline(yintercept = 0.01, color = "blue")+
  geom_text(data = subset(pip_nonzero, rs == "chr1:23602616"),
            aes(x = 1:nrow(subset(pip_nonzero, rs == "chr1:23602616")),
                label = "PLA1A", y = gamma),
            vjust = -0.5, size = 3, color = "black") +
  labs(x = "Genomic Position", y = "log10(PIP)", title = "") +
  scale_y_log10() +
  theme_classic() + theme(axis.title.x = element_text(size = 18), axis.title.y = element_text(size = 18)) +
  theme(axis.text.x = element_blank())  # Hide x-axis text since it is just row order

jpeg("results/PIP_PC1_dorsum_bslmm.jpeg", width = 2000, height = 1000, res = 175)
plot_chrs
dev.off()

manhattan(pip_nonzero, chr = "chr", bp = "ps", snp = "rs", p = "gamma", logp=T, 
          cex.axis = 2, cex.label = 4, annotatePval = 0.01)



# Plot asso ---------------------------------------------------------------

png(file = "results/Asso_gwas_manhattan_n95_ASY_LRT0.0001_lines.png", width = 1000, height = 400)
manhattan(lrt_man, chr = "CHR", bp = "BP", snp = "SNP", p = "LRT", logp=F, 
          cex.axis = 2, cex.label = 4, genomewideline = threshLRTgw, suggestiveline = threshLRTsug)
dev.off()

gene <- c("CAPN3", "GNA11", "GNAI1", "GNAI2",  "GNAI3")
genesnploc <- ugenehits_detailed[ugenehits_detailed$Gene.Symbol %in% gene,]

genesnp <- unique(ugenehits_detailed$unique_SNPs[ugenehits_detailed$Gene.Symbol %in% gene])

png(file = "results/Asso_gwas_manhattan_n95_ASY_colorgenes_highlighted.png", width = 1000, height = 400)
manhattan(lrt_man, chr = "CHR", bp = "BP", snp = "SNP", p = "LRT", logp=F, 
          highlight = genesnp,
          cex.axis = 2, cex.label = 4, genomewideline = threshLRTgw, suggestiveline = threshLRTsug)
dev.off()


gene <- c("CAPN3", "GNA11", "GNAI1", "GNAI2",  "GNAI3", "GNA11", "GNAO1", 
          "GNAT1", "GNAT2", "GNAT3", "GNAZ", 
          "MGAT4A", "MGAT4B", "SLC25A17")

genesnp <- ugenehits_detailed[ugenehits_detailed$Gene.Symbol %in% gene,] %>% 
  select(Gene.Symbol, SNP = unique_SNPs)
