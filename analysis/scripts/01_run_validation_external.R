# =============================================================
# 01_run_validation_external.R — GBM-LLM-Benchmark
# Runs all 3 models on 25 TCGA-GBM external validation cases
# Same prompt and parameters as main benchmark
# =============================================================

library(httr2)
library(jsonlite)
library(here)

source(here("prompts", "prompt_template.R"))

openai_key   <- Sys.getenv("OPENAI_API_KEY")
gemini_key   <- Sys.getenv("GEMINI_API_KEY")
deepseek_key <- Sys.getenv("DEEPSEEK_API_KEY")

stopifnot(nchar(openai_key)   > 10,
          nchar(gemini_key)   > 10,
          nchar(deepseek_key) > 10)
message(">>> API keys verified")

case_files <- list.files(
  here("validation_external","cases"),
  pattern="\\.json$", full.names=TRUE)

message(">>> TCGA validation cases: ", length(case_files))

models <- c("gpt4o", "gemini25", "deepseek_r1")

for (model in models) {
  dir.create(here("validation_external","outputs", model),
             recursive=TRUE, showWarnings=FALSE)
}

call_gpt4o <- function(prompt_text) {
  response <- request("https://api.openai.com/v1/chat/completions") |>
    req_headers("Authorization"=paste("Bearer", openai_key),
                "Content-Type"="application/json") |>
    req_body_json(list(model="gpt-4o", temperature=TEMPERATURE,
                       max_tokens=MAX_TOKENS,
                       messages=list(list(role="user", content=prompt_text)))) |>
    req_perform()
  resp_body_json(response)$choices[[1]]$message$content
}

call_gemini25 <- function(prompt_text) {
  url <- paste0("https://generativelanguage.googleapis.com/v1beta/models/",
                "gemini-2.5-pro:generateContent?key=", gemini_key)
  response <- request(url) |>
    req_headers("Content-Type"="application/json") |>
    req_body_json(list(
      contents=list(list(parts=list(list(text=prompt_text)))),
      generationConfig=list(temperature=TEMPERATURE_GEMINI,
                            maxOutputTokens=MAX_TOKENS_GEMINI))) |>
    req_perform()
  tryCatch(
    resp_body_json(response)$candidates[[1]]$content$parts[[1]]$text,
    error=function(e) NA_character_
  )
}

call_deepseek <- function(prompt_text) {
  response <- request("https://api.deepseek.com/v1/chat/completions") |>
    req_headers("Authorization"=paste("Bearer", deepseek_key),
                "Content-Type"="application/json") |>
    req_body_json(list(model="deepseek-reasoner",
                       temperature=TEMPERATURE_R1, max_tokens=MAX_TOKENS_R1,
                       messages=list(list(role="user", content=prompt_text)))) |>
    req_perform()
  result <- resp_body_json(response)
  list(content   = result$choices[[1]]$message$content,
       reasoning = result$choices[[1]]$message$reasoning_content)
}

total <- length(case_files) * length(models)
run   <- 0

message(">>> Starting validation — ", total, " API calls\n")

for (case_file in case_files) {
  case_id   <- tools::file_path_sans_ext(basename(case_file))
  case_data <- fromJSON(case_file)
  prompt_filled <- gsub("\\{CASE\\}",
                        toJSON(case_data$profile, auto_unbox=TRUE, pretty=TRUE),
                        PROMPT_TEMPLATE)

  for (model in models) {
    run      <- run + 1
    out_file <- here("validation_external","outputs", model,
                     paste0(case_id, ".json"))

    if (file.exists(out_file)) {
      message(sprintf("  [skip]    %s / %s (%d/%d)", model, case_id, run, total))
      next
    }

    message(sprintf("  [running] %s / %s (%d/%d)", model, case_id, run, total))

    tryCatch({
      raw <- switch(model,
        gpt4o       = list(content=call_gpt4o(prompt_filled),   reasoning=NULL),
        gemini25    = list(content=call_gemini25(prompt_filled), reasoning=NULL),
        deepseek_r1 = call_deepseek(prompt_filled)
      )
      write_json(list(case_id=case_id, model=model,
                      timestamp=format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
                      content=raw$content, reasoning=raw$reasoning),
                 out_file, auto_unbox=TRUE, pretty=TRUE)
      message(sprintf("  [saved]   %s / %s", model, case_id))
      Sys.sleep(2)
    }, error=function(e) {
      message(sprintf("  [ERROR]   %s / %s : %s", model, case_id, e$message))
    })
  }
}

message("\n>>> Validation run complete.")
message(">>> Outputs saved to validation_external/outputs/")
message(">>> Next: run 02_scoring_validation.R")
