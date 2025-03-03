Preliminary_results_geographic_variation_plumage
================
Ore, MJ.
2024-06-18

# How does brightness of the dorsum vary across populations?

![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/brightness%20by%20pop-1.png)<!-- -->

    ## 
    ## Call:
    ## lm(formula = dblMean ~ lat, data = d_sub, na.action = na.exclude)
    ## 
    ## Residuals:
    ##        Min         1Q     Median         3Q        Max 
    ## -0.0214893 -0.0082713  0.0001099  0.0059726  0.0228861 
    ## 
    ## Coefficients:
    ##              Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept) 0.0189550  0.0104424   1.815   0.0732 .  
    ## lat         0.0010708  0.0002543   4.212 6.46e-05 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.01095 on 82 degrees of freedom
    ## Multiple R-squared:  0.1778, Adjusted R-squared:  0.1678 
    ## F-statistic: 17.74 on 1 and 82 DF,  p-value: 6.463e-05

![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/brightness%20by%20indv-1.png)<!-- -->
\##Short wavelength by pop

![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/sw%20by%20pop-1.png)<!-- -->

# Correlations between body parts - Are dark backed birds darker overall?

## Dorsum vs throat

![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/d%20vs%20t%20plot-1.png)<!-- -->![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/d%20vs%20t%20plot-2.png)<!-- -->

    ## 
    ##  Shapiro-Wilk normality test
    ## 
    ## data:  lum_wide$dblMean_d
    ## W = 0.98476, p-value = 0.4256

    ## 
    ##  Shapiro-Wilk normality test
    ## 
    ## data:  lum_wide$dblMean_t
    ## W = 0.88969, p-value = 2.868e-06

![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/d%20vs%20t%20plot-3.png)<!-- -->

## Dorsum vs wing covert

![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/d%20vs%20o%20plot-1.png)<!-- -->![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/d%20vs%20o%20plot-2.png)<!-- -->

    ## 
    ##  Shapiro-Wilk normality test
    ## 
    ## data:  lum_wide$dblMean_d
    ## W = 0.98476, p-value = 0.4256

    ## 
    ##  Shapiro-Wilk normality test
    ## 
    ## data:  lum_wide$dblMean_o
    ## W = 0.95748, p-value = 0.007313

![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/d%20vs%20o%20plot-3.png)<!-- -->

## Dorsum and belly

![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/d%20vs%20b%20plot%20-1.png)<!-- -->

    ## 
    ##  Shapiro-Wilk normality test
    ## 
    ## data:  lum_wide$dblMean_b
    ## W = 0.96185, p-value = 0.01227

![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/d%20vs%20b%20plot%20-2.png)<!-- -->

## Dorsum and wing spot - do darker birds have whiter wing spots?

![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/d%20and%20ws%20plot-1.png)<!-- -->

    ## 
    ##  Shapiro-Wilk normality test
    ## 
    ## data:  lum_wide$dblMean_w
    ## W = 0.9772, p-value = 0.1275

![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/d%20and%20ws%20plot-2.png)<!-- -->

# Do darker birds have larger wing spots?

    ## 
    ##  Shapiro-Wilk normality test
    ## 
    ## data:  lum_wide$area_w
    ## W = 0.9892, p-value = 0.6942

    ## 
    ##  Shapiro-Wilk normality test
    ## 
    ## data:  lum_wide$dblMean_d
    ## W = 0.98476, p-value = 0.4256

![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/dorsum%20vs%20wingspot%20area-1.png)<!-- -->

\#Do brighter/larger wingspots correlate to throat badge or uv in crown?

    ## 
    ##  Shapiro-Wilk normality test
    ## 
    ## data:  lum_wide$area_w
    ## W = 0.9892, p-value = 0.6942

    ## 
    ##  Shapiro-Wilk normality test
    ## 
    ## data:  lum_wide$dblMean_w
    ## W = 0.9772, p-value = 0.1275

    ## 
    ##  Shapiro-Wilk normality test
    ## 
    ## data:  lum_wide$dblMean_t
    ## W = 0.88969, p-value = 2.868e-06

    ## 
    ##  Shapiro-Wilk normality test
    ## 
    ## data:  lum_wide$uvMean_c
    ## W = 0.99237, p-value = 0.9337

![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/sex%20selection-1.png)<!-- -->![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/sex%20selection-2.png)<!-- -->![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/sex%20selection-3.png)<!-- -->![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/sex%20selection-4.png)<!-- -->![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/sex%20selection-5.png)<!-- -->![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/sex%20selection-6.png)<!-- -->![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/sex%20selection-7.png)<!-- -->![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/sex%20selection-8.png)<!-- -->
\#Age and Markers

prep data

## Are wing spots brighter or larger in ASY vs SY males

    ## 
    ##  Welch Two Sample t-test
    ## 
    ## data:  dblMean_w by Age
    ## t = 8.1535, df = 82.159, p-value = 3.426e-12
    ## alternative hypothesis: true difference in means between group ASY and group SY is not equal to 0
    ## 95 percent confidence interval:
    ##  0.06652207 0.10945645
    ## sample estimates:
    ## mean in group ASY  mean in group SY 
    ##         0.4452821         0.3572929

![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/wingspot%20and%20age-1.png)<!-- -->

    ## 
    ##  Welch Two Sample t-test
    ## 
    ## data:  area_w by Age
    ## t = 8.6023, df = 129.27, p-value = 2.257e-14
    ## alternative hypothesis: true difference in means between group ASY and group SY is not equal to 0
    ## 95 percent confidence interval:
    ##  18282.19 29203.69
    ## sample estimates:
    ## mean in group ASY  mean in group SY 
    ##          59050.30          35307.36

![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/wingspot%20and%20age-2.png)<!-- -->

## Are backs darker in ASY vs SY males

    ## 
    ##  Welch Two Sample t-test
    ## 
    ## data:  dblMean_d by Age
    ## t = -6.9236, df = 133.9, p-value = 1.664e-10
    ## alternative hypothesis: true difference in means between group ASY and group SY is not equal to 0
    ## 95 percent confidence interval:
    ##  -0.014977684 -0.008321802
    ## sample estimates:
    ## mean in group ASY  mean in group SY 
    ##        0.06264613        0.07429587

![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/dorsum%20brightness%20vs%20age-1.png)<!-- -->
