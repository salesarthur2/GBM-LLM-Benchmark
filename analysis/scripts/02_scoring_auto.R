# =============================================================
# 02_scoring_auto.R
# Automatic scoring: C1 (variant identification) and C4 (hallucination)
# =============================================================

library(jsonlite)
library(tidyverse)
library(here)

# Load ground truth files
gt_files <- list.files(here("ground_truth"),
                       pattern = "\.json$",
                       full.names = TRUE)

results <- list()

for (gt_file in gt_files) {

  case_id <- tools::file_path_sans_ext(basename(gt_file))
  gt      <- fromJSON(gt_file)

  for (model in c("gpt4o", "gemini25", "deepseek_r1")) {

    out_file <- here("outputs", model, paste0(case_id, ".json"))
    if (!file.exists(out_file)) next

    output <- fromJSON(out_file)

    # --- C1: Variant identification and classification ---
    # Parse model output and compare against ground truth classifications
    # Metrics: precision, recall, F1 per case
    # NOTE: implement parser after reviewing pilot output structure

    # --- C4: Hallucination check ---
    # Verify model did not invent variants absent from the profile
    # Binary flag: 0 (hallucination detected) or 6 (no hallucination)
    # Also check: fabricated references, non-existent drugs, wrong mechanisms

    results[[paste(case_id, model, sep = "_")]] <- list(
      case_id = case_id,
      model   = model,
      C1      = NA,  # fill after implementing parser
      C4      = NA   # fill after implementing hallucination check
    )
  }
}

# Consolidate into dataframe
df_auto <- bind_rows(results)
write_csv(df_auto, here("scoring", "auto_scores.csv"))

message(">>> Automatic scores saved to scoring/auto_scores.csv")

