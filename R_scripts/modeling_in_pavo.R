# Calculating color distances with pavo

library(pavo)

# prep data ---------------------------------------------------------------


btbwcol <- read.csv("data/BTBW_whole_specimen_Image_Analysis_measurements_averaged_allpop.csv")

vis.btbw <- btbwcol %>% 
  dplyr::select(u = uvMean , s = swMean, m = mwMean , l = lwMean, lum = dblMean)

rownames(vis.btbw) <- paste0(btbwcol$ID, ".", btbwcol$pl_code)


tcs.btbw <- colspace(vis.btbw, space = "tcs", qcatch = "Qi")

# plot in tetrahedral color space -------------------------------------------------------------

tcsplot(tcs.btbw)

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
