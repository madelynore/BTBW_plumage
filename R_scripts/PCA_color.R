# PCA color ---------------------------------------------------------------

library(RColorBrewer)
library(tidyverse)
library(ggbiplot)


avg_img <- read.csv("data/BTBW_whole_specimen_Image_Analysis_measurements_allpop_avgimg_wide.csv")

## select only brightness for ASY males
asy <- avg_img %>% 
  filter(Age == "ASY")

#filtering for just dorsum measures, removing lum bc redundant with dbl and area bc it's not relevant for this patch
dorsum <- avg_img %>% 
  dplyr::select(ends_with("_d"), -lumSD_d,-lumMean_d, -area_mm2_d, -PC1_d) %>% 
  na.omit()


d_pca <- prcomp(~ ., data = dorsum)

screeplot(d_pca, type="lines")

dplot <- ggbiplot(d_pca, choices = c(1,2))+
  theme_classic()

dorsum_pcs <- cbind(dorsum, predict(d_pca))

plot(dorsum_pcs$dblMean_d, dorsum_pcs$PC1)

#filtering for just throat measures, removing lum bc redundant with dbl and area bc it's not relevant for this patch
throat <- asy %>% 
  dplyr::select(ends_with("_t"), -lumSD_t,-lumMean_t, -area_mm2_t, PC1_t) %>% 
  na.omit()


t_pca <- prcomp(~ ., data = throat)

screeplot(t_pca, type="lines")

tplot <- ggbiplot(t_pca, choices = c(1,2))+
  ylim(c(-2,2)) +
  theme_classic()

throat_pcs <- cbind(throat, predict(t_pca))

plot(throat_pcs$dblMean_t, throat_pcs$PC1)

#filtering for just covert measures, removing lum bc redundant with dbl and area bc it's not relevant for this patch
covert <- asy %>% 
  dplyr::select(ends_with("_o"), -lumSD_o,-lumMean_o, -area_mm2_o, -PC1_o) %>% 
  na.omit()


o_pca <- prcomp(~ ., data = covert)

screeplot(o_pca, type="lines")

oplot <- ggbiplot(o_pca, choices = c(1,2))+
  theme_classic()

covert_pcs <- cbind(covert, predict(o_pca))

plot(covert_pcs$dblMean_o, covert_pcs$PC1)


#filtering for just crown measures, removing lum bc redundant with dbl and area bc it's not relevant for this patch
crown <- asy %>% 
  dplyr::select(ends_with("_c"), -lumSD_c,-lumMean_c, -area_mm2_c, -PC1_c) %>% 
  na.omit()


c_pca <- prcomp(~ ., data = crown)

screeplot(c_pca, type="lines")

cplot <- ggbiplot(c_pca, choices = c(1,2))+
  theme_classic()

crown_pcs <- cbind(crown, predict(c_pca))

plot(crown_pcs$dblMean_c, crown_pcs$PC1)


#filtering for just wingspot measures, removing lum bc redundant with dbl and area bc i just want color
wingspot <- asy %>% 
  dplyr::select(ends_with("_w"), -lumSD_w,-lumMean_w, -area_mm2_w, -PC1_w) %>% 
  na.omit()


w_pca <- prcomp(~ ., data = wingspot)

screeplot(w_pca, type="lines")

wplot <- ggbiplot(w_pca, choices = c(1,2))+
  theme_classic()

wingspot_pcs <- cbind(wingspot, predict(w_pca))

plot(wingspot_pcs$dblMean_w, wingspot_pcs$PC1)



# combine -----------------------------------------------------------------

library(patchwork)
# Fix each biplot with consistent coord limits and remove legends
fix_biplot <- function(p, title = NULL) {
  p + 
    coord_equal(xlim = c(-3, 3), ylim = c(-3, 3)) +  # uniform axis limits
    theme_classic() +
    theme(
      legend.position = "none",           # remove legends (add one later if needed)
      plot.title = element_text(hjust = 0.5)
    ) +
    if (!is.null(title)) ggtitle(title) else NULL
}

# Apply to each plot
oplot <- fix_biplot(ggbiplot(o_pca, choices = c(1,2)))
cplot <- fix_biplot(ggbiplot(c_pca, choices = c(1,2)))
dplot <- fix_biplot(ggbiplot(d_pca, choices = c(1,2)))
tplot <- fix_biplot(ggbiplot(t_pca, choices = c(1,2)))
wplot <- fix_biplot(ggbiplot(w_pca, choices = c(1,2)))

# Combine
pcaplots <- oplot + cplot + dplot + tplot + wplot +
  plot_layout(ncol = 2) +
  plot_annotation(tag_levels = 'A')

ggsave(filename = "results/Color_PCA_plot.png", plot = pcaplots, 
       width = 12, height = 18, dpi = 600)
