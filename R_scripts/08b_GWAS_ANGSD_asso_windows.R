## GWAS method 2: ANGSD-asso in sliding windows -> suggestive regions
# windows approach adapted from https://github.com/lucasrocmoreira/Moreira-Smith_SciAdv_2023
#
# Association scan: ANGSD -doAsso 5 (score test + latent genotype model) on the imputed genotype probabilities, card-
# corrected mantle luminance, covariates genomic PC1 + age, all aged males (n = 152).
# 1. Median LRT in sliding windows of 50 SNPs, step 10 SNPs, within each chromosome.
# 2. Two threshold lines:
#    observed line: 99.99th percentile of the observed window medians
#    null line:     99.9th percentile of the null window medians. The null: the scan was repeated 200 times with the
#                   phenotype shuffled among birds of the same age class, and the median LRT computed in the same
#                   windows for each shuffle (on the server, LRT_window_permutation_null.R).
#    A window is suggestive above either line; overlapping suggestive windows are merged into regions (used by 08c, 08d).
#
# The windows are computed with data.table rather than the windowscanr package: windowscanr 0.1 no longer runs with
# current dplyr (it uses rename_() and group_by_(), which are defunct). Windows: 50 SNPs, starting at SNP 1 and moving
# 10 SNPs at a time; the last window is the first one to reach the chromosome's last SNP (so only end windows have
# fewer than 50 SNPs).
# Writes data/gwas/GWAS_<prefix>_ANGSD_windows.tsv.gz (every window), data/gwas/GWAS_<prefix>_ANGSD_window_thresholds.csv,
# data/gwas/GWAS_<prefix>_ANGSD_window_regions.csv (suggestive regions).

library(data.table)
library(here)

# Settings -----------------------------------------------------------------------
prefix           <- "btbw_n152_allages_lumMean_m_cc"
observed_file    <- here("data_raw/gwas/gwas_allages/asso/btbw_n152_allages_lumMean_m_cc__PC1cov_age.lrt0.gz")
window_null_file <- here("data_raw/gwas/gwas_allages/perm_withinage/LRT_window_null.rds")   # null window medians (windows x shuffles)

win_size   <- 50       # SNPs per window (must match LRT_window_permutation_null.R)
win_step   <- 10       # SNPs between window starts
obs_percentile <- 0.9999   # top percentile
null_percentile <- 0.999   # top percentile



# 1. Median LRT in sliding windows -----------------------------------------------------
observed <- fread(observed_file, select = c("Chromosome", "Position", "LRTscore"))
# tested SNPs on chromosomes only (untested SNPs = -999; scaffolds and mito left out, as in the Manhattan plots)
snps <- observed[LRTscore > -999 & !grepl("scaffold|mito", Chromosome)]
cat("Tested SNPs used:", nrow(snps), "on", uniqueN(snps$Chromosome), "chromosomes\n")

window_medians <- function(lrt, position) {
  n <- length(lrt)
  starts <- seq(1, n, by = win_step)
  starts <- starts[starts == 1 | (starts - win_step + win_size - 1) < n]   # stop at the first window reaching the last SNP
  ends <- pmin(starts + win_size - 1, n)
  data.table(win_start  = starts,
             win_end    = starts + win_size - 1,   # as in the server's null windows (checked below)
             start_bp   = position[starts],
             end_bp     = position[ends],
             LRT_n      = ends - starts + 1,
             LRT_median = mapply(function(s, e) median(lrt[s:e]), starts, ends))
}
windows <- snps[, window_medians(LRTscore, Position), by = Chromosome]
cat("Windows:", nrow(windows), "\n")


# 2. Threshold lines ---------------------------------------------------------------------
window_null <- readRDS(window_null_file)
stopifnot("The null windows differ from these windows; rerun LRT_window_permutation_null.R" =
            isTRUE(all.equal(as.data.frame(windows[, .(Chromosome, win_start, win_end, LRT_n)]),
                             window_null$windows, check.attributes = FALSE)))
null_medians <- window_null$null_medians
cat("Shuffles in the null:", ncol(null_medians), "\n")

observed_line <- quantile(windows$LRT_median, obs_percentile, names = FALSE)
null_line     <- quantile(as.vector(null_medians), null_percentile, names = FALSE)

windows[, above_observed_line := LRT_median > observed_line]
windows[, above_null_line     := LRT_median > null_line]
windows[, suggestive          := above_observed_line | above_null_line]

cat(sprintf("Observed line (%.2fth percentile of observed window medians): %.3f\n", 100 * obs_percentile, observed_line))
cat(sprintf("Null line (%.2fth percentile of null window medians): %.3f\n", 100 * null_percentile, null_line))
cat("Windows above the observed line:", sum(windows$above_observed_line), "| above the null line:", sum(windows$above_null_line),
    "(expected by chance:", round(nrow(windows) * (1 - null_percentile), 1), ")\n")

fwrite(windows, here(paste0("data/gwas/GWAS_", prefix, "_ANGSD_windows.tsv.gz")), sep = "\t")
fwrite(data.table(line = c("null line", "observed line"),
                  description = sprintf(c("%.2fth percentile of null window medians (%d shuffles)",
                                          "%.2fth percentile of observed window medians"),
                                        c(100 * null_percentile, 100 * obs_percentile), ncol(null_medians)),
                  LRT_median = c(null_line, observed_line)),
       here(paste0("data/gwas/GWAS_", prefix, "_ANGSD_window_thresholds.csv")))


# 3. Suggestive regions: overlapping suggestive windows merged ----------------------------
regions <- windows[suggestive == TRUE][order(Chromosome, start_bp)]
regions[, region := cumsum(c(1, head(end_bp, -1) < tail(start_bp, -1) | head(Chromosome, -1) != tail(Chromosome, -1)))]
regions <- regions[, .(start_bp = min(start_bp), end_bp = max(end_bp), n_windows = .N,
                       max_LRT_median = max(LRT_median),
                       above_observed_line = any(above_observed_line), above_null_line = any(above_null_line)),
                   by = .(Chromosome, region)]
fwrite(regions, here(paste0("data/gwas/GWAS_", prefix, "_ANGSD_window_regions.csv")))
cat("Suggestive regions:", nrow(regions), "| above both lines:", sum(regions$above_observed_line & regions$above_null_line), "\n")
print(regions[order(-max_LRT_median)])
