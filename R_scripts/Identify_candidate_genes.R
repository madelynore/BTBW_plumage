## plotting GWAS results

# plotting with manhattan package - for log10 pval

if (!require("pacman")) install.packages("pacman")
pacman::p_load_gh("sahirbhatnagar/manhattanly")

library(manhattanly)
library(qqman)
library(tidyverse)
library(data.table)

gwa <- read.table(file = "data_raw/GWAS_n95_ASY_gatk_fromvcf_dorsumPC_lmm_subset.assoc.txt", header = T) 

gwa_rand <- read.table(file = "data_raw/GWAS_n95_ASY_gatk_fromvcf_impute_rand_assign_dorsumPC_lmm_subset.assoc.txt", header = T) 

head(gwa)

process_gwa <- function(gwa) {
  #no scaffolds
  gwa_filt <- gwa[!grepl("scaffold", gwa$rs, ignore.case = TRUE), ]
  
  # Fix chromosome names
  gwa_chr <- gwa_filt %>%
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
  
  gwa_ind$SNP <- sub(gwa_ind$rs, pattern = ":", replacement = "_")
  
  # Select relevant columns
  gwa_sub <- gwa_ind %>%
    dplyr::select(CHR = index, BP = ps, P = p_wald, logp, pos = ps, SNP, chr)
  
  return(gwa_sub)
}

gwa_man <- process_gwa(gwa)

gwa_rand_man <- process_gwa(gwa_rand)

png(file = "results/GEMMA_gwas_manhattan_n95_ASY.png", width = 1500, height = 400)
manhattan(gwa_man, chr = "CHR", bp = "BP", snp = "SNP", p = "P", logp=T,
          cex.axis = 2, cex.lab = 2)
dev.off()

png(file = "results/GEMMA_highlighted_gwas_manhattan_n95_ASY.png", width = 1500, height = 400)
# Highlight by SNP names
manhattan(gwa_man, chr = "CHR", bp = "BP", snp = "SNP", p = "P", logp=T,
          cex.axis = 2, cex.lab = 2, 
          highlight = gemma_relevantSNPS,
          highlightCol = "red",
          cex.highlight = 8, cex.annotate = 1.8)
dev.off()


manhattanly(gwa_rand_man, genomewideline = -log10(1e-07))

fastman::fastman(gwa_man, chr = "CHR", bp = "BP", p = "P",logp = T, sortchr = T, maxP = max(gwa_man$logp), 
                 ylim = c(min(gwa_man$logp), max(gwa_man$logp)), 
                 speedup=F, col="rgbs",cex=0.5,xlab="Chromosome",ylab="-log10(p)",cex.axis = 1)
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

png(file = "results/Asso_gwas_manhattan_n95_ASY.png", width = 1500, height = 400)
manhattan(lrt_man, chr = "CHR", bp = "BP", snp = "SNP", p = "LRT", logp=F, 
          cex.axis = 2, cex.label = 2, genomewideline = F, suggestiveline = F)
dev.off()

png(file = "results/Asso_highlighted_gwas_manhattan_n95_ASY.png", width = 1500, height = 400)
manhattan(lrt_man, chr = "CHR", bp = "BP", snp = "SNP", p = "LRT", logp=F, 
          cex.axis = 2, cex.label = 2, genomewideline = F, suggestiveline = F, 
          highlight = asso_relevantSNPs)
dev.off()


pdf(file = "results/Asso_lrt_manhattan_n95_ASY.pdf", width = 12, height = 8)
fastman::fastman(lrt_man, chr = "CHR", bp = "BP", p = "LRT",logp = F, sortchr = T, maxP = max(lrt_man$LRT), 
        speedup=T, col="rgbs",cex=0.5,xlab="Chromosome",ylab="LRT",cex.axis = 1)
dev.off()

quantile(lrt_man$LRT, probs = 0.9999)

threshold <- fread("data/LRT_threshold_0.00001.tsv") %>% 
  rename(LRTscore = LRT)

thresh_man <- process_lrt(threshold)
fastman::fastman(thresh_man, chr = "CHR", bp = "BP", p = "LRT",logp = F, sortchr = T, maxP = max(lrt_man$LRT), 
                 speedup=T, col="rgbs",cex=0.5,xlab="Chromosome",ylab="LRT",cex.axis = 1)
#this looks weird... nothing below 5?
significant <- lrt_man[lrt_man$LRT>threshold$LRT,]
# looking for hits with suggestive snps -----------------------------------

# BiocManager::install("GenomicRanges")
library(tidyverse)
library(GenomicRanges)

# get SNPs above suggestive line and fix to match warbler.gff
sugSNPsgemma <- gwa_man[which(gwa_man$logp >= -log10(1e-5)),]
sugSNPsgemma$chr <- paste0("chr", sugSNPsgemma$chr)
sugSNPsasso <- lrt_man[which(lrt_man$LRT >= quantile(lrt_man$LRT, probs = 0.9999)),] 


#check for replicates 
intersect(sugSNPsgemma$SNP, sugSNPsasso$SNP)

sugSNPs <- merge(sugSNPsgemma, sugSNPsasso, by.x = c("CHR", "BP", "SNP", "chr"), by.y = c("CHR", "BP", "SNP", "Chromosome"),
                 all = T) %>% 
  mutate(source = case_when(
    !is.na(LRT) & !is.na(P) ~ "both",
    !is.na(P) ~ "GEMMA",
    !is.na(LRT) ~ "ANGSD-asso",
    TRUE ~ NA_character_
  ))



sugSNPs$start <- sugSNPs$BP-25000
sugSNPs$end <- sugSNPs$BP+25000

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


write.csv(AutoOutlier_merged, "data/GWAS_n95_ASY_gatk_vcf_outlier_genehits25kb.csv", row.names = F)

unique_genehits <- unique(AutoOutlier_merged$RefSeq.Protein.Accession)

write.table(unique_genehits, "data/GWAS_n95_ASY_gatk_vcf_outlier_unique_genehits25kb.txt", row.names = F, quote = F)

AutoOutlier_merged$RefSeq.Protein.Accession.clean <- gsub("\\..*", "", AutoOutlier_merged$RefSeq.Protein.Accession)



##Took list of entrez IDs and coverted them to gene names - https://biodbnet-abcc.ncifcrf.gov/db/db2db.php
## RefSeq Protein Accession -> Gene Info

##Took list of entrez IDs and coverted them to gene names - https://biodbnet-abcc.ncifcrf.gov/db/db2db.php
## RefSeq Protein Accession -> Gene Info

# looking for melanogenesis genes -----------------------------------------
# had to remove spaces from col names 
genesymb <- read.csv(file = "data_raw/bioDBnet_db2db_n95_asso_gemma_genehits.csv")

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

write.csv(ugenehits_detailed, "results/Unique_gene_hits_n95_ASY_asso_gemma.csv", row.names = F)

melano <- read.csv("data_raw/Melanogenesis_genes.csv")

ugenehits_detailed[which(ugenehits_detailed$Gene.Symbol %in% melano$Melanogenesis_genes),]


keratin <- read.csv("data_raw/Keratin_related_genes.csv", header = F) %>% 
  dplyr::select(V3, V5, V10)
head(keratin)

ugene_keratin <- unique(keratin$V3)

ugenehits_detailed[which(ugenehits_detailed$Gene.Symbol %in% ugene_keratin),]


asso_relevantSNPs <- unique(c(ugenehits_detailed$unique_SNPs[which(ugenehits_detailed$Gene.Symbol %in% melano$Melanogenesis_genes & ugenehits_detailed$unique_sources == "ANGSD-asso")], 
  ugenehits_detailed$unique_SNPs[which(ugenehits_detailed$Gene.Symbol %in% ugene_keratin  & ugenehits_detailed$unique_sources == "ANGSD-asso")]))

gemma_relevantSNPS<- unique(c(ugenehits_detailed$unique_SNPs[which(ugenehits_detailed$Gene.Symbol %in% melano$Melanogenesis_genes & ugenehits_detailed$unique_sources == "GEMMA")], 
                              ugenehits_detailed$unique_SNPs[which(ugenehits_detailed$Gene.Symbol %in% ugene_keratin  & ugenehits_detailed$unique_sources == "GEMMA")]))
