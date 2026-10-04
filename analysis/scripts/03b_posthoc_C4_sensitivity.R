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
#   This script adds a post-hoc robustness check: the same 509
#   eligible variants were evaluated by all three models (a
#   repeated-measures design), with further clustering of
#   variants within case — neither of which the chi-squared test
#   accounts for. Here we re-fit the comparison as a mixed-effects
#   logistic regression (model as fixed effect, case as a random
#   intercept), the same approach pre-registered for C1 and C2,
#   to check whether the chi-squared conclusion is robust to this
#   non-independence.
#
#   This analysis was NOT in protocol v4 and is reported in the
#   manuscript explicitly as a non-pre-registered sensitivity
#   analysis, not as a replacement for the primary C4 test.
# =============================================================

library(tidyverse)
library(lme4)
library(emmeans)
library(here)

scores <- read_csv(here("scoring", "scores_all_variants.csv"),
                    show_col_types = FALSE)

scores_c4 <- scores |>
  filter(!gt_relevant) |>
  mutate(model = factor(model, levels = c("gpt4o", "gemini25", "deepseek_r1")))

message(">>> C4 post-hoc sensitivity analysis")
message(">>> N eligible variants: ", nrow(scores_c4))
message(">>> N cases: ", length(unique(scores_c4$case_id)))

m_c4 <- glmer(c4_hallucination ~ model + (1 | case_id),
              data = scores_c4, family = binomial,
              control = glmerControl(optimizer = "bobyqa"))
m_c4_null <- glmer(c4_hallucination ~ 1 + (1 | case_id),
                    data = scores_c4, family = binomial,
                    control = glmerControl(optimizer = "bobyqa"))

cat("\n=== C4 POST-HOC MIXED-EFFECTS MODEL — LIKELIHOOD RATIO TEST ===\n")
lrt_c4_posthoc <- anova(m_c4_null, m_c4)
print(lrt_c4_posthoc)

cat("\n=== C4 POST-HOC PAIRWISE COMPARISONS (Bonferroni) ===\n")
emm_c4 <- emmeans(m_c4, ~model)
pairs_c4_posthoc <- pairs(emm_c4, adjust = "bonferroni")
print(pairs_c4_posthoc)

cat("\n=== MODEL SUMMARY ===\n")
print(summary(m_c4))

dir.create(here("results", "tables"), recursive = TRUE, showWarnings = FALSE)
sink(here("results", "tables", "c4_posthoc_mixed_model.txt"))
cat("=== C4 POST-HOC MIXED-EFFECTS MODEL (non-pre-registered sensitivity analysis) ===\n")
cat("Primary, pre-registered C4 analysis (chi-squared, independent counts) is in\n")
cat("statistical_tests.txt / 03_analysis.R. This file checks robustness to the\n")
cat("repeated-measures / case-clustering structure the chi-squared test ignores.\n\n")
cat("=== LIKELIHOOD RATIO TEST ===\n"); print(lrt_c4_posthoc)
cat("\n=== PAIRWISE COMPARISONS (Bonferroni) ===\n"); print(pairs_c4_posthoc)
sink()

message("\n>>> Post-hoc C4 sensitivity analysis complete.")
message(">>> Results saved to results/tables/c4_posthoc_mixed_model.txt")
