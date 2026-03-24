# =============================================================
# 03_analysis.R
# Statistical analysis and figure generation
# =============================================================

library(tidyverse)
library(ggplot2)
library(irr)    # Cohen kappa
library(here)

# --- Load consolidated scores ------------------------------------------------
df <- read_csv(here("scoring", "final_scores.csv"))

# --- Inter-rater agreement (C2, C3, C5) --------------------------------------
# kappa2(cbind(rater1_C2, rater2_C2))  # repeat for C3 and C5

# --- Model comparison --------------------------------------------------------

# Global Kruskal-Wallis
kruskal.test(total_score ~ model, data = df)

# Post-hoc Dunn with Bonferroni correction
# dunn.test::dunn.test(df$total_score, df$model, method = "bonferroni")

# --- Figures (ggplot2) -------------------------------------------------------

model_colors <- c(
  "gpt4o"       = "#185FA5",
  "gemini25"    = "#1D9E75",
  "deepseek_r1" = "#D85A30"
)

model_labels <- c(
  "gpt4o"       = "GPT-4o",
  "gemini25"    = "Gemini 2.5 Pro",
  "deepseek_r1" = "DeepSeek R1"
)

# Figure 1 — Total score by model (boxplot)
ggplot(df, aes(x = model, y = total_score, fill = model)) +
  geom_boxplot(alpha = 0.7, outlier.shape = NA) +
  geom_jitter(width = 0.1, alpha = 0.4, size = 1.5) +
  scale_fill_manual(values = model_colors) +
  scale_x_discrete(labels = model_labels) +
  labs(x = NULL, y = "Total score (0-30)") +
  theme_minimal(base_size = 13) +
  theme(legend.position = "none")

ggsave(here("analysis", "figures", "fig1_total_score_boxplot.pdf"),
       width = 7, height = 5)

# Figure 2 — Score heatmap by criterion and model
# Figure 3 — Hallucination rate per model (bar chart)
# Figure 4 — Score by case category (CAT-1 to CAT-5)
# Figure 5 — Spearman correlation: synthetic vs. external validation

message(">>> Analysis complete.")

