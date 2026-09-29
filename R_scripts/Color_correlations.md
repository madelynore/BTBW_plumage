Are dark-backed birds darker overall?
================
Ore, MJ.
2025-03-10

# normality checks

![](Color_correlations_files/figure-gfm/normality-1.png)<!-- -->![](Color_correlations_files/figure-gfm/normality-2.png)<!-- -->![](Color_correlations_files/figure-gfm/normality-3.png)<!-- -->![](Color_correlations_files/figure-gfm/normality-4.png)<!-- -->![](Color_correlations_files/figure-gfm/normality-5.png)<!-- -->![](Color_correlations_files/figure-gfm/normality-6.png)<!-- -->

# make a table of results

    ##                Response                                             Explanatory
    ## 1       Crown luminance     Fixed effect: Mantle luminance, Random effect: Year
    ## 2      Throat luminance     Fixed effect: Mantle luminance, Random effect: Year
    ## 3      Covert luminance     Fixed effect: Mantle luminance, Random effect: Year
    ## 4  Wing spot area (mm²)     Fixed effect: Mantle luminance, Random effect: Year
    ## 5       Crown luminance  Fixed effect: Wing spot luminance, Random effect: Year
    ## 6      Covert luminance  Fixed effect: Wing spot luminance, Random effect: Year
    ## 7      Mantle luminance  Fixed effect: Wing spot luminance, Random effect: Year
    ## 8      Throat luminance  Fixed effect: Wing spot luminance, Random effect: Year
    ## 9       Crown luminance Fixed effect: Wing spot area (mm²), Random effect: Year
    ## 10     Covert luminance Fixed effect: Wing spot area (mm²), Random effect: Year
    ## 11     Mantle luminance Fixed effect: Wing spot area (mm²), Random effect: Year
    ## 12     Throat luminance Fixed effect: Wing spot area (mm²), Random effect: Year
    ##         R2m  P_value
    ## 1      0.19 2.26e-05
    ## 2      0.16 5.00e-05
    ## 3      0.34 2.06e-10
    ## 4  4.16e-06     0.98
    ## 5     0.024    0.076
    ## 6    0.0072      0.3
    ## 7     0.031    0.016
    ## 8     0.013     0.17
    ## 9    0.0031     0.52
    ## 10   0.0031     0.49
    ## 11 2.35e-04     0.84
    ## 12   0.0027     0.54
