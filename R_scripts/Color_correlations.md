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

    ## Warning: package 'lubridate' was built under R version 4.3.3

    ## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ## ✔ dplyr     1.1.4     ✔ readr     2.1.5
    ## ✔ forcats   1.0.0     ✔ stringr   1.5.1
    ## ✔ ggplot2   3.5.1     ✔ tibble    3.2.1
    ## ✔ lubridate 1.9.4     ✔ tidyr     1.3.1
    ## ✔ purrr     1.0.4     
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()
    ## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
    ## here() starts at /Users/madelynore/Documents/Cornell/BTBW_geographic_coloration/BTBW_plumage

    ## Warning: package 'viridis' was built under R version 4.3.1

    ## Loading required package: viridisLite
    ## here() starts at /Users/madelynore/Documents/Cornell/BTBW_geographic_coloration/BTBW_plumage

How do luminance and shortwavelength correlate

\#crown

    ## Loading required package: lme4

    ## Warning: package 'lme4' was built under R version 4.3.3

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

    ## Warning: package 'MuMIn' was built under R version 4.3.3

    ## Warning: package 'sjPlot' was built under R version 4.3.3

![](Color_correlations_files/figure-gfm/crown-1.png)<!-- -->![](Color_correlations_files/figure-gfm/crown-2.png)<!-- -->

    ## boundary (singular) fit: see help('isSingular')

    ## Linear mixed model fit by REML. t-tests use Satterthwaite's method [
    ## lmerModLmerTest]
    ## Formula: PC1_c ~ PC1_d + (1 | Year) + (1 | prepartor)
    ##    Data: asy
    ## 
    ## REML criterion at convergence: -449.3
    ## 
    ## Scaled residuals: 
    ##      Min       1Q   Median       3Q      Max 
    ## -3.01350 -0.61586  0.02561  0.55013  2.69540 
    ## 
    ## Random effects:
    ##  Groups    Name        Variance Std.Dev.
    ##  Year      (Intercept) 0.000000 0.00000 
    ##  prepartor (Intercept) 0.000000 0.00000 
    ##  Residual              0.000858 0.02929 
    ## Number of obs: 109, groups:  Year, 7; prepartor, 6
    ## 
    ## Fixed effects:
    ##              Estimate Std. Error        df t value Pr(>|t|)    
    ## (Intercept) 6.814e-03  2.923e-03 1.070e+02   2.331   0.0216 *  
    ## PC1_d       4.622e-01  8.684e-02 1.070e+02   5.322 5.69e-07 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##       (Intr)
    ## PC1_d 0.281 
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see help('isSingular')

    ##            R2m       R2c
    ## [1,] 0.2077702 0.2077702

<table style="border-collapse:collapse; border:none;">
<tr>
<th style="border-top: double; text-align:center; font-style:normal; font-weight:bold; padding:0.2cm;  text-align:left; ">
 
</th>
<th colspan="3" style="border-top: double; text-align:center; font-style:normal; font-weight:bold; padding:0.2cm; ">
PC1_c
</th>
</tr>
<tr>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  text-align:left; ">
Predictors
</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">
Estimates
</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">
CI
</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">
p
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">
(Intercept)
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
0.01
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
0.00 – 0.01
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
<strong>0.022</strong>
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">
PC1 d
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
0.46
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
0.29 – 0.63
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
<strong>\<0.001</strong>
</td>
</tr>
<tr>
<td colspan="4" style="font-weight:bold; text-align:left; padding-top:.8em;">
Random Effects
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
σ<sup>2</sup>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.00
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
τ<sub>00</sub> <sub>Year</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.00
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
τ<sub>00</sub> <sub>prepartor</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.00
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
N <sub>Year</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
7
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
N <sub>prepartor</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
6
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm; border-top:1px solid;">
Observations
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left; border-top:1px solid;" colspan="3">
109
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
Marginal R<sup>2</sup> / Conditional R<sup>2</sup>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.208 / NA
</td>
</tr>
</table>

    ## `geom_smooth()` using formula = 'y ~ x'

    ## Warning: Removed 4 rows containing non-finite outside the scale range
    ## (`stat_smooth()`).

    ## Warning: Removed 4 rows containing missing values or values outside the scale range
    ## (`geom_point()`).

![](Color_correlations_files/figure-gfm/crown-3.png)<!-- -->

\#wingspot

``` r
library(lmerTest)
library(MuMIn)
library(sjPlot)

# check for normality
hist(asy$PC1_d)
```

![](Color_correlations_files/figure-gfm/wingspot-1.png)<!-- -->

``` r
hist(asy$PC1_w)
```

![](Color_correlations_files/figure-gfm/wingspot-2.png)<!-- -->

``` r
z <- lmerTest::lmer(PC1_w ~ PC1_d + (1|Year) + (1|prepartor), data = asy, na.action = na.exclude) 
```

    ## boundary (singular) fit: see help('isSingular')

``` r
summary(z)
```

    ## Linear mixed model fit by REML. t-tests use Satterthwaite's method [
    ## lmerModLmerTest]
    ## Formula: PC1_w ~ PC1_d + (1 | Year) + (1 | prepartor)
    ##    Data: asy
    ## 
    ## REML criterion at convergence: -200.9
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -2.7017 -0.6159  0.2075  0.7450  1.7949 
    ## 
    ## Random effects:
    ##  Groups    Name        Variance  Std.Dev.
    ##  Year      (Intercept) 0.0000000 0.00000 
    ##  prepartor (Intercept) 0.0005339 0.02311 
    ##  Residual              0.0090183 0.09496 
    ## Number of obs: 112, groups:  Year, 7; prepartor, 6
    ## 
    ## Fixed effects:
    ##              Estimate Std. Error        df t value Pr(>|t|)   
    ## (Intercept)   0.06789    0.01613   2.45528   4.208  0.03601 * 
    ## PC1_d        -0.81083    0.28958 107.78664  -2.800  0.00606 **
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##       (Intr)
    ## PC1_d 0.186 
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see help('isSingular')

``` r
r.squaredGLMM(z)
```

    ##             R2m      R2c
    ## [1,] 0.06618442 0.118381

``` r
tab_model(z)
```

<table style="border-collapse:collapse; border:none;">
<tr>
<th style="border-top: double; text-align:center; font-style:normal; font-weight:bold; padding:0.2cm;  text-align:left; ">
 
</th>
<th colspan="3" style="border-top: double; text-align:center; font-style:normal; font-weight:bold; padding:0.2cm; ">
PC1_w
</th>
</tr>
<tr>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  text-align:left; ">
Predictors
</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">
Estimates
</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">
CI
</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">
p
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">
(Intercept)
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
0.07
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
0.04 – 0.10
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
<strong>\<0.001</strong>
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">
PC1 d
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
-0.81
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
-1.38 – -0.24
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
<strong>0.006</strong>
</td>
</tr>
<tr>
<td colspan="4" style="font-weight:bold; text-align:left; padding-top:.8em;">
Random Effects
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
σ<sup>2</sup>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.01
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
τ<sub>00</sub> <sub>Year</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.00
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
τ<sub>00</sub> <sub>prepartor</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.00
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
N <sub>Year</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
7
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
N <sub>prepartor</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
6
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm; border-top:1px solid;">
Observations
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left; border-top:1px solid;" colspan="3">
112
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
Marginal R<sup>2</sup> / Conditional R<sup>2</sup>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.070 / NA
</td>
</tr>
</table>

``` r
dVw <- ggplot(asy)+
  geom_point(aes(x = PC1_d, y = PC1_w, col = lat), size = 6)+
  scale_color_viridis_c(direction = -1)+
  geom_smooth(aes(x = PC1_d, y = PC1_w), method = "lm", col = "black")+
  labs(x = "Dorsum PC1", y = "Wingspot PC1")+
  theme_classic()+
  theme(text=element_text(size=20))  

dVw
```

    ## `geom_smooth()` using formula = 'y ~ x'

    ## Warning: Removed 1 row containing non-finite outside the scale range
    ## (`stat_smooth()`).

    ## Warning: Removed 1 row containing missing values or values outside the scale range
    ## (`geom_point()`).

![](Color_correlations_files/figure-gfm/wingspot-3.png)<!-- -->

``` r
ggsave(plot = dVw, here("results/WingspotVSDorsum_plot.png"), dpi = 600, width = 8, height = 6)
```

    ## `geom_smooth()` using formula = 'y ~ x'

    ## Warning: Removed 1 row containing non-finite outside the scale range (`stat_smooth()`).
    ## Removed 1 row containing missing values or values outside the scale range
    ## (`geom_point()`).

``` r
z <- lmerTest::lmer(area_mm2_w ~ PC1_d + (1|Year) + (1|prepartor), data = asy, na.action = na.exclude) 
```

    ## boundary (singular) fit: see help('isSingular')

``` r
summary(z)
```

    ## Linear mixed model fit by REML. t-tests use Satterthwaite's method [
    ## lmerModLmerTest]
    ## Formula: area_mm2_w ~ PC1_d + (1 | Year) + (1 | prepartor)
    ##    Data: asy
    ## 
    ## REML criterion at convergence: 862.7
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -2.3451 -0.7045  0.0608  0.5663  2.7622 
    ## 
    ## Random effects:
    ##  Groups    Name        Variance  Std.Dev. 
    ##  Year      (Intercept) 1.508e-13 3.883e-07
    ##  prepartor (Intercept) 3.264e+01 5.713e+00
    ##  Residual              1.394e+02 1.181e+01
    ## Number of obs: 112, groups:  Year, 7; prepartor, 6
    ## 
    ## Fixed effects:
    ##             Estimate Std. Error      df t value Pr(>|t|)    
    ## (Intercept)   46.337      3.221   3.595  14.387 0.000262 ***
    ## PC1_d        -15.642     36.536 109.744  -0.428 0.669396    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##       (Intr)
    ## PC1_d 0.131 
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see help('isSingular')

``` r
r.squaredGLMM(z)
```

    ##              R2m       R2c
    ## [1,] 0.001462646 0.1909201

``` r
tab_model(z)
```

<table style="border-collapse:collapse; border:none;">
<tr>
<th style="border-top: double; text-align:center; font-style:normal; font-weight:bold; padding:0.2cm;  text-align:left; ">
 
</th>
<th colspan="3" style="border-top: double; text-align:center; font-style:normal; font-weight:bold; padding:0.2cm; ">
area_mm2_w
</th>
</tr>
<tr>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  text-align:left; ">
Predictors
</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">
Estimates
</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">
CI
</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">
p
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">
(Intercept)
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
46.34
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
39.95 – 52.72
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
<strong>\<0.001</strong>
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">
PC1 d
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
-15.64
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
-88.07 – 56.79
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
0.669
</td>
</tr>
<tr>
<td colspan="4" style="font-weight:bold; text-align:left; padding-top:.8em;">
Random Effects
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
σ<sup>2</sup>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
139.38
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
τ<sub>00</sub> <sub>Year</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.00
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
τ<sub>00</sub> <sub>prepartor</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
32.64
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
ICC
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.19
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
N <sub>Year</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
7
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
N <sub>prepartor</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
6
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm; border-top:1px solid;">
Observations
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left; border-top:1px solid;" colspan="3">
112
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
Marginal R<sup>2</sup> / Conditional R<sup>2</sup>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.001 / 0.191
</td>
</tr>
</table>

``` r
ggplot(asy)+
  geom_point(aes(x = PC1_d, y = area_mm2_w, col = lat))+
  scale_color_viridis_c(direction = -1)+
  geom_smooth(aes(x = PC1_d, y = area_mm2_w), method = "lm", col = "black")+
  labs(x = "Dorsum PC1", y = "Wingspot area (mm2)")+
  theme_classic()
```

    ## `geom_smooth()` using formula = 'y ~ x'

    ## Warning: Removed 1 row containing non-finite outside the scale range (`stat_smooth()`).
    ## Removed 1 row containing missing values or values outside the scale range
    ## (`geom_point()`).

![](Color_correlations_files/figure-gfm/wingspot-4.png)<!-- -->

\#throat

``` r
library(lmerTest)
library(MuMIn)
library(sjPlot)

# check for normality
hist(asy$PC1_d)
```

![](Color_correlations_files/figure-gfm/throat-1.png)<!-- -->

``` r
hist(asy$PC1_t)
```

![](Color_correlations_files/figure-gfm/throat-2.png)<!-- -->

``` r
z <- lmerTest::lmer(PC1_t ~ PC1_d + (1|Year) + (1|prepartor), data = asy, na.action = na.exclude) 
summary(z)
```

    ## Linear mixed model fit by REML. t-tests use Satterthwaite's method [
    ## lmerModLmerTest]
    ## Formula: PC1_t ~ PC1_d + (1 | Year) + (1 | prepartor)
    ##    Data: asy
    ## 
    ## REML criterion at convergence: -550.1
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -1.9537 -0.8198  0.1277  0.6831  2.1010 
    ## 
    ## Random effects:
    ##  Groups    Name        Variance  Std.Dev.
    ##  Year      (Intercept) 1.131e-04 0.010636
    ##  prepartor (Intercept) 9.956e-06 0.003155
    ##  Residual              3.165e-04 0.017791
    ## Number of obs: 110, groups:  Year, 7; prepartor, 6
    ## 
    ## Fixed effects:
    ##               Estimate Std. Error         df t value Pr(>|t|)    
    ## (Intercept) -3.691e-04  4.826e-03  6.950e+00  -0.076 0.941190    
    ## PC1_d        2.310e-01  6.730e-02  1.019e+02   3.432 0.000867 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##       (Intr)
    ## PC1_d 0.095

``` r
r.squaredGLMM(z)
```

    ##            R2m      R2c
    ## [1,] 0.1124659 0.360979

``` r
tab_model(z)
```

<table style="border-collapse:collapse; border:none;">
<tr>
<th style="border-top: double; text-align:center; font-style:normal; font-weight:bold; padding:0.2cm;  text-align:left; ">
 
</th>
<th colspan="3" style="border-top: double; text-align:center; font-style:normal; font-weight:bold; padding:0.2cm; ">
PC1_t
</th>
</tr>
<tr>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  text-align:left; ">
Predictors
</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">
Estimates
</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">
CI
</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">
p
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">
(Intercept)
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
-0.00
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
-0.01 – 0.01
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
0.939
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">
PC1 d
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
0.23
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
0.10 – 0.36
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
<strong>0.001</strong>
</td>
</tr>
<tr>
<td colspan="4" style="font-weight:bold; text-align:left; padding-top:.8em;">
Random Effects
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
σ<sup>2</sup>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.00
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
τ<sub>00</sub> <sub>Year</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.00
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
τ<sub>00</sub> <sub>prepartor</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.00
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
ICC
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.28
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
N <sub>Year</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
7
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
N <sub>prepartor</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
6
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm; border-top:1px solid;">
Observations
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left; border-top:1px solid;" colspan="3">
110
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
Marginal R<sup>2</sup> / Conditional R<sup>2</sup>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.112 / 0.361
</td>
</tr>
</table>

``` r
ggplot(asy)+
  geom_point(aes(x = PC1_d, y = PC1_t, col = lat))+
  scale_color_viridis_c(direction = -1)+
  geom_smooth(aes(x = PC1_d, y = PC1_t), method = "lm", col = "black")+
  labs(x = "Dorsum PC1", y = "Throat PC1")+
  theme_classic()
```

    ## `geom_smooth()` using formula = 'y ~ x'

    ## Warning: Removed 3 rows containing non-finite outside the scale range
    ## (`stat_smooth()`).

    ## Warning: Removed 3 rows containing missing values or values outside the scale range
    ## (`geom_point()`).

![](Color_correlations_files/figure-gfm/throat-3.png)<!-- -->

\#marginal covert

``` r
library(lmerTest)
library(MuMIn)
library(sjPlot)

# check for normality
hist(asy$PC1_d)
```

![](Color_correlations_files/figure-gfm/coverts-1.png)<!-- -->

``` r
hist(asy$PC1_o)
```

![](Color_correlations_files/figure-gfm/coverts-2.png)<!-- -->

``` r
z <- lmerTest::lmer(PC1_o ~ PC1_d + (1|Year) + (1|prepartor), data = asy, na.action = na.exclude) 
```

    ## boundary (singular) fit: see help('isSingular')

``` r
summary(z)
```

    ## Linear mixed model fit by REML. t-tests use Satterthwaite's method [
    ## lmerModLmerTest]
    ## Formula: PC1_o ~ PC1_d + (1 | Year) + (1 | prepartor)
    ##    Data: asy
    ## 
    ## REML criterion at convergence: -455.1
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -1.5915 -0.7281 -0.1813  0.5379  2.6529 
    ## 
    ## Random effects:
    ##  Groups    Name        Variance  Std.Dev.
    ##  Year      (Intercept) 0.0002135 0.01461 
    ##  prepartor (Intercept) 0.0000000 0.00000 
    ##  Residual              0.0007785 0.02790 
    ## Number of obs: 110, groups:  Year, 7; prepartor, 6
    ## 
    ## Fixed effects:
    ##              Estimate Std. Error        df t value Pr(>|t|)    
    ## (Intercept) -0.011202   0.006301  6.345071  -1.778    0.123    
    ## PC1_d        0.580264   0.104757 95.592587   5.539 2.67e-07 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##       (Intr)
    ## PC1_d 0.113 
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see help('isSingular')

``` r
r.squaredGLMM(z)
```

    ##            R2m       R2c
    ## [1,] 0.2587958 0.4182977

``` r
tab_model(z)
```

<table style="border-collapse:collapse; border:none;">
<tr>
<th style="border-top: double; text-align:center; font-style:normal; font-weight:bold; padding:0.2cm;  text-align:left; ">
 
</th>
<th colspan="3" style="border-top: double; text-align:center; font-style:normal; font-weight:bold; padding:0.2cm; ">
PC1_o
</th>
</tr>
<tr>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  text-align:left; ">
Predictors
</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">
Estimates
</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">
CI
</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">
p
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">
(Intercept)
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
-0.01
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
-0.02 – 0.00
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
0.078
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">
PC1 d
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
0.58
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
0.37 – 0.79
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
<strong>\<0.001</strong>
</td>
</tr>
<tr>
<td colspan="4" style="font-weight:bold; text-align:left; padding-top:.8em;">
Random Effects
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
σ<sup>2</sup>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.00
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
τ<sub>00</sub> <sub>Year</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.00
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
τ<sub>00</sub> <sub>prepartor</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.00
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
N <sub>Year</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
7
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
N <sub>prepartor</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
6
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm; border-top:1px solid;">
Observations
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left; border-top:1px solid;" colspan="3">
110
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
Marginal R<sup>2</sup> / Conditional R<sup>2</sup>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.308 / NA
</td>
</tr>
</table>

``` r
ggplot(asy)+
  geom_point(aes(x = PC1_d, y = PC1_o, col = lat))+
  scale_color_viridis_c(direction = -1)+
  geom_smooth(aes(x = PC1_d, y = PC1_o), method = "lm", col = "black")+
  labs(x = "Dorsum PC1", y = "Covert PC1")+
  theme_classic()
```

    ## `geom_smooth()` using formula = 'y ~ x'

    ## Warning: Removed 3 rows containing non-finite outside the scale range
    ## (`stat_smooth()`).

    ## Warning: Removed 3 rows containing missing values or values outside the scale range
    ## (`geom_point()`).

![](Color_correlations_files/figure-gfm/coverts-3.png)<!-- -->

\#belly

``` r
library(lmerTest)
library(MuMIn)
library(sjPlot)

# check for normality
hist(asy$PC1_d)
```

![](Color_correlations_files/figure-gfm/belly-1.png)<!-- -->

``` r
hist(asy$PC1_b)
```

![](Color_correlations_files/figure-gfm/belly-2.png)<!-- -->

``` r
z <- lmerTest::lmer(PC1_b ~ PC1_d + (1|Year) + (1|prepartor), data = asy, na.action = na.exclude) 
summary(z)
```

    ## Linear mixed model fit by REML. t-tests use Satterthwaite's method [
    ## lmerModLmerTest]
    ## Formula: PC1_b ~ PC1_d + (1 | Year) + (1 | prepartor)
    ##    Data: asy
    ## 
    ## REML criterion at convergence: -251.1
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -2.4074 -0.6322  0.1041  0.6162  3.0707 
    ## 
    ## Random effects:
    ##  Groups    Name        Variance Std.Dev.
    ##  Year      (Intercept) 0.000376 0.01939 
    ##  prepartor (Intercept) 0.001740 0.04171 
    ##  Residual              0.005257 0.07251 
    ## Number of obs: 111, groups:  Year, 7; prepartor, 6
    ## 
    ## Fixed effects:
    ##             Estimate Std. Error       df t value Pr(>|t|)
    ## (Intercept)  0.01223    0.02381  2.97779   0.514    0.643
    ## PC1_d       -0.27159    0.25405 48.98863  -1.069    0.290
    ## 
    ## Correlation of Fixed Effects:
    ##       (Intr)
    ## PC1_d 0.112

``` r
r.squaredGLMM(z)
```

    ##             R2m       R2c
    ## [1,] 0.01027172 0.2943256

``` r
tab_model(z)
```

<table style="border-collapse:collapse; border:none;">
<tr>
<th style="border-top: double; text-align:center; font-style:normal; font-weight:bold; padding:0.2cm;  text-align:left; ">
 
</th>
<th colspan="3" style="border-top: double; text-align:center; font-style:normal; font-weight:bold; padding:0.2cm; ">
PC1_b
</th>
</tr>
<tr>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  text-align:left; ">
Predictors
</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">
Estimates
</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">
CI
</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">
p
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">
(Intercept)
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
0.01
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
-0.03 – 0.06
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
0.609
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">
PC1 d
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
-0.27
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
-0.78 – 0.23
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
0.287
</td>
</tr>
<tr>
<td colspan="4" style="font-weight:bold; text-align:left; padding-top:.8em;">
Random Effects
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
σ<sup>2</sup>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.01
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
τ<sub>00</sub> <sub>Year</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.00
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
τ<sub>00</sub> <sub>prepartor</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.00
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
ICC
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.29
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
N <sub>Year</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
7
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
N <sub>prepartor</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
6
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm; border-top:1px solid;">
Observations
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left; border-top:1px solid;" colspan="3">
111
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
Marginal R<sup>2</sup> / Conditional R<sup>2</sup>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.010 / 0.294
</td>
</tr>
</table>

``` r
ggplot(asy)+
  geom_point(aes(x = PC1_d, y = PC1_b, col = lat))+
  scale_color_viridis_c(direction = -1)+
  geom_smooth(aes(x = PC1_d, y = PC1_b), method = "lm", col = "black")+
  labs(x = "Dorsum PC1", y = "Belly PC1")+
  ylim(0.3,0.6)+
  theme_classic()
```

    ## `geom_smooth()` using formula = 'y ~ x'

    ## Warning: Removed 113 rows containing non-finite outside the scale range
    ## (`stat_smooth()`).

    ## Warning: Removed 113 rows containing missing values or values outside the scale range
    ## (`geom_point()`).

![](Color_correlations_files/figure-gfm/belly-3.png)<!-- -->

\#throat vs wingspot

``` r
library(lmerTest)
library(MuMIn)
library(sjPlot)

# check for normality
hist(asy$PC1_t)
```

![](Color_correlations_files/figure-gfm/throat%20v%20wingspot-1.png)<!-- -->

``` r
hist(asy$PC1_w)
```

![](Color_correlations_files/figure-gfm/throat%20v%20wingspot-2.png)<!-- -->

``` r
z <- lmerTest::lmer(PC1_w ~ PC1_t + (1|Year) + (1|prepartor), data = asy, na.action = na.exclude) 
```

    ## boundary (singular) fit: see help('isSingular')

``` r
summary(z)
```

    ## Linear mixed model fit by REML. t-tests use Satterthwaite's method [
    ## lmerModLmerTest]
    ## Formula: PC1_w ~ PC1_t + (1 | Year) + (1 | prepartor)
    ##    Data: asy
    ## 
    ## REML criterion at convergence: -195.2
    ## 
    ## Scaled residuals: 
    ##      Min       1Q   Median       3Q      Max 
    ## -2.75103 -0.67981  0.01409  0.75942  1.75553 
    ## 
    ## Random effects:
    ##  Groups    Name        Variance  Std.Dev.
    ##  Year      (Intercept) 2.623e-05 0.005122
    ##  prepartor (Intercept) 0.000e+00 0.000000
    ##  Residual              9.431e-03 0.097113
    ## Number of obs: 110, groups:  Year, 7; prepartor, 6
    ## 
    ## Fixed effects:
    ##              Estimate Std. Error        df t value Pr(>|t|)    
    ## (Intercept)  0.075522   0.009593  6.200281   7.872 0.000189 ***
    ## PC1_t       -0.875917   0.432759 60.160010  -2.024 0.047415 *  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##       (Intr)
    ## PC1_t 0.142 
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see help('isSingular')

``` r
r.squaredGLMM(z)
```

    ##             R2m        R2c
    ## [1,] 0.03656925 0.03924166

``` r
tab_model(z)
```

<table style="border-collapse:collapse; border:none;">
<tr>
<th style="border-top: double; text-align:center; font-style:normal; font-weight:bold; padding:0.2cm;  text-align:left; ">
 
</th>
<th colspan="3" style="border-top: double; text-align:center; font-style:normal; font-weight:bold; padding:0.2cm; ">
PC1_w
</th>
</tr>
<tr>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  text-align:left; ">
Predictors
</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">
Estimates
</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">
CI
</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">
p
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">
(Intercept)
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
0.08
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
0.06 – 0.09
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
<strong>\<0.001</strong>
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">
PC1 t
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
-0.88
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
-1.73 – -0.02
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
<strong>0.046</strong>
</td>
</tr>
<tr>
<td colspan="4" style="font-weight:bold; text-align:left; padding-top:.8em;">
Random Effects
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
σ<sup>2</sup>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.01
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
τ<sub>00</sub> <sub>Year</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.00
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
τ<sub>00</sub> <sub>prepartor</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.00
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
N <sub>Year</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
7
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
N <sub>prepartor</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
6
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm; border-top:1px solid;">
Observations
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left; border-top:1px solid;" colspan="3">
110
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
Marginal R<sup>2</sup> / Conditional R<sup>2</sup>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.037 / NA
</td>
</tr>
</table>

``` r
ggplot(asy)+
  geom_point(aes(x = PC1_t, y = PC1_w, col = lat))+
  scale_color_viridis_c(direction = -1)+
  geom_smooth(aes(x = PC1_t, y = PC1_w), method = "lm", col = "black")+
  labs(x = "Throat PC1", y = "Wingspot PC1")+
  theme_classic()
```

    ## `geom_smooth()` using formula = 'y ~ x'

    ## Warning: Removed 3 rows containing non-finite outside the scale range
    ## (`stat_smooth()`).

    ## Warning: Removed 3 rows containing missing values or values outside the scale range
    ## (`geom_point()`).

![](Color_correlations_files/figure-gfm/throat%20v%20wingspot-3.png)<!-- -->

``` r
z <- lmerTest::lmer(area_mm2_w ~ PC1_t + (1|Year) + (1|prepartor), data = asy, na.action = na.exclude) 
```

    ## boundary (singular) fit: see help('isSingular')

``` r
summary(z)
```

    ## Linear mixed model fit by REML. t-tests use Satterthwaite's method [
    ## lmerModLmerTest]
    ## Formula: area_mm2_w ~ PC1_t + (1 | Year) + (1 | prepartor)
    ##    Data: asy
    ## 
    ## REML criterion at convergence: 847.5
    ## 
    ## Scaled residuals: 
    ##      Min       1Q   Median       3Q      Max 
    ## -2.35122 -0.68216  0.06182  0.59469  2.70788 
    ## 
    ## Random effects:
    ##  Groups    Name        Variance Std.Dev.
    ##  Year      (Intercept)   0.00    0.000  
    ##  prepartor (Intercept)  33.93    5.825  
    ##  Residual              140.81   11.866  
    ## Number of obs: 110, groups:  Year, 7; prepartor, 6
    ## 
    ## Fixed effects:
    ##             Estimate Std. Error      df t value Pr(>|t|)    
    ## (Intercept)   46.553      3.249   3.561  14.327 0.000282 ***
    ## PC1_t        -31.176     54.937 107.612  -0.567 0.571570    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##       (Intr)
    ## PC1_t 0.036 
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see help('isSingular')

``` r
r.squaredGLMM(z)
```

    ##              R2m       R2c
    ## [1,] 0.002595674 0.1962694

``` r
tab_model(z)
```

<table style="border-collapse:collapse; border:none;">
<tr>
<th style="border-top: double; text-align:center; font-style:normal; font-weight:bold; padding:0.2cm;  text-align:left; ">
 
</th>
<th colspan="3" style="border-top: double; text-align:center; font-style:normal; font-weight:bold; padding:0.2cm; ">
area_mm2_w
</th>
</tr>
<tr>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  text-align:left; ">
Predictors
</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">
Estimates
</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">
CI
</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">
p
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">
(Intercept)
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
46.55
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
40.11 – 53.00
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
<strong>\<0.001</strong>
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">
PC1 t
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
-31.18
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
-140.11 – 77.75
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">
0.572
</td>
</tr>
<tr>
<td colspan="4" style="font-weight:bold; text-align:left; padding-top:.8em;">
Random Effects
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
σ<sup>2</sup>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
140.81
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
τ<sub>00</sub> <sub>Year</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.00
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
τ<sub>00</sub> <sub>prepartor</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
33.93
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
N <sub>Year</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
7
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
N <sub>prepartor</sub>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
6
</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm; border-top:1px solid;">
Observations
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left; border-top:1px solid;" colspan="3">
110
</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">
Marginal R<sup>2</sup> / Conditional R<sup>2</sup>
</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">
0.003 / NA
</td>
</tr>
</table>

``` r
ggplot(asy)+
  geom_point(aes(x = PC1_t, y = area_mm2_w, col = lat))+
  scale_color_viridis_c(direction = -1)+
  geom_smooth(aes(x = PC1_t, y = area_mm2_w), method = "lm", col = "black")+
  labs(x = "Throat PC1", y = "Wingspot area (mm2)")+
  theme_classic()
```

    ## `geom_smooth()` using formula = 'y ~ x'

    ## Warning: Removed 3 rows containing non-finite outside the scale range (`stat_smooth()`).
    ## Removed 3 rows containing missing values or values outside the scale range
    ## (`geom_point()`).

![](Color_correlations_files/figure-gfm/throat%20v%20wingspot-4.png)<!-- -->

# wingspot vs other plumage patches

``` r
crown <- lmerTest::lmer(PC1_c ~ PC1_w + (1|Year) + (1|prepartor), data = asy, na.action = na.exclude) 
```

    ## boundary (singular) fit: see help('isSingular')

``` r
summary(crown)
```

    ## Linear mixed model fit by REML. t-tests use Satterthwaite's method [
    ## lmerModLmerTest]
    ## Formula: PC1_c ~ PC1_w + (1 | Year) + (1 | prepartor)
    ##    Data: asy
    ## 
    ## REML criterion at convergence: -433.2
    ## 
    ## Scaled residuals: 
    ##      Min       1Q   Median       3Q      Max 
    ## -2.53331 -0.64077 -0.02601  0.60197  2.56322 
    ## 
    ## Random effects:
    ##  Groups    Name        Variance  Std.Dev.
    ##  Year      (Intercept) 0.0001626 0.01275 
    ##  prepartor (Intercept) 0.0000000 0.00000 
    ##  Residual              0.0009112 0.03019 
    ## Number of obs: 109, groups:  Year, 7; prepartor, 6
    ## 
    ## Fixed effects:
    ##               Estimate Std. Error         df t value Pr(>|t|)  
    ## (Intercept)   0.008985   0.006179   8.074660   1.454   0.1837  
    ## PC1_w        -0.056472   0.030542 103.440369  -1.849   0.0673 .
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##       (Intr)
    ## PC1_w -0.371
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see help('isSingular')

``` r
covert <- lmerTest::lmer(PC1_o ~ PC1_w + (1|Year) + (1|prepartor), data = asy, na.action = na.exclude) 
```

    ## boundary (singular) fit: see help('isSingular')

``` r
summary(covert)
```

    ## Linear mixed model fit by REML. t-tests use Satterthwaite's method [
    ## lmerModLmerTest]
    ## Formula: PC1_o ~ PC1_w + (1 | Year) + (1 | prepartor)
    ##    Data: asy
    ## 
    ## REML criterion at convergence: -426.2
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -1.8580 -0.6908 -0.1054  0.4375  2.7095 
    ## 
    ## Random effects:
    ##  Groups    Name        Variance  Std.Dev. 
    ##  Year      (Intercept) 3.354e-04 1.832e-02
    ##  prepartor (Intercept) 3.145e-13 5.608e-07
    ##  Residual              9.828e-04 3.135e-02
    ## Number of obs: 110, groups:  Year, 7; prepartor, 6
    ## 
    ## Fixed effects:
    ##               Estimate Std. Error         df t value Pr(>|t|)
    ## (Intercept)  -0.013217   0.008033   7.114031  -1.645    0.143
    ## PC1_w        -0.025490   0.030797 103.365867  -0.828    0.410
    ## 
    ## Correlation of Fixed Effects:
    ##       (Intr)
    ## PC1_w -0.291
    ## optimizer (nloptwrap) convergence code: 0 (OK)
    ## boundary (singular) fit: see help('isSingular')

``` r
belly <- lmerTest::lmer(PC1_b ~ PC1_w + (1|Year) + (1|prepartor), data = asy, na.action = na.exclude) 
summary(belly)
```

    ## Linear mixed model fit by REML. t-tests use Satterthwaite's method [
    ## lmerModLmerTest]
    ## Formula: PC1_b ~ PC1_w + (1 | Year) + (1 | prepartor)
    ##    Data: asy
    ## 
    ## REML criterion at convergence: -249.7
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -2.1416 -0.6034  0.1324  0.6020  2.8653 
    ## 
    ## Random effects:
    ##  Groups    Name        Variance  Std.Dev.
    ##  Year      (Intercept) 0.0001697 0.01303 
    ##  prepartor (Intercept) 0.0018168 0.04262 
    ##  Residual              0.0052762 0.07264 
    ## Number of obs: 111, groups:  Year, 7; prepartor, 6
    ## 
    ## Fixed effects:
    ##              Estimate Std. Error        df t value Pr(>|t|)
    ## (Intercept) 4.722e-03  2.416e-02 2.811e+00   0.195    0.858
    ## PC1_w       1.025e-01  7.166e-02 1.038e+02   1.431    0.155
    ## 
    ## Correlation of Fixed Effects:
    ##       (Intr)
    ## PC1_w -0.256

``` r
throat <- lmerTest::lmer(PC1_t ~ PC1_w + (1|Year) + (1|prepartor), data = asy, na.action = na.exclude) 
summary(throat)
```

    ## Linear mixed model fit by REML. t-tests use Satterthwaite's method [
    ## lmerModLmerTest]
    ## Formula: PC1_t ~ PC1_w + (1 | Year) + (1 | prepartor)
    ##    Data: asy
    ## 
    ## REML criterion at convergence: -539.7
    ## 
    ## Scaled residuals: 
    ##      Min       1Q   Median       3Q      Max 
    ## -1.91821 -0.75205  0.09299  0.73877  1.84039 
    ## 
    ## Random effects:
    ##  Groups    Name        Variance  Std.Dev.
    ##  Year      (Intercept) 1.298e-04 0.011393
    ##  prepartor (Intercept) 4.815e-06 0.002194
    ##  Residual              3.406e-04 0.018454
    ## Number of obs: 110, groups:  Year, 7; prepartor, 6
    ## 
    ## Fixed effects:
    ##               Estimate Std. Error         df t value Pr(>|t|)  
    ## (Intercept)   0.000556   0.005116   7.593923   0.109   0.9163  
    ## PC1_w        -0.034306   0.018365 103.624795  -1.868   0.0646 .
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##       (Intr)
    ## PC1_w -0.280

``` r
tvc <- lmerTest::lmer(PC1_t ~ PC1_o + (1|Year) + (1|prepartor), data = asy, na.action = na.exclude) 
summary(tvc)
```

    ## Linear mixed model fit by REML. t-tests use Satterthwaite's method [
    ## lmerModLmerTest]
    ## Formula: PC1_t ~ PC1_o + (1 | Year) + (1 | prepartor)
    ##    Data: asy
    ## 
    ## REML criterion at convergence: -576.9
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -2.3006 -0.7445  0.1498  0.6702  2.0681 
    ## 
    ## Random effects:
    ##  Groups    Name        Variance  Std.Dev.
    ##  Year      (Intercept) 1.949e-05 0.004414
    ##  prepartor (Intercept) 1.034e-05 0.003215
    ##  Residual              2.338e-04 0.015290
    ## Number of obs: 108, groups:  Year, 7; prepartor, 6
    ## 
    ## Fixed effects:
    ##              Estimate Std. Error        df t value Pr(>|t|)    
    ## (Intercept)  0.003646   0.003010  4.312537   1.211    0.288    
    ## PC1_o        0.378261   0.045394 91.826444   8.333 7.37e-13 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##       (Intr)
    ## PC1_o 0.211

# make a table of results

    ## boundary (singular) fit: see help('isSingular')
    ## boundary (singular) fit: see help('isSingular')
    ## boundary (singular) fit: see help('isSingular')
    ## boundary (singular) fit: see help('isSingular')
    ## boundary (singular) fit: see help('isSingular')
    ## boundary (singular) fit: see help('isSingular')
    ## boundary (singular) fit: see help('isSingular')

    ##    Response                                   Explanatory      P_value
    ## 1     PC1_c      + + PC1_d + (1 | Year) + (1 | prepartor) 5.693240e-07
    ## 2     PC1_o      + + PC1_d + (1 | Year) + (1 | prepartor) 2.671333e-07
    ## 3     PC1_b      + + PC1_d + (1 | Year) + (1 | prepartor) 2.902830e-01
    ## 4     PC1_t      + + PC1_d + (1 | Year) + (1 | prepartor) 8.667564e-04
    ## 5     PC1_c      + + PC1_w + (1 | Year) + (1 | prepartor) 6.731598e-02
    ## 6     PC1_o      + + PC1_w + (1 | Year) + (1 | prepartor) 4.097528e-01
    ## 7     PC1_b      + + PC1_w + (1 | Year) + (1 | prepartor) 1.554054e-01
    ## 8     PC1_d      + + PC1_w + (1 | Year) + (1 | prepartor) 9.299282e-03
    ## 9     PC1_t      + + PC1_w + (1 | Year) + (1 | prepartor) 6.458662e-02
    ## 10    PC1_c + + area_mm2_w + (1 | Year) + (1 | prepartor) 9.055215e-01
    ## 11    PC1_o + + area_mm2_w + (1 | Year) + (1 | prepartor) 4.730336e-01
    ## 12    PC1_b + + area_mm2_w + (1 | Year) + (1 | prepartor) 6.602048e-01
    ## 13    PC1_d + + area_mm2_w + (1 | Year) + (1 | prepartor) 8.234511e-01
    ## 14    PC1_t + + area_mm2_w + (1 | Year) + (1 | prepartor) 7.073917e-01
    ##             R2m
    ## 1  0.2077702439
    ## 2  0.2587958119
    ## 3  0.0102717210
    ## 4  0.1124658573
    ## 5  0.0271374534
    ## 6  0.0048353499
    ## 7  0.0139669734
    ## 8  0.0342779664
    ## 9  0.0235186721
    ## 10 0.0001134963
    ## 11 0.0037817310
    ## 12 0.0015746543
    ## 13 0.0002539083
    ## 14 0.0010252290
