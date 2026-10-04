# =============================================================
# 03b_posthoc_C4_sensitivity.R — GBM-LLM-Benchmark
# Post-hoc sensitivity analysis — NOT pre-registered
# =============================================================
# Context:
#   Protocol v4, Section 10, pre-specifies the C4 (hallucination
#   rate) comparison as a Pearson chi-squared test treating each
#   model's counts as independent. That test is retained as the
#   PRIMARY, pre-registered analysis in 03_analysis.R and in the
#   manuscript.
#
#   The same 509 eligible variants were evaluated by all three
#   models (a repeated-measures design: each variant contributes
#   one paired observation per model), which the chi-squared test
#   does not model.
#
#   Revision history of this script (kept for transparency):
#   v1 fit glmer(hallucination ~ model + (1|case_id)) — a random
#   intercept for CASE only. Because a case can contain several
#   different variants, this does not represent the within-variant
#   pairing across the three models, only broader case-level
#   clustering. Its variance component was estimated at the
#   boundary (~0), which v1 mis-described as evidence of "no
#   material clustering" — a boundary estimate does not establish
#   independence, especially with these sparse hallucination counts
#   (72 / 5 / 1 across the three models).
#
#   v2 (this version) instead fits a GEE (geepack::geeglm) with the
#   cluster identifier set to VARIANT (not case): each variant
#   contributes exactly 3 correlated observations, one per model,
#   and an exchangeable working correlation with robust (sandwich)
#   standard errors is used, so inference does not depend on a
#   variance component being estimable away from the boundary.
# =============================================================

library(tidyverse)
library(geepack)
library(emmeans)
library(here)

scores <- read_csv(here("scoring", "scores_all_variants.csv"),
                    show_col_types = FALSE) |>
  mutate(variant_id = paste(case_id, gene, hgvsp, sep = "|"))

scores_c4 <- scores |>
  filter(!gt_relevant) |>
  mutate(model = factor(model, levels = c("gpt4o", "gemini25", "deepseek_r1")),
         variant_num = as.integer(factor(variant_id))) |>
  arrange(variant_num, model) |>
  as.data.frame()

message(">>> C4 post-hoc sensitivity analysis (GEE, cluster = variant)")
message(">>> N eligible observations: ", nrow(scores_c4))
message(">>> N variant clusters (each size 3, one obs per model): ",
        length(unique(scores_c4$variant_num)))

gee_c4 <- geeglm(c4_hallucination ~ model, id = variant_num, data = scores_c4,
                  family = binomial, corstr = "exchangeable")

cat("\n=== C4 GEE MODEL SUMMARY ===\n")
print(summary(gee_c4))

cat("\n=== C4 GEE OMNIBUS WALD TEST ===\n")
wald_c4 <- anova(gee_c4)
print(wald_c4)

cat("\n=== C4 GEE PAIRWISE COMPARISONS (Bonferroni, robust SE) ===\n")
emm_c4 <- emmeans(gee_c4, ~model, vcov. = vcov(gee_c4))
pairs_c4_gee <- pairs(emm_c4, adjust = "bonferroni")
print(pairs_c4_gee)

dir.create(here("results", "tables"), recursive = TRUE, showWarnings = FALSE)
sink(here("results", "tables", "c4_posthoc_mixed_model.txt"))
cat("=== C4 POST-HOC SENSITIVITY ANALYSIS (non-pre-registered) ===\n")
cat("Primary, pre-registered C4 analysis (chi-squared, independent counts) is in\n")
cat("statistical_tests.txt / 03_analysis.R.\n\n")
cat("Method: GEE (geepack::geeglm), cluster = variant (each of the 509 eligible\n")
cat("variants contributes one paired observation per model), exchangeable working\n")
cat("correlation, robust (sandwich) standard errors. This directly represents the\n")
cat("repeated-measures pairing across models that a case-level-only random\n")
cat("intercept does not capture.\n\n")
cat("=== OMNIBUS WALD TEST ===\n"); print(wald_c4)
cat("\n=== PAIRWISE COMPARISONS (Bonferroni) ===\n"); print(pairs_c4_gee)
sink()

message("\n>>> Post-hoc C4 sensitivity analysis complete.")
message(">>> Results saved to results/tables/c4_posthoc_mixed_model.txt")
