# Calculating color distances with pavo

library(pavo)
library(tidyverse)

# prep data ---------------------------------------------------------------


btbwcol <- read.csv("data/BTBW_whole_specimen_Image_Analysis_measurements_averaged_allpop.csv")

vis.btbw <- btbwcol %>% 
  dplyr::select(u = uvMean , s = swMean, m = mwMean , l = lwMean, lum = dblMean)

rownames(vis.btbw) <- paste0(btbwcol$ID, ".", btbwcol$pl_code)


tcs.btbw <- colspace(vis.btbw, space = "tcs", qcatch = "Qi")


# calculate achromatic contrast  ------------------------------------------

vis.btbw <- btbwcol %>% 
  dplyr::filter(pl_code %in% c("d", "w", "o")) %>% 
  dplyr::select(u = uvMean , s = swMean, m = mwMean , l = lwMean, lum = dblMean) 

btbwnames <- btbwcol %>% 
  dplyr::filter(pl_code %in% c("d", "w", "o")) %>% 
  dplyr::select(ID, pl_code)

rownames(vis.btbw) <- paste0(btbwnames$ID, ".", btbwnames$pl_code)

tcs.btbw <- colspace(vis.btbw, space = "tcs", qcatch = "Qi")

# create grouping variable to group by body region, by extracting the plcode from row names
regions <- substr(rownames(tcs.btbw), nchar(rownames(tcs.btbw)), nchar(rownames(tcs.btbw)))

btbwdist <- bootcoldist(tcs.btbw,
                       by = regions,
                       n = c(1, 2, 2, 4),
                       weber = 0.05,
                       achromatic = T,weber.achro = 0.1)

plot(btbwdist[, 1],
     ylim = c(0, 20),
     pch = 21,
     bg = 1,
     cex = 2,
     xaxt = "n",
     xlab = "Centroid comparison",
     ylab = "Chromatic contrast (dS)"
)
axis(1, at = 1:3, labels = rownames(btbwdist))
segments(1:3, btbwdist[, 2], 1:3, btbwdist[, 3], lwd = 2) # Add CI's
abline(h = 1, lty = 3, lwd = 2) # Add a 'threshold' line at dS = 1

# plot in tetrahedral color space -------------------------------------------------------------

tcsplot(tcs.btbw)
projplot(tcs.btbw)

patch <- btbwcol$pl_code
tcs.dorsum <- subset(tcs.btbw, "d")
tcs.crown <- subset(tcs.btbw, "c")
tcs.covert <- subset(tcs.btbw, "o")
tcs.wingspot <- subset(tcs.btbw, "w")
tcs.throat <- subset(tcs.btbw, "t")
tcs.belly <- subset(tcs.btbw, "b")

tcsplot(tcs.crown, col = "blue")
tcspoints(tcs.dorsum, col = "black")
tcspoints(tcs.covert, col = "red")
tcspoints(tcs.wingspot, col = "grey")
tcspoints(tcs.belly, col = "green")
tcspoints(tcs.throat, col = "orange")
tcsvol(tcs.btbw)


# calculate color differences between populations -------------------------

vis.btbw_d <- btbwcol %>% 
  filter(pl_code == "d") %>% 
  dplyr::select(u = uvMean , s = swMean, m = mwMean , l = lwMean, lum = dblMean)

tcs.btbw_d <- colspace(vis.btbw, space = "tcs", qcatch = "Qi")

popcol <- btbwcol %>% 
  filter(pl_code == "d") %>% 
  dplyr::select(pop, lat, lon)

coldist_d <- bootcoldist(tcs.btbw_d, by = pop$pop, achromatic = F)

coldistD_df <- as.data.frame(coldist_d)
coldistD_df$pop <- row.names(coldistD_df)

coldistD_nm <- coldistD_df %>% 
  separate(col = pop, into = c("Var2", "Var1"), sep = "-")

pop_sum <- popcol %>% 
  group_by(pop) %>% 
  summarise(
    lat = mean(lat),
    lon = mean(lon)
  )

library(geosphere)

dist_matrix <- distm(pop_sum[, c("lon", "lat")], fun = distHaversine)
dist_matrix_km <- dist_matrix/1000

colnames(dist_matrix_km) <- pop_sum$pop
rownames(dist_matrix_km) <- pop_sum$pop

dist_df <- as.data.frame(as.table(as.matrix(dist_matrix_km)))
dist_df <- dist_df[dist_df$Var1 != dist_df$Var2, ]

colpopdist <- merge(dist_df, coldistD_nm)

plot(x = colpopdist$Freq, y = colpopdist$dS.mean)



