# PCA of plumage color ----------------------------------------------------
# Runs one PCA per plumage patch for ASY birds, orients PC1 so that higher
# values = lighter, and checks that PC1 really tracks luminance.

library(tidyverse)
library(ggbiplot)
library(patchwork)

# Data --------------------------------------------------------------------

avg_img <- read.csv("data/BTBW_whole_specimen_Image_Analysis_measurements_allpop_avgimg_wide.csv")

asy <- avg_img %>%
  filter(Age == "ASY")

# Settings ----------------------------------------------------------------

id_col <- "ID"

# Column-name suffix for each patch, and the name to show on the figure.
# The order here is the order of the panels in the figure.
patches <- c(o = "Coverts",
             c = "Crown",
             m = "Mantle",
             t = "Throat",
             w = "Wing spot")

# Columns to leave out of every PCA, as names WITHOUT the patch suffix
# (the suffix is added in the loop: "lumSD" -> "lumSD_m"):
# dbl is redundant with lum, area is not a color measure,
# SD may be measuring patchiness of the spot or the texture of the feathers, so just using means
sd_measures   <- unique(str_remove(grep("SD_", colnames(avg_img), value = TRUE), "_[a-z]$"))  # "lumSD", "lwSD", ...
drop_measures <- c("dblMean", "area_mm2", sd_measures)



# function ----------------------------------------------------------------

# Flip PC1 so it increases with luminance (higher PC1 = lighter)
orient_pc1 <- function(pca, luminance) {
  if (cor(pca$x[, 1], luminance, use = "complete.obs") < 0) {
    pca$x[, 1]        <- -pca$x[, 1]
    pca$rotation[, 1] <- -pca$rotation[, 1]
  }
  pca
}


# Run one PCA per patch ---------------------------------------------------

pcas       <- list()
pc1_scores <- list()
biplots    <- list()

for (p in names(patches)) {
  suffix <- paste0("_", p)
  
  # This patch's color measures, plus the ID so results can be joined back
  patch_data <- asy %>%
    select(all_of(id_col), ends_with(suffix)) %>%
    select(-any_of(paste0(drop_measures, suffix))) %>%
    na.omit()
  
  # Remove the suffix from column names ("swMean_d" -> "swMean")
  # so the biplot arrow labels are short and easy to read
  measures <- patch_data %>%
    select(-all_of(id_col)) %>%
    rename_with(~ str_remove(.x, paste0(suffix, "$")))
  
  # Only mean values should be left (lumMean, lwMean, mwMean, swMean, uvMean)
  if (any(!str_detect(names(measures), "Mean$"))) {
    stop(patches[p], ": non-mean columns in the PCA: ",
         paste(names(measures)[!str_detect(names(measures), "Mean$")], collapse = ", "))
  }
  
  pca <- prcomp(measures, scale. = T)
  pca <- orient_pc1(pca, measures$lumMean)
  
  # Check that PC1 is a light/dark axis
  r_lum        <- cor(pca$x[, 1], measures$lumMean)
  var_explained <- summary(pca)$importance["Proportion of Variance", "PC1"]
  
  cat(patches[p], ": n =", nrow(measures),
      "| measures:", paste(names(measures), collapse = ", "),
      "| PC1 explains", round(var_explained * 100, 1), "% of variance",
      "| r(PC1, luminance) =", round(r_lum, 2), "\n")
  
  if (r_lum < 0.5) {
    warning(patches[p], ": PC1 is only weakly related to luminance (r = ",
            round(r_lum, 2), "). It should not be described as light vs dark.")
  }
  
  # Save results for this patch
  pcas[[p]] <- pca
  
  scores <- data.frame(patch_data[[id_col]], pca$x[, 1])
  names(scores) <- c(id_col, paste0("PC1", suffix))
  pc1_scores[[p]] <- scores
  
  biplots[[p]] <- ggbiplot(pca, choices = c(1, 2),
                           alpha = 0.5,            # lighter points so arrows stand out
                           varname.size = 8,       # bigger arrow labels
                           varname.adjust = 1.4) + # push labels past arrow tips
    coord_equal(xlim = c(-3, 4), ylim = c(-3, 3)) + # same scale in every panel; x goes to 4 so the arrow labels (all pointing right) aren't cut off
    ggtitle(patches[p]) +
    theme_classic(base_size = 16) +
    theme(legend.position = "none",
          plot.title = element_text(hjust = 0.5, face = "bold"))
}


# Combine PC1 scores into one data frame ----------------------------------

# Start from all ASY birds so birds missing a patch get NA instead of being dropped
pc1_all <- asy %>%
  select(all_of(id_col))

for (p in names(patches)) {
  pc1_all <- left_join(pc1_all, pc1_scores[[p]], by = id_col)
}

stopifnot(!any(duplicated(pc1_all[[id_col]])))

head(pc1_all)

write.csv(pc1_all, "data/color_PC1_all_patches.csv", row.names = FALSE)
saveRDS(pcas, "results/color_pcas.rds")


# Plots of PCAs figure -----------------------------------------------------

pcaplots <- wrap_plots(biplots, ncol = 2) +
  plot_annotation(tag_levels = "A") &
  theme(plot.tag   = element_text(size = 18, face = "bold"),
      axis.ticks.length = unit(0.25, "cm"),
      axis.ticks = element_line(linewidth = 0.8),
      axis.text  = element_text(size = 16),
      axis.title = element_text(size = 18))

pcaplots

ggsave(filename = "results/Color_PCA_plot.png", plot = pcaplots,
       width = 12, height = 18, dpi = 600)

