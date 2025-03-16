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
    ## REML criterion at convergence: -567.5
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -5.3102 -0.4473  0.0456  0.5075  1.8699 
    ## 
    ## Random effects:
    ##  Groups    Name        Variance  Std.Dev.
    ##  Year      (Intercept) 3.499e-06 0.001871
    ##  prepartor (Intercept) 0.000e+00 0.000000
    ##  Residual              9.707e-05 0.009853
    ## Number of obs: 91, groups:  Year, 7; prepartor, 6
    ## 
    ## Fixed effects:
    ##              Estimate Std. Error        df t value Pr(>|t|)    
    ## (Intercept)  0.041459   0.006177 21.007650   6.712 1.21e-06 ***
    ## dblMean_d    0.458853   0.092971 24.452803   4.935 4.66e-05 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##           (Intr)
    ## dblMean_d -0.979
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see help('isSingular')

    ## `geom_smooth()` using formula = 'y ~ x'

    ## Warning: Removed 17 rows containing non-finite outside the scale range
    ## (`stat_smooth()`).

    ## Warning: Removed 17 rows containing missing values or values outside the scale range
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
    ## REML criterion at convergence: -312
    ## 
    ## Scaled residuals: 
    ##      Min       1Q   Median       3Q      Max 
    ## -2.70104 -0.55696  0.01546  0.74277  1.83954 
    ## 
    ## Random effects:
    ##  Groups    Name        Variance  Std.Dev.
    ##  Year      (Intercept) 0.000e+00 0.000000
    ##  prepartor (Intercept) 7.099e-05 0.008426
    ##  Residual              2.154e-03 0.046413
    ## Number of obs: 97, groups:  Year, 7; prepartor, 6
    ## 
    ## Fixed effects:
    ##             Estimate Std. Error       df t value Pr(>|t|)    
    ## (Intercept)  0.49311    0.02627 64.56362  18.768   <2e-16 ***
    ## dblMean_d   -0.74694    0.39652 86.06345  -1.884    0.063 .  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##           (Intr)
    ## dblMean_d -0.966
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

    ## Warning: Removed 11 rows containing non-finite outside the scale range
    ## (`stat_smooth()`).

    ## Warning: Removed 11 rows containing missing values or values outside the scale range
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
    ## REML criterion at convergence: -652.6
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -2.2264 -0.6133  0.0203  0.4848  3.2346 
    ## 
    ## Random effects:
    ##  Groups    Name        Variance  Std.Dev.
    ##  Year      (Intercept) 2.303e-05 0.004799
    ##  prepartor (Intercept) 1.462e-06 0.001209
    ##  Residual              4.608e-05 0.006789
    ## Number of obs: 95, groups:  Year, 7; prepartor, 6
    ## 
    ## Fixed effects:
    ##              Estimate Std. Error        df t value Pr(>|t|)    
    ## (Intercept)  0.024577   0.005493 62.269048   4.474 3.32e-05 ***
    ## dblMean_d    0.301059   0.077917 87.485805   3.864 0.000214 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##           (Intr)
    ## dblMean_d -0.924

``` r
ggplot(lum_wide)+
  geom_point(aes(x = dblMean_d, y = dblMean_t, col = lat))+
  scale_color_viridis_c(direction = -1)+
  geom_smooth(aes(x = dblMean_d, y = dblMean_t), method = "lm", col = "black")+
  labs(x = "Dorsum Brightness", y = "Throat Brightness")+
  theme_classic()
```

    ## `geom_smooth()` using formula = 'y ~ x'

    ## Warning: Removed 13 rows containing non-finite outside the scale range
    ## (`stat_smooth()`).

    ## Warning: Removed 13 rows containing missing values or values outside the scale range
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
    ## REML criterion at convergence: -568.5
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -1.6343 -0.6079 -0.1570  0.5359  2.7489 
    ## 
    ## Random effects:
    ##  Groups    Name        Variance  Std.Dev.
    ##  Year      (Intercept) 0.0000436 0.006603
    ##  prepartor (Intercept) 0.0000000 0.000000
    ##  Residual              0.0001164 0.010789
    ## Number of obs: 95, groups:  Year, 7; prepartor, 6
    ## 
    ## Fixed effects:
    ##              Estimate Std. Error        df t value Pr(>|t|)    
    ## (Intercept)  0.021838   0.008398 58.542582   2.601   0.0118 *  
    ## dblMean_d    0.747181   0.122106 79.867684   6.119  3.3e-08 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##           (Intr)
    ## dblMean_d -0.943
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

    ## Warning: Removed 13 rows containing non-finite outside the scale range
    ## (`stat_smooth()`).

    ## Warning: Removed 13 rows containing missing values or values outside the scale range
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
    ## REML criterion at convergence: -355.7
    ## 
    ## Scaled residuals: 
    ##      Min       1Q   Median       3Q      Max 
    ## -2.46203 -0.70039  0.05921  0.52616  2.94922 
    ## 
    ## Random effects:
    ##  Groups    Name        Variance  Std.Dev.
    ##  Year      (Intercept) 0.0001378 0.01174 
    ##  prepartor (Intercept) 0.0004260 0.02064 
    ##  Residual              0.0011961 0.03458 
    ## Number of obs: 96, groups:  Year, 7; prepartor, 6
    ## 
    ## Fixed effects:
    ##             Estimate Std. Error       df t value Pr(>|t|)    
    ## (Intercept)  0.46382    0.02605 28.11875  17.806   <2e-16 ***
    ## dblMean_d   -0.60402    0.36438 36.22810  -1.658    0.106    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##           (Intr)
    ## dblMean_d -0.888

``` r
ggplot(lum_wide)+
  geom_point(aes(x = dblMean_d, y = dblMean_b, col = lat))+
  scale_color_viridis_c(direction = -1)+
  geom_smooth(aes(x = dblMean_d, y = dblMean_b), method = "lm", col = "black")+
  labs(x = "Dorsum Brightness", y = "Belly Brightness")+
  theme_classic()
```

    ## `geom_smooth()` using formula = 'y ~ x'

    ## Warning: Removed 12 rows containing non-finite outside the scale range
    ## (`stat_smooth()`).

    ## Warning: Removed 12 rows containing missing values or values outside the scale range
    ## (`geom_point()`).

![](Color_correlations_files/figure-gfm/belly-3.png)<!-- -->
