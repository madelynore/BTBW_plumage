## Pst vs Fst: is color more differentiated among sites than neutral genetic markers? (added 2026-10-04)
#
# Pst (phenotypic analogue of Qst; Brommer 2011 J Evol Biol 24:1160):
#   Pst = (c/h2 * Vb) / (c/h2 * Vb + 2 * Vw)
#   Vb, Vw = between-site and within-site variance from lmer(luminance ~ Age + (1 | site)), all aged males.
#   c/h2 = unknown ratio of the additive genetic share of the between-site vs the within-site variance, so Pst is
#   shown over c/h2 from 0 to 2. 95% CI from a parametric bootstrap (1000 simulations).
#   Critical c/h2 = smallest c/h2 at which the lower 95% CI of Pst exceeds mean Fst: the lower it is, the more robust
#   "Pst > Fst" is to the unknown heritabilities. Categories in the table:
#     PST >> FST  critical c/h2 <= strong_cutoff (Pst > Fst even if the between-site differences are mostly non-genetic)
#     PST > FST   critical c/h2 <= 1
#     PST = FST   lower 95% CI does not exceed Fst at c/h2 = 1 (critical shown as "-")
#   strong_cutoff (0.125) has no standard value; it is set to reproduce the split in the example table format.
# Traits: luminance of the five patches and wing spot area (all age-adjusted through the Age fixed effect).
# Fst: pairwise Fst between sampling sites

library(tidyverse)
library(lme4)
library(vegan)
library(here)
source(here("R_scripts/table_helpers.R"))
set.seed(20261003)

avg_img <- read.csv(here("data/photos/BTBW_whole_specimen_Image_Analysis_measurements_allpop_avgimg_wide.csv")) %>%
  filter(Age == "ASY" | Age == "SY")
sites <- sort(unique(avg_img$pop))

# pairwise Fst among our sites --------------------------------------------------------------------------------
fst <- read.table(here("data_raw/pst_fst/Pairwise.fst.BTBW_wgs_ds2x_mergedthenfiltered_maxmiss0.8_minQ30_maf.05_rmrelatedind7_vcfsites_ngsLDpruned_NovoS.majmin4.txt"),
                  col.names = c("pop1", "pop2", "fst_unweighted", "fst_weighted")) %>%
  filter(pop1 %in% sites, pop2 %in% sites)
stopifnot("Fst missing for some pairs of sites" = nrow(fst) == choose(length(sites), 2))
fst_mean <- mean(fst$fst_weighted); fst_max <- max(fst$fst_weighted); fst_min <- min(fst$fst_weighted)

# Pst per patch ------------------------------------------------------------------------------------------------
r_grid <- seq(0.001, 2, 0.001)
pst <- function(vb, vw, r) r * vb / (r * vb + 2 * vw)
var_comp <- function(fit) { v <- as.data.frame(VarCorr(fit))
  c(vb = v$vcov[v$grp == "site"], vw = v$vcov[v$grp == "Residual"]) }

patch_cols <- c("lumMean_m", "lumMean_t", "lumMean_c", "lumMean_o", "lumMean_w", "area_mm2_w")
strong_cutoff <- 0.125
pst_curves <- map_dfr(patch_cols, function(col) {
  dat <- avg_img %>% filter(!is.na(.data[[col]])) %>% transmute(y = .data[[col]], Age, site = pop)
  fit <- lmer(y ~ Age + (1 | site), data = dat)
  est <- var_comp(fit)
  boot <- bootMer(fit, var_comp, nsim = 1000, type = "parametric")$t
  map_dfr(r_grid, function(r) { b <- pst(boot[, "vb"], boot[, "vw"], r)
    tibble(c_h2 = r, Pst = pst(est[["vb"]], est[["vw"]], r), lower = quantile(b, 0.025), upper = quantile(b, 0.975)) }) %>%
    mutate(patch = col, n = nrow(dat), n_sites = n_distinct(dat$site), .before = 1)
})

critical <- function(d, f) { k <- d$c_h2[d$lower > f]; if (length(k)) min(k) else NA_real_ }
category <- function(crit) case_when(!is.na(crit) & crit <= strong_cutoff ~ "PST ≫ FST",
                                     !is.na(crit) & crit <= 1 ~ "PST > FST", TRUE ~ "PST = FST")
pst_table <- pst_curves %>% group_by(patch, n, n_sites) %>%
  summarise(Pst = Pst[c_h2 == 1], lower95 = lower[c_h2 == 1], upper95 = upper[c_h2 == 1],
            critical_c_h2_mean_Fst = critical(pick(c_h2, lower), fst_mean),
            critical_c_h2_max_Fst = critical(pick(c_h2, lower), fst_max), .groups = "drop") %>%
  mutate(category = category(critical_c_h2_mean_Fst), Fst_mean = fst_mean, Fst_min = fst_min, Fst_max = fst_max) %>%
  arrange(desc(Pst))
write.csv(pst_table, here("results/pst_fst/Pst_Fst_table.csv"), row.names = FALSE)
print(pst_table)


# readable table ------------------------------------------------------------------------------------------------
save_table(
  pst_table %>%
    transmute(Trait = patch_label(patch), PST = sprintf("%.3f", Pst), `Lower 95% CI` = sprintf("%.3f", lower95),
              `Upper 95% CI` = sprintf("%.3f", upper95),
              `Critical c/h²` = ifelse(is.na(critical_c_h2_mean_Fst) | critical_c_h2_mean_Fst > 1, "—", sprintf("%.3f", critical_c_h2_mean_Fst)),
              `PST–FST` = category) %>%
    gt() %>%
    tab_header(title = "Phenotypic differentiation among sites (PST at c/h² = 1) vs genomic FST") %>%
    tab_source_note(sprintf(paste("Pst = (c/h² Vb) / (c/h² Vb + 2 Vw), Vb and Vw from trait ~ Age + (1 | site); 95%% CI from 1000",
                                  "parametric bootstraps. Pairwise Fst among the %d sites: mean %.3f (range %.3f–%.3f). Critical c/h² =",
                                  "smallest c/h² at which the lower 95%% CI of Pst exceeds mean Fst (— : not reached by c/h² = 1). PST ≫ FST: critical",
                                  "c/h² ≤ %.3f; PST > FST: ≤ 1; PST = FST: otherwise."), length(sites), fst_mean, fst_min, fst_max, strong_cutoff)) %>%
    style_table(),
  "Pst_Fst_table")

