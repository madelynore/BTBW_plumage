Are dark-backed birds darker overall?
================
Ore, MJ.
2025-03-10

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

    ## Linear mixed model fit by REML. t-tests use Satterthwaite's method [
    ## lmerModLmerTest]
    ## Formula: dblMean_c ~ dblMean_d + (1 | Year) + (1 | prepartor)
    ##    Data: lum_wide
    ## 
    ## REML criterion at convergence: -580.1
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -5.3045 -0.4525  0.0572  0.5077  1.8672 
    ## 
    ## Random effects:
    ##  Groups    Name        Variance  Std.Dev.
    ##  Year      (Intercept) 3.283e-06 0.001812
    ##  prepartor (Intercept) 0.000e+00 0.000000
    ##  Residual              9.739e-05 0.009869
    ## Number of obs: 93, groups:  Year, 7; prepartor, 6
    ## 
    ## Fixed effects:
    ##              Estimate Std. Error        df t value Pr(>|t|)    
    ## (Intercept)  0.041199   0.006025 19.869605   6.838 1.25e-06 ***
    ## dblMean_d    0.462975   0.091060 23.535618   5.084 3.55e-05 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##           (Intr)
    ## dblMean_d -0.978
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see help('isSingular')

    ## `geom_smooth()` using formula = 'y ~ x'

    ## Warning: Removed 16 rows containing non-finite outside the scale range
    ## (`stat_smooth()`).

    ## Warning: Removed 16 rows containing missing values or values outside the scale range
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
z <- lmerTest::lmer(dblMean_w ~ dblMean_d + (1|Year) + (1|prepartor), data = lum_wide, na.action = na.exclude) 
```

    ## boundary (singular) fit: see help('isSingular')

``` r
summary(z)
```

    ## Linear mixed model fit by REML. t-tests use Satterthwaite's method [
    ## lmerModLmerTest]
    ## Formula: dblMean_w ~ dblMean_d + (1 | Year) + (1 | prepartor)
    ##    Data: lum_wide
    ## 
    ## REML criterion at convergence: -315.3
    ## 
    ## Scaled residuals: 
    ##      Min       1Q   Median       3Q      Max 
    ## -2.71889 -0.61065  0.04433  0.73233  1.84397 
    ## 
    ## Random effects:
    ##  Groups    Name        Variance  Std.Dev.
    ##  Year      (Intercept) 0.0000000 0.000000
    ##  prepartor (Intercept) 0.0000976 0.009879
    ##  Residual              0.0021452 0.046316
    ## Number of obs: 98, groups:  Year, 7; prepartor, 6
    ## 
    ## Fixed effects:
    ##             Estimate Std. Error       df t value Pr(>|t|)    
    ## (Intercept)  0.49137    0.02634 63.34752  18.656   <2e-16 ***
    ## dblMean_d   -0.72859    0.39643 88.10820  -1.838   0.0694 .  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##           (Intr)
    ## dblMean_d -0.960
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

    ## Warning: Removed 10 rows containing non-finite outside the scale range
    ## (`stat_smooth()`).

    ## Warning: Removed 10 rows containing missing values or values outside the scale range
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
z <- lmerTest::lmer(dblMean_t ~ dblMean_d + (1|Year) + (1|prepartor), data = lum_wide, na.action = na.exclude) 
summary(z)
```

    ## Linear mixed model fit by REML. t-tests use Satterthwaite's method [
    ## lmerModLmerTest]
    ## Formula: dblMean_t ~ dblMean_d + (1 | Year) + (1 | prepartor)
    ##    Data: lum_wide
    ## 
    ## REML criterion at convergence: -657.1
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -2.0860 -0.6418  0.0018  0.5797  3.2413 
    ## 
    ## Random effects:
    ##  Groups    Name        Variance  Std.Dev.
    ##  Year      (Intercept) 2.155e-05 0.004642
    ##  prepartor (Intercept) 1.232e-06 0.001110
    ##  Residual              4.767e-05 0.006905
    ## Number of obs: 96, groups:  Year, 7; prepartor, 6
    ## 
    ## Fixed effects:
    ##              Estimate Std. Error        df t value Pr(>|t|)    
    ## (Intercept)  0.022705   0.005502 61.655926   4.126 0.000112 ***
    ## dblMean_d    0.326826   0.078525 86.488494   4.162 7.42e-05 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##           (Intr)
    ## dblMean_d -0.929

``` r
ggplot(lum_wide)+
  geom_point(aes(x = dblMean_d, y = dblMean_t, col = lat))+
  scale_color_viridis_c(direction = -1)+
  geom_smooth(aes(x = dblMean_d, y = dblMean_t), method = "lm", col = "black")+
  labs(x = "Dorsum Brightness", y = "Throat Brightness")+
  theme_classic()
```

    ## `geom_smooth()` using formula = 'y ~ x'

    ## Warning: Removed 12 rows containing non-finite outside the scale range
    ## (`stat_smooth()`).

    ## Warning: Removed 12 rows containing missing values or values outside the scale range
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
z <- lmerTest::lmer(dblMean_o ~ dblMean_d + (1|Year) + (1|prepartor), data = lum_wide, na.action = na.exclude) 
```

    ## boundary (singular) fit: see help('isSingular')

``` r
summary(z)
```

    ## Linear mixed model fit by REML. t-tests use Satterthwaite's method [
    ## lmerModLmerTest]
    ## Formula: dblMean_o ~ dblMean_d + (1 | Year) + (1 | prepartor)
    ##    Data: lum_wide
    ## 
    ## REML criterion at convergence: -574.3
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -1.6286 -0.6054 -0.1657  0.5464  2.7366 
    ## 
    ## Random effects:
    ##  Groups    Name        Variance Std.Dev.
    ##  Year      (Intercept) 4.26e-05 0.006527
    ##  prepartor (Intercept) 0.00e+00 0.000000
    ##  Residual              1.17e-04 0.010819
    ## Number of obs: 96, groups:  Year, 7; prepartor, 6
    ## 
    ## Fixed effects:
    ##              Estimate Std. Error        df t value Pr(>|t|)    
    ## (Intercept)  0.020959   0.008362 58.041496   2.506    0.015 *  
    ## dblMean_d    0.759142   0.121772 79.545371   6.234 2.04e-08 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##           (Intr)
    ## dblMean_d -0.944
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

    ## Warning: Removed 12 rows containing non-finite outside the scale range
    ## (`stat_smooth()`).

    ## Warning: Removed 12 rows containing missing values or values outside the scale range
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
z <- lmerTest::lmer(dblMean_b ~ dblMean_d + (1|Year) + (1|prepartor), data = lum_wide, na.action = na.exclude) 
summary(z)
```

    ## Linear mixed model fit by REML. t-tests use Satterthwaite's method [
    ## lmerModLmerTest]
    ## Formula: dblMean_b ~ dblMean_d + (1 | Year) + (1 | prepartor)
    ##    Data: lum_wide
    ## 
    ## REML criterion at convergence: -360.3
    ## 
    ## Scaled residuals: 
    ##      Min       1Q   Median       3Q      Max 
    ## -2.47783 -0.69798  0.06055  0.54931  2.96276 
    ## 
    ## Random effects:
    ##  Groups    Name        Variance  Std.Dev.
    ##  Year      (Intercept) 0.0001362 0.01167 
    ##  prepartor (Intercept) 0.0004315 0.02077 
    ##  Residual              0.0011862 0.03444 
    ## Number of obs: 97, groups:  Year, 7; prepartor, 6
    ## 
    ## Fixed effects:
    ##             Estimate Std. Error       df t value Pr(>|t|)    
    ## (Intercept)  0.46264    0.02588 27.97177   17.87   <2e-16 ***
    ## dblMean_d   -0.58984    0.36184 36.35462   -1.63    0.112    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##           (Intr)
    ## dblMean_d -0.886

``` r
ggplot(lum_wide)+
  geom_point(aes(x = dblMean_d, y = dblMean_b, col = lat))+
  scale_color_viridis_c(direction = -1)+
  geom_smooth(aes(x = dblMean_d, y = dblMean_b), method = "lm", col = "black")+
  labs(x = "Dorsum Brightness", y = "Belly Brightness")+
  ylim(0.3,0.6)+
  theme_classic()
```

    ## `geom_smooth()` using formula = 'y ~ x'

    ## Warning: Removed 11 rows containing non-finite outside the scale range
    ## (`stat_smooth()`).

    ## Warning: Removed 11 rows containing missing values or values outside the scale range
    ## (`geom_point()`).

![](Color_correlations_files/figure-gfm/belly-3.png)<!-- -->
