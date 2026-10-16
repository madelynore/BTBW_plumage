## Manhattan plots for both GWAS methods, with the suggestive hits and their genes labelled
#
# Run after 08a, 08b and 08c.
# Top: ANGSD-asso median LRT in 50-SNP windows (08b), with its two lines (blue = null line, 99.9th percentile of the
#   null window medians; dotted = observed line, 99.99th percentile of the observed window medians). Suggestive windows in blue; regions above both lines labelled with
#   their nearest named gene(s); regions with a melanogenesis gene within 25 kb marked in red.
# Bottom: BSLMM mean PIP over the chains (log scale; SNPs with mean PIP < 1e-4 not drawn), line at PIP = 0.01;
#   SNPs above it labelled with their genes and the number of chains in which they pass.

library(tidyverse)
library(data.table)
library(ggrepel)
library(patchwork)
library(here)

prefix <- "btbw_n152_allages_lumMean_m_cc"
lrt_file <- here("data_raw/gwas/gwas_allages/asso/btbw_n152_allages_lumMean_m_cc__PC1cov_age.lrt0.gz")   # for chromosome lengths

windows    <- fread(here(paste0("data/gwas/GWAS_", prefix, "_ANGSD_windows.tsv.gz")))
thresholds <- fread(here(paste0("data/gwas/GWAS_", prefix, "_ANGSD_window_thresholds.csv")))   # row 1 null line, row 2 observed line
genes <- fread(here(paste0("data/gwas/GWAS_", prefix, "_suggestive_hits_genes.csv")))
n_chains_total <- 3

# genome coordinates: chromosomes in numeric order (1, 1a, 2, ..., 4a, ..., z), cumulative positions
chrom_order <- function(x) { u <- unique(x); k <- sub("^chr", "", u)
  num <- suppressWarnings(as.numeric(sub("a$", ".5", k))); num[tolower(k) == "z"] <- 99; u[order(num, k)] }
lrt <- fread(lrt_file, select = c("Chromosome", "Position", "LRTscore"))[LRTscore > -999 & !grepl("scaffold|mito", Chromosome)]
lens <- lrt[, .(len = max(Position)), by = Chromosome][, Chromosome := factor(Chromosome, chrom_order(Chromosome))]
setorder(lens, Chromosome); lens[, offset := cumsum(c(0, head(as.numeric(len), -1)))]
add_pos <- function(d) { d <- merge(d, lens[, .(Chromosome = as.character(Chromosome), offset)], by = "Chromosome")
  d[, `:=`(pos = Position + offset, shade = as.integer(factor(Chromosome, levels(lens$Chromosome))) %% 2 == 0)][] }
lrt <- add_pos(lrt[, .(Chromosome, Position)][, .SD[c(1, .N)], by = Chromosome])   # chromosome ends only (axis)
axis <- lrt[, .(mid = (min(pos) + max(pos)) / 2), by = Chromosome][, label := sub("^chr", "", Chromosome)][
  , label := ifelse(label %in% c("22", "24", "26", "28", "4a"), "", label)]

short_genes <- function(g) {   # nearest two named genes (LOC names only when nothing else), "+n" for the rest
  g <- trimws(strsplit(g, ", ")[[1]]); if (!length(g) || grepl("^(no gene|unnamed)", g[1])) return("")
  nm <- g[!grepl("^LOC", g)]; use <- if (length(nm)) nm else g
  paste0(paste(sub(" \\(.*", "", head(use, 2)), collapse = "/"), if (length(use) > 2) paste0(" +", length(use) - 2) else "") }
genes[, Position := round((start + end) / 2)]
genes <- add_pos(genes)
genes[, label := vapply(genes, short_genes, "")]
windows[, Position := round((start_bp + end_bp) / 2)]
windows <- add_pos(windows)

# ANGSD-asso windows --------------------------------------------------------------------------------------------
reg <- genes[source == "ANGSD-asso windows"]
lab_lrt <- reg[above_null_line == TRUE & above_observed_line == TRUE & label != ""]
melano  <- reg[melanogenesis_genes != ""]
p_lrt <- ggplot(windows, aes(pos, LRT_median)) +
  geom_point(aes(colour = shade), size = 0.35, show.legend = FALSE) +
  scale_colour_manual(values = c(`TRUE` = "grey60", `FALSE` = "grey25")) +
  geom_hline(yintercept = thresholds$LRT_median[2], colour = "grey40", linetype = "dotted", linewidth = 0.4) +
  geom_hline(yintercept = thresholds$LRT_median[1], colour = "blue", linewidth = 0.4) +
  geom_point(data = windows[suggestive == TRUE], colour = "blue", size = 0.9) +
  geom_point(data = melano, aes(y = LRT_median), colour = "red3", size = 1.6) +
  # geom_text_repel(data = lab_lrt, aes(y = LRT_median, label = label), size = 3.5, fontface = "italic", min.segment.length = 0,
  #                 box.padding = 0.8, max.overlaps = Inf, seed = 1) +
  geom_text_repel(data = melano[, .SD[which.max(LRT_median)], by = melanogenesis_genes], aes(y = LRT_median, label = melanogenesis_genes),
                  size = 4, fontface = "italic", colour = "red3", min.segment.length = 0, nudge_y = 0.6, max.overlaps = Inf, seed = 2) +
  scale_x_continuous(breaks = axis$mid, labels = axis$label, expand = c(0.01, 0)) +
  labs(x = NULL, y = "Median LRT (50-SNP window)") +
  theme_classic() + theme(axis.text.x = element_text(size = 6), plot.subtitle = element_text(size = 7))

# BSLMM -------------------------------------------------------------------------------------------------------------
pip <- add_pos(fread(here(paste0("data/gwas/GWAS_", prefix, "_BSLMM_PIP_all.tsv.gz")))[Chromosome %in% lens$Chromosome])
lab_pip <- genes[grepl("BSLMM", source)][, label := sprintf("%s\n(%d/%d chains)", ifelse(label == "", "no named gene", label), n_chains, n_chains_total)]
p_pip <- ggplot(pip[mean_pip > 1e-4], aes(pos, mean_pip)) +
  geom_point(aes(colour = shade), size = 0.5, show.legend = FALSE) +
  scale_colour_manual(values = c(`TRUE` = "grey60", `FALSE` = "grey25")) +
  geom_hline(yintercept = 0.01, colour = "blue", linewidth = 0.4) +
  geom_point(data = lab_pip, aes(y = PIP), colour = "blue", size = 1.4) +
  # geom_text_repel(data = lab_pip, aes(y = PIP, label = label), size = 2.5, fontface = "italic", min.segment.length = 0,
  #                 box.padding = 0.5, max.overlaps = Inf, seed = 1) +
  scale_y_log10() +
  scale_x_continuous(breaks = axis$mid, labels = axis$label, limits = range(lrt$pos), expand = c(0.01, 0)) +
  labs(x = "Chromosome", y = "Mean PIP (BSLMM, log scale)")+
  theme_classic() + theme(axis.text.x = element_text(size = 6), plot.subtitle = element_text(size = 7))

ggsave(here(paste0("results/gwas/GWAS_", prefix, "_manhattan_ANGSD.png")), p_lrt, width = 12, height = 4, dpi = 300)
ggsave(here(paste0("results/gwas/GWAS_", prefix, "_manhattan_BSLMM.png")), p_pip, width = 12, height = 4, dpi = 300)
ggsave(here(paste0("results/gwas/GWAS_", prefix, "_manhattan.png")), p_lrt / p_pip + plot_annotation(tag_levels = "A"), width = 12, height = 8, dpi = 300)
