# =============================================================
# prompt_template.R — GBM-LLM-Benchmark
# Version: 3.1 — MAX_TOKENS_GEMINI added
# Zero-shot structured — single arm
# DO NOT modify after data collection starts
# =============================================================

PROMPT_TEMPLATE <- "
You are a molecular neuro-oncology assistant supporting a tumor board.
Analyze the somatic genomic profile below.

For EACH variant listed, respond using exactly this format — no additional text:

GENE HGVSp:
Classification: [driver | co-driver | VUS | passenger] — Confidence: [high | moderate | low]
Therapeutic relevance: [Yes | No] — Confidence: [high | moderate | low]
If Yes → Treatment: [specify] — Confidence: [high | moderate | low]

Classification definitions:
- driver: primary oncogenic alteration with established role in glioblastoma
- co-driver: recurrent alteration with supporting but secondary oncogenic role in glioblastoma
- VUS: variant of uncertain significance — insufficient evidence to classify in glioblastoma
- passenger: likely bystander with no established oncogenic role in glioblastoma

Rules:
- Base all classifications on evidence specific to glioblastoma
- If evidence is absent or uncertain in glioblastoma specifically, classify as VUS or passenger
- Therapeutic relevance is Yes only if a targeted therapy is specifically recommended
  for glioblastoma in clinical practice guidelines (NCCN, EANO) or has FDA/EMA approval
  for this specific indication in glioblastoma
- Tumor-agnostic approvals (e.g. TMB-high, MSI-H) do not qualify unless specifically
  endorsed in glioblastoma guidelines
- Standard chemotherapy (temozolomide) and radiotherapy are NOT targeted therapies
  and must NOT be cited as treatment for any individual variant
- Do not add explanations, summaries, or any text outside the format above

---
GENOMIC PROFILE:
{CASE}
"

# =============================================================
# Execution parameters
# =============================================================

# GPT-4o
TEMPERATURE  <- 0
MAX_TOKENS   <- 1500

# Gemini 2.5 Pro — requires higher token budget due to internal reasoning
TEMPERATURE_GEMINI  <- 0
MAX_TOKENS_GEMINI   <- 8000

# DeepSeek R1 — reasoning model requires higher token budget
TEMPERATURE_R1 <- 0
MAX_TOKENS_R1  <- 8000

PROMPT_TYPE <- "zero-shot structured"

# =============================================================
# Scoring criteria (reference only — not sent to model)
# =============================================================
# C1: 1pt per variant with correct classification vs ground truth   [automatic]
# C2: 1pt per variant with correct therapeutic relevance (Yes/No)   [automatic]
# C3: 2pts if correct treatment named where C2=Yes (correct)        [human, rare]
# C4: hallucination = Yes where ground truth is No                  [automatic, separate metric]
# C5: confidence-accuracy analysis                                   [not scored, qualitative]
