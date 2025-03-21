Dorsum_environment
================
Ore, MJ.
2025-03-11

    ## Warning: package 'ggplot2' was built under R version 4.3.1

    ## Warning: package 'tidyr' was built under R version 4.3.1

    ## Warning: package 'readr' was built under R version 4.3.1

    ## Warning: package 'purrr' was built under R version 4.3.3

    ## Warning: package 'dplyr' was built under R version 4.3.1

    ## Warning: package 'stringr' was built under R version 4.3.1

    ## Warning: package 'lubridate' was built under R version 4.3.1

    ## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ## ✔ dplyr     1.1.4     ✔ readr     2.1.5
    ## ✔ forcats   1.0.0     ✔ stringr   1.5.1
    ## ✔ ggplot2   3.5.1     ✔ tibble    3.2.1
    ## ✔ lubridate 1.9.3     ✔ tidyr     1.3.1
    ## ✔ purrr     1.0.4     
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()
    ## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
    ## here() starts at /Users/madelynore/Documents/Cornell/BTBW_geographic_coloration/BTBW_plumage

    ## Warning: package 'viridis' was built under R version 4.3.1

    ## Loading required package: viridisLite
    ## here() starts at /Users/madelynore/Documents/Cornell/BTBW_geographic_coloration/BTBW_plumage

# Build model for env-dorsum correlation

    ## Loading required package: lme4

    ## Warning: package 'lme4' was built under R version 4.3.1

    ## Loading required package: Matrix

    ## Warning: package 'Matrix' was built under R version 4.3.1

    ## 
    ## Attaching package: 'Matrix'

    ## The following objects are masked from 'package:tidyr':
    ## 
    ##     expand, pack, unpack

    ## 
    ## Attaching package: 'lmerTest'

    ## The following object is masked from 'package:lme4':
    ## 
    ##     lmer

    ## The following object is masked from 'package:stats':
    ## 
    ##     step

    ## Warning: package 'MASS' was built under R version 4.3.1

    ## 
    ## Attaching package: 'MASS'

    ## The following object is masked from 'package:dplyr':
    ## 
    ##     select

    ## Warning in optwrap(optimizer, devfun, getStart(start, rho$pp), lower =
    ## rho$lower, : convergence code 5 from nloptwrap: NLOPT_MAXEVAL_REACHED:
    ## Optimization stopped because maxeval (above) was reached.

    ## boundary (singular) fit: see help('isSingular')

    ## Warning: Model failed to converge with 2 negative eigenvalues: -4.6e-03
    ## -1.3e-02

    ## Linear mixed model fit by REML. t-tests use Satterthwaite's method [
    ## lmerModLmerTest]
    ## Formula: dblMean_d ~ bio_10 + bio_18 + srtm + lat + (lat | pop) + (dblMean_d |  
    ##     Year) + (dblMean_d | prepartor) + (dblMean_d | pop)
    ##    Data: lumenv_sel
    ## 
    ## REML criterion at convergence: -908.3
    ## 
    ## Scaled residuals: 
    ##      Min       1Q   Median       3Q      Max 
    ## -1.69281 -0.07378  0.00464  0.07716  1.25669 
    ## 
    ## Random effects:
    ##  Groups    Name        Variance  Std.Dev.  Corr 
    ##  pop       (Intercept) 6.494e-12 2.548e-06      
    ##            dblMean_d   1.268e-08 1.126e-04 -1.00
    ##  pop.1     (Intercept) 1.848e-13 4.299e-07      
    ##            lat         3.916e-15 6.258e-08 1.00 
    ##  Year      (Intercept) 1.303e-05 3.609e-03      
    ##            dblMean_d   2.820e-03 5.310e-02 -1.00
    ##  prepartor (Intercept) 1.295e-04 1.138e-02      
    ##            dblMean_d   3.585e-02 1.894e-01 -0.99
    ##  Residual              1.597e-06 1.264e-03      
    ## Number of obs: 98, groups:  pop, 21; Year, 7; prepartor, 6
    ## 
    ## Fixed effects:
    ##               Estimate Std. Error         df t value Pr(>|t|)    
    ## (Intercept)  5.883e-02  1.337e-02  2.848e+01   4.400 0.000138 ***
    ## bio_10       2.972e-05  2.780e-04  2.912e+01   0.107 0.915610    
    ## bio_18      -9.334e-07  4.260e-06  3.261e+01  -0.219 0.827915    
    ## srtm         2.137e-07  1.254e-06  2.322e+01   0.170 0.866127    
    ## lat          1.765e-05  1.777e-04  2.574e+01   0.099 0.921688    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##        (Intr) bio_10 bio_18 srtm  
    ## bio_10 -0.950                     
    ## bio_18 -0.439  0.246              
    ## srtm   -0.873  0.807  0.191       
    ## lat    -0.988  0.912  0.419  0.892
    ## optimizer (nloptwrap) convergence code: 5 (NLOPT_MAXEVAL_REACHED: Optimization stopped because maxeval (above) was reached.)
    ## boundary (singular) fit: see help('isSingular')

    ## Start:  AIC=-919.48
    ## dblMean_d ~ (bio_10 + bio_18 + srtm + pop)^4
    ## 
    ## 
    ## Step:  AIC=-919.48
    ## dblMean_d ~ bio_10 + bio_18 + srtm + pop + bio_10:bio_18 + bio_10:srtm + 
    ##     bio_10:pop + bio_18:srtm + bio_18:pop + srtm:pop + bio_10:bio_18:srtm + 
    ##     bio_10:bio_18:pop + bio_10:srtm:pop + bio_18:srtm:pop
    ## 
    ## 
    ## Step:  AIC=-919.48
    ## dblMean_d ~ bio_10 + bio_18 + srtm + pop + bio_10:bio_18 + bio_10:srtm + 
    ##     bio_10:pop + bio_18:srtm + bio_18:pop + srtm:pop + bio_10:bio_18:srtm + 
    ##     bio_10:bio_18:pop + bio_10:srtm:pop
    ## 
    ## 
    ## Step:  AIC=-919.48
    ## dblMean_d ~ bio_10 + bio_18 + srtm + pop + bio_10:bio_18 + bio_10:srtm + 
    ##     bio_10:pop + bio_18:srtm + bio_18:pop + srtm:pop + bio_10:bio_18:srtm + 
    ##     bio_10:bio_18:pop
    ## 
    ## 
    ## Step:  AIC=-919.48
    ## dblMean_d ~ bio_10 + bio_18 + srtm + pop + bio_10:bio_18 + bio_10:srtm + 
    ##     bio_10:pop + bio_18:srtm + bio_18:pop + srtm:pop + bio_10:bio_18:srtm
    ## 
    ## 
    ## Step:  AIC=-919.48
    ## dblMean_d ~ bio_10 + bio_18 + srtm + pop + bio_10:bio_18 + bio_10:srtm + 
    ##     bio_10:pop + bio_18:srtm + bio_18:pop + srtm:pop
    ## 
    ## 
    ## Step:  AIC=-919.48
    ## dblMean_d ~ bio_10 + bio_18 + srtm + pop + bio_10:bio_18 + bio_10:srtm + 
    ##     bio_10:pop + bio_18:srtm + bio_18:pop
    ## 
    ##                 Df  Sum of Sq       RSS     AIC
    ## - bio_10:srtm    1 0.00000102 0.0031626 -921.45
    ## <none>                        0.0031616 -919.48
    ## - bio_18:srtm    1 0.00010698 0.0032686 -918.22
    ## - bio_10:bio_18  1 0.00010795 0.0032696 -918.19
    ## - bio_10:pop     6 0.00049197 0.0036536 -917.31
    ## - bio_18:pop     6 0.00073666 0.0038983 -910.95
    ## 
    ## Step:  AIC=-921.45
    ## dblMean_d ~ bio_10 + bio_18 + srtm + pop + bio_10:bio_18 + bio_10:pop + 
    ##     bio_18:srtm + bio_18:pop
    ## 
    ##                     Df  Sum of Sq       RSS     AIC
    ## <none>                            0.0031626 -921.45
    ## - bio_10:bio_18      1 0.00011022 0.0032728 -920.09
    ## + bio_10:srtm        1 0.00000102 0.0031616 -919.48
    ## + srtm:pop           1 0.00000102 0.0031616 -919.48
    ## + bio_10:bio_18:pop  1 0.00000102 0.0031616 -919.48
    ## - bio_18:srtm        1 0.00014589 0.0033085 -919.03
    ## - bio_10:pop         6 0.00073251 0.0038951 -913.03
    ## - bio_18:pop         6 0.00074077 0.0039034 -912.83

    ## 
    ## Call:
    ## lm(formula = dblMean_d ~ bio_10 + bio_18 + srtm + pop + bio_10:bio_18 + 
    ##     bio_10:pop + bio_18:srtm + bio_18:pop, data = norand)
    ## 
    ## Residuals:
    ##       Min        1Q    Median        3Q       Max 
    ## -0.014165 -0.002526  0.000000  0.002076  0.015827 
    ## 
    ## Coefficients: (20 not defined because of singularities)
    ##                            Estimate Std. Error t value Pr(>|t|)  
    ## (Intercept)               8.728e+01  6.607e+01   1.321   0.1923  
    ## bio_10                   -4.267e+00  3.414e+00  -1.250   0.2169  
    ## bio_18                   -3.824e-01  2.734e-01  -1.399   0.1679  
    ## srtm                     -1.981e-02  1.286e-02  -1.540   0.1295  
    ## popME.Piscataquis         8.153e+00  5.236e+00   1.557   0.1255  
    ## popMI.Iron                1.720e+01  7.862e+00   2.188   0.0332 *
    ## popNB.York                1.276e+00  4.051e+00   0.315   0.7541  
    ## popNC.Graham              2.114e+01  1.924e+01   1.098   0.2771  
    ## popNS.Halifax            -2.476e+00  1.762e+00  -1.405   0.1659  
    ## popNY.Hamilton           -9.186e+00  5.374e+00  -1.709   0.0934 .
    ## popNY.Sullivan            1.079e+01  7.311e+00   1.476   0.1459  
    ## popON.Renfrew            -3.081e+00  6.818e+00  -0.452   0.6532  
    ## popON.Thunder             8.254e+00  5.440e+00   1.517   0.1352  
    ## popPA.Bedford             4.917e+01  2.873e+01   1.711   0.0930 .
    ## popPA.Potter              7.914e+00  5.442e+00   1.454   0.1519  
    ## popSC.Oconee              2.659e+01  2.014e+01   1.320   0.1926  
    ## popTN.Carter              1.702e+01  1.133e+01   1.503   0.1390  
    ## popTN.Unicoi              2.232e+01  1.478e+01   1.511   0.1369  
    ## popVA.Giles               6.710e+00  4.842e+00   1.386   0.1717  
    ## popVA.Wise                2.315e+01  1.471e+01   1.574   0.1215  
    ## popWI.All                -1.043e+00  3.264e+00  -0.319   0.7507  
    ## popWV.Randolph            7.718e+00  5.358e+00   1.441   0.1557  
    ## popWV.Tucker              2.487e+01  1.746e+01   1.424   0.1605  
    ## popWV.Webster             3.531e+00  2.339e+00   1.510   0.1372  
    ## bio_10:bio_18             1.776e-02  1.320e-02   1.346   0.1841  
    ## bio_10:popME.Piscataquis -9.098e-01  5.594e-01  -1.626   0.1099  
    ## bio_10:popMI.Iron        -1.173e+00  5.796e-01  -2.024   0.0481 *
    ## bio_10:popNB.York        -6.417e-01  5.229e-01  -1.227   0.2253  
    ## bio_10:popNC.Graham      -1.050e+00  9.677e-01  -1.086   0.2827  
    ## bio_10:popNS.Halifax      7.941e-01  4.993e-01   1.591   0.1178  
    ## bio_10:popNY.Hamilton    -4.127e-01  3.664e-01  -1.126   0.2652  
    ## bio_10:popNY.Sullivan            NA         NA      NA       NA  
    ## bio_10:popON.Renfrew     -5.501e-01  5.143e-01  -1.070   0.2897  
    ## bio_10:popON.Thunder             NA         NA      NA       NA  
    ## bio_10:popPA.Bedford     -1.535e+00  8.999e-01  -1.706   0.0940 .
    ## bio_10:popPA.Potter              NA         NA      NA       NA  
    ## bio_10:popSC.Oconee      -1.452e+00  1.103e+00  -1.316   0.1939  
    ## bio_10:popTN.Carter      -6.393e-01  4.121e-01  -1.551   0.1270  
    ## bio_10:popTN.Unicoi      -9.276e-01  6.066e-01  -1.529   0.1323  
    ## bio_10:popVA.Giles               NA         NA      NA       NA  
    ## bio_10:popVA.Wise        -9.435e-01  5.929e-01  -1.591   0.1176  
    ## bio_10:popWI.All          5.567e-01  4.266e-01   1.305   0.1977  
    ## bio_10:popWV.Randolph            NA         NA      NA       NA  
    ## bio_10:popWV.Tucker      -9.793e-01  6.931e-01  -1.413   0.1636  
    ## bio_10:popWV.Webster             NA         NA      NA       NA  
    ## bio_18:srtm               6.940e-05  4.481e-05   1.549   0.1275  
    ## bio_18:popME.Piscataquis  5.486e-02  3.668e-02   1.496   0.1408  
    ## bio_18:popMI.Iron         3.838e-02  3.298e-02   1.164   0.2499  
    ## bio_18:popNB.York         6.249e-02  3.797e-02   1.646   0.1059  
    ## bio_18:popNC.Graham              NA         NA      NA       NA  
    ## bio_18:popNS.Halifax             NA         NA      NA       NA  
    ## bio_18:popNY.Hamilton     7.951e-02  5.100e-02   1.559   0.1251  
    ## bio_18:popNY.Sullivan            NA         NA      NA       NA  
    ## bio_18:popON.Renfrew      7.537e-02  5.034e-02   1.497   0.1404  
    ## bio_18:popON.Thunder             NA         NA      NA       NA  
    ## bio_18:popPA.Bedford     -4.503e-02  2.641e-02  -1.705   0.0941 .
    ## bio_18:popPA.Potter              NA         NA      NA       NA  
    ## bio_18:popSC.Oconee              NA         NA      NA       NA  
    ## bio_18:popTN.Carter              NA         NA      NA       NA  
    ## bio_18:popTN.Unicoi              NA         NA      NA       NA  
    ## bio_18:popVA.Giles               NA         NA      NA       NA  
    ## bio_18:popVA.Wise                NA         NA      NA       NA  
    ## bio_18:popWI.All                 NA         NA      NA       NA  
    ## bio_18:popWV.Randolph            NA         NA      NA       NA  
    ## bio_18:popWV.Tucker              NA         NA      NA       NA  
    ## bio_18:popWV.Webster             NA         NA      NA       NA  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.007799 on 52 degrees of freedom
    ##   (10 observations deleted due to missingness)
    ## Multiple R-squared:  0.7835, Adjusted R-squared:  0.5961 
    ## F-statistic: 4.182 on 45 and 52 DF,  p-value: 6.584e-07

    ## Warning: not plotting observations with leverage one:
    ##   34, 35, 44, 48, 51, 61, 62, 64, 73, 81, 82

![](Plumage_Env_files/figure-gfm/lmm%20pheno-env-1.png)<!-- -->![](Plumage_Env_files/figure-gfm/lmm%20pheno-env-2.png)<!-- -->![](Plumage_Env_files/figure-gfm/lmm%20pheno-env-3.png)<!-- -->

    ## Warning in sqrt(crit * p * (1 - hh)/hh): NaNs produced

    ## Warning in sqrt(crit * p * (1 - hh)/hh): NaNs produced

![](Plumage_Env_files/figure-gfm/lmm%20pheno-env-4.png)<!-- -->

    ## Analysis of Variance Table
    ## 
    ## Response: dblMean_d
    ##               Df    Sum Sq    Mean Sq F value    Pr(>F)    
    ## bio_10         1 0.0030513 0.00305127 50.1689 3.648e-09 ***
    ## bio_18         1 0.0000926 0.00009256  1.5219    0.2229    
    ## srtm           1 0.0001428 0.00014277  2.3475    0.1315    
    ## pop           20 0.0066615 0.00033307  5.4764 4.025e-07 ***
    ## bio_10:bio_18  1 0.0000792 0.00007915  1.3014    0.2592    
    ## bio_10:pop    14 0.0006278 0.00004484  0.7373    0.7278    
    ## bio_18:srtm    1 0.0000497 0.00004965  0.8164    0.3704    
    ## bio_18:pop     6 0.0007408 0.00012346  2.0300    0.0781 .  
    ## Residuals     52 0.0031626 0.00006082                      
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    ## 'log Lik.' 367.6686 (df=47)

    ## [1] -641.3373
