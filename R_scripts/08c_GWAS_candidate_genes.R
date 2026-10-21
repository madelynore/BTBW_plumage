## Candidate genes near the suggestive GWAS hits (ANGSD-asso hits are window regions since 2026-10-16)

# Run after 08a_GWAS_BSLMM_SNPs.R (BSLMM SNPs with mean PIP >= 0.01) and 08b_GWAS_ANGSD_asso_windows.R (ANGSD-asso
# regions: merged 50-SNP windows above the null line or the observed line, both 99.99th percentiles).
#   1. the hits of both methods: BSLMM SNPs (a point) and ANGSD window regions (start-end); a BSLMM SNP inside an
#      ANGSD region is flagged in_other_method on both rows (rows are kept separate)
#   2. search intervals = hit +/- 25 kb
#   3. genes in those regions: protein_match features of the Yellow-rumped Warbler annotation (GFF), with GenomicRanges
#   4. gene symbols for the RefSeq protein accessions: bioDBnet db2db (RefSeq Protein Accession -> Gene Symbol); the
#      tables in data_raw/gene_lists/ cover every accession in the genome (~58% have a symbol)
#   5. one row per gene with its hits and methods (results/gwas/Unique_gene_hits_<prefix>.csv)
#   6. comparison with melanogenesis genes (data_raw/gene_lists/Melanogenesis_genes.csv) and with genes linked to environmental
#      adaptation (data/gwas/Environmental_adaptation_genes.csv: Gene, Function, Reference, Source)
#   7. table for the paper (results/gwas/Candidate_genes_table_<prefix>.csv)
# Note: several proteins (paralogs, other species) often align to one locus, so names at one locus are alternatives
# for the same gene; "loci" (hits within 50 kb of each other) are reported alongside.

library(tidyverse)
library(data.table)
library(GenomicRanges)
library(here)

# Settings -----------------------------------------------------------------------------------------------------
prefix      <- "btbw_n152_allages_lumMean_m_cc"
flank       <- 25000
gff_file    <- "/Users/madelynore/Documents/Work/PhD/Genoscape BTBW/BTBW-GEA/data/mywagenomev2.1.all.noseq.gff"   # full annotation
melano_file <- here("data_raw/gene_lists/Melanogenesis_genes.csv")
env_file    <- here("data/gwas/Environmental_adaptation_genes.csv")


# 1. suggestive hits from both methods -------------------------------------------------------------------------------
hits_bslmm <- fread(here(paste0("data/gwas/GWAS_", prefix, "_BSLMM_SNPs.csv"))) %>%
  transmute(chr = Chromosome, start_hit = Position, end_hit = Position, hit = SNP, gamma = mean_pip, n_chains, beta,
            source = "BSLMM")
hits_asso <- fread(here(paste0("data/gwas/GWAS_", prefix, "_ANGSD_window_regions.csv"))) %>%
  transmute(chr = Chromosome, start_hit = start_bp, end_hit = end_bp,
            hit = sprintf("%s:%.3f-%.3fMb", Chromosome, start_bp / 1e6, end_bp / 1e6),
            LRT_median = max_LRT_median, n_windows, above_observed_line, above_null_line,
            source = "ANGSD-asso windows")
hits <- bind_rows(hits_bslmm, hits_asso) %>% arrange(chr, start_hit)

# a BSLMM SNP inside an ANGSD region: flagged on both rows
both <- hits_bslmm %>% inner_join(hits_asso, by = "chr", suffix = c("", ".r"), relationship = "many-to-many") %>%
  filter(start_hit >= start_hit.r, start_hit <= end_hit.r)
hits <- hits %>% mutate(in_other_method = hit %in% c(both$hit, both$hit.r))

# loci: hits within 50 kb of each other
hits <- hits %>%
  group_by(chr) %>% mutate(locus_id = cumsum(c(TRUE, start_hit[-1] - cummax(end_hit)[-n()] > 50000))) %>%
  group_by(chr, locus_id) %>% mutate(locus = paste0(chr[1], ":", round(min(start_hit) / 1e6, 2), "Mb")) %>% ungroup() %>% select(-locus_id)

cat("Suggestive hits:", nrow(hits), "| BSLMM SNPs", nrow(hits_bslmm), "| ANGSD-asso window regions", nrow(hits_asso),
    "| BSLMM SNPs inside an ANGSD region", nrow(both), "| loci", n_distinct(hits$locus), "\n")


# 2. search intervals: hit +/- 25 kb --------------------------------------------------------------------------------
hits$start <- hits$start_hit - flank
hits$end   <- hits$end_hit + flank
sugSNPs <- hits   # name used below


# 3. genes in the regions (GFF protein matches) -----------------------------------------------------------------------
# only the protein_match lines are needed, so they are filtered while reading (the full GFF is 600 MB)
warbler.gff_mrna <- fread(cmd = sprintf("awk -F'\\t' '$3 == \"protein_match\"' '%s'", gff_file), header = FALSE, sep = "\t", quote = "")
setnames(warbler.gff_mrna, paste0("V", seq_len(ncol(warbler.gff_mrna))))

r.autooutliers <- GRanges(sugSNPs$chr, IRanges(start = sugSNPs$start, end = sugSNPs$end))
r.gff_mrna     <- GRanges(warbler.gff_mrna$V1, IRanges(start = warbler.gff_mrna$V4, end = warbler.gff_mrna$V5))
fo.autosomal   <- findOverlaps(r.autooutliers, r.gff_mrna)

AutoOutlier_named <- warbler.gff_mrna[subjectHits(fo.autosomal), ] %>%
  dplyr::rename(Chr = V1, dbsource = V2, type = V3, start = V4, end = V5, gene.hit = V9) %>%
  mutate(RefSeq.Protein.Accession = str_extract(gene.hit, "(XP|NP)_[A-Za-z0-9_.]+"))
# repeatrunner matches carry GenBank accessions instead
repeatrunner_condition <- is.na(AutoOutlier_named$RefSeq.Protein.Accession) & AutoOutlier_named$dbsource == "repeatrunner"
AutoOutlier_named$RefSeq.Protein.Accession[repeatrunner_condition] <-
  str_extract(AutoOutlier_named$gene.hit[repeatrunner_condition], "(AAA|AAL|A)[0-9]+\\.?[0-9]*")

setDT(AutoOutlier_named); setDT(sugSNPs)
setkey(AutoOutlier_named, Chr, start, end)
setkey(sugSNPs, chr, start, end)
AutoOutlier_merged <- foverlaps(AutoOutlier_named, sugSNPs, by.x = c("Chr", "start", "end"), by.y = c("chr", "start", "end"),
                                type = "any", nomatch = 0L)
AutoOutlier_merged[, RefSeq.Protein.Accession.clean := gsub("\\..*", "", RefSeq.Protein.Accession)]
# distance from the hit (SNP or region) to the protein alignment (0 = overlapping)
AutoOutlier_merged[, distance_kb := pmax(0, i.start - end_hit, start_hit - i.end) / 1000]

write.csv(AutoOutlier_merged, here(paste0("data/gwas/GWAS_", prefix, "_outlier_genehits25kb.csv")), row.names = FALSE)
unique_genehits <- unique(AutoOutlier_merged$RefSeq.Protein.Accession.clean)
write.table(unique_genehits, here(paste0("data/gwas/GWAS_", prefix, "_outlier_unique_genehits25kb.txt")), row.names = FALSE, quote = FALSE, col.names = FALSE)
cat("Protein matches within 25 kb:", nrow(AutoOutlier_merged), "| unique accessions:", length(unique_genehits), "\n")


# 4b. gene symbols from NCBI (current RefSeq records) ---------------------------------------
# every accession in the genome is looked up in NCBI Protein (gene name = the /gene qualifier of the protein record).
# The lookup takes ~10 min and is cached in data_raw/gene_lists/.
library(rentrez)

ncbi_file  <- here("data_raw/gene_lists/NCBI_protein_to_gene_symbol.csv")
genome_acc <- warbler.gff_mrna[V2 != "repeatrunner", unique(str_extract(V9, "(XP|NP|YP)_[0-9]+"))]

if (!file.exists(ncbi_file)) {
  parse_gp <- function(txt) {
    recs <- strsplit(txt, "\n//\n", fixed = TRUE)[[1]]
    recs <- recs[grepl("\nVERSION", recs)]
    tibble(RefSeq.Protein.Accession = str_match(recs, "\nVERSION\\s+([A-Z]{2}_[0-9]+)")[, 2],
           Gene.Symbol = str_match(recs, '/gene="([^"]+)"')[, 2],
           GeneID      = str_match(recs, "GeneID:([0-9]+)")[, 2],
           Organism    = str_match(recs, "\n  ORGANISM  ([^\n]+)")[, 2])
  }
  fetch_gp <- insistently(entrez_fetch, rate_backoff(max_times = 3))   # retry if NCBI times out
  batches  <- split(genome_acc, ceiling(seq_along(genome_acc) / 200))
  ncbi <- map_dfr(seq_along(batches), function(i) {
    if (i %% 20 == 0) cat("batch", i, "of", length(batches), "\n")
    txt <- fetch_gp(db = "protein", id = batches[[i]], rettype = "gp", retmode = "text")
    Sys.sleep(0.4)   # NCBI allows 3 requests/s without an API key
    parse_gp(txt)
  })
  write.csv(ncbi, ncbi_file, row.names = FALSE)
}
ncbi <- fread(ncbi_file)

# accession by accession: same symbol, different symbol, or found by only one method
cmp <- tibble(RefSeq.Protein.Accession = genome_acc) %>%
  left_join(ncbi %>% select(RefSeq.Protein.Accession, NCBI = Gene.Symbol), by = "RefSeq.Protein.Accession") %>%
  left_join(as_tibble(genesymb) %>% select(RefSeq.Protein.Accession, bioDBnet = Gene.Symbol), by = "RefSeq.Protein.Accession") %>%
  mutate(status = case_when(is.na(NCBI) & is.na(bioDBnet) ~ "no symbol",
                            is.na(bioDBnet)                ~ "NCBI only",
                            is.na(NCBI)                    ~ "bioDBnet only",
                            toupper(NCBI) == toupper(bioDBnet) ~ "same",
                            TRUE                           ~ "different"))
print(count(cmp, status))
write.csv(filter(cmp, status == "different"), here("data_raw/gene_lists/bioDBnet_vs_NCBI_different_symbols.csv"), row.names = FALSE)

cat("Unique genes in the hits:", uniqueN(genesymb_source$Gene.Symbol), "\n")
# background for the hypergeometric test (symbols in upper case: proteins come from several bird species)
named_genome_ncbi <- unique(toupper(na.omit(ncbi$Gene.Symbol)))
cat("Unique gene symbols in the genome: NCBI", length(named_genome_ncbi),
    "(", sum(!grepl("^LOC", named_genome_ncbi)), "without LOC ) | bioDBnet", n_distinct(toupper(genesymb$Gene.Symbol)), "\n")

# to use the NCBI symbols downstream, replace genesymb and rerun the merge from section 4:
genesymb <- ncbi[!is.na(Gene.Symbol), .(RefSeq.Protein.Accession, Gene.Symbol = toupper(Gene.Symbol))]
genesymb_source <- merge(genesymb, AutoOutlier_merged, by.x = "RefSeq.Protein.Accession", by.y = "RefSeq.Protein.Accession.clean")

# 5. one row per gene -------------------------------------------------------------------------------------------------
ugenehits_detailed <- genesymb_source %>%
  group_by(Gene.Symbol) %>%
  summarise(
    unique_hits = paste(unique(hit), collapse = "; "),
    unique_sources = paste(unique(source), collapse = "; "),
    loci = paste(unique(locus), collapse = "; "),
    nearest_kb = min(distance_kb),
    n_unique_hits = n_distinct(hit),
    n_unique_sources = n_distinct(source),
    best_PIP = suppressWarnings(max(gamma, na.rm = TRUE)),
    best_LRT_median = suppressWarnings(max(LRT_median, na.rm = TRUE)),
    has_multiple_hits = n_distinct(hit) > 1,
    has_multiple_sources = n_distinct(source) > 1,
    .groups = "drop") %>%
  mutate(across(c(best_PIP, best_LRT_median), ~ ifelse(is.infinite(.x), NA, .x)))
write.csv(ugenehits_detailed, here(paste0("results/gwas/Unique_gene_hits_", prefix, ".csv")), row.names = FALSE)
cat("Named genes within 25 kb:", nrow(ugenehits_detailed), "at", n_distinct(unlist(strsplit(ugenehits_detailed$loci, "; "))), "loci\n")


# one row per hit with its genes, nearest first (used by 08d for the plot labels)
melano_list <- read.csv(melano_file)$Melanogenesis_genes
per_hit <- genesymb_source %>% group_by(hit, Gene.Symbol) %>% summarise(d = min(distance_kb), .groups = "drop") %>% arrange(hit, d) %>%
  group_by(hit) %>% summarise(genes = paste(sprintf("%s (%s)", Gene.Symbol, ifelse(d == 0, "inside", sprintf("%.0f kb", d))), collapse = ", "),
                              melanogenesis_genes = paste(Gene.Symbol[Gene.Symbol %in% melano_list], collapse = ", "), .groups = "drop")
hit_genes <- as_tibble(sugSNPs) %>% left_join(per_hit, by = "hit") %>%
  mutate(genes = case_when(!is.na(genes) ~ genes, hit %in% AutoOutlier_merged$hit ~ "unnamed protein(s) only", TRUE ~ "no gene within 25 kb"),
         melanogenesis_genes = coalesce(melanogenesis_genes, "")) %>%
  transmute(Chromosome = chr, start = start_hit, end = end_hit, hit, source, locus, in_other_method, PIP = gamma, n_chains,
            LRT_median, n_windows, above_observed_line, above_null_line, genes, melanogenesis_genes)
write.csv(hit_genes, here(paste0("data/gwas/GWAS_", prefix, "_suggestive_hits_genes.csv")), row.names = FALSE)


# 6. melanogenesis and environmental-adaptation genes ---------------------------------------------------------------
melano <- read.csv(melano_file)
melano <- melano[melano$Melanogenesis_genes != "", ]
melanoSNP <- merge(ugenehits_detailed, melano, by.x = "Gene.Symbol", by.y = "Melanogenesis_genes", all = FALSE)

# environmental adaptation genes (note: the list also includes some pigmentation genes and GO terms, e.g. MC1R)
env <- read.csv(env_file)
envSNP <- merge(ugenehits_detailed, env, by.x = "Gene.Symbol", by.y = "Gene", all = FALSE)

named_genome <- unique(genesymb$Gene.Symbol)
cat(sprintf("Melanogenesis genes: %d (%s)",
            nrow(melanoSNP), paste(melanoSNP$Gene.Symbol, collapse = ", ")))
cat("Environmental adaptation genes:", nrow(envSNP), "(", paste(envSNP$Gene.Symbol, collapse = ", "), ")\n")


# 7. table for the paper ----------------------------------------------------------------------------------------------
cands <- bind_rows(
  melanoSNP %>% transmute(Gene.Symbol, list = "Melanogenesis", Function = "Melanogenesis", Citation),
  envSNP %>% transmute(Gene.Symbol, list = "Environmental adaptation", Function, Citation = Reference))

# add the hits and their scores (one row per gene x hit)
scores <- genesymb_source %>% distinct(Gene.Symbol, hit, source, locus, gamma, LRT_median, distance_kb)
cand_tbl <- cands %>%
  left_join(scores, by = "Gene.Symbol", relationship = "many-to-many") %>%
  group_by(Gene.Symbol, hit) %>%
  summarise(Detection.method = dplyr::first(source), locus = dplyr::first(locus), distance_kb = min(distance_kb),
            PIP = dplyr::first(gamma), LRT_median = dplyr::first(LRT_median),
            Lists = paste(unique(list), collapse = "; "), Function = paste(unique(na.omit(Function)), collapse = "; "),
            Citation = paste(unique(na.omit(Citation[Citation != ""])), collapse = "; "), .groups = "drop") %>%
  arrange(desc(LRT_median), desc(PIP))
write.csv(cand_tbl, here(paste0("results/gwas/Candidate_genes_table_", prefix, ".csv")), row.names = FALSE)
print(cand_tbl, n = 50)
