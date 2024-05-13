## geographic variation in plumage (whole specimen)

library(tidyverse)

avgimg <- read.csv("data/BTBW_micat_avgd_photo_measurements.csv")


# Correlation analysis dorsum ----------------------------------------------------

library("ggpubr")

## select only the back 
dorsum <- avg_img %>% 
  filter(pl_code %in% c("d", "f"))
## pivot data
dorsum_wide <- dorsum %>%
  pivot_wider(
    names_from = pl_code,
    values_from = c("lumMean", "lumSD",   "lwMean",  "lwSD",    "mwMean",  "mwSD",   
                    "swMean",  "swSD",    "uvMean",  "uvSD", "dblMean",
                    "dblSD",  "area", "N")
  )

## remove weird one --> values seem wrong and my notes said the photo analysis in mica didn't look right
dorsum_wide <- dorsum_wide %>%
  filter(ID != "612918")


ggscatter(dorsum_wide, x = "lumMean_d", y = "lumMean_f", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "Luminance Mean subsets", ylab = "Luminance Mean full")

# Shapiro-Wilk normality test for subsets
shapiro.test(dorsum_wide$lumMean_d) # => p-value = 0.7993
# Shapiro-Wilk normality test for full
shapiro.test(dorsum_wide$lumMean_f) # => p-value = 0.6143

## both normal, but also doing visual inspection of Q plots
# subset
ggqqplot(dorsum_wide$lumMean_d, ylab = "Lum Mean subset")
# full
ggqqplot(dorsum_wide$lumMean_f, ylab = "Lum Mean full")
## both come from normal distributions 

res <- cor.test(dorsum_wide$lumMean_d, dorsum_wide$lumMean_f, 
                method = "pearson")
res
## t = 24.009, df = 13, p-value = 3.747e-12
# alternative hypothesis: true correlation is not equal to 0
# 95 percent confidence interval:
#   0.9660121 0.9964099
# sample estimates:
#   cor 
# 0.9889105 

## STRONGLY correlated 

## select df with only the num values 
dwide_num <- dorsum_wide[3:nrow(dorsum_wide)]

d_correlations <- as.data.frame(cor(dwide_num,method="pearson"))
write.csv(d_correlations, file = "results/dorsum_variable_correlations.csv")

## ran matrix for all variable and they are >98% correlated!! 



# Cor analysis belly ------------------------------------------------------

## select only the back 
belly <- avg_img %>% 
  filter(pl_code %in% c("b", "v"))
## pivot data
belly_wide <- belly %>%
  pivot_wider(
    names_from = pl_code,
    values_from = c("lumMean", "lumSD",   "lwMean",  "lwSD",    "mwMean",  "mwSD",   
                    "swMean",  "swSD",    "uvMean",  "uvSD", "dblMean",
                    "dblSD",  "area", "N")
  )

## 614269 doesn't have full ventral measures 
belly_wide <- belly_wide %>%
  filter(ID != "614269")


ggscatter(belly_wide, x = "lumMean_b", y = "lumMean_v", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "Luminance Mean subsets", ylab = "Luminance Mean full")

# Shapiro-Wilk normality test for subsets
shapiro.test(belly_wide$lumMean_b) # => p-value = 0.7138
# Shapiro-Wilk normality test for full
shapiro.test(belly_wide$lumMean_v) # => p-value = 0.9244

## both normal, but also doing visual inspection of Q plots
# subset
ggqqplot(belly_wide$lumMean_b, ylab = "Lum Mean subset")
# full
ggqqplot(belly_wide$lumMean_v, ylab = "Lum Mean full")
## both come from normal distributions 

res <- cor.test(belly_wide$lumMean_b, belly_wide$lumMean_v, 
                method = "pearson")
res
# t = 5.0084, df = 14, p-value = 0.0001915
# alternative hypothesis: true correlation is not equal to 0
# 95 percent confidence interval:
#   0.5065966 0.9282144
# sample estimates:
#   cor 
# 0.8011221 

## STRONGLY correlated 

## select df with only the num values 
bwide_num <- belly_wide[3:nrow(belly_wide)]

b_correlations <- as.data.frame(cor(bwide_num,method="pearson"))
write.csv(b_correlations, file = "results/belly_variable_correlations.csv")



# Prin Comp ---------------------------------------------------------------



dpca <- prcomp(avg_img[9:14], scale = T)  
## eigen vectors
#reverse the signs
dpca$rotation <- -1*dpca$rotation

#display principal components
dpca$rotation
## eigen values
#reverse the signs of the scores
pcscores <- as.data.frame(-1*dpca$x)

img_dpc <- cbind(avg_img, pcscores)

#display the first six scores
head(dpca$x)

biplot(dpca, scale = 0)

#calculate total variance explained by each principal component
pc.percent <- dpca$sdev^2 / sum(dpca$sdev^2)*100
pc1perc <- as.character(round(pc.percent[1], 2))
pc2perc <- as.character(round(pc.percent[2], 2))


## make scree plot 
#calculate total variance explained by each principal component
var_explained = dpca$sdev^2 / sum(dpca$sdev^2)

## create a scree plot
plot(var_explained)


# add metadata ------------------------------------------------------------

meta <- read.csv("../NMNH_specimen_data.csv")

meta_b <- meta %>% 
  select(USNM.no., County, State.Province)

d_prelim <- merge(meta_b, img_dpc, by.x = "USNM.no.", by.y = "ID", all = F)


# make plots -----------------------------------------------------------

ggplot(d_prelim, aes(x = PC1, y = PC2, color = State.Province, shape = State.Province))+
  geom_point(size = 6.5)+
  xlab(paste0("PC1 (", pc1perc ,"% explained)")) +
  ylab(paste0("PC2 (", pc2perc,"% explained)")) +
  theme_classic()
 
d_less <- d_prelim[-c(14,15,17),]

ggplot(data = d_less, aes(y = lumMean, x = State.Province, fill = USNM.no., color = USNM.no.)) + 
  geom_pointrange(aes(ymin = lumMean - lumSD, ymax = lumMean + lumSD), position = position_dodge(width = 0.2), fatten = 1.5) +
  labs(x = "Location", y = "Luminance (brightness)") +
  theme_classic() +
  theme(
    aspect.ratio = 0.75,
    text = element_text(size = 16),
    axis.text = element_text(size = 14)
  )

# Perform t-test for comparing perc_black between states
t_test_result <- t.test(lumMean ~ State.Province, data = d_less)

# Print the test results
print(t_test_result)






