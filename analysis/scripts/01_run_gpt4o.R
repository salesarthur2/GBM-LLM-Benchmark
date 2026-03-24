# =============================================================
# 01_run_gpt4o.R — GBM-LLM-Benchmark
# Runs GPT-4o on all benchmark cases
# =============================================================
# HOW TO RUN:
#   1. Open GBM-LLM-Benchmark.Rproj in RStudio
#   2. Confirm API key: Sys.getenv("OPENAI_API_KEY")
#   3. Set RUN_PILOT <- TRUE for pilot (CAT-1 only)
#   4. source(here("analysis", "scripts", "01_run_gpt4o.R"))
# =============================================================

library(httr2)
library(jsonlite)
library(here)

# =============================================================
# CONFIGURATION
# =============================================================

RUN_PILOT <- FALSE  # TRUE = CAT-1 only | FALSE = all 100 cases
MODEL_NAME <- "gpt4o"

openai_key <- Sys.getenv("OPENAI_API_KEY")
stopifnot("OPENAI_API_KEY not found in .Renviron" = nchar(openai_key) > 10)
message(">>> API key verified: OpenAI")

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

  resp_body_json(response)$choices[[1]]$message$content
}

# =============================================================
# MAIN LOOP
# =============================================================

message(">>> Starting GPT-4o — ", length(case_files), " cases\n")

for (i in seq_along(case_files)) {

  case_file <- case_files[[i]]
  case_id   <- tools::file_path_sans_ext(basename(case_file))
  out_file  <- here("outputs", MODEL_NAME, paste0(case_id, ".json"))

  if (file.exists(out_file)) {
    message(sprintf("  [skip] %s (%d/%d)", case_id, i, length(case_files)))
    next
  }

  message(sprintf("  [running] %s (%d/%d)", case_id, i, length(case_files)))

  case_data     <- fromJSON(case_file)
  prompt_filled <- gsub("\\{CASE\\}",
                        toJSON(case_data$profile, auto_unbox = TRUE, pretty = TRUE),
                        PROMPT_TEMPLATE)

  tryCatch({
    content <- call_gpt4o(prompt_filled)

    output <- list(
      case_id   = case_id,
      model     = MODEL_NAME,
      timestamp = format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
      content   = content
    )

    write_json(output, out_file, auto_unbox = TRUE, pretty = TRUE)
    message(sprintf("  [saved]   %s", case_id))
    Sys.sleep(1.5)

  }, error = function(e) {
    message(sprintf("  [ERROR]   %s : %s", case_id, e$message))
  })
}

message("\n>>> GPT-4o complete.")
message(">>> Outputs saved to: outputs/gpt4o/")
