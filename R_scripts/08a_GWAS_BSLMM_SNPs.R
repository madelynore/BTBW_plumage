## GWAS method 1: GEMMA BSLMM -> suggestive SNPs (PIP >= 0.01)
#
# Three independent BSLMM chains of the same phenotype (card-corrected mantle luminance, age-adjusted; all aged males,
# n = 152; 20 M sampling steps, 0.5 M burn-in; seeds 101, 202, 303).
#Suggestive SNPs: mean PIP over the chains >= 0.01; n_chains = in how many chains the SNP passes on its own.
# Writes data/gwas/GWAS_<prefix>_BSLMM_SNPs.csv (suggestive SNPs), data/gwas/GWAS_<prefix>_BSLMM_PIP_all.tsv.gz (every SNP's
# mean PIP, for the Manhattan plot), results/gwas/bslmm_hyperparameters_<prefix>.csv and .pdf.

library(tidyverse)
library(data.table)
library(coda)
library(here)

# Settings -----------------------------------------------------------------------------------------------------
bslmm_dir  <- here("data_raw/gwas/gwas_allages/gemma/output")
prefix     <- "btbw_n152_allages_lumMean_m_cc"
chains     <- paste0("BSLMM_", prefix, "_age_adjusted_seed", c(101, 202, 303))
null_chain <- paste0("BSLMM_", prefix, "_withinsite_perm_age_adjusted_seed505")   # NA if not available
pip_cut    <- 0.01

# Hyperparameters and convergence ----------------------------------------------------------------------------------
# (.hyp.txt lines end with a tab, so read.table rather than fread)
hyp <- lapply(setNames(chains, sub(".*_seed", "seed", chains)), function(ch)
  read.table(file.path(bslmm_dir, paste0(ch, ".hyp.txt")), header = TRUE))
pars <- c("pve", "pge", "pi", "n_gamma")
n <- min(sapply(hyp, nrow))
rhat_m <- vapply(pars, function(p) unname(gelman.diag(mcmc.list(lapply(hyp, function(h) mcmc(h[1:n, p]))),
                                                    autoburnin = FALSE)$psrf[1, 1:2]), numeric(2))   # row 1 = R-hat, row 2 = upper 95%

# effective sample size per chain only (slow on ~2 M samples; not computed for the pooled chains)
summ <- function(h, label, ess = TRUE) map_dfr(pars, ~ tibble(chain = label, parameter = .x, median = median(h[[.x]]),
                                                  lower95 = quantile(h[[.x]], 0.025), upper95 = quantile(h[[.x]], 0.975),
                                                  effective_samples = if (ess) as.numeric(effectiveSize(h[[.x]])) else NA_real_))
hyp_table <- bind_rows(imap_dfr(hyp, summ), summ(bind_rows(hyp), "pooled", ess = FALSE))
if (!is.na(null_chain) && file.exists(file.path(bslmm_dir, paste0(null_chain, ".hyp.txt"))))
  hyp_table <- bind_rows(hyp_table, summ(read.table(file.path(bslmm_dir, paste0(null_chain, ".hyp.txt")), header = TRUE),
                                         "null: within-site shuffle", ess = FALSE))
hyp_table <- hyp_table %>% left_join(tibble(parameter = pars, rhat = rhat_m[1, ], rhat_upper95 = rhat_m[2, ]), by = "parameter") %>%
  mutate(across(c(rhat, rhat_upper95), ~ ifelse(startsWith(chain, "null"), NA, .x)))   # R-hat is across the 3 real chains
write.csv(hyp_table, here(paste0("results/gwas/bslmm_hyperparameters_", prefix, ".csv")), row.names = FALSE)
print(hyp_table %>% mutate(across(where(is.double), ~ signif(.x, 3))), n = Inf)

pdf(here(paste0("results/gwas/bslmm_hyperparameters_", prefix, ".pdf")), width = 8.3, height = 11.7)
par(mfrow = c(4, 2))
for (p in pars) {
  plot(NA, xlim = c(1, n), ylim = range(sapply(hyp, function(h) range(h[[p]]))), xlab = "sample", ylab = p, main = paste(p, "trace"))
  for (i in seq_along(hyp)) lines(seq(1, n, by = 100), hyp[[i]][seq(1, n, by = 100), p], col = i)
  d <- lapply(hyp, function(h) density(h[[p]]))
  plot(NA, xlim = range(sapply(d, function(x) range(x$x))), ylim = c(0, max(sapply(d, function(x) max(x$y)))), xlab = p, ylab = "density",
       main = paste(p, "posterior"))
  for (i in seq_along(d)) lines(d[[i]], col = i)
}
dev.off()

# PIP averaged over chains -------------------------------------------------------------------------------------------
param <- lapply(chains, function(ch) fread(file.path(bslmm_dir, paste0(ch, ".param.txt")), select = c("chr", "rs", "ps", "beta", "gamma")))
for (p in param) stopifnot("SNP order differs between chains" = identical(p$rs, param[[1]]$rs))
pip <- param[[1]][, .(Chromosome = chr, Position = ps, SNP = rs)]
for (i in seq_along(param)) set(pip, j = paste0("pip_seed", sub(".*seed", "", chains[i])), value = param[[i]]$gamma)
pip[, beta := rowMeans(sapply(param, function(p) p$beta))]
rm(param)
pcols <- grep("^pip_seed", names(pip), value = TRUE)
pip[, mean_pip := rowMeans(.SD), .SDcols = pcols]
pip[, n_chains := rowSums(.SD >= pip_cut), .SDcols = pcols]
fwrite(pip[, .(Chromosome, Position, SNP, mean_pip, n_chains)], here(paste0("data/gwas/GWAS_", prefix, "_BSLMM_PIP_all.tsv.gz")), sep = "\t")

bslmm_snps <- pip[mean_pip >= pip_cut][order(-mean_pip)]
write.csv(bslmm_snps, here(paste0("data/gwas/GWAS_", prefix, "_BSLMM_SNPs.csv")), row.names = FALSE)
cat(sprintf("\nBSLMM: %d SNPs with mean PIP >= %.2f (%d of them >= %.2f in all %d chains); max mean PIP %.3f\n",
            nrow(bslmm_snps), pip_cut, sum(bslmm_snps$n_chains == length(chains)), pip_cut, length(chains), max(pip$mean_pip)))
