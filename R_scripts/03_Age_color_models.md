Age_Color_models
================
Ore, MJ.
2025-03-20

    ## Warning: package 'dplyr' was built under R version 4.5.2

    ## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ## ✔ dplyr     1.2.1     ✔ readr     2.1.5
    ## ✔ forcats   1.0.1     ✔ stringr   1.6.0
    ## ✔ ggplot2   4.0.0     ✔ tibble    3.3.0
    ## ✔ lubridate 1.9.4     ✔ tidyr     1.3.1
    ## ✔ purrr     1.2.0     
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()
    ## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
    ## here() starts at /Users/madelynore/Documents/Work/PhD/BTBW_geographic_coloration/BTBW_plumage
    ## 
    ## Loading required package: viridisLite
    ## 
    ## here() starts at /Users/madelynore/Documents/Work/PhD/BTBW_geographic_coloration/BTBW_plumage

# Crown

    ## Warning: Removed 3 rows containing non-finite outside the scale range
    ## (`stat_boxplot()`).

![](Age_color_models_files/figure-gfm/crown-1.png)<!-- -->

# coverts

    ## Warning: Removed 5 rows containing non-finite outside the scale range
    ## (`stat_boxplot()`).

![](Age_color_models_files/figure-gfm/coverts-1.png)<!-- -->

# throat

    ## Warning: Removed 4 rows containing non-finite outside the scale range
    ## (`stat_boxplot()`).

![](Age_color_models_files/figure-gfm/throat-1.png)<!-- -->

# mantle

    ## Warning: Removed 4 rows containing non-finite outside the scale range
    ## (`stat_boxplot()`).

![](Age_color_models_files/figure-gfm/mantle-1.png)<!-- -->

# wingspot

    ## Warning: Removed 3 rows containing non-finite outside the scale range
    ## (`stat_boxplot()`).

![](Age_color_models_files/figure-gfm/wingspot%20color-1.png)<!-- -->

    ## Warning: Removed 3 rows containing non-finite outside the scale range
    ## (`stat_boxplot()`).

![](Age_color_models_files/figure-gfm/wingspot%20area-1.png)<!-- -->

# make a table of results

| Trait | ASY n | ASY mean (SD) | SY n | SY mean (SD) | t | df | p |
|:---|---:|:---|---:|:---|---:|---:|:---|
| Crown luminance | 110 | 0.0718 (0.01) | 72 | 0.0718 (0.011) | 0.01 | 144.1 | 0.995 |
| Covert luminance | 110 | 0.0687 (0.016) | 70 | 0.0894 (0.017) | -8.21 | 137.7 | 1.45e-13 |
| Mantle luminance | 112 | 0.0623 (0.013) | 69 | 0.0735 (0.0074) | -7.26 | 177.5 | 1.17e-11 |
| Throat luminance | 110 | 0.0433 (0.0093) | 71 | 0.0473 (0.0097) | -2.71 | 144.6 | 0.00744 |
| Wing spot luminance | 112 | 0.445 (0.047) | 70 | 0.35 (0.06) | 11.18 | 120.2 | 2.44e-20 |
| Wing spot area (mm²) | 112 | 43.3 (13) | 70 | 27.4 (9.9) | 9.45 | 171.1 | 2.62e-17 |

Plumage traits by age class

Note: Welch two-sample t-tests comparing after-second-year (ASY) and
second-year (SY) males; t \> 0 means ASY is higher. Luminance = mean
double-cone catch of the patch; n = birds with a measurement for that
patch.
