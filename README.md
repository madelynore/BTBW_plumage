# Code for: Environment shapes plumage color variation in a new world warbler Setophaga caerulescens 
## Ore et al. 

-------------------------------------------------------------

![BTBW_illustrations](results/Figure1_illustrations.png)

### Overview: 
Within-species plumage variation allows us to investigate how the environment, 
feather structure, and genes together produce visible differences in appearance.
Color variation in male *Setophaga caerulescens* (Black-throated Blue Warbler) follows Gloger’s Rule—
a geographic pattern in which individuals tend to be darker in warmer and wetter environments.
Darker mantle coloration results from melanin granules deposited within the feather barbs,
shifting color of the barb from blue to black.
Color variation likely driven by the combined action of many genes—each contributing a small effect,
or to phenotypic plasticity, where individuals adjust their appearance in response to local environmental conditions. 
Plumage coloration in *S. caerulescens* is a window into the processes of adaptation,
revealing how genes, structure, and natural selection interact to shape wild populations over time.


### Relationship between plumage and environment

[PCA_color.R](R_scripts/PCA_color.R): generates PCA based on quantum-catch model outputs of plumage patches

[Color_correlations.Rmd](R_scripts/Color_correlations.md): looks for correlations between different plumage patches

[Age_color_models.Rmd](R_scripts/Age_color_models.md): looks for associations between age class and color

[Plumage_Env.Rmd](R_scripts/Plumage_Env.md): model selection and generalized additive models for associations between plumage color and environmental variables

### Relationship between plumage and genotype

[PCA_genomics.R](R_scripts/PCA_genomics.R): generates PCA based on a covariance matrix output from ANGSD to correct for relatedness in -doAsso

[GWAS.Rmd](R_scripts/GWAS.md): runs GEMMA BSLMM and ANGSD-asso

[LRT_rolling_window.R](R_scripts/LRT_rolling_window.R): calculates the median LRT score for a null distribution
    LRT permutation array created based on scripts found [here](https://github.com/lucasrocmoreira/Moreira-Smith_SciAdv_2023/tree/main)
    
[Identify_candidate_genes.R](R_scripts/Identify_candidate_genes.R): looks for genes near SNPs strongly correlated with mantle color and compares them to a list of known melanogenesis and climate-linked genes

