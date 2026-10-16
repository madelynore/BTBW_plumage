# ANGSD and GEMMA match birds by row position only, so every file is in that order.
# Phenotype: card-corrected mean mantle luminance 
#
# Age: ANGSD takes covariates (age class + genomic PC1). GEMMA BSLMM takes
# none, so its phenotypes are age-adjusted: the residuals of phenotype ~ age class (0 = ASY, 1 = SY).
#
# Writes data/gwas_inputs/ (copy into inputs/ on the server):
#   yQuant_<phenotype>.txt      ANGSD -yQuant, one value per line
#   age_SY.txt                  0 = ASY, 1 = SY
#   gemma_phenotypes.txt        GEMMA -p, one column per phenotype (picked with -n; KEY file lists the columns)
#   gemma_covariates_intercept_age.txt   GEMMA -c (LMM only): column of 1s + age
#   yQuant_lumMean_m_cc_perm200_withinage.tsv    200 shuffles within age class (the ANGSD permutation null)
#   phenotype_table.tsv         everything above with bird IDs, for checking

library(tidyverse)
library(here)

out <- here("data/gwas_inputs"); dir.create(out, showWarnings = FALSE)
set.seed(20260929)

# loco-pipe sample table of the n = 152 run (docs/sample_table.tsv on the server; bird order of the beagle files)
s <- read_tsv(here("data_raw/gwas/gwas_allages/sample_table.tsv"), show_col_types = FALSE) %>%
  mutate(ID = as.integer(sub("^Z", "", sample_name)))
stopifnot(!anyNA(s$age_SY), all(s$age_SY == (s$Age == "SY")), !any(duplicated(s$ID)))

cc <- read.csv(here("data/photos/BTBW_whole_specimen_Image_Analysis_measurements_allpop_avgimg_wide.csv")) %>%
  select(ID, lumMean_m_cc = lumMean_m)
s <- left_join(s, cc, by = "ID")
stopifnot("Some birds have no phenotype" = !anyNA(s[, c("lumMean_m", "lumMean_m_cc")]))
r <- cor(s$lumMean_m, s$lumMean_m_cc)
cat(nrow(s), "birds:", sum(s$Age == "ASY"), "ASY,", sum(s$Age == "SY"), "SY | r(measured, data/ luminance) =", round(r, 3), "\n")
if (r > 0.99) warning("The data/ wide file holds the measured luminance: run 01_data_cleaning.R with use_card_corrected <- TRUE")

# age-adjusted phenotypes for BSLMM; one free shuffle per phenotype (first permuted phenotypes, for null)
resid_age <- function(y) unname(residuals(lm(y ~ s$age_SY)))
s <- s %>% mutate(lumMean_m_permuted    = sample(lumMean_m),
                  lumMean_m_cc_permuted = sample(lumMean_m_cc),
                  lumMean_m_age_adjusted    = resid_age(lumMean_m),
                  lumMean_m_cc_age_adjusted = resid_age(lumMean_m_cc))

for (p in c("lumMean_m", "lumMean_m_permuted", "lumMean_m_cc", "lumMean_m_cc_permuted"))
  write_lines(s[[p]], file.path(out, paste0("yQuant_", p, ".txt")))
write_lines(s$age_SY, file.path(out, "age_SY.txt"))

# permutation nulls for ANGSD---------------------
y <- s$lumMean_m_cc
shuffle <- function(group) { x <- y; for (g in unique(group)) { i <- which(group == g); if (length(i) > 1) x[i] <- y[i][sample.int(length(i))] }; x }
make_perm <- function(group, seed, name) {
  set.seed(seed); p <- replicate(200, shuffle(group))
  stopifnot(!any(apply(p, 2, identical, y)), !any(duplicated(t(p))))
  write.table(apply(p, 2, function(x) format(x, digits = 15)), file.path(out, paste0("yQuant_lumMean_m_cc_perm200_", name, ".tsv")),
              sep = "\t", quote = FALSE, row.names = FALSE, col.names = FALSE)
  p }
invisible(make_perm(s$Age, 20261003, "withinage"))

# GEMMA ---------------------------------------------------------------------------------------------------------
gem <- c("lumMean_m", "lumMean_m_cc", "lumMean_m_age_adjusted",
         "lumMean_m_cc_age_adjusted", "lumMean_m_permuted", "lumMean_m_cc_permuted")
write.table(s[, gem], file.path(out, "gemma_phenotypes.txt"), quote = FALSE, col.names = FALSE, row.names = FALSE)
writeLines(paste0("-n ", seq_along(gem), " = ", gem), file.path(out, "gemma_phenotypes_KEY.txt"))
write.table(data.frame(1, s$age_SY), file.path(out, "gemma_covariates_intercept_age.txt"), quote = FALSE, col.names = FALSE, row.names = FALSE)
write_tsv(s %>% select(sample_name, ID, population, Age, age_SY, all_of(gem)), file.path(out, "phenotype_table.tsv"))
cat("Wrote", out, "\n")
