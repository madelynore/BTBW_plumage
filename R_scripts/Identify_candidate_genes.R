## plotting GWAS results

# plotting with manhattan package - for log10 pval

if (!require("pacman")) install.packages("pacman")
pacman::p_load_gh("sahirbhatnagar/manhattanly")

library(manhattanly)
library(tidyverse)

gwa <- read.table(file = "data_raw/GWAS_n95_ASY_gatk_fromvcf_dorsumPC_lmm_subset.assoc.txt", header = T) 

gwa_rand <- read.table(file = "data_raw/GWAS_n95_ASY_gatk_fromvcf_impute_rand_assign_dorsumPC_lmm_subset.assoc.txt", header = T) 

head(gwa)

process_gwa <- function(gwa) {
  # Fix chromosome names
  gwa_chr <- gwa %>%
    mutate(chr = case_when(
      grepl("chr1a", rs) ~ "1a",
      grepl("chr4a", rs) ~ "4a",
      grepl("chrz", rs) ~ "z",
      TRUE ~ as.character(chr)
    ))
  
  # Calculate -log10(p_wald)
  gwa_chr <- gwa_chr %>%
    mutate(logp = -log10(p_wald))
  
  # Assign index values for chromosomes
  gwa_ind <- gwa_chr %>%
    mutate(index = case_when(
      chr == "1a" ~ 1.2,
      chr == "4a" ~ 4.2,
      chr == "z" ~ 30,
      TRUE ~ as.numeric(chr)
    ))
  
  # Select relevant columns
  gwa_sub <- gwa_ind %>%
    dplyr::select(CHR = index, BP = ps, P = p_wald, logp, pos = ps, chr)
  
  return(gwa_sub)
}

gwa_man <- process_gwa(gwa)

gwa_rand_man <- process_gwa(gwa_rand)

manhattanly(gwa_man, genomewideline = -log10(1e-07))
manhattanly(gwa_rand_man, genomewideline = -log10(1e-07))

pdf(file = "results/GEMMA_lrt_manhattan_n95_ASY.pdf", width = 12, height = 8)
fastman::fastman(gwa_man, chr = "CHR", bp = "BP", p = "P",logp = T, sortchr = T, maxP = max(gwa_man$logp), 
                 ylim = c(min(gwa_man$logp), max(gwa_man$logp)), 
                 speedup=F, col="rgbs",cex=0.5,xlab="Chromosome",ylab="-log10(p)",cex.axis = 1)
dev.off()
# LRT from angsd-asso -----------------------------------------------------

lrt <- read.table("data_raw/btbw_n95_ASY_gatk_maxmiss20_minQ30_maf05_ds2x_minInd66_maxd400_impute_PC1cov_asso5.lrt0.gz")
#fix col names as headers
colnames(lrt) <- lrt[1,]
lrt <- lrt[-1,]

process_lrt <- function(lrt) {
  lrt$chr <- sub(pattern = "^chr", replacement = "", lrt$Chromosome)
  # Assign index values for chromosomes
  lrt_ind <- lrt %>%
    mutate(chr = case_when(
      chr == "1a" ~ 1.2,
      chr == "4a" ~ 4.2,
      chr == "z" ~ 30,
      TRUE ~ as.numeric(chr)
    ))
  
  lrt_ind$Position <- as.numeric(lrt_ind$Position)
  lrt_ind$LRT <- as.numeric(lrt_ind$LRT) 
  
  # Select relevant columns
  lrt_sub <- lrt_ind %>%
    dplyr::select(CHR = chr, BP = Position, LRT, Chromosome) %>% 
    filter(LRT > -999)
  
  return(lrt_sub)
}

lrt_man <- process_lrt(lrt)

pdf(file = "results/Asso_lrt_manhattan_n95_ASY.pdf", width = 12, height = 8)
fastman::fastman(lrt_man, chr = "CHR", bp = "BP", p = "LRT",logp = F, sortchr = T, maxP = max(lrt_man$LRT), 
        speedup=T, col="rgbs",cex=0.5,xlab="Chromosome",ylab="LRT",cex.axis = 1)
dev.off()

quantile(lrt_man$LRT, probs = 0.9999)

threshold <- fread("data/LRT_threshold_0.00001.tsv")

thresh_man <- process_lrt(threshold)
fastman::fastman(thresh_man, chr = "CHR", bp = "BP", p = "LRT",logp = F, sortchr = T, maxP = max(lrt_man$LRT), 
                 speedup=T, col="rgbs",cex=0.5,xlab="Chromosome",ylab="LRT",cex.axis = 1)
#this looks weird... nothing below 5?
significant <- lrt_man[lrt_man$LRT>threshold$LRT,]
# looking for hits with suggestive snps - GEMMA -----------------------------------

# BiocManager::install("GenomicRanges")
library(tidyverse)
library(GenomicRanges)

# get SNPs above suggestive line and fix to match warbler.gff
sugSNPs <- gwa_man[which(gwa_man$logp > -log10(1e-5)),]

sugSNPs$start <- sugSNPs$BP-20000
sugSNPs$end <- sugSNPs$BP+20000

sugSNPs$chr <- paste0("chr", sugSNPs$chr)

head(sugSNPs)

regions4fasta <- sugSNPs %>% 
  dplyr::select(chr, start, end)

write_tsv(regions4fasta, file = "data/suggestive_SNPs_regions_n95_ASY_gatk_vcf_20kb.bed",
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
  dplyr::rename(Chr = V1, `source` = V2, `type` = V3, `start` = V4, `end` = V5, `gene.hit` = V9)

# extract XP 
AutoOutlier_named$RefSeq.Protein.Accession <- str_extract(AutoOutlier_named$gene.hit, "(XP|NP)_[A-Za-z0-9_.]+")
# Identify rows where extraction is NA and the source is "repeatrunner"
repeatrunner_condition <- is.na(AutoOutlier_named$RefSeq.Protein.Accession ) & AutoOutlier_named$source == "repeatrunner"

# For rows meeting the condition, extract AAA, AAL, A patterns
AutoOutlier_named$RefSeq.Protein.Accession[repeatrunner_condition] <- str_extract(AutoOutlier_named$gene.hit[repeatrunner_condition], "(AAA|AAL|A)[0-9]+\\.?[0-9]*")
head(AutoOutlier_named)
length(unique(AutoOutlier_named$RefSeq.Protein.Accession))

write.csv(AutoOutlier_named, "data/GWAS_n95_ASY_gatk_vcf_outlier_genehits20kb.csv", row.names = F)

unique_genehits <- unique(AutoOutlier_named$RefSeq.Protein.Accession)

write.table(unique_genehits, "data/GWAS_n95_ASY_gatk_vcf_outlier_unique_genehits20kb.txt", row.names = F, quote = F)

##Took list of entrez IDs and coverted them to gene names - https://biodbnet-abcc.ncifcrf.gov/db/db2db.php
## RefSeq Protein Accession -> Gene Info


# looking for hits with suggestive snps - Angsd-asso -----------------------------------

# BiocManager::install("GenomicRanges")
library(tidyverse)
library(GenomicRanges)

# get SNPs above suggestive line and fix to match warbler.gff
sugSNPs <- lrt_man[which(lrt_man$LRT > quantile(lrt_man$LRT, probs = 0.9999)),]

sugSNPs$start <- sugSNPs$BP-20000
sugSNPs$end <- sugSNPs$BP+20000

sugSNPs$chr <- paste0("chr", sugSNPs$chr)

head(sugSNPs)

regions4fasta <- sugSNPs %>% 
  dplyr::select(Chromosome, start, end)

write_tsv(regions4fasta, file = "data/suggestive_SNPs_regions_n95_ASY_gatk_asso_20kb.bed",
          quote = "none", col_names = F)

warbler.gff<-read.delim("/Users/madelynore/Documents/Cornell/Genoscape BTBW/BTBW-GEA/data/mywagenomev2.1.all.noseq.gff", header=F, comment.char="#") #full gff
warbler.gff_mrna<-warbler.gff %>% filter (V3=="protein_match") #only keep the mRNA entries since these are the tracks we are interested in
head(warbler.gff_mrna)

####use Genomic Ranges packages to extract gene names in those peaks####
#set up dataframes for the package to use
r.autooutliers<-GRanges(sugSNPs$Chromosome, IRanges(start=sugSNPs$start, end=sugSNPs$end))
r.gff_mrna<-GRanges(warbler.gff_mrna$V1, IRanges(start=warbler.gff_mrna$V4, end=warbler.gff_mrna$V5))

#find overlaps
##Autosomal Outliers
fo.autosomal<-findOverlaps(r.autooutliers,r.gff_mrna)

AutoOutlier_genes<-warbler.gff_mrna[subjectHits(fo.autosomal),] #these are all the genes (and associated gff info) in the elevated windows

head(AutoOutlier_genes)
#rename columns
AutoOutlier_named <- AutoOutlier_genes %>% 
  dplyr::rename(Chr = V1, `source` = V2, `type` = V3, `start` = V4, `end` = V5, `gene.hit` = V9)

# extract XP 
AutoOutlier_named$RefSeq.Protein.Accession <- str_extract(AutoOutlier_named$gene.hit, "(XP|NP)_[A-Za-z0-9_.]+")
# Identify rows where extraction is NA and the source is "repeatrunner"
repeatrunner_condition <- is.na(AutoOutlier_named$RefSeq.Protein.Accession ) & AutoOutlier_named$source == "repeatrunner"

# For rows meeting the condition, extract AAA, AAL, A patterns
AutoOutlier_named$RefSeq.Protein.Accession[repeatrunner_condition] <- str_extract(AutoOutlier_named$gene.hit[repeatrunner_condition], "(AAA|AAL|A)[0-9]+\\.?[0-9]*")
head(AutoOutlier_named)
length(unique(AutoOutlier_named$RefSeq.Protein.Accession))

write.csv(AutoOutlier_named, "data/GWAS_n95_ASY_gatk_asso_outlier_genehits20kb.csv", row.names = F)

unique_genehits <- unique(AutoOutlier_named$RefSeq.Protein.Accession)

write.table(unique_genehits, "data/GWAS_n95_ASY_gatk_asso_outlier_unique_genehits20kb.txt", row.names = F, quote = F)

##Took list of entrez IDs and coverted them to gene names - https://biodbnet-abcc.ncifcrf.gov/db/db2db.php
## RefSeq Protein Accession -> Gene Info

genehits_gemma <- read.table("data/GWAS_n94_ASY_vcf_outlier_unique_genehits20kb.txt")
genehits_asso <- read.table("data/GWAS_n95_ASY_gatk_asso_outlier_unique_genehits20kb.txt")
intersect(genehits_gemma, genehits_asso)

# looking for melanogenesis genes -----------------------------------------
# had to remove spaces from col names 
genesymb_gemma <- read_table(file = "results/bioDBnet_db2db_Gene_symb_n95_ASY_gatk_gemma.txt")
genesymb_asso <- read_table(file = "results/Gene_symbol_n95_ASY_gatk_asso.txt", col_names = F)


ugenesym <- unique(genesymb_gemma$Gene_Symbol)

write.table(ugenesym, "results/unique_gene_hits_n95_ASY_gatk_vcf_20kb.txt", quote = F,
            row.names = F)
melano <- read.csv("data_raw/Melanogenesis_genes.csv")

ugenesym[which(ugenesym %in% melano$Melanogenesis_genes)]
genehits_asso[which(genehits_asso$V1 %in% melano$Melanogenesis_genes)]

