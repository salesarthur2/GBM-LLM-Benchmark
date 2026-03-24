# =============================================================
# 01_run_benchmark.R — GBM-LLM-Benchmark
# Calls APIs for the 3 models across all benchmark cases
# Version: 3.0 — aligned with prompt_template.R v3
# =============================================================
# HOW TO RUN:
#   1. Open GBM-LLM-Benchmark.Rproj in RStudio
#   2. Confirm API keys are loaded: Sys.getenv("OPENAI_API_KEY")
#   3. For pilot run: set RUN_PILOT <- TRUE (runs CAT-1 only)
#   4. For full run: set RUN_PILOT <- FALSE
# =============================================================

library(httr2)
library(jsonlite)
library(tidyverse)
library(here)

# =============================================================
# CONFIGURATION
# =============================================================

# Set TRUE for pilot (10 cases), FALSE for full benchmark (100 cases)
RUN_PILOT <- TRUE

# Load API keys from .Renviron
openai_key   <- Sys.getenv("OPENAI_API_KEY")
gemini_key   <- Sys.getenv("GEMINI_API_KEY")
deepseek_key <- Sys.getenv("DEEPSEEK_API_KEY")

# Verify keys are loaded
stopifnot(
  "OPENAI_API_KEY not found in .Renviron"   = nchar(openai_key)   > 10,
  "GEMINI_API_KEY not found in .Renviron"   = nchar(gemini_key)   > 10,
  "DEEPSEEK_API_KEY not found in .Renviron" = nchar(deepseek_key) > 10
)
message(">>> API keys verified.")

# Load fixed prompt template
source(here("prompts", "prompt_template.R"))

# =============================================================
# LOAD CASES
# =============================================================

if (RUN_PILOT) {
  # Pilot: CAT-1 only
  case_files <- list.files(here("cases", "cat1_classic"),
                           pattern = "\\.json$",
                           full.names = TRUE)
  message(">>> PILOT MODE — CAT-1 cases: ", length(case_files))
} else {
  # Full benchmark: all categories
  case_files <- list.files(here("cases"),
                           pattern = "\\.json$",
                           recursive = TRUE,
                           full.names = TRUE)
  message(">>> FULL MODE — Total cases: ", length(case_files))
}

# =============================================================
# API CALL FUNCTIONS
# =============================================================

call_gpt4o <- function(prompt_text) {
  response <- request("https://api.openai.com/v1/chat/completions") |>
    req_headers(
      "Authorization" = paste("Bearer", openai_key),
      "Content-Type"  = "application/json"
    ) |>
    req_body_json(list(
      model       = "gpt-4o",
      temperature = TEMPERATURE,
      max_tokens  = MAX_TOKENS,
      messages    = list(list(role = "user", content = prompt_text))
    )) |>
    req_perform()

  list(
    content   = resp_body_json(response)$choices[[1]]$message$content,
    reasoning = NULL
  )
}

call_gemini <- function(prompt_text) {
  url <- paste0(
    "https://generativelanguage.googleapis.com/v1beta/models/",
    "gemini-2.5-pro:generateContent?key=", gemini_key
  )

  response <- request(url) |>
    req_headers("Content-Type" = "application/json") |>
    req_body_json(list(
      contents = list(list(
        parts = list(list(text = prompt_text))
      )),
      generationConfig = list(
        temperature     = TEMPERATURE,
        maxOutputTokens = MAX_TOKENS
      )
    )) |>
    req_perform()

  list(
    content   = resp_body_json(response)$candidates[[1]]$content$parts[[1]]$text,
    reasoning = NULL
  )
}

call_deepseek <- function(prompt_text) {
  # DeepSeek R1 uses MAX_TOKENS_R1 (8000) to accommodate chain-of-thought
  # reasoning_content = internal reasoning (archived but not scored)
  # content           = final structured response (used for scoring)
  response <- request("https://api.deepseek.com/v1/chat/completions") |>
    req_headers(
      "Authorization" = paste("Bearer", deepseek_key),
      "Content-Type"  = "application/json"
    ) |>
    req_body_json(list(
      model       = "deepseek-reasoner",
      temperature = TEMPERATURE_R1,
      max_tokens  = MAX_TOKENS_R1,
      messages    = list(list(role = "user", content = prompt_text))
    )) |>
    req_perform()

  result <- resp_body_json(response)

  list(
    content   = result$choices[[1]]$message$content,
    reasoning = result$choices[[1]]$message$reasoning_content
  )
}

# =============================================================
# MAIN LOOP
# =============================================================

models <- c("gpt4o", "gemini25", "deepseek_r1")

total_runs  <- length(case_files) * length(models)
current_run <- 0

message(">>> Starting benchmark — ", total_runs, " total API calls\n")

for (case_file in case_files) {

  case_id   <- tools::file_path_sans_ext(basename(case_file))
  case_data <- fromJSON(case_file)

  # Build prompt by inserting case profile into template
  prompt_filled <- gsub(
    "\\{CASE\\}",
    toJSON(case_data$profile, auto_unbox = TRUE, pretty = TRUE),
    PROMPT_TEMPLATE
  )

  for (model in models) {

    current_run <- current_run + 1
    out_file    <- here("outputs", model, paste0(case_id, ".json"))

    # Skip if already run — allows safe resumption after interruption
    if (file.exists(out_file)) {
      message(sprintf("  [skip]    %s / %s (%d/%d)",
                      model, case_id, current_run, total_runs))
      next
    }

    message(sprintf("  [running] %s / %s (%d/%d)",
                    model, case_id, current_run, total_runs))

    tryCatch({

      raw <- switch(model,
        gpt4o       = call_gpt4o(prompt_filled),
        gemini25    = call_gemini(prompt_filled),
        deepseek_r1 = call_deepseek(prompt_filled)
      )

      output <- list(
        case_id   = case_id,
        model     = model,
        timestamp = format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
        content   = raw$content,    # used for scoring
        reasoning = raw$reasoning   # archived only (DeepSeek R1 chain-of-thought)
      )

      write_json(output, out_file, auto_unbox = TRUE, pretty = TRUE)

      # Pause between calls to respect rate limits
      Sys.sleep(1.5)

    }, error = function(e) {
      message(sprintf("  [ERROR]   %s / %s : %s", model, case_id, e$message))
    })
  }
}

message("\n>>> Benchmark complete.")
message(">>> Outputs saved to outputs/gpt4o/, outputs/gemini25/, outputs/deepseek_r1/")
message(">>> Next step: run analysis/scripts/02_scoring_auto.R")
