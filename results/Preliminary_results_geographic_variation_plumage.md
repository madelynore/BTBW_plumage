Preliminary_results_geographic_variation_plumage
================
Ore, MJ.
2024-06-18

# How does brightness of the dorsum vary across populations?

![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/brightness%20by%20pop-1.png)<!-- -->
![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/brightness%20by%20indv-1.png)<!-- -->
\##Short wavelength by pop

![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/sw%20by%20pop-1.png)<!-- -->
\# short wavelength by indv
![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/blue%20by%20indv-1.png)<!-- -->

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

# are larger wingspots also brighter? no

![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/wingspot-1.png)<!-- -->![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/wingspot-2.png)<!-- -->![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/wingspot-3.png)<!-- -->

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

## Do darker birds in the south have brighter/larger wingspots?

# they have brighter but NOT larger wingspots

![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/south%20dark%20wingspot-1.png)<!-- -->

    ## 
    ## Call:
    ## lm(formula = dblMean_w ~ dblMean_d, data = s_lum)
    ## 
    ## Residuals:
    ##       Min        1Q    Median        3Q       Max 
    ## -0.107983 -0.022388  0.000505  0.024624  0.074847 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  0.53475    0.04309  12.411 2.39e-13 ***
    ## dblMean_d   -1.53792    0.75624  -2.034   0.0509 .  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.04479 on 30 degrees of freedom
    ##   (6 observations deleted due to missingness)
    ## Multiple R-squared:  0.1212, Adjusted R-squared:  0.09186 
    ## F-statistic: 4.136 on 1 and 30 DF,  p-value: 0.05092

    ## Analysis of Variance Table
    ## 
    ## Response: dblMean_w
    ##           Df   Sum Sq  Mean Sq F value  Pr(>F)  
    ## dblMean_d  1 0.008296 0.008296  4.1357 0.05092 .
    ## Residuals 30 0.060179 0.002006                  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/south%20dark%20wingspot-2.png)<!-- -->

    ## 
    ## Call:
    ## lm(formula = area_w ~ dblMean_d, data = s_lum)
    ## 
    ## Residuals:
    ##    Min     1Q Median     3Q    Max 
    ## -29352 -13811   1515  14562  26335 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)   
    ## (Intercept)    58278      16732   3.483  0.00154 **
    ## dblMean_d      79130     293679   0.269  0.78943   
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 17390 on 30 degrees of freedom
    ##   (6 observations deleted due to missingness)
    ## Multiple R-squared:  0.002414,   Adjusted R-squared:  -0.03084 
    ## F-statistic: 0.0726 on 1 and 30 DF,  p-value: 0.7894

    ## Analysis of Variance Table
    ## 
    ## Response: area_w
    ##           Df     Sum Sq   Mean Sq F value Pr(>F)
    ## dblMean_d  1   21962755  21962755  0.0726 0.7894
    ## Residuals 30 9075488605 302516287

## Do darker birds in the North have brighter/larger wingspots?

# they have larger but NOT brighter wingspots - but that’s likely bc of age

![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/north%20dark%20wingspot-1.png)<!-- -->

    ## 
    ## Call:
    ## lm(formula = dblMean_w ~ dblMean_d, data = n_lum)
    ## 
    ## Residuals:
    ##       Min        1Q    Median        3Q       Max 
    ## -0.117160 -0.034415  0.008162  0.037568  0.079028 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  0.53477    0.06351   8.421 9.95e-10 ***
    ## dblMean_d   -1.33073    0.92887  -1.433    0.161    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.05352 on 33 degrees of freedom
    ## Multiple R-squared:  0.05855,    Adjusted R-squared:  0.03002 
    ## F-statistic: 2.052 on 1 and 33 DF,  p-value: 0.1614

    ## Analysis of Variance Table
    ## 
    ## Response: dblMean_w
    ##           Df   Sum Sq   Mean Sq F value Pr(>F)
    ## dblMean_d  1 0.005878 0.0058782  2.0524 0.1614
    ## Residuals 33 0.094511 0.0028640

![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/north%20dark%20wingspot-2.png)<!-- -->

    ## 
    ## Call:
    ## lm(formula = area_w ~ dblMean_d, data = n_lum)
    ## 
    ## Residuals:
    ##    Min     1Q Median     3Q    Max 
    ## -27185 -11069  -4704   8518  40941 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)   112326      22402   5.014 1.77e-05 ***
    ## dblMean_d    -837663     327647  -2.557   0.0154 *  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 18880 on 33 degrees of freedom
    ## Multiple R-squared:  0.1653, Adjusted R-squared:   0.14 
    ## F-statistic: 6.536 on 1 and 33 DF,  p-value: 0.01536

    ## Analysis of Variance Table
    ## 
    ## Response: area_w
    ##           Df     Sum Sq    Mean Sq F value  Pr(>F)  
    ## dblMean_d  1 2.3292e+09 2329175046  6.5362 0.01536 *
    ## Residuals 33 1.1760e+10  356350218                  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

\#Age and Markers

prep data

## Are wing spots brighter or larger in ASY vs SY males

![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/wingspot%20and%20age-1.png)<!-- -->![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/wingspot%20and%20age-2.png)<!-- -->

## Are backs darker in ASY vs SY males

![](Preliminary_results_geographic_variation_plumage_files/figure-gfm/dorsum%20brightness%20vs%20age-1.png)<!-- -->
