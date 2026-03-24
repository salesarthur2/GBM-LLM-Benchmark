# =============================================================
# 03_analysis.R — GBM-LLM-Benchmark
# Statistical analysis — pre-specified per protocol v4
# =============================================================
# Analyses:
#   C1: Mixed-effects logistic regression (variant as unit,
#       case as random effect) + pairwise comparisons
#   C2: Same approach as C1
#   C3: Proportion correct per model + Fisher's exact test
#   C4: Hallucination rate + Chi-square + severity breakdown
#   C5: Confidence-accuracy calibration table
#   Sensitivity: C1 with driver+co-driver collapsed
# =============================================================

library(tidyverse)
library(lme4)
library(emmeans)
library(here)

# =============================================================
# LOAD DATA
# =============================================================

scores  <- read_csv(here("scoring", "scores_all_variants.csv"),
                    show_col_types=FALSE)
c3_data <- read_csv(here("scoring", "c3_human_scoring_template.csv"),
                    show_col_types=FALSE)

message(">>> Data loaded: ", nrow(scores), " variant observations")
message(">>> Models: ", paste(unique(scores$model), collapse=", "))
message(">>> Categories: ", paste(sort(unique(scores$category)), collapse=", "))

# =============================================================
# C1 — VARIANT CLASSIFICATION ACCURACY
# Mixed-effects logistic regression
# =============================================================

cat("\n==============================\n")
cat("C1 — MIXED-EFFECTS LOGISTIC REGRESSION\n")
cat("==============================\n")

scores_c1 <- scores |>
  filter(!is.na(c1_correct)) |>
  mutate(model = factor(model, levels=c("gpt4o","gemini25","deepseek_r1")))

m_c1 <- glmer(c1_correct ~ model + (1|case_id),
              data   = scores_c1,
              family = binomial,
              control= glmerControl(optimizer="bobyqa"))

cat("\nModel summary:\n")
print(summary(m_c1))

cat("\nLikelihood ratio test (model effect):\n")
m_c1_null <- glmer(c1_correct ~ 1 + (1|case_id),
                   data=scores_c1, family=binomial,
                   control=glmerControl(optimizer="bobyqa"))
lrt_c1 <- anova(m_c1_null, m_c1)
print(lrt_c1)

cat("\nPairwise comparisons (Bonferroni):\n")
emm_c1 <- emmeans(m_c1, ~model)
pairs_c1 <- pairs(emm_c1, adjust="bonferroni")
print(pairs_c1)

# Marginal accuracy per model
cat("\nMarginal accuracy per model:\n")
acc_c1 <- scores_c1 |>
  group_by(model) |>
  summarise(n=n(), correct=sum(c1_correct),
            accuracy=round(mean(c1_correct),3),
            .groups="drop")
print(acc_c1)

# =============================================================
# C1 SENSITIVITY — driver + co-driver collapsed
# =============================================================

cat("\n==============================\n")
cat("C1 SENSITIVITY — ONCOGENIC CATEGORY COLLAPSED\n")
cat("==============================\n")

scores_c1s <- scores |>
  filter(!is.na(c1_sens_correct)) |>
  mutate(model = factor(model, levels=c("gpt4o","gemini25","deepseek_r1")))

m_c1s <- glmer(c1_sens_correct ~ model + (1|case_id),
               data=scores_c1s, family=binomial,
               control=glmerControl(optimizer="bobyqa"))

cat("\nPairwise comparisons (sensitivity, Bonferroni):\n")
emm_c1s <- emmeans(m_c1s, ~model)
pairs_c1s <- pairs(emm_c1s, adjust="bonferroni")
print(pairs_c1s)

acc_c1s <- scores_c1s |>
  group_by(model) |>
  summarise(n=n(), correct=sum(c1_sens_correct),
            accuracy=round(mean(c1_sens_correct),3),
            .groups="drop")
print(acc_c1s)

# =============================================================
# C1 BY CATEGORY
# =============================================================

cat("\n==============================\n")
cat("C1 — BY CATEGORY\n")
cat("==============================\n")

acc_c1_cat <- scores_c1 |>
  group_by(model, category) |>
  summarise(n=n(), accuracy=round(mean(c1_correct),3), .groups="drop") |>
  pivot_wider(names_from=model, values_from=accuracy)
print(acc_c1_cat)

# =============================================================
# C2 — THERAPEUTIC RELEVANCE ACCURACY
# =============================================================

cat("\n==============================\n")
cat("C2 — MIXED-EFFECTS LOGISTIC REGRESSION\n")
cat("==============================\n")

scores_c2 <- scores |>
  filter(!is.na(c2_correct)) |>
  mutate(model = factor(model, levels=c("gpt4o","gemini25","deepseek_r1")))

m_c2 <- glmer(c2_correct ~ model + (1|case_id),
              data=scores_c2, family=binomial,
              control=glmerControl(optimizer="bobyqa"))

cat("\nLikelihood ratio test:\n")
m_c2_null <- glmer(c2_correct ~ 1 + (1|case_id),
                   data=scores_c2, family=binomial,
                   control=glmerControl(optimizer="bobyqa"))
lrt_c2 <- anova(m_c2_null, m_c2)
print(lrt_c2)

cat("\nPairwise comparisons (Bonferroni):\n")
emm_c2 <- emmeans(m_c2, ~model)
pairs_c2 <- pairs(emm_c2, adjust="bonferroni")
print(pairs_c2)

acc_c2 <- scores_c2 |>
  group_by(model) |>
  summarise(n=n(), correct=sum(c2_correct),
            accuracy=round(mean(c2_correct),3),
            .groups="drop")
print(acc_c2)

# =============================================================
# C3 — TREATMENT ACCURACY
# =============================================================

cat("\n==============================\n")
cat("C3 — TREATMENT ACCURACY\n")
cat("==============================\n")

c3_summary <- c3_data |>
  group_by(model) |>
  summarise(n_items  = n(),
            n_correct= sum(c3_score==2, na.rm=TRUE),
            pct      = round(mean(c3_score==2, na.rm=TRUE)*100, 1),
            .groups  = "drop")
print(c3_summary)

# Fisher's exact test
c3_matrix <- c3_data |>
  mutate(correct = c3_score==2) |>
  group_by(model) |>
  summarise(correct=sum(correct), incorrect=sum(!correct), .groups="drop")

cat("\nFisher's exact test:\n")
fisher_c3 <- fisher.test(as.matrix(c3_matrix[,c("correct","incorrect")]))
print(fisher_c3)

# =============================================================
# C4 — HALLUCINATION RATE
# =============================================================

cat("\n==============================\n")
cat("C4 — HALLUCINATION RATE\n")
cat("==============================\n")

scores_c4 <- scores |>
  filter(!gt_relevant) |>
  mutate(model = factor(model, levels=c("gpt4o","gemini25","deepseek_r1")))

c4_summary <- scores_c4 |>
  group_by(model) |>
  summarise(
    n_variants       = n(),
    n_hallucinations = sum(c4_hallucination, na.rm=TRUE),
    rate             = round(mean(c4_hallucination, na.rm=TRUE), 4),
    pct              = round(mean(c4_hallucination, na.rm=TRUE)*100, 2),
    n_high_conf      = sum(c4_hallucination &
                            c4_hallucination_confidence=="high", na.rm=TRUE),
    n_mod_conf       = sum(c4_hallucination &
                            c4_hallucination_confidence=="moderate", na.rm=TRUE),
    n_low_conf       = sum(c4_hallucination &
                            c4_hallucination_confidence=="low", na.rm=TRUE),
    .groups = "drop"
  )
print(c4_summary)

cat("\nChi-square test (hallucination rate between models):\n")
c4_matrix <- scores_c4 |>
  group_by(model) |>
  summarise(hallucinated = sum(c4_hallucination, na.rm=TRUE),
            not_hallucinated = sum(!c4_hallucination, na.rm=TRUE),
            .groups="drop")
chisq_c4 <- chisq.test(as.matrix(c4_matrix[,c("hallucinated","not_hallucinated")]))
print(chisq_c4)

cat("\nPairwise Fisher's exact tests (Bonferroni):\n")
models_list <- unique(as.character(scores_c4$model))
for (i in 1:(length(models_list)-1)) {
  for (j in (i+1):length(models_list)) {
    m1 <- models_list[i]; m2 <- models_list[j]
    sub <- c4_matrix |> filter(model %in% c(m1,m2))
    ft  <- fisher.test(as.matrix(sub[,c("hallucinated","not_hallucinated")]))
    cat(sprintf("  %s vs %s: OR=%.2f, p=%.4f (Bonf. p=%.4f)\n",
                m1, m2, ft$estimate, ft$p.value, min(ft$p.value*3, 1)))
  }
}

# Hallucination by category
cat("\nHallucination rate by category:\n")
c4_by_cat <- scores_c4 |>
  group_by(model, category) |>
  summarise(rate=round(mean(c4_hallucination, na.rm=TRUE), 3),
            .groups="drop") |>
  pivot_wider(names_from=model, values_from=rate)
print(c4_by_cat)

# =============================================================
# C5 — CONFIDENCE CALIBRATION
# =============================================================

cat("\n==============================\n")
cat("C5 — CONFIDENCE-ACCURACY CALIBRATION\n")
cat("==============================\n")

cat("\nC1 calibration (classification confidence vs accuracy):\n")
c5_c1 <- scores |>
  filter(!is.na(class_confidence)) |>
  group_by(model, confidence=class_confidence) |>
  summarise(n=n(),
            accuracy=round(mean(c1_correct, na.rm=TRUE), 3),
            .groups="drop") |>
  mutate(confidence=factor(confidence, levels=c("high","moderate","low"))) |>
  arrange(model, confidence)
print(c5_c1)

cat("\nC2 calibration (therapeutic confidence vs accuracy):\n")
c5_c2 <- scores |>
  filter(!is.na(ther_confidence)) |>
  group_by(model, confidence=ther_confidence) |>
  summarise(n=n(),
            accuracy=round(mean(c2_correct, na.rm=TRUE), 3),
            .groups="drop") |>
  mutate(confidence=factor(confidence, levels=c("high","moderate","low"))) |>
  arrange(model, confidence)
print(c5_c2)

cat("\nHigh-confidence hallucinations (most clinically dangerous):\n")
high_conf_halluc <- scores |>
  filter(c4_hallucination & c4_hallucination_confidence=="high") |>
  select(model, case_id, category, gene) |>
  group_by(model) |>
  summarise(n=n(), genes=paste(unique(gene), collapse=", "), .groups="drop")
print(high_conf_halluc)

# =============================================================
# SAVE ALL RESULTS
# =============================================================

dir.create(here("results","tables"), recursive=TRUE, showWarnings=FALSE)

write_csv(acc_c1,     here("results","tables","c1_accuracy.csv"))
write_csv(acc_c1s,    here("results","tables","c1_sensitivity.csv"))
write_csv(acc_c1_cat, here("results","tables","c1_by_category.csv"))
write_csv(acc_c2,     here("results","tables","c2_accuracy.csv"))
write_csv(c3_summary, here("results","tables","c3_summary.csv"))
write_csv(c4_summary, here("results","tables","c4_hallucination.csv"))
write_csv(c4_by_cat,  here("results","tables","c4_by_category.csv"))
write_csv(c5_c1,      here("results","tables","c5_calibration_c1.csv"))
write_csv(c5_c2,      here("results","tables","c5_calibration_c2.csv"))

# Save statistical test results
sink(here("results","tables","statistical_tests.txt"))
cat("=== C1 LIKELIHOOD RATIO TEST ===\n"); print(lrt_c1)
cat("\n=== C1 PAIRWISE COMPARISONS ===\n"); print(pairs_c1)
cat("\n=== C1 SENSITIVITY PAIRWISE ===\n"); print(pairs_c1s)
cat("\n=== C2 LIKELIHOOD RATIO TEST ===\n"); print(lrt_c2)
cat("\n=== C2 PAIRWISE COMPARISONS ===\n"); print(pairs_c2)
cat("\n=== C3 FISHER'S EXACT TEST ===\n"); print(fisher_c3)
cat("\n=== C4 CHI-SQUARE TEST ===\n"); print(chisq_c4)
sink()

message("\n>>> Analysis complete.")
message(">>> All tables saved to results/tables/")
