# =============================================================
# 01_run_deepseek_r1.R — GBM-LLM-Benchmark
# Runs DeepSeek R1 on all benchmark cases
# NOTE: MAX_TOKENS_R1 = 8000 to accommodate chain-of-thought
# Only the content field (final response) is used for scoring
# The reasoning_content field is archived for qualitative analysis
# =============================================================
# HOW TO RUN:
#   1. Open GBM-LLM-Benchmark.Rproj in RStudio
#   2. Confirm API key: Sys.getenv("DEEPSEEK_API_KEY")
#   3. Set RUN_PILOT <- TRUE for pilot (CAT-1 only)
#   4. source(here("analysis", "scripts", "01_run_deepseek_r1.R"))
# =============================================================

library(httr2)
library(jsonlite)
library(here)

# =============================================================
# CONFIGURATION
# =============================================================

RUN_PILOT  <- TRUE   # TRUE = CAT-1 only | FALSE = all 100 cases
MODEL_NAME <- "deepseek_r1"

deepseek_key <- Sys.getenv("DEEPSEEK_API_KEY")
stopifnot("DEEPSEEK_API_KEY not found in .Renviron" = nchar(deepseek_key) > 10)
message(">>> API key verified: DeepSeek")

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

call_deepseek_r1 <- function(prompt_text) {
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

message(">>> Starting DeepSeek R1 — ", length(case_files), " cases")
message(">>> Note: R1 generates chain-of-thought before final response")
message(">>> reasoning_content archived separately — only content scored\n")

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
    result <- call_deepseek_r1(prompt_filled)

    output <- list(
      case_id   = case_id,
      model     = MODEL_NAME,
      timestamp = format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
      content   = result$content,    # final structured response — used for scoring
      reasoning = result$reasoning   # chain-of-thought — archived only
    )

    write_json(output, out_file, auto_unbox = TRUE, pretty = TRUE)
    message(sprintf("  [saved]   %s", case_id))
    Sys.sleep(2)  # slightly longer pause for R1 due to reasoning tokens

  }, error = function(e) {
    message(sprintf("  [ERROR]   %s : %s", case_id, e$message))
  })
}

message("\n>>> DeepSeek R1 complete.")
message(">>> Outputs saved to: outputs/deepseek_r1/")
