# =============================================================
# 02_scoring_auto.R — GBM-LLM-Benchmark
# Automatic scoring — C1, C2, C4, C5
# Version: 4.0 — gene name extraction fixed
# =============================================================

library(jsonlite)
library(tidyverse)
library(here)

# =============================================================
# HELPER: Load ground truth
# =============================================================

load_ground_truth <- function(case_file) {
  case_data <- fromJSON(case_file)
  gt_class  <- case_data$ground_truth$classifications
  gt_ther   <- case_data$ground_truth$therapeutic_relevance

  rows <- lapply(names(gt_class), function(gene) {
    treatment_val <- gt_ther[[gene]]$treatment
    if (is.null(treatment_val) || length(treatment_val) == 0 ||
        is.list(treatment_val)) treatment_val <- NA_character_
    relevant_val <- gt_ther[[gene]]$relevant
    if (is.null(relevant_val) || length(relevant_val) == 0)
      relevant_val <- FALSE
    data.frame(
      gene         = gene,
      gt_class     = gt_class[[gene]]$class,
      gt_relevant  = as.logical(relevant_val),
      gt_treatment = as.character(treatment_val),
      is_trap      = as.logical(gt_class[[gene]]$is_trap),
      stringsAsFactors = FALSE
    )
  })
  bind_rows(rows)
}

# =============================================================
# HELPER: Detect gene header line
# =============================================================

detect_gene_header <- function(line) {
  if (grepl("^Classification:", line, ignore.case=TRUE)) return(NA)
  if (grepl("^Therapeutic",     line, ignore.case=TRUE)) return(NA)
  if (grepl("^If Yes",          line, ignore.case=TRUE)) return(NA)
  if (grepl("^Confidence:",     line, ignore.case=TRUE)) return(NA)
  if (grepl("\u2014", line)) return(NA)
  if (grepl(" — ", line))    return(NA)

  # Format: "GENE HGVSp: GENE_NAME variant"
  if (grepl("^GENE HGVSp:", line, ignore.case=TRUE)) {
    gene_name <- trimws(sub("^GENE HGVSp:\\s*", "", line, ignore.case=TRUE))
    gene_name <- trimws(gsub(":$", "", gene_name))
    if (nchar(gene_name) > 0) return(gene_name)
  }

  clean <- trimws(gsub(":$", "", line))
  if (nchar(clean) == 0 || nchar(clean) > 80) return(NA)
  if (!grepl("^[A-Z]", clean)) return(NA)
  return(clean)
}

# =============================================================
# HELPER: Parse model output
# =============================================================

parse_model_output <- function(content, case_id, model) {
  if (is.null(content) || length(content) == 0 ||
      is.na(content) || nchar(trimws(content)) < 10) return(NULL)

  lines <- strsplit(content, "\n")[[1]]
  lines <- trimws(lines)
  lines <- lines[nchar(lines) > 0]

  results      <- list()
  current_gene <- NULL

  for (line in lines) {
    gene_candidate <- detect_gene_header(line)
    if (!is.na(gene_candidate)) {
      # Extract only the gene symbol (first word before space)
      gene_symbol <- trimws(gsub("\\s+.*$", "", gene_candidate))
      # Handle fusion genes like FGFR3-TACC3
      if (grepl("^[A-Z0-9]+-[A-Z0-9]+$", gene_symbol)) {
        current_gene <- gene_symbol
      } else {
        current_gene <- gene_symbol
      }
      if (!current_gene %in% names(results)) {
        results[[current_gene]] <- list(
          gene             = current_gene,
          classification   = NA_character_,
          class_confidence = NA_character_,
          therapeutic      = NA_character_,
          ther_confidence  = NA_character_,
          treatment        = NA_character_,
          treat_confidence = NA_character_
        )
      }
      next
    }

    if (is.null(current_gene)) next

    # Classification
    if (grepl("^Classification:", line, ignore.case=TRUE)) {
      m <- regmatches(line,
            regexpr("\\b(driver|co-driver|VUS|passenger)\\b",
                    line, ignore.case=TRUE))
      if (length(m) > 0)
        results[[current_gene]]$classification <- tolower(m)

      m <- regmatches(line,
            regexpr("Confidence:\\s*(high|moderate|low)",
                    line, ignore.case=TRUE))
      if (length(m) > 0)
        results[[current_gene]]$class_confidence <- tolower(
          trimws(sub("Confidence:\\s*", "", m, ignore.case=TRUE)))
      next
    }

    # Therapeutic relevance
    if (grepl("^Therapeutic", line, ignore.case=TRUE)) {
      m <- regmatches(line, regexpr("\\b(Yes|No)\\b", line, ignore.case=TRUE))
      if (length(m) > 0)
        results[[current_gene]]$therapeutic <- tolower(m)

      m <- regmatches(line,
            regexpr("Confidence:\\s*(high|moderate|low)",
                    line, ignore.case=TRUE))
      if (length(m) > 0)
        results[[current_gene]]$ther_confidence <- tolower(
          trimws(sub("Confidence:\\s*", "", m, ignore.case=TRUE)))
      next
    }

    # Treatment
    if (grepl("If Yes", line, ignore.case=TRUE) &&
        grepl("Treatment:", line, ignore.case=TRUE)) {
      m <- regexpr("Treatment:\\s*(.+?)\\s*(\u2014|Confidence:|$)",
                   line, perl=TRUE)
      if (m > 0) {
        tx <- regmatches(line, m)
        tx <- sub("Treatment:\\s*", "", tx, ignore.case=TRUE)
        tx <- sub("\\s*(\u2014|Confidence:).*$", "", tx)
        tx <- trimws(tx)
        if (nchar(tx) > 0) results[[current_gene]]$treatment <- tx
      }

      m <- regmatches(line,
            regexpr("Confidence:\\s*(high|moderate|low)",
                    line, ignore.case=TRUE))
      if (length(m) > 0)
        results[[current_gene]]$treat_confidence <- tolower(
          trimws(sub("Confidence:\\s*", "", m, ignore.case=TRUE)))
      next
    }
  }

  if (length(results) == 0) return(NULL)

  df         <- bind_rows(lapply(results, as.data.frame, stringsAsFactors=FALSE))
  df$case_id <- case_id
  df$model   <- model
  return(df)
}

# =============================================================
# MAIN LOOP
# =============================================================

models     <- c("gpt4o", "gemini25", "deepseek_r1")
case_files <- list.files(here("cases"), pattern="\\.json$",
                         recursive=TRUE, full.names=TRUE)

all_scores     <- list()
parse_failures <- c()

message(">>> Starting automatic scoring — ", length(case_files),
        " cases x ", length(models), " models\n")

for (case_file in case_files) {

  case_id  <- tools::file_path_sans_ext(basename(case_file))
  category <- fromJSON(case_file)$category
  gt       <- load_ground_truth(case_file)

  for (model in models) {

    out_file <- here("outputs", model, paste0(case_id, ".json"))
    if (!file.exists(out_file)) {
      message("  [missing] ", model, " / ", case_id)
      next
    }

    output  <- fromJSON(out_file)
    content <- output$content

    parsed <- tryCatch(
      parse_model_output(content, case_id, model),
      error = function(e) {
        message("  [parse error] ", model, "/", case_id, ": ", e$message)
        NULL
      }
    )

    if (is.null(parsed) || nrow(parsed) == 0) {
      parse_failures <- c(parse_failures, paste0(model, "/", case_id))
      next
    }

    scored <- gt |>
      left_join(
        parsed |> select(gene, classification, class_confidence,
                         therapeutic, ther_confidence,
                         treatment, treat_confidence),
        by = "gene"
      ) |>
      mutate(
        case_id  = case_id,
        model    = model,
        category = category,

        c1_correct = !is.na(classification) &
                     tolower(classification) == tolower(gt_class),

        c1_oncogenic_gt    = gt_class %in% c("driver","co-driver"),
        c1_oncogenic_model = tolower(classification) %in% c("driver","co-driver"),
        c1_sens_correct    = !is.na(classification) &
                             (c1_oncogenic_gt == c1_oncogenic_model),

        model_therapeutic = !is.na(therapeutic) &
                            tolower(therapeutic) == "yes",
        c2_correct = !is.na(therapeutic) &
                     (model_therapeutic == gt_relevant),

        c4_hallucination = model_therapeutic & !gt_relevant,
        c4_hallucination_confidence = ifelse(
          c4_hallucination, ther_confidence, NA_character_)
      )

    all_scores[[paste0(model, "_", case_id)]] <- scored
  }
}

# =============================================================
# COMBINE
# =============================================================

scores_df <- bind_rows(all_scores)
message("\n>>> Total observations: ", nrow(scores_df))
message(">>> Models: ", paste(unique(scores_df$model), collapse=", "))

# =============================================================
# SUMMARIES
# =============================================================

c1_summary <- scores_df |>
  group_by(model) |>
  summarise(
    n_variants       = n(),
    c1_correct       = sum(c1_correct, na.rm=TRUE),
    c1_accuracy      = round(mean(c1_correct, na.rm=TRUE), 3),
    c1_sens_accuracy = round(mean(c1_sens_correct, na.rm=TRUE), 3),
    .groups = "drop"
  )

c1_by_cat <- scores_df |>
  group_by(model, category) |>
  summarise(
    n           = n(),
    c1_accuracy = round(mean(c1_correct, na.rm=TRUE), 3),
    .groups = "drop"
  )

c2_summary <- scores_df |>
  group_by(model) |>
  summarise(
    n_variants  = n(),
    c2_correct  = sum(c2_correct, na.rm=TRUE),
    c2_accuracy = round(mean(c2_correct, na.rm=TRUE), 3),
    .groups = "drop"
  )

c4_summary <- scores_df |>
  filter(!gt_relevant) |>
  group_by(model) |>
  summarise(
    n_no_variants      = n(),
    n_hallucinations   = sum(c4_hallucination, na.rm=TRUE),
    hallucination_rate = round(mean(c4_hallucination, na.rm=TRUE), 3),
    n_high_conf        = sum(c4_hallucination &
                              c4_hallucination_confidence=="high", na.rm=TRUE),
    n_mod_conf         = sum(c4_hallucination &
                              c4_hallucination_confidence=="moderate", na.rm=TRUE),
    n_low_conf         = sum(c4_hallucination &
                              c4_hallucination_confidence=="low", na.rm=TRUE),
    .groups = "drop"
  )

c4_cases <- scores_df |>
  filter(c4_hallucination) |>
  select(model, case_id, category, gene, ther_confidence) |>
  distinct()

c5_class <- scores_df |>
  filter(!is.na(class_confidence)) |>
  group_by(model, confidence=class_confidence) |>
  summarise(n=n(),
            c1_accuracy=round(mean(c1_correct, na.rm=TRUE), 3),
            .groups="drop") |>
  mutate(criterion="C1")

c5_ther <- scores_df |>
  filter(!is.na(ther_confidence)) |>
  group_by(model, confidence=ther_confidence) |>
  summarise(n=n(),
            c2_accuracy=round(mean(c2_correct, na.rm=TRUE), 3),
            .groups="drop") |>
  mutate(criterion="C2")

# =============================================================
# PRINT
# =============================================================

cat("\n==============================\n")
cat("C1 — VARIANT CLASSIFICATION ACCURACY\n")
cat("==============================\n")
print(c1_summary)

cat("\n==============================\n")
cat("C1 — BY CATEGORY\n")
cat("==============================\n")
print(c1_by_cat |> pivot_wider(names_from=model, values_from=c1_accuracy))

cat("\n==============================\n")
cat("C2 — THERAPEUTIC RELEVANCE ACCURACY\n")
cat("==============================\n")
print(c2_summary)

cat("\n==============================\n")
cat("C4 — HALLUCINATION RATE\n")
cat("==============================\n")
print(c4_summary)

cat("\n==============================\n")
cat("C4 — HALLUCINATION CASES\n")
cat("==============================\n")
print(c4_cases)

cat("\n==============================\n")
cat("C5 — CONFIDENCE CALIBRATION (C1)\n")
cat("==============================\n")
print(c5_class)

cat("\n==============================\n")
cat("C5 — CONFIDENCE CALIBRATION (C2)\n")
cat("==============================\n")
print(c5_ther)

# =============================================================
# SAVE
# =============================================================

dir.create(here("scoring"), showWarnings=FALSE)
dir.create(here("results","tables"), recursive=TRUE, showWarnings=FALSE)

write_csv(scores_df,  here("scoring","scores_all_variants.csv"))
write_csv(c1_summary, here("results","tables","c1_summary.csv"))
write_csv(c1_by_cat,  here("results","tables","c1_by_category.csv"))
write_csv(c2_summary, here("results","tables","c2_summary.csv"))
write_csv(c4_summary, here("results","tables","c4_hallucination_summary.csv"))
write_csv(c4_cases,   here("results","tables","c4_hallucination_cases.csv"))
write_csv(c5_class,   here("results","tables","c5_calibration_c1.csv"))
write_csv(c5_ther,    here("results","tables","c5_calibration_c2.csv"))

c3_template <- scores_df |>
  filter(gt_relevant & c2_correct & model_therapeutic) |>
  select(model, case_id, category, gene, gt_treatment, treatment) |>
  mutate(c3_score=NA_real_, rater1_score=NA_real_, rater2_score=NA_real_,
         notes=NA_character_)

write_csv(c3_template, here("scoring","c3_human_scoring_template.csv"))

if (length(parse_failures) > 0) {
  message("\n>>> Parse failures (", length(parse_failures), "):")
  for (f in parse_failures) message("    ", f)
}

message("\n>>> Scoring complete.")
message(">>> ", nrow(scores_df), " variant-level observations")
message(">>> C3 template: ", nrow(c3_template), " items for human evaluation")
