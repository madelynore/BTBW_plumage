Are dark-backed birds darker overall?
================
Ore, MJ.
2025-03-10

    ## Warning: package 'ggplot2' was built under R version 4.3.1

    ## Warning: package 'tidyr' was built under R version 4.3.1

    ## Warning: package 'readr' was built under R version 4.3.1

    ## Warning: package 'dplyr' was built under R version 4.3.1

    ## Warning: package 'stringr' was built under R version 4.3.1

    ## Warning: package 'lubridate' was built under R version 4.3.1

    ## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ## ✔ dplyr     1.1.4     ✔ readr     2.1.5
    ## ✔ forcats   1.0.0     ✔ stringr   1.5.1
    ## ✔ ggplot2   3.5.1     ✔ tibble    3.2.1
    ## ✔ lubridate 1.9.3     ✔ tidyr     1.3.1
    ## ✔ purrr     1.0.2     
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()
    ## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
    ## here() starts at /Users/madelynore/Documents/Cornell/BTBW geographic coloration/BTBW_plumage

    ## Warning: package 'viridis' was built under R version 4.3.1

    ## Loading required package: viridisLite
    ## here() starts at /Users/madelynore/Documents/Cornell/BTBW geographic coloration/BTBW_plumage

\#crown

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

![](Color_correlations_files/figure-gfm/crown-1.png)<!-- -->![](Color_correlations_files/figure-gfm/crown-2.png)<!-- -->

    ## boundary (singular) fit: see help('isSingular')

    ## Warning: Model failed to converge with 2 negative eigenvalues: -9.1e-04
    ## -3.0e-02

    ## Linear mixed model fit by REML. t-tests use Satterthwaite's method [
    ## lmerModLmerTest]
    ## Formula: dblMean_c ~ dblMean_d + (dblMean_d | Year) + (dblMean_d | prepartor)
    ##    Data: lum_wide
    ## 
    ## REML criterion at convergence: -419
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -4.5295 -0.3370  0.0051  0.5347  1.9330 
    ## 
    ## Random effects:
    ##  Groups    Name        Variance  Std.Dev. Corr
    ##  Year      (Intercept) 0.000e+00 0.000000     
    ##            dblMean_d   5.463e-03 0.073912  NaN
    ##  prepartor (Intercept) 0.000e+00 0.000000     
    ##            dblMean_d   2.163e-03 0.046507  NaN
    ##  Residual              9.128e-05 0.009554     
    ## Number of obs: 68, groups:  Year, 7; prepartor, 6
    ## 
    ## Fixed effects:
    ##              Estimate Std. Error        df t value Pr(>|t|)   
    ## (Intercept)  0.048199   0.008023  4.107419   6.008  0.00355 **
    ## dblMean_d    0.323616   0.133354 17.050304   2.427  0.02661 * 
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##           (Intr)
    ## dblMean_d -0.946
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see help('isSingular')

    ## `geom_smooth()` using formula = 'y ~ x'

    ## Warning: Removed 24 rows containing non-finite outside the scale range
    ## (`stat_smooth()`).

    ## Warning: Removed 24 rows containing missing values or values outside the scale range
    ## (`geom_point()`).

![](Color_correlations_files/figure-gfm/crown-3.png)<!-- -->

\#wingspot

``` r
library(lmerTest)

# check for normality
hist(lum_wide$dblMean_d)
```

![](Color_correlations_files/figure-gfm/wingspot-1.png)<!-- -->

``` r
hist(lum_wide$dblMean_w)
```

![](Color_correlations_files/figure-gfm/wingspot-2.png)<!-- -->

``` r
z <- lmerTest::lmer(dblMean_w ~ dblMean_d + (dblMean_d|Year) + (dblMean_d|prepartor), data = lum_wide, na.action = na.exclude) 
```

    ## boundary (singular) fit: see help('isSingular')

``` r
summary(z)
```

    ## Linear mixed model fit by REML. t-tests use Satterthwaite's method [
    ## lmerModLmerTest]
    ## Formula: dblMean_w ~ dblMean_d + (dblMean_d | Year) + (dblMean_d | prepartor)
    ##    Data: lum_wide
    ## 
    ## REML criterion at convergence: -267.8
    ## 
    ## Scaled residuals: 
    ##      Min       1Q   Median       3Q      Max 
    ## -2.64637 -0.47987  0.03535  0.72055  1.71805 
    ## 
    ## Random effects:
    ##  Groups    Name        Variance  Std.Dev.  Corr 
    ##  Year      (Intercept) 1.246e-10 1.116e-05      
    ##            dblMean_d   2.585e-08 1.608e-04 -1.00
    ##  prepartor (Intercept) 4.547e-04 2.132e-02      
    ##            dblMean_d   3.076e-02 1.754e-01 -1.00
    ##  Residual              2.187e-03 4.677e-02      
    ## Number of obs: 84, groups:  Year, 7; prepartor, 6
    ## 
    ## Fixed effects:
    ##             Estimate Std. Error       df t value Pr(>|t|)    
    ## (Intercept)  0.49396    0.03009  5.50155  16.415 6.95e-06 ***
    ## dblMean_d   -0.78240    0.44338 15.08823  -1.765   0.0979 .  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##           (Intr)
    ## dblMean_d -0.967
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see help('isSingular')

``` r
ggplot(lum_wide)+
  geom_point(aes(x = dblMean_d, y = dblMean_w, col = lat))+
  scale_color_viridis_c(direction = -1)+
  geom_smooth(aes(x = dblMean_d, y = dblMean_w), method = "lm", col = "black")+
  labs(x = "Dorsum Brightness", y = "Wingspot Brightness")+
  theme_classic()
```

    ## `geom_smooth()` using formula = 'y ~ x'

    ## Warning: Removed 8 rows containing non-finite outside the scale range
    ## (`stat_smooth()`).

    ## Warning: Removed 8 rows containing missing values or values outside the scale range
    ## (`geom_point()`).

![](Color_correlations_files/figure-gfm/wingspot-3.png)<!-- -->

\#throat

``` r
library(lmerTest)

# check for normality
hist(lum_wide$dblMean_d)
```

![](Color_correlations_files/figure-gfm/throat-1.png)<!-- -->

``` r
hist(lum_wide$dblMean_t)
```

![](Color_correlations_files/figure-gfm/throat-2.png)<!-- -->

``` r
z <- lmerTest::lmer(dblMean_t ~ dblMean_d + (dblMean_d|Year) + (dblMean_d|prepartor), data = lum_wide, na.action = na.exclude) 
```

    ## boundary (singular) fit: see help('isSingular')

``` r
summary(z)
```

    ## Linear mixed model fit by REML. t-tests use Satterthwaite's method [
    ## lmerModLmerTest]
    ## Formula: dblMean_t ~ dblMean_d + (dblMean_d | Year) + (dblMean_d | prepartor)
    ##    Data: lum_wide
    ## 
    ## REML criterion at convergence: -549
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -2.0159 -0.7271  0.0982  0.5619  3.3990 
    ## 
    ## Random effects:
    ##  Groups    Name        Variance  Std.Dev. Corr 
    ##  Year      (Intercept) 2.484e-04 0.015762      
    ##            dblMean_d   2.935e-02 0.171304 -1.00
    ##  prepartor (Intercept) 6.099e-05 0.007809      
    ##            dblMean_d   9.022e-03 0.094983 -1.00
    ##  Residual              4.886e-05 0.006990      
    ## Number of obs: 81, groups:  Year, 7; prepartor, 6
    ## 
    ## Fixed effects:
    ##             Estimate Std. Error       df t value Pr(>|t|)  
    ## (Intercept) 0.023616   0.009771 5.451126   2.417   0.0562 .
    ## dblMean_d   0.316254   0.125220 6.047212   2.526   0.0446 *
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##           (Intr)
    ## dblMean_d -0.986
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see help('isSingular')

``` r
ggplot(lum_wide)+
  geom_point(aes(x = dblMean_d, y = dblMean_t, col = lat))+
  scale_color_viridis_c(direction = -1)+
  geom_smooth(aes(x = dblMean_d, y = dblMean_t), method = "lm", col = "black")+
  labs(x = "Dorsum Brightness", y = "Throat Brightness")+
  theme_classic()
```

    ## `geom_smooth()` using formula = 'y ~ x'

    ## Warning: Removed 11 rows containing non-finite outside the scale range
    ## (`stat_smooth()`).

    ## Warning: Removed 11 rows containing missing values or values outside the scale range
    ## (`geom_point()`).

![](Color_correlations_files/figure-gfm/throat-3.png)<!-- -->

\#marginal covert

``` r
library(lmerTest)

# check for normality
hist(lum_wide$dblMean_d)
```

![](Color_correlations_files/figure-gfm/coverts-1.png)<!-- -->

``` r
hist(lum_wide$dblMean_o)
```

![](Color_correlations_files/figure-gfm/coverts-2.png)<!-- -->

``` r
z <- lmerTest::lmer(dblMean_o ~ dblMean_d + (dblMean_d|Year) + (dblMean_d|prepartor), data = lum_wide, na.action = na.exclude) 
```

    ## boundary (singular) fit: see help('isSingular')

``` r
summary(z)
```

    ## Linear mixed model fit by REML. t-tests use Satterthwaite's method [
    ## lmerModLmerTest]
    ## Formula: dblMean_o ~ dblMean_d + (dblMean_d | Year) + (dblMean_d | prepartor)
    ##    Data: lum_wide
    ## 
    ## REML criterion at convergence: -489.7
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -1.7485 -0.4978 -0.1923  0.5367  3.2625 
    ## 
    ## Random effects:
    ##  Groups    Name        Variance  Std.Dev.  Corr 
    ##  Year      (Intercept) 3.406e-04 1.846e-02      
    ##            dblMean_d   3.342e-02 1.828e-01 -1.00
    ##  prepartor (Intercept) 1.444e-10 1.202e-05      
    ##            dblMean_d   4.082e-08 2.020e-04 -1.00
    ##  Residual              1.059e-04 1.029e-02      
    ## Number of obs: 81, groups:  Year, 7; prepartor, 6
    ## 
    ## Fixed effects:
    ##             Estimate Std. Error      df t value Pr(>|t|)   
    ## (Intercept)  0.02045    0.01143 4.98298   1.789  0.13392   
    ## dblMean_d    0.75321    0.14982 7.28395   5.027  0.00135 **
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##           (Intr)
    ## dblMean_d -0.976
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see help('isSingular')

``` r
ggplot(lum_wide)+
  geom_point(aes(x = dblMean_d, y = dblMean_o, col = lat))+
  scale_color_viridis_c(direction = -1)+
  geom_smooth(aes(x = dblMean_d, y = dblMean_o), method = "lm", col = "black")+
  labs(x = "Dorsum Brightness", y = "Covert Brightness")+
  theme_classic()
```

    ## `geom_smooth()` using formula = 'y ~ x'

    ## Warning: Removed 11 rows containing non-finite outside the scale range
    ## (`stat_smooth()`).

    ## Warning: Removed 11 rows containing missing values or values outside the scale range
    ## (`geom_point()`).

![](Color_correlations_files/figure-gfm/coverts-3.png)<!-- -->

\#belly

``` r
library(lmerTest)

# check for normality
hist(lum_wide$dblMean_d)
```

![](Color_correlations_files/figure-gfm/belly-1.png)<!-- -->

``` r
hist(lum_wide$dblMean_b)
```

![](Color_correlations_files/figure-gfm/belly-2.png)<!-- -->

``` r
z <- lmerTest::lmer(dblMean_b ~ dblMean_d + (dblMean_d|Year) + (dblMean_d|prepartor), data = lum_wide, na.action = na.exclude) 
```

    ## boundary (singular) fit: see help('isSingular')

``` r
summary(z)
```

    ## Linear mixed model fit by REML. t-tests use Satterthwaite's method [
    ## lmerModLmerTest]
    ## Formula: dblMean_b ~ dblMean_d + (dblMean_d | Year) + (dblMean_d | prepartor)
    ##    Data: lum_wide
    ## 
    ## REML criterion at convergence: -295.8
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -2.2497 -0.5734  0.0206  0.5435  2.8555 
    ## 
    ## Random effects:
    ##  Groups    Name        Variance  Std.Dev. Corr
    ##  Year      (Intercept) 4.937e-06 0.002222     
    ##            dblMean_d   1.318e-02 0.114812 1.00
    ##  prepartor (Intercept) 5.705e-04 0.023884     
    ##            dblMean_d   5.158e-05 0.007182 1.00
    ##  Residual              1.369e-03 0.036994     
    ## Number of obs: 83, groups:  Year, 7; prepartor, 6
    ## 
    ## Fixed effects:
    ##             Estimate Std. Error       df t value Pr(>|t|)    
    ## (Intercept)  0.45005    0.02696  5.61057  16.693 5.36e-06 ***
    ## dblMean_d   -0.46602    0.38592 31.20483  -1.208    0.236    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##           (Intr)
    ## dblMean_d -0.869
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see help('isSingular')

``` r
ggplot(lum_wide)+
  geom_point(aes(x = dblMean_d, y = dblMean_b, col = lat))+
  scale_color_viridis_c(direction = -1)+
  geom_smooth(aes(x = dblMean_d, y = dblMean_b), method = "lm", col = "black")+
  labs(x = "Dorsum Brightness", y = "Belly Brightness")+
  theme_classic()
```

    ## `geom_smooth()` using formula = 'y ~ x'

    ## Warning: Removed 9 rows containing non-finite outside the scale range
    ## (`stat_smooth()`).

    ## Warning: Removed 9 rows containing missing values or values outside the scale range
    ## (`geom_point()`).

![](Color_correlations_files/figure-gfm/belly-3.png)<!-- -->
