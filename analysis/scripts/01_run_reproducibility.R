# =============================================================
# 01_run_reproducibility.R — GBM-LLM-Benchmark
# Re-runs 10 randomly selected cases on all 3 models
# to confirm deterministic stability at temperature=0
# Pre-specified cases (seed=42):
#   GBM-050, GBM-066, GBM-026, GBM-075, GBM-019,
#   GBM-101, GBM-048, GBM-025, GBM-072, GBM-090
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

repro_ids <- c("GBM-050","GBM-066","GBM-026","GBM-075","GBM-019",
               "GBM-101","GBM-048","GBM-025","GBM-072","GBM-090")

all_cases   <- list.files(here("cases"), pattern="\\.json$",
                          recursive=TRUE, full.names=TRUE)
repro_files <- all_cases[tools::file_path_sans_ext(basename(all_cases))
                         %in% repro_ids]

message(">>> Reproducibility cases: ", length(repro_files))

repro_dir <- here("outputs", "reproducibility")
dir.create(repro_dir, showWarnings=FALSE)

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

models <- c("gpt4o", "gemini25", "deepseek_r1")
total  <- length(repro_files) * length(models)
run    <- 0

message(">>> Starting reproducibility run — ", total, " API calls\n")

for (case_file in repro_files) {
  case_id       <- tools::file_path_sans_ext(basename(case_file))
  case_data     <- fromJSON(case_file)
  prompt_filled <- gsub("\\{CASE\\}",
                        toJSON(case_data$profile, auto_unbox=TRUE, pretty=TRUE),
                        PROMPT_TEMPLATE)

  for (model in models) {
    run      <- run + 1
    out_file <- file.path(repro_dir, paste0(case_id, "_", model, ".json"))
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

message("\n>>> Comparing original vs reproducibility outputs...\n")

results <- data.frame(model=character(), case_id=character(),
                      match=logical(), stringsAsFactors=FALSE)

for (case_id in repro_ids) {
  for (model in models) {
    orig_file  <- here("outputs", model, paste0(case_id, ".json"))
    repro_file <- file.path(repro_dir, paste0(case_id, "_", model, ".json"))
    if (!file.exists(orig_file) || !file.exists(repro_file)) next

    orig_clean  <- trimws(gsub("\\s+", " ",
                               fromJSON(orig_file)$content))
    repro_clean <- trimws(gsub("\\s+", " ",
                               fromJSON(repro_file)$content))
    is_match <- identical(orig_clean, repro_clean)
    results  <- rbind(results,
                      data.frame(model=model, case_id=case_id,
                                 match=is_match, stringsAsFactors=FALSE))
    message(sprintf("  [%s] %s / %s", if(is_match) "MATCH" else "DIFF",
                    model, case_id))
  }
}

cat("\n==============================\n")
cat("REPRODUCIBILITY SUMMARY\n")
cat("==============================\n")
match_rate <- results |>
  dplyr::group_by(model) |>
  dplyr::summarise(n=dplyr::n(), n_match=sum(match),
                   match_rate=round(mean(match), 3), .groups="drop")
print(match_rate)
cat(sprintf("\nOverall match rate: %.1f%%\n", mean(results$match)*100))

dir.create(here("results","tables"), recursive=TRUE, showWarnings=FALSE)
write.csv(results,    here("results","tables","reproducibility_detail.csv"),
          row.names=FALSE)
write.csv(match_rate, here("results","tables","reproducibility_summary.csv"),
          row.names=FALSE)

message("\n>>> Reproducibility analysis complete.")
