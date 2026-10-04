# =============================================================
# 03c_posthoc_C1C2_gee_check.R — GBM-LLM-Benchmark
# Post-hoc robustness check — NOT pre-registered
# =============================================================
# Context:
#   C1 and C2's PRIMARY, pre-registered analysis (protocol v4,
#   Section 10) is mixed-effects logistic regression with CASE as
#   a random intercept, as implemented in 03_analysis.R and
#   reported in the manuscript. That remains unchanged here.
#
#   This script checks robustness using GEE with cluster = CASE
#   (exchangeable working correlation, robust sandwich SE) -- the
#   same approach used in 03b_posthoc_C4_sensitivity.R. Clustering
#   on case covers both layers of non-independence in this design
#   (the same variant scored by all three models, and multiple
#   variants sharing a case) within a single cluster, so the robust
#   SE is valid without requiring the within-cluster correlation to
#   be exactly specified. Purely confirmatory; does not alter any
#   primary result, table, or figure.
#
#   (An earlier version of this check clustered on variant alone,
#   which covers only the within-variant/across-model pairing and
#   not the broader within-case structure; superseded by this
#   case-clustered version.)
# =============================================================

library(tidyverse)
library(geepack)
library(emmeans)
library(here)

scores <- read_csv(here("scoring", "scores_all_variants.csv"),
                    show_col_types = FALSE)

run_gee_case <- function(outcome, label, only_c4_eligible = FALSE) {
  d <- scores
  if (only_c4_eligible) d <- d |> filter(!gt_relevant)
  d <- d |>
    filter(!is.na(.data[[outcome]])) |>
    mutate(model = factor(model, levels = c("gpt4o", "gemini25", "deepseek_r1")),
           case_num = as.integer(factor(case_id))) |>
    arrange(case_num, model) |>
    as.data.frame()

  f <- as.formula(paste(outcome, "~ model"))
  g <- geeglm(f, id = case_num, data = d, family = binomial,
              corstr = "exchangeable")

  cat("\n============ ", label, " GEE check (cluster = case) ============\n")
  cat("N obs:", nrow(d), " N case clusters:", length(unique(d$case_num)), "\n")
  cat("\n--- Omnibus Wald test ---\n")
  print(anova(g))
  emm <- emmeans(g, ~model, vcov. = vcov(g))
  cat("\n--- Pairwise (Bonferroni) ---\n")
  print(pairs(emm, adjust = "bonferroni"))
  g
}

g_c1 <- run_gee_case("c1_correct", "C1")
g_c2 <- run_gee_case("c2_correct", "C2")

dir.create(here("results", "tables"), recursive = TRUE, showWarnings = FALSE)
sink(here("results", "tables", "c1c2_posthoc_gee_check.txt"))
cat("=== C1/C2 POST-HOC GEE ROBUSTNESS CHECK (non-pre-registered) ===\n")
cat("Primary, pre-registered C1/C2 analysis (mixed-effects logistic regression,\n")
cat("case as random intercept) is in statistical_tests.txt / 03_analysis.R and is\n")
cat("unchanged by this file. This check uses GEE with cluster = CASE\n")
cat("(exchangeable correlation, robust SE), covering both the within-variant\n")
cat("pairing across models and the within-case grouping of variants, to confirm\n")
cat("the primary conclusions are robust.\n\n")
cat("--- C1 ---\n"); print(anova(g_c1))
cat("\n"); print(pairs(emmeans(g_c1, ~model, vcov. = vcov(g_c1)), adjust = "bonferroni"))
cat("\n\n--- C2 ---\n"); print(anova(g_c2))
cat("\n"); print(pairs(emmeans(g_c2, ~model, vcov. = vcov(g_c2)), adjust = "bonferroni"))
sink()

message("\n>>> C1/C2 post-hoc GEE check complete.")
message(">>> Results saved to results/tables/c1c2_posthoc_gee_check.txt")
