# =============================================================
# 02_scoring_validation.R — GBM-LLM-Benchmark
# Scoring for TCGA external validation (25 cases x 3 models)
# Same parser and criteria as 02_scoring_auto.R
# =============================================================

library(jsonlite)
library(tidyverse)
library(here)

# =============================================================
# HELPERS (same as 02_scoring_auto.R)
# =============================================================

load_ground_truth <- function(case_file) {
  case_data <- fromJSON(case_file, simplifyVector=FALSE)
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

detect_gene_header <- function(line) {
  if (grepl("^Classification:", line, ignore.case=TRUE)) return(NA)
  if (grepl("^Therapeutic",     line, ignore.case=TRUE)) return(NA)
  if (grepl("^If Yes",          line, ignore.case=TRUE)) return(NA)
  if (grepl("^Confidence:",     line, ignore.case=TRUE)) return(NA)
  if (grepl("\u2014", line)) return(NA)
  if (grepl(" — ", line))    return(NA)
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
      gene_symbol  <- trimws(gsub("\\s+.*$", "", gene_candidate))
      current_gene <- gene_symbol
      if (!current_gene %in% names(results)) {
        results[[current_gene]] <- list(
          gene=current_gene, classification=NA_character_,
          class_confidence=NA_character_, therapeutic=NA_character_,
          ther_confidence=NA_character_, treatment=NA_character_,
          treat_confidence=NA_character_)
      }
      next
    }
    if (is.null(current_gene)) next
    if (grepl("^Classification:", line, ignore.case=TRUE)) {
      m <- regmatches(line, regexpr("\\b(driver|co-driver|VUS|passenger)\\b",
                                    line, ignore.case=TRUE))
      if (length(m) > 0) results[[current_gene]]$classification <- tolower(m)
      m <- regmatches(line, regexpr("Confidence:\\s*(high|moderate|low)",
                                    line, ignore.case=TRUE))
      if (length(m) > 0)
        results[[current_gene]]$class_confidence <- tolower(
          trimws(sub("Confidence:\\s*", "", m, ignore.case=TRUE)))
      next
    }
    if (grepl("^Therapeutic", line, ignore.case=TRUE)) {
      m <- regmatches(line, regexpr("\\b(Yes|No)\\b", line, ignore.case=TRUE))
      if (length(m) > 0) results[[current_gene]]$therapeutic <- tolower(m)
      m <- regmatches(line, regexpr("Confidence:\\s*(high|moderate|low)",
                                    line, ignore.case=TRUE))
      if (length(m) > 0)
        results[[current_gene]]$ther_confidence <- tolower(
          trimws(sub("Confidence:\\s*", "", m, ignore.case=TRUE)))
      next
    }
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
      m <- regmatches(line, regexpr("Confidence:\\s*(high|moderate|low)",
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
# MAIN SCORING LOOP
# =============================================================

models     <- c("gpt4o", "gemini25", "deepseek_r1")
case_files <- list.files(here("validation_external","cases"),
                         pattern="\\.json$", full.names=TRUE)

all_scores     <- list()
parse_failures <- c()

message(">>> Scoring TCGA validation — ", length(case_files),
        " cases x ", length(models), " models\n")

for (case_file in case_files) {
  case_id  <- tools::file_path_sans_ext(basename(case_file))
  gt       <- load_ground_truth(case_file)

  for (model in models) {
    out_file <- here("validation_external","outputs", model,
                     paste0(case_id, ".json"))
    if (!file.exists(out_file)) {
      message("  [missing] ", model, " / ", case_id); next
    }
    content <- fromJSON(out_file)$content
    parsed  <- tryCatch(
      parse_model_output(content, case_id, model),
      error=function(e) { message("  [parse error] ", model, "/", case_id); NULL }
    )
    if (is.null(parsed) || nrow(parsed) == 0) {
      parse_failures <- c(parse_failures, paste0(model, "/", case_id)); next
    }
    scored <- gt |>
      left_join(parsed |> select(gene, classification, class_confidence,
                                  therapeutic, ther_confidence,
                                  treatment, treat_confidence), by="gene") |>
      mutate(
        case_id  = case_id,
        model    = model,
        category = "TCGA_VAL",
        c1_correct = !is.na(classification) &
                     tolower(classification) == tolower(gt_class),
        c1_oncogenic_gt    = gt_class %in% c("driver","co-driver"),
        c1_oncogenic_model = tolower(classification) %in% c("driver","co-driver"),
        c1_sens_correct    = !is.na(classification) &
                             (c1_oncogenic_gt == c1_oncogenic_model),
        model_therapeutic  = !is.na(therapeutic) & tolower(therapeutic) == "yes",
        c2_correct         = !is.na(therapeutic) &
                             (model_therapeutic == gt_relevant),
        c4_hallucination   = model_therapeutic & !gt_relevant,
        c4_hallucination_confidence = ifelse(c4_hallucination,
                                             ther_confidence, NA_character_)
      )
    all_scores[[paste0(model, "_", case_id)]] <- scored
  }
}

scores_val <- bind_rows(all_scores)
message(">>> Total observations: ", nrow(scores_val))
message(">>> Models: ", paste(unique(scores_val$model), collapse=", "))

# =============================================================
# SUMMARIES
# =============================================================

c1_val <- scores_val |>
  group_by(model) |>
  summarise(n=n(), correct=sum(c1_correct, na.rm=TRUE),
            accuracy=round(mean(c1_correct, na.rm=TRUE), 3),
            sens_accuracy=round(mean(c1_sens_correct, na.rm=TRUE), 3),
            .groups="drop")

c2_val <- scores_val |>
  group_by(model) |>
  summarise(n=n(), correct=sum(c2_correct, na.rm=TRUE),
            accuracy=round(mean(c2_correct, na.rm=TRUE), 3),
            .groups="drop")

c4_val <- scores_val |>
  filter(!gt_relevant) |>
  group_by(model) |>
  summarise(n_eligible=n(),
            n_hallucinations=sum(c4_hallucination, na.rm=TRUE),
            rate=round(mean(c4_hallucination, na.rm=TRUE), 3),
            n_high=sum(c4_hallucination &
                        c4_hallucination_confidence=="high", na.rm=TRUE),
            .groups="drop")

c4_cases_val <- scores_val |>
  filter(c4_hallucination) |>
  select(model, case_id, gene, ther_confidence) |>
  distinct()

cat("\n==============================\n")
cat("TCGA VALIDATION — C1\n")
cat("==============================\n")
print(c1_val)

cat("\n==============================\n")
cat("TCGA VALIDATION — C2\n")
cat("==============================\n")
print(c2_val)

cat("\n==============================\n")
cat("TCGA VALIDATION — C4 HALLUCINATION\n")
cat("==============================\n")
print(c4_val)

cat("\n==============================\n")
cat("C4 HALLUCINATION CASES\n")
cat("==============================\n")
print(c4_cases_val)

# =============================================================
# SAVE
# =============================================================

dir.create(here("validation_external","results"), showWarnings=FALSE)

write_csv(scores_val, here("validation_external","results","scores_validation.csv"))
write_csv(c1_val,     here("validation_external","results","c1_validation.csv"))
write_csv(c2_val,     here("validation_external","results","c2_validation.csv"))
write_csv(c4_val,     here("validation_external","results","c4_validation.csv"))
write_csv(c4_cases_val, here("validation_external","results","c4_cases_validation.csv"))

if (length(parse_failures) > 0) {
  message("\n>>> Parse failures: ", paste(parse_failures, collapse=", "))
}

message("\n>>> Validation scoring complete.")
message(">>> Results saved to validation_external/results/")
