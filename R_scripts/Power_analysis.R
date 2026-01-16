## Power analysis

# for btbw gemma ----------------------------------------------------------------

# Tailored for BTBW color analysis
btbw_power_analysis <- function() {
  
  # Your current study parameters
  current_n <- 95  # Based on your ASY analysis
  current_snps <- 3.3e6  # Based on your VCF filtering
  
  # Effect sizes to test (large effects for color genes)
  color_effects <- c(0.05, 0.1, 0.15, 0.2, 0.3)  # 5-30% variance explained
  
  # Different sample sizes to compare
  sample_scenarios <- c(25, 50, 95, 100, 150, 200, 500)
  
  results <- expand.grid(
    sample_size = sample_scenarios,
    effect_size = color_effects
  )
  
  # Calculate power for each scenario
  results$power <- mapply(function(n, eff) {
    gwas_power_analysis(n, current_snps, eff, maf = 0.2, alpha = 5e-8)$power
  }, results$sample_size, results$effect_size)
  
  # Add current study indicator
  results$is_current <- results$sample_size == current_n
  
  return(results)
}

# Run BTBW-specific analysis
btbw_results <- btbw_power_analysis()

# Plot for your study
ggplot(btbw_results, aes(x = sample_size, y = power, color = factor(effect_size))) +
  geom_line(size = 1.2) +
  geom_point(data = btbw_results[btbw_results$is_current,], 
             size = 4, shape = 17) +  # Mark current study
  geom_hline(yintercept = 0.8, linetype = "dashed", alpha = 0.7) +
  scale_color_viridis_d(name = "Effect Size\n(R²)") +
  labs(x = "Sample Size", y = "Statistical Power",
       title = "BTBW Color GWAS: Power Analysis",
       subtitle = "Triangles = Current study (n=95)") +
  theme_minimal() +
  theme(legend.position = "right")


# angsd-asso --------------------------------------------------------------

# ANGSD-asso specific power analysis
angsd_power_analysis <- function(n_samples, n_snps, effect_size, 
                                 coverage = 2, alpha = 5e-8,
                                 method = "LRT") {
  
  # ANGSD-asso accounts for genotype uncertainty
  # Effective sample size is reduced based on coverage/uncertainty
  
  # Coverage-based adjustment (empirical formula)
  # Lower coverage = more uncertainty = reduced effective N
  coverage_factor <- pmin(1, coverage / 10)  # Saturates at 10x coverage
  effective_n <- n_samples * coverage_factor
  
  # Genotype likelihood uncertainty reduces power
  # (more conservative than hard calls)
  uncertainty_penalty <- 0.85  # ~15% power reduction vs hard calls
  
  if (method == "LRT") {
    # For -doAsso 2 (LRT test)
    # Calculate non-centrality parameter for chi-square test
    ncp <- 2 * effective_n * effect_size / (1 - effect_size)
    
    # Multiple testing correction
    corrected_alpha <- alpha / n_snps
    critical_value <- qchisq(1 - corrected_alpha, df = 1)
    
    # Power calculation with uncertainty penalty
    power <- pchisq(critical_value, df = 1, ncp = ncp, lower.tail = FALSE)
    power <- power * uncertainty_penalty
    
  } else if (method == "score") {
    # For -doAsso 5 (score test) - generally more conservative
    # Similar to LRT but with additional penalty
    ncp <- 2 * effective_n * effect_size / (1 - effect_size)
    corrected_alpha <- alpha / n_snps
    critical_value <- qchisq(1 - corrected_alpha, df = 1)
    
    power <- pchisq(critical_value, df = 1, ncp = ncp, lower.tail = FALSE)
    power <- power * uncertainty_penalty * 0.9  # Additional penalty for score test
  }
  
  return(list(
    power = pmax(0, pmin(1, power)),
    effective_n = effective_n,
    method = method
  ))
}

# Compare ANGSD vs GEMMA power for your data
btbw_angsd_power_comparison <- function() {
  
  current_n <- 95
  current_snps <- 3.3e6  # Your SNP count
  effect_sizes <- c(0.05, 0.1, 0.15, 0.2, 0.3)
  sample_sizes <- c(50, 95, 150, 200, 300, 500)
  
  results <- expand.grid(
    sample_size = sample_sizes,
    effect_size = effect_sizes
  )
  
  # GEMMA power (hard calls)
  results$gemma_power <- mapply(function(n, eff) {
    gwas_power_analysis(n, current_snps, eff, alpha = 5e-8)$power
  }, results$sample_size, results$effect_size)
  
  # ANGSD-asso power (genotype likelihoods)
  results$angsd_lrt_power <- mapply(function(n, eff) {
    angsd_power_analysis(n, current_snps, eff, 
                         coverage = 4, method = "LRT")$power
  }, results$sample_size, results$effect_size)
  
  results$angsd_score_power <- mapply(function(n, eff) {
    angsd_power_analysis(n, current_snps, eff, 
                         coverage = 4, method = "score")$power
  }, results$sample_size, results$effect_size)
  
  return(results)
}

# Run comparison
comparison_results <- btbw_angsd_power_comparison()

# Reshape for plotting
library(tidyr)
comparison_long <- comparison_results %>%
  pivot_longer(cols = ends_with("_power"), 
               names_to = "method", 
               values_to = "power") %>%
  mutate(method = case_when(
    method == "gemma_power" ~ "GEMMA (hard calls)",
    method == "angsd_lrt_power" ~ "ANGSD LRT (-doAsso 2)",
    method == "angsd_score_power" ~ "ANGSD Score (-doAsso 5)"
  ))

# Plot comparison
ggplot(comparison_long, aes(x = sample_size, y = power, 
                            color = factor(effect_size), 
                            linetype = method)) +
  geom_line(size = 1) +
  geom_point(data = comparison_long[comparison_long$sample_size == 95,],
             size = 3) +
  geom_hline(yintercept = 0.8, linetype = "dashed", alpha = 0.5) +
  scale_color_viridis_d(name = "Effect Size") +
  scale_linetype_manual(values = c("solid", "dashed", "dotted"),
                        name = "Method") +
  labs(x = "Sample Size", y = "Statistical Power",
       title = "BTBW GWAS: Method Comparison",
       subtitle = "Points mark current study (n=95)") +
  theme_minimal() +
  facet_wrap(~effect_size, labeller = label_both)

# power for dowo hawo -----------------------------------------------------

# ANGSD-asso specific power analysis
angsd_power_analysis <- function(n_samples, n_snps, effect_size, 
                                 coverage = 5, alpha = 5e-8,
                                 method = "LRT") {
  
  # ANGSD-asso accounts for genotype uncertainty
  # Effective sample size is reduced based on coverage/uncertainty
  
  # Coverage-based adjustment (empirical formula)
  # Lower coverage = more uncertainty = reduced effective N
  coverage_factor <- pmin(1, coverage / 10)  # Saturates at 10x coverage
  effective_n <- n_samples * coverage_factor
  
  # Genotype likelihood uncertainty reduces power
  # (more conservative than hard calls)
  uncertainty_penalty <- 0.85  # ~15% power reduction vs hard calls
  
  if (method == "LRT") {
    # For -doAsso 2 (LRT test)
    # Calculate non-centrality parameter for chi-square test
    ncp <- 2 * effective_n * effect_size / (1 - effect_size)
    
    # Multiple testing correction
    corrected_alpha <- alpha / n_snps
    critical_value <- qchisq(1 - corrected_alpha, df = 1)
    
    # Power calculation with uncertainty penalty
    power <- pchisq(critical_value, df = 1, ncp = ncp, lower.tail = FALSE)
    power <- power * uncertainty_penalty
    
  } else if (method == "score") {
    # For -doAsso 5 (score test) - generally more conservative
    # Similar to LRT but with additional penalty
    ncp <- 2 * effective_n * effect_size / (1 - effect_size)
    corrected_alpha <- alpha / n_snps
    critical_value <- qchisq(1 - corrected_alpha, df = 1)
    
    power <- pchisq(critical_value, df = 1, ncp = ncp, lower.tail = FALSE)
    power <- power * uncertainty_penalty * 0.9  # Additional penalty for score test
  }
  
  return(list(
    power = pmax(0, pmin(1, power)),
    effective_n = effective_n,
    method = method
  ))
}

# Compare ANGSD vs GEMMA power for your data
dowo_angsd_power_comparison <- function() {
  
  current_n <- 140
  current_snps <- 7.1e6  # Your SNP count
  effect_sizes <- c(0.05, 0.1, 0.15, 0.2, 0.3)
  sample_sizes <- c(50, 95, 150, 200, 300, 500)
  
  results <- expand.grid(
    sample_size = sample_sizes,
    effect_size = effect_sizes
  )
  
  # GEMMA power (hard calls)
  results$gemma_power <- mapply(function(n, eff) {
    gwas_power_analysis(n, current_snps, eff, alpha = 5e-8)$power
  }, results$sample_size, results$effect_size)
  
  # ANGSD-asso power (genotype likelihoods)
  results$angsd_lrt_power <- mapply(function(n, eff) {
    angsd_power_analysis(n, current_snps, eff, 
                         coverage = 4, method = "LRT")$power
  }, results$sample_size, results$effect_size)
  
  results$angsd_score_power <- mapply(function(n, eff) {
    angsd_power_analysis(n, current_snps, eff, 
                         coverage = 4, method = "score")$power
  }, results$sample_size, results$effect_size)
  
  return(results)
}

# Run comparison
comparison_results <- dowo_angsd_power_comparison()

# Reshape for plotting
library(tidyr)
comparison_long <- comparison_results %>%
  pivot_longer(cols = ends_with("_power"), 
               names_to = "method", 
               values_to = "power") %>%
  mutate(method = case_when(
    method == "gemma_power" ~ "GEMMA (hard calls)",
    method == "angsd_lrt_power" ~ "ANGSD LRT (-doAsso 2)",
    method == "angsd_score_power" ~ "ANGSD Score (-doAsso 5)"
  ))

# Plot comparison
ggplot(comparison_long, aes(x = sample_size, y = power, 
                            color = factor(effect_size), 
                            linetype = method)) +
  geom_line(size = 1) +
  geom_point(data = comparison_long[comparison_long$sample_size == 140,],
             size = 3) +
  geom_hline(yintercept = 0.8, linetype = "dashed", alpha = 0.5) +
  scale_color_viridis_d(name = "Effect Size") +
  scale_linetype_manual(values = c("solid", "dashed", "dotted"),
                        name = "Method") +
  labs(x = "Sample Size", y = "Statistical Power",
       title = "DOWO/HAWO GWAS: Method Comparison",
       subtitle = "Points mark study sample size (n=140)") +
  theme_minimal() +
  facet_wrap(~effect_size, labeller = label_both)


# power for NOFL ----------------------------------------------------------
# ANGSD-asso specific power analysis
angsd_power_analysis <- function(n_samples, n_snps, effect_size, 
                                 coverage = 4, alpha = 5e-8,
                                 method = "LRT") {
  
  # ANGSD-asso accounts for genotype uncertainty
  # Effective sample size is reduced based on coverage/uncertainty
  
  # Coverage-based adjustment (empirical formula)
  # Lower coverage = more uncertainty = reduced effective N
  coverage_factor <- pmin(1, coverage / 10)  # Saturates at 10x coverage
  effective_n <- n_samples * coverage_factor
  
  # Genotype likelihood uncertainty reduces power
  # (more conservative than hard calls)
  uncertainty_penalty <- 0.85  # ~15% power reduction vs hard calls
  
  if (method == "LRT") {
    # For -doAsso 2 (LRT test)
    # Calculate non-centrality parameter for chi-square test
    ncp <- 2 * effective_n * effect_size / (1 - effect_size)
    
    # Multiple testing correction
    corrected_alpha <- alpha / n_snps
    critical_value <- qchisq(1 - corrected_alpha, df = 1)
    
    # Power calculation with uncertainty penalty
    power <- pchisq(critical_value, df = 1, ncp = ncp, lower.tail = FALSE)
    power <- power * uncertainty_penalty
    
  } else if (method == "score") {
    # For -doAsso 5 (score test) - generally more conservative
    # Similar to LRT but with additional penalty
    ncp <- 2 * effective_n * effect_size / (1 - effect_size)
    corrected_alpha <- alpha / n_snps
    critical_value <- qchisq(1 - corrected_alpha, df = 1)
    
    power <- pchisq(critical_value, df = 1, ncp = ncp, lower.tail = FALSE)
    power <- power * uncertainty_penalty * 0.9  # Additional penalty for score test
  }
  
  return(list(
    power = pmax(0, pmin(1, power)),
    effective_n = effective_n,
    method = method
  ))
}

# Compare ANGSD vs GEMMA power for your data
nofl_angsd_power_comparison <- function() {
  
  current_n <- 48
  current_snps <- 7.2e6  # Your SNP count
  effect_sizes <- c(0.05, 0.1, 0.15, 0.2, 0.3)
  sample_sizes <- c(20, 50, 95, 150, 200, 300, 500)
  
  results <- expand.grid(
    sample_size = sample_sizes,
    effect_size = effect_sizes
  )
  
  # GEMMA power (hard calls)
  results$gemma_power <- mapply(function(n, eff) {
    gwas_power_analysis(n, current_snps, eff, alpha = 5e-8)$power
  }, results$sample_size, results$effect_size)
  
  # ANGSD-asso power (genotype likelihoods)
  results$angsd_lrt_power <- mapply(function(n, eff) {
    angsd_power_analysis(n, current_snps, eff, 
                         coverage = 4, method = "LRT")$power
  }, results$sample_size, results$effect_size)
  
  results$angsd_score_power <- mapply(function(n, eff) {
    angsd_power_analysis(n, current_snps, eff, 
                         coverage = 4, method = "score")$power
  }, results$sample_size, results$effect_size)
  
  return(results)
}

# Run comparison
comparison_results <- nofl_angsd_power_comparison()

# Reshape for plotting
library(tidyr)
comparison_long <- comparison_results %>%
  pivot_longer(cols = ends_with("_power"), 
               names_to = "method", 
               values_to = "power") %>%
  mutate(method = case_when(
    method == "gemma_power" ~ "GEMMA (hard calls)",
    method == "angsd_lrt_power" ~ "ANGSD LRT (-doAsso 2)",
    method == "angsd_score_power" ~ "ANGSD Score (-doAsso 5)"
  ))

# Plot comparison
ggplot(comparison_long, aes(x = sample_size, y = power, 
                            color = factor(effect_size), 
                            linetype = method)) +
  geom_line(size = 1) +
  geom_point(data = comparison_long[comparison_long$sample_size == 48,],
             size = 3) +
  geom_hline(yintercept = 0.8, linetype = "dashed", alpha = 0.5) +
  scale_color_viridis_d(name = "Effect Size") +
  scale_linetype_manual(values = c("solid", "dashed", "dotted"),
                        name = "Method") +
  labs(x = "Sample Size", y = "Statistical Power",
       title = "NOFL GWAS: Method Comparison",
       subtitle = "Points mark study sample size (n=48)") +
  theme_minimal() +
  facet_wrap(~effect_size, labeller = label_both)

