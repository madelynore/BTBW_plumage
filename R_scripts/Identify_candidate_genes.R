## plotting GWAS results

# plotting with manhattan package

if (!require("pacman")) install.packages("pacman")
pacman::p_load_gh("sahirbhatnagar/manhattanly")

library(manhattanly)
library(tidyverse)

gwa <- read.table(file = "data_raw/GWAS_n87_ASY_from_vcf_lumdorsum_lmm_subset.assoc.txt", header = T) 

head(gwa)

#fix chrs 1a,4a,z
gwa_chr <- gwa %>%
  mutate(chr = case_when(
    grepl("chr1a", rs) ~ "1a",
    grepl("chr4a", rs) ~ "4a",
    grepl("chrz", rs) ~ "z",
    TRUE ~ as.character(chr)
  ))

gwa_chr$logp <- -log10(gwa_chr$p_wald)

gwa_ind <- gwa_chr %>%
  mutate(index = case_when(
    chr == "1a" ~ 1.2,
    chr == "4a" ~ 4.2,
    chr == "z" ~ 30,
    TRUE ~ as.numeric(chr)
  ))

# select just chr, snp and pwald
gwa_sub <- gwa_ind %>% 
  dplyr::select(CHR = index, BP = ps, P = p_wald, logp, pos = ps, chr)

manhattanly(gwa_sub)


# looking for hits with suggestive snps -----------------------------------

# BiocManager::install("GenomicRanges")
library(tidyverse)
library(GenomicRanges)

# get SNPs above suggestive line and fix to match warbler.gff
sugSNPs <- gwa_sub[which(gwa_sub$logp > -log10(1e-5)),]

sugSNPs$start <- sugSNPs$BP-20000
sugSNPs$end <- sugSNPs$BP+20000

sugSNPs$chr <- paste0("chr", sugSNPs$chr)

head(sugSNPs)

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

write.csv(AutoOutlier_named, "data/GWAS_n87_ASY_vcf_outlier_genehits20kb.csv", row.names = F)

unique_genehits <- unique(AutoOutlier_named$RefSeq.Protein.Accession)

write.table(unique_genehits, "data/GWAS_n87_ASY_angsdvcf_outlier_unique_genehits20kb.txt", row.names = F, quote = F)

##Took list of entrez IDs and coverted them to gene names - https://biodbnet-abcc.ncifcrf.gov/db/db2db.php
## RefSeq Protein Accession -> Gene Info



# looking for melanogenesis genes -----------------------------------------
# had to remove spaces from col names 
genehits <- read.table("data/bioDBnet_db2db_n87_ASY_vcf_20kb.txt", header = T)

#change locs

genehits$GeneSymbol[which(genehits$GeneSymbol == "LOC100223824")] <- "tspan3"
genehits$GeneSymbol[which(genehits$GeneSymbol == "LOC100217958")] <- "HS3ST1"
genehits$GeneSymbol[which(genehits$GeneSymbol == "LOC100226815")] <- "KLHL3"
genehits$GeneSymbol[which(genehits$GeneSymbol == "LOC100232358")] <- "HS3ST3A1"
genehits$GeneSymbol[which(genehits$GeneSymbol == "LOC100232659")] <- "HS3ST3B1"


ugenesym <- unique(genehits$GeneSymbol)


melano <- read.csv("data_raw/Melanogenesis_genes_Poelstra_etal_2015_moleco.csv")

ugenesym[which(ugenesym %in% melano$Melanogenesis_genes)]
