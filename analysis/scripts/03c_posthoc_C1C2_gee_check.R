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
#   As with C4 (see 03b_posthoc_C4_sensitivity.R), the same
#   variants are also evaluated by all three models, a pairing the
#   case-level random intercept does not directly represent. This
#   script checks whether the C1/C2 conclusions are robust to that
#   alternative clustering structure, using the same GEE approach
#   (cluster = variant, exchangeable correlation, robust SE) used
#   for the C4 check. Purely confirmatory; not used to alter any
#   primary result, table or figure.
# =============================================================

library(tidyverse)
library(geepack)
library(emmeans)
library(here)

scores <- read_csv(here("scoring", "scores_all_variants.csv"),
                    show_col_types = FALSE) |>
  mutate(variant_id = paste(case_id, gene, hgvsp, sep = "|"))

run_gee_check <- function(outcome, label) {
  d <- scores |>
    filter(!is.na(.data[[outcome]])) |>
    mutate(model = factor(model, levels = c("gpt4o", "gemini25", "deepseek_r1")),
           variant_num = as.integer(factor(variant_id))) |>
    arrange(variant_num, model) |>
    as.data.frame()

  f <- as.formula(paste(outcome, "~ model"))
  g <- geeglm(f, id = variant_num, data = d, family = binomial,
              corstr = "exchangeable")

  cat("\n============ ", label, " GEE check (cluster = variant) ============\n")
  cat("N obs:", nrow(d), " N clusters:", length(unique(d$variant_num)), "\n")
  cat("\n--- Omnibus Wald test ---\n")
  print(anova(g))
  emm <- emmeans(g, ~model, vcov. = vcov(g))
  cat("\n--- Pairwise (Bonferroni) ---\n")
  print(pairs(emm, adjust = "bonferroni"))
  g
}

g_c1 <- run_gee_check("c1_correct", "C1")
g_c2 <- run_gee_check("c2_correct", "C2")

dir.create(here("results", "tables"), recursive = TRUE, showWarnings = FALSE)
sink(here("results", "tables", "c1c2_posthoc_gee_check.txt"))
cat("=== C1/C2 POST-HOC GEE ROBUSTNESS CHECK (non-pre-registered) ===\n")
cat("Primary, pre-registered C1/C2 analysis (mixed-effects logistic regression,\n")
cat("case as random intercept) is in statistical_tests.txt / 03_analysis.R and is\n")
cat("unchanged by this file. This check uses GEE with cluster = variant\n")
cat("(exchangeable correlation, robust SE) to confirm the primary conclusions are\n")
cat("robust to the within-variant pairing across models.\n\n")
cat("--- C1 ---\n"); print(anova(g_c1))
cat("\n"); print(pairs(emmeans(g_c1, ~model, vcov. = vcov(g_c1)), adjust = "bonferroni"))
cat("\n\n--- C2 ---\n"); print(anova(g_c2))
cat("\n"); print(pairs(emmeans(g_c2, ~model, vcov. = vcov(g_c2)), adjust = "bonferroni"))
sink()

message("\n>>> C1/C2 post-hoc GEE check complete.")
message(">>> Results saved to results/tables/c1c2_posthoc_gee_check.txt")
