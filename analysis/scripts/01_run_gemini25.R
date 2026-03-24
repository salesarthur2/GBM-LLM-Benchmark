# =============================================================
# 01_run_gemini25.R — GBM-LLM-Benchmark
# Runs Gemini 2.5 Pro on all benchmark cases
# Version: 3.1 — MAX_TOKENS_GEMINI = 8000
# =============================================================

library(httr2)
library(jsonlite)
library(here)

# =============================================================
# CONFIGURATION
# =============================================================

RUN_PILOT  <- TRUE
MODEL_NAME <- "gemini25"

gemini_key <- Sys.getenv("GEMINI_API_KEY")
stopifnot("GEMINI_API_KEY not found in .Renviron" = nchar(gemini_key) > 10)
message(">>> API key verified: Gemini")

source(here("prompts", "prompt_template.R"))

# =============================================================
# LOAD CASES
# =============================================================

if (RUN_PILOT) {
  case_files <- list.files(here("cases", "cat1_classic"),
                           pattern = "\\.json$", full.names = TRUE)
  message(">>> PILOT MODE — cases: ", length(case_files))
} else {
  case_files <- list.files(here("cases"),
                           pattern = "\\.json$", recursive = TRUE, full.names = TRUE)
  message(">>> FULL MODE — cases: ", length(case_files))
}

# =============================================================
# API CALL FUNCTION
# =============================================================

call_gemini25 <- function(prompt_text) {
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
        temperature     = TEMPERATURE_GEMINI,
        maxOutputTokens = MAX_TOKENS_GEMINI
      )
    )) |>
    req_perform()

  result <- resp_body_json(response)

  # Extract text safely
  tryCatch(
    result$candidates[[1]]$content$parts[[1]]$text,
    error = function(e) {
      message("    [warn] Could not extract text — finishReason: ",
              result$candidates[[1]]$finishReason)
      NA_character_
    }
  )
}

# =============================================================
# MAIN LOOP
# =============================================================

message(">>> Starting Gemini 2.5 Pro — ", length(case_files), " cases\n")

for (i in seq_along(case_files)) {

  case_file <- case_files[[i]]
  case_id   <- tools::file_path_sans_ext(basename(case_file))
  out_file  <- here("outputs", MODEL_NAME, paste0(case_id, ".json"))

  if (file.exists(out_file)) {
    # Re-check if previously saved output has empty content
    existing <- fromJSON(out_file)
    if (!is.null(existing$content) && length(existing$content) > 0 &&
        !is.na(existing$content) && nchar(existing$content) > 10) {
      message(sprintf("  [skip] %s (%d/%d)", case_id, i, length(case_files)))
      next
    } else {
      message(sprintf("  [retry — empty content] %s (%d/%d)", case_id, i, length(case_files)))
    }
  }

  message(sprintf("  [running] %s (%d/%d)", case_id, i, length(case_files)))

  case_data     <- fromJSON(case_file)
  prompt_filled <- gsub("\\{CASE\\}",
                        toJSON(case_data$profile, auto_unbox = TRUE, pretty = TRUE),
                        PROMPT_TEMPLATE)

  tryCatch({
    content <- call_gemini25(prompt_filled)

    output <- list(
      case_id   = case_id,
      model     = MODEL_NAME,
      timestamp = format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
      content   = content
    )

    write_json(output, out_file, auto_unbox = TRUE, pretty = TRUE)
    message(sprintf("  [saved]   %s", case_id))
    Sys.sleep(2)

  }, error = function(e) {
    message(sprintf("  [ERROR]   %s : %s", case_id, e$message))
  })
}

message("\n>>> Gemini 2.5 Pro complete.")
message(">>> Outputs saved to: outputs/gemini25/")
