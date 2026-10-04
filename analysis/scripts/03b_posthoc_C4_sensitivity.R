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
#   Non-independence in this data has two layers: (1) the same
#   variant is evaluated by all three models (repeated measures),
#   and (2) multiple variants belong to the same case, and may
#   share case-level difficulty. The chi-squared test ignores both.
#
#   Revision history of this script (kept for transparency):
#   v1 fit glmer(hallucination ~ model + (1|case_id)) — random
#   intercept for case only; its boundary (~0) variance estimate
#   was mis-described as evidence of "no material clustering."
#   v2 fit a GEE clustered on VARIANT (exchangeable corr, robust
#   SE) — this models layer (1) correctly, but still treats
#   different variants within the same case as independent
#   clusters, leaving layer (2) unaddressed.
#   v3 (this version) clusters on CASE instead: each case cluster
#   contains all (variant x model) observations for that case, so
#   both layers of non-independence fall inside one cluster and
#   are covered by the robust sandwich SE, without needing either
#   layer's correlation to be estimated exactly right (GEE's
#   robust SE is valid under correlation misspecification as long
#   as the clustering/independence unit itself is correct, and
#   case is the correct unit here: different cases are genuinely
#   independent patients/profiles).
# =============================================================

library(tidyverse)
library(geepack)
library(emmeans)
library(here)

scores <- read_csv(here("scoring", "scores_all_variants.csv"),
                    show_col_types = FALSE)

scores_c4 <- scores |>
  filter(!gt_relevant) |>
  mutate(model = factor(model, levels = c("gpt4o", "gemini25", "deepseek_r1")),
         case_num = as.integer(factor(case_id))) |>
  arrange(case_num, model) |>
  as.data.frame()

message(">>> C4 post-hoc sensitivity analysis (GEE, cluster = case)")
message(">>> N eligible observations: ", nrow(scores_c4))
message(">>> N case clusters: ", length(unique(scores_c4$case_num)))

gee_c4 <- geeglm(c4_hallucination ~ model, id = case_num, data = scores_c4,
                  family = binomial, corstr = "exchangeable")

cat("\n=== C4 GEE MODEL SUMMARY (cluster = case) ===\n")
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
cat("Method: GEE (geepack::geeglm), cluster = CASE (each case's full set of\n")
cat("variant x model observations is one cluster), exchangeable working\n")
cat("correlation, robust (sandwich) standard errors. This covers both layers of\n")
cat("non-independence in this design -- the same variant scored by all three\n")
cat("models, and multiple variants sharing a case -- within one cluster, so\n")
cat("robust SEs are valid without requiring either correlation to be estimated\n")
cat("exactly right.\n\n")
cat("=== OMNIBUS WALD TEST ===\n"); print(wald_c4)
cat("\n=== PAIRWISE COMPARISONS (Bonferroni) ===\n"); print(pairs_c4_gee)
sink()

message("\n>>> Post-hoc C4 sensitivity analysis complete.")
message(">>> Results saved to results/tables/c4_posthoc_mixed_model.txt")
