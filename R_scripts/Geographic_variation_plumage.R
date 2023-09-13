## geographic variation in plumage (whole specimen)

library(tidyverse)

img <- read.csv("data_raw/Image Analysis Results Samsung NX1000 Nikkor EL 80mm D65 to Bluetit D65.csv")

head(img)

img_ID <- img %>% 
  separate(Label, into = c("ID", "photo", "plumage_patch"), sep = "_")

avg_img <- img_ID %>% 
  group_by(ID, photo) %>% 
  summarise(lumMean = mean(lumMean),
            lumSD = mean(lumSD),
            lwMean = mean(lwMean),
            lwSD = mean(lwSD),
            mwMean = mean(mwMean),
            mwSD = mean(mwSD),
            swMean = mean(swMean),
            swSD = mean(swSD),
            uvMean = mean(uvMean),
            uvSD = mean(uvSD),
            dblMean = mean(dblMean),
            dblSD = mean(dblSD))

dpca <- prcomp(avg_img[3:14], scale = T)  
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






