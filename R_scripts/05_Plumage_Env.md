Plumage_environment
================
Ore, MJ.
2025-03-11

    ## here() starts at /Users/madelynore/Documents/Work/PhD/BTBW_geographic_coloration/BTBW_plumage

## Does location predict color ?

    ## 
    ## Call:
    ## lm(formula = lumMean_m ~ lat + Age, data = lum_env, na.action = na.omit)
    ## 
    ## Residuals:
    ##       Min        1Q    Median        3Q       Max 
    ## -0.045068 -0.006676  0.000878  0.006110  0.023236 
    ## 
    ## Coefficients:
    ##              Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept) 0.0286940  0.0078148   3.672 0.000318 ***
    ## lat         0.0008360  0.0001925   4.344 2.35e-05 ***
    ## AgeSY       0.0101273  0.0016721   6.057 8.06e-09 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.01082 on 178 degrees of freedom
    ##   (4 observations deleted due to missingness)
    ## Multiple R-squared:  0.2642, Adjusted R-squared:  0.256 
    ## F-statistic: 31.96 on 2 and 178 DF,  p-value: 1.382e-12

    ## Warning in geom_point(width = 0.6, position = position_dodge(width = 0.7)):
    ## Ignoring unknown parameters: `width`

    ## `geom_smooth()` using formula = 'y ~ x'

    ## Warning: `position_dodge()` requires non-overlapping x intervals.

![](Plumage_Env_files/figure-gfm/latitude-1.png)<!-- -->

    ## Warning: In lm.fit(x, y, offset = offset, singular.ok = singular.ok, ...) :
    ##  extra argument 'REML' will be disregarded

    ##                                                       formulas    df     AICc
    ## mod2dbyY              lumMean_m ~ s(lon, lat, by = Year) + Age 30.08 -1187.79
    ## mod2dYY        lumMean_m ~ s(lon, lat, by = Year) + Year + Age 31.01 -1187.22
    ## mod2d                            lumMean_m ~ s(lon, lat) + Age 29.41 -1173.51
    ## modlmY                                  lumMean_m ~ Year + Age  9.00 -1161.80
    ## mod2dY                    lumMean_m ~ s(lon, lat) + Year + Age 17.93 -1161.72
    ## modlmlat_randY              lumMean_m ~ lat + (1 | Year) + Age  5.00 -1113.57
    ## modnull                                    lumMean_m ~ 1 + Age  3.00 -1103.41
    ##                deltaic weights MarginalR2 ConditionalR2
    ## mod2dbyY          0.00 5.7e-01         NA            NA
    ## mod2dYY           0.57 4.3e-01         NA            NA
    ## mod2d            14.28 4.5e-04         NA            NA
    ## modlmY           25.99 1.3e-06         NA            NA
    ## mod2dY           26.07 1.2e-06         NA            NA
    ## modlmlat_randY   74.22 4.4e-17       0.17          0.39
    ## modnull          84.38 2.7e-19         NA            NA

## GAMs

``` r
gam_rhs  <- "s(lon, lat) + s(RH_br) + s(Tave_br) + s(PPT_br) + s(srtm) + s(ndvi_M) + Age"
response <- "lumMean"  # column prefix: "lumMean" -> lumMean_c, lumMean_m, ...; "PC1" -> PC1_c, ...

gam_fits <- list()          
gam_results <- list()
for (p in names(patches)) {
  patch_name <- patches[[p]]
  column     <- paste0(response, "_", p)   # e.g. "lumMean_c"

  if (!column %in% names(lum_env)) stop("Column not found in lum_env: ", column)

  dat <- lum_env %>%
    filter(!is.na(.data[[column]]))

  fit <- gam(as.formula(paste(column, "~", gam_rhs)), select = TRUE, data = dat, method = "REML")
  gam_fits[[p]] <- fit      # saved by patch code (gam_fits$m = mantle model), used for the plots
  sm  <- summary(fit)

  # smooth terms
  smooths <- as.data.frame(sm$s.table) %>%
    rownames_to_column("term") %>%
    transmute(term, edf, F, p = `p-value`)

  # Age is a parametric term: reported in the same table (F = t^2 for a 1-df term)
  age_row <- tibble(term = "Age (SY vs ASY)", edf = 1,
                    F = sm$p.table["AgeSY", "t value"]^2,
                    p = sm$p.table["AgeSY", "Pr(>|t|)"])

  gam_results[[column]] <- bind_rows(smooths, age_row) %>%
    mutate(response = column, patch = patch_name, n = nrow(dat),
           dev_expl = sm$dev.expl, .before = 1)
}

gam_results <- bind_rows(gam_results)
```

``` r
# Table of GAM results: one block of rows per patch (smooth terms + Age),
# with sample size and deviance explained for each model
combined_gam <- gam_results %>%
  transmute(Model = patch,
            Response = response,
            n,
            `Deviance explained` = dev_expl,
            Term = term,
            edf, F,
            `p-value` = p) %>%
  mutate(across(where(is.double),
                ~ ifelse(abs(.x) < 0.001, format(.x, scientific = TRUE, digits = 3),
                         as.character(round(.x, 2)))))

combined_gam
```

    ##     Model  Response   n Deviance explained            Term      edf        F
    ## 1  covert lumMean_o 180               0.58      s(lon,lat)     1.59     0.33
    ## 2  covert lumMean_o 180               0.58        s(RH_br)     2.15     1.75
    ## 3  covert lumMean_o 180               0.58      s(Tave_br) 4.06e-05 3.72e-07
    ## 4  covert lumMean_o 180               0.58       s(PPT_br)     3.77     2.59
    ## 5  covert lumMean_o 180               0.58         s(srtm)     2.99      2.9
    ## 6  covert lumMean_o 180               0.58       s(ndvi_M) 3.58e-05 3.03e-07
    ## 7  covert lumMean_o 180               0.58 Age (SY vs ASY)        1    99.76
    ## 8   crown lumMean_c 182               0.27      s(lon,lat)     3.78      0.3
    ## 9   crown lumMean_c 182               0.27        s(RH_br) 1.44e-04 1.26e-05
    ## 10  crown lumMean_c 182               0.27      s(Tave_br)        2     0.76
    ## 11  crown lumMean_c 182               0.27       s(PPT_br)     1.65     0.64
    ## 12  crown lumMean_c 182               0.27         s(srtm)     0.92     1.26
    ## 13  crown lumMean_c 182               0.27       s(ndvi_M)     1.65     0.68
    ## 14  crown lumMean_c 182               0.27 Age (SY vs ASY)        1     1.21
    ## 15 mantle lumMean_m 181               0.56      s(lon,lat)     1.94     2.24
    ## 16 mantle lumMean_m 181               0.56        s(RH_br)     2.21     2.14
    ## 17 mantle lumMean_m 181               0.56      s(Tave_br) 3.61e-04 9.26e-06
    ## 18 mantle lumMean_m 181               0.56       s(PPT_br)     2.33     1.45
    ## 19 mantle lumMean_m 181               0.56         s(srtm)     4.59     6.97
    ## 20 mantle lumMean_m 181               0.56       s(ndvi_M) 2.67e-04 1.94e-05
    ## 21 mantle lumMean_m 181               0.56 Age (SY vs ASY)        1    36.18
    ## 22 throat lumMean_t 181               0.71      s(lon,lat)     4.24     0.32
    ## 23 throat lumMean_t 181               0.71        s(RH_br) 2.22e-04 1.48e-06
    ## 24 throat lumMean_t 181               0.71      s(Tave_br)     2.13        1
    ## 25 throat lumMean_t 181               0.71       s(PPT_br)     4.67     6.69
    ## 26 throat lumMean_t 181               0.71         s(srtm)     2.83     4.47
    ## 27 throat lumMean_t 181               0.71       s(ndvi_M) 7.67e-05 4.62e-07
    ## 28 throat lumMean_t 181               0.71 Age (SY vs ASY)        1    18.66
    ## 29  wspot lumMean_w 182               0.46      s(lon,lat) 1.34e-04 3.80e-06
    ## 30  wspot lumMean_w 182               0.46        s(RH_br) 2.57e-05 1.14e-06
    ## 31  wspot lumMean_w 182               0.46      s(Tave_br)     0.48      0.1
    ## 32  wspot lumMean_w 182               0.46       s(PPT_br)     0.85     0.63
    ## 33  wspot lumMean_w 182               0.46         s(srtm) 9.35e-05 9.00e-06
    ## 34  wspot lumMean_w 182               0.46       s(ndvi_M) 1.72e-05 2.67e-07
    ## 35  wspot lumMean_w 182               0.46 Age (SY vs ASY)        1   144.77
    ##     p-value
    ## 1  6.76e-04
    ## 2  1.01e-04
    ## 3       0.9
    ## 4  1.75e-05
    ## 5  9.36e-07
    ## 6      0.94
    ## 7  1.01e-18
    ## 8      0.02
    ## 9       0.3
    ## 10        0
    ## 11     0.01
    ## 12 4.12e-06
    ## 13     0.01
    ## 14     0.27
    ## 15 0.00e+00
    ## 16 1.69e-05
    ## 17     0.74
    ## 18 7.58e-04
    ## 19 0.00e+00
    ## 20     0.47
    ## 21 1.09e-08
    ## 22     0.01
    ## 23     0.94
    ## 24 1.26e-04
    ## 25 0.00e+00
    ## 26 0.00e+00
    ## 27     0.95
    ## 28 2.69e-05
    ## 29     0.46
    ## 30     0.58
    ## 31     0.16
    ## 32     0.01
    ## 33     0.33
    ## 34     0.83
    ## 35 8.36e-25

``` r
write.csv(combined_gam, here("results/Env_GAM_pl_patches.csv"), row.names = FALSE)
```

``` r
# Partial-effect plots -------------------------------------------------------
# For each patch GAM, one panel per environmental variable showing that variable's
# fitted smooth on its own, s(variable), i.e. its partial effect:
#   - line + band: the smooth and its 95% confidence interval. The y-axis is the
#     change in the response due to this term; mgcv centres each smooth so its
#     average over the birds is 0 (so it's a difference from average, not a
#     predicted luminance, and no "average bird" has to be made up).
#   - points: partial residuals = each bird's model residual + its value of this
#     term, i.e. the data with the effects of all OTHER terms (location, other
#     climate variables, age) removed.
# A term the model shrank away (select = TRUE) shows as a flat line at 0.
# The first panel is the RAW latitude relationship (latitude sits inside the 2-D
# s(lon, lat) surface, so it has no one-dimensional partial effect).

# Environmental variables to plot, with axis labels (a named vector: column = label)
env_vars <- c(PPT_br = "Mean Precipitation (mm)",
              RH_br = "Relative Humidity (%)",
              srtm    = "Elevation (m)")

response_label <- c(lumMean = "luminance", PC1 = "PC1")[[response]]

# Which patches to plot (codes from `patches`): "m" = mantle only.
# For all five use names(patches)
plot_patches <- "m"

for (p in plot_patches) {
  column  <- paste0(response, "_", p)                  # e.g. "lumMean_m"
  y_label <- paste(tools::toTitleCase(patches[[p]]), response_label)
  model   <- gam_fits[[p]]

  # the exact rows the model was fitted on (so residuals line up with birds)
  birds <- model$model

  panels <- list()

  # Latitude: raw data with a linear fit (descriptive, not a model effect)
  panels[["lat"]] <- ggplot(birds, aes(x = lat, y = .data[[column]])) +
    geom_point(aes(color = lat, shape = Age), size = 4) +
    geom_smooth(method = "lm", color = "black") +
    scale_x_reverse() +
    scale_color_viridis_c(direction = -1) +
    labs(x = "Latitude", y = paste(y_label, "(raw)"), color = "Latitude")

  for (v in names(env_vars)) {
    term <- paste0("s(", v, ")")                        # e.g. "s(srtm)"

    # The smooth over the observed range of v. predict() needs every model
    # variable in newdata, but with type = "terms" only this term is returned,
    # so the other columns (copied from the first bird) don't affect the result.
    grid <- birds[rep(1, 100), ]
    grid[[v]] <- seq(min(birds[[v]]), max(birds[[v]]), length.out = 100)
    curve <- predict(model, newdata = grid, type = "terms", terms = term, se.fit = TRUE)
    grid$effect   <- curve$fit[, term]
    grid$lower_CI <- curve$fit[, term] - 1.96 * curve$se.fit[, term]
    grid$upper_CI <- curve$fit[, term] + 1.96 * curve$se.fit[, term]

    if (anyNA(grid$effect)) stop("Partial effect is NA for ", column, " vs ", v)

    # Partial residuals: residual + this bird's value of the term
    # (Gaussian model, so the default deviance residuals = observed - fitted)
    bird_terms <- predict(model, type = "terms", terms = term)
    birds$partial_residual <- residuals(model) + bird_terms[, term]

    # edf and p-value of this smooth, shown above the panel
    term_stats <- summary(model)$s.table[term, ]
    # mgcv reports p-values below ~2e-16 as exactly 0
    p_text <- ifelse(term_stats[["p-value"]] < 2e-16, "p < 2e-16",
                     paste("p =", signif(term_stats[["p-value"]], 2)))
    subtitle <- paste0("edf = ", round(term_stats[["edf"]], 2), ", ", p_text)

    panels[[v]] <- ggplot(birds, aes(x = .data[[v]], y = partial_residual)) +
      geom_hline(yintercept = 0, linetype = "dashed", color = "grey50") +
      geom_point(aes(color = lat, shape = Age), size = 4) +
      geom_ribbon(data = grid, aes(x = .data[[v]], ymin = lower_CI, ymax = upper_CI),
                  alpha = 0.2, inherit.aes = FALSE) +
      geom_line(data = grid, aes(x = .data[[v]], y = effect),
                linewidth = 1, color = "black", inherit.aes = FALSE) +
      scale_color_viridis_c(direction = -1) +
      labs(x = env_vars[[v]], y = paste("Partial effect on", tolower(y_label)),
           subtitle = subtitle, color = "Latitude")
  }

  env_plots <- wrap_plots(panels, nrow = 1) +
    plot_annotation(tag_levels = "A") +
    plot_layout(axis_titles = "collect", guides = "collect") &   # one shared legend
    theme_classic() &
    theme(text = element_text(size = 24))

  print(env_plots)
  ggsave(here(paste0("results/env_plots_", column, ".png")), plot = env_plots,
         width = 8 * length(panels), height = 8, dpi = 600)
}
```

    ## `geom_smooth()` using formula = 'y ~ x'
    ## `geom_smooth()` using formula = 'y ~ x'

![](Plumage_Env_files/figure-gfm/plot-1.png)<!-- -->
