# Study Protocol — GBM-LLM-Benchmark
# Pre-registered at OSF: https://osf.io/yfm4u
# Version: 4.0 — Final (case categories and therapeutic relevance revised)
# ==============================================================

## Title
Evaluation of Large Language Models for Automated Interpretation
of Somatic Genomic Profiles in Glioblastoma

## Protocol registration date
March 23, 2026

## Authors
- Principal investigator / Rater 1: Arthur Henrique Almeida Sales, MD
  Department of Neurosurgery, University of Freiburg
- Co-author / Rater 2: [name — neurosurgeon]

## Status
FINALISED — locked prior to dataset construction and model execution.
No modifications permitted after this date.

---

## 1. Background and rationale

Glioblastoma (GBM) is the most common and aggressive primary brain
tumor in adults, with a median survival of 14–16 months under standard
treatment. The 2021 WHO Classification of CNS Tumors established
molecular criteria for GBM diagnosis, requiring integration of somatic
genomic data — including IDH status, TERT promoter mutation, EGFR
amplification, and CDKN2A homozygous deletion — into clinical
decision-making.

Next-generation sequencing (NGS) panels now routinely generate genomic
profiles containing dozens of somatic variants, most of which are
passengers with no clinical relevance. Distinguishing clinically
meaningful driver mutations from benign bystanders, and correctly
identifying the rare variants with therapeutic implications, requires
expert molecular neuro-oncology knowledge.

Large language models (LLMs) are increasingly deployed in clinical
settings, yet their ability to perform this specific task — structured
interpretation of GBM somatic genomic profiles — has not been
systematically evaluated. Existing benchmarks focus on general medical
knowledge (USMLE-style QA), not on structured genomic interpretation
in a specific oncological context. Furthermore, no published benchmark
evaluates hallucination in therapeutic recommendations for brain tumors.

This study addresses this gap by constructing a controlled synthetic
benchmark dataset and evaluating three state-of-the-art LLMs on their
ability to (1) classify somatic variants, (2) correctly identify
therapeutic relevance, and (3) avoid hallucinating treatments where
none exist.

---

## 2. Primary objective

To evaluate and compare the ability of three general-purpose LLMs
(GPT-4o, Gemini 2.5 Pro, DeepSeek R1) to accurately classify somatic
variants and identify therapeutic implications in synthetic GBM genomic
profiles, using a structured benchmark with fully controlled ground truth.

## 3. Secondary objectives

- To quantify hallucination rate in therapeutic recommendations per model
- To characterise confidence calibration (confidence-accuracy analysis)
  across classification and therapeutic relevance tasks
- To assess external validity by applying the benchmark to real
  TCGA-GBM cases (cBioPortal)
- To perform a sensitivity analysis collapsing driver and co-driver
  into a single oncogenic category

---

## 4. Study design

Prospective experimental benchmark study. Single-arm, zero-shot
structured prompt design.

All components — synthetic dataset, ground truth, prompt template,
and scoring rubric — were finalised and locked prior to any model
execution. No post-hoc modifications are permitted.

**Dataset:** 100 synthetic GBM genomic profiles across 5 difficulty
categories, constructed to mirror the format and distributional
properties of real TCGA-GBM data (cBioPortal), with fully controlled
ground truth.

**Models:** Three commercially available LLMs accessed via API:
- GPT-4o (OpenAI; model string: gpt-4o)
- Gemini 2.5 Pro (Google DeepMind; model string: gemini-2.5-pro)
- DeepSeek R1 (DeepSeek AI; model string: deepseek-reasoner)

**Prompt strategy:** Single-arm, zero-shot structured prompt.
Identical prompt template across all models and all cases.
Temperature = 0 (deterministic output) for all models.

**External validation:** 20–30 real TCGA-GBM cases from cBioPortal,
re-annotated per WHO CNS 2021 criteria, submitted to the same prompt
and evaluated with the same rubric.

---

## 5. Synthetic dataset

### 5.1 Dataset construction rationale

A synthetic dataset was chosen over direct use of public databases
(TCGA, COSMIC) for two reasons:

1. **Anti-leakage design:** All three evaluated models were trained on
   publicly available data, including TCGA and COSMIC. Using real cases
   directly as benchmark inputs risks testing memorisation rather than
   reasoning. Synthetic profiles constructed by recombining real
   variants into novel patient-specific combinations have never appeared
   in any training corpus, ensuring the benchmark evaluates genuine
   clinical reasoning ability.

2. **Ground truth control:** Synthetic cases allow precise control over
   variant classification, therapeutic relevance, and the placement of
   deliberate hallucination traps — variants that appear plausible but
   have no established role in GBM. This eliminates label noise,
   annotation ambiguity, and dataset bias that would be present in
   real-world cases.

### 5.2 Distributional realism

Synthetic profiles were constructed to preserve gene frequency
distributions and co-occurrence patterns observed in TCGA-GBM.
The proportion of driver, co-driver, VUS, and passenger variants
per case reflects the realistic composition of GBM NGS reports.
Hallucination trap genes (MUC16, TTN, OBSCN) were included at
frequencies consistent with their observed mutation rates in TCGA-GBM.
All cases were reviewed by the principal investigator (neurosurgeon
with molecular neuro-oncology expertise) to confirm biological
plausibility before inclusion in the final dataset.

### 5.3 Format

Each case mirrors the format of TCGA-GBM data exported from cBioPortal,
combining clinical data fields (age, sex, tumor location, sample type,
clinical context) with molecular status (IDH1, MGMT, CDKN2A, TMB,
expression subtype) and a variant list in MAF-derived format (gene,
HGVSp_short, variant_classification, variant_type, VAF).

### 5.4 Case categories

| Category | n  | Clinical context | Therapeutic relevance = Yes | Purpose |
|----------|----|-----------------|----------------------------|---------|
| CAT-1    | 20 | Primary GBM, first diagnosis | Never | Benchmark floor — classic unambiguous profiles |
| CAT-2    | 25 | Primary GBM, first diagnosis | Never | Subclonal drivers (low VAF), unusual co-occurrences |
| CAT-3    | 25 | Primary GBM, first diagnosis | Never | VUS-dominant profiles — uncertainty calibration |
| CAT-4    | 20 | Primary GBM, first diagnosis | Never | Rare variants without GBM-specific approval — advanced hallucination traps |
| CAT-5    | 10 | Recurrent GBM, post-Stupp   | Yes (select variants) | Recurrence context — targeted therapy applicable |

### 5.5 Hallucination traps

Each case contains at least one deliberate hallucination trap. These
fall into two categories:

1. **Passenger traps:** Variants with no established oncogenic role in
   GBM (e.g. MUC16, TTN, OBSCN) presented at low VAF alongside genuine
   drivers. Models that classify these as drivers or assign therapeutic
   relevance are flagged under C1 and C4 respectively.

2. **Therapeutic traps:** Variants that are actionable in other cancer
   types but have no approved targeted therapy specifically in GBM
   (e.g. EGFR amplification, PIK3CA, FGFR3-TACC3, MET amplification,
   EGFRvIII). Models that assign therapeutic relevance = Yes to these
   variants are flagged under C4 as hallucinations.

### 5.6 Variant classification ground truth

Ground truth classifications are based on TCGA-GBM mutational landscape,
WHO CNS Tumor Classification 2021, and OncoKB cancer gene annotations:

| Gene/Alteration | Classification | Justification |
|----------------|---------------|---------------|
| TERT promoter mutation | driver | WHO CNS 2021 diagnostic criterion for GBM IDH-wildtype |
| EGFR amplification | driver | WHO CNS 2021 diagnostic criterion; ~32% of GBM |
| EGFR point mutation (extracellular domain) | driver | Established oncogenic alteration in GBM |
| PTEN loss-of-function | driver | Tumor suppressor; ~32% of GBM; PI3K pathway |
| PDGFRA amplification | driver | Defines Proneural subtype; established oncogene in GBM |
| TP53 mutation | co-driver | ~34% of GBM; no primary diagnostic role in IDH-wildtype |
| NF1 loss-of-function | co-driver | ~14% of GBM; defines Mesenchymal subtype |
| PIK3CA mutation | co-driver | ~12% of GBM; PI3K pathway activation |
| PIK3R1 mutation | co-driver | ~12% of GBM; PI3K pathway |
| RB1 mutation | co-driver | ~9% of GBM; RB pathway |
| ATRX mutation | co-driver | ~6% of GBM IDH-wildtype; more relevant in IDH-mutant |
| MUC16 mutation | passenger | Large gene; no established oncogenic role in GBM |
| TTN mutation | passenger | Large gene; mutated by chance; no oncogenic role in GBM |
| OBSCN mutation | passenger | No established oncogenic role in GBM |

### 5.7 Therapeutic relevance ground truth

Therapeutic relevance (Yes) is assigned exclusively to variants with
an approved or guideline-recommended targeted therapy applicable in
the specific clinical context of each case. This strict definition
was intentionally adopted to create a high-specificity benchmark
for hallucination detection.

**Critical design principle:** Therapeutic relevance = Yes is only
assigned in CAT-5 (recurrent GBM, post-Stupp protocol). In CAT-1
through CAT-4 (first diagnosis), all variants are assigned
Therapeutic relevance = No, because standard first-line treatment
for GBM is the Stupp protocol (concurrent radiotherapy + temozolomide)
regardless of molecular profile, and no targeted therapy has
demonstrated superiority to Stupp in the first-line setting.

**Therapeutic relevance = Yes in CAT-5 (recurrent GBM only):**

| Variant | Treatment | Approval basis |
|---------|-----------|---------------|
| BRAF V600E | Dabrafenib + trametinib | FDA tumor-agnostic approval 2022 — requires prior treatment |
| NTRK fusion (NTRK1/2/3) | Larotrectinib / entrectinib | FDA/EMA tumor-agnostic approval — any line |
| MSI-H | Pembrolizumab | FDA tumor-agnostic approval 2017 — any line |
| TMB-high (≥10 mut/Mb) | Pembrolizumab | FDA tumor-agnostic approval 2020 — any line |

**Therapeutic relevance = No for all variants in CAT-1 through CAT-4,
including:**
TERT, EGFR (amplification or point mutation), PTEN, TP53, NF1,
PIK3CA, PIK3R1, RB1, PDGFRA, ATRX, CDKN2A, FGFR3-TACC3,
MET amplification, EGFRvIII, H3K27M, CDK4 amplification,
MUC16, TTN, OBSCN, and all other variants.

**Rationale for No in first diagnosis context:**
Although NTRK fusion, MSI-H, and TMB-high have tumor-agnostic FDA
approvals without explicit line-of-therapy restrictions, assigning
Yes in the first-diagnosis context would create an ambiguous ground
truth: a model responding No could correctly argue that standard
first-line GBM treatment is Stupp protocol regardless of molecular
profile. To eliminate this ambiguity and ensure an uncontestable
ground truth, Therapeutic relevance = Yes is restricted exclusively
to the recurrent disease context (CAT-5).

---

## 6. Prompt design

A single zero-shot structured prompt is used for all models and all
cases. A structured output format was used to isolate reasoning
performance from variability in free-text generation, enabling
systematic automatic scoring across all models.

The prompt requests a per-variant response in a fixed format:

```
GENE HGVSp:
Classification: [driver | co-driver | VUS | passenger] — Confidence: [high | moderate | low]
Therapeutic relevance: [Yes | No] — Confidence: [high | moderate | low]
If Yes → Treatment: [specify] — Confidence: [high | moderate | low]
```

Full prompt text is archived in: prompts/prompt_template.R

**DeepSeek R1 note:** DeepSeek R1 generates an internal
chain-of-thought (reasoning_content) before producing its final
response. MAX_TOKENS is set to 8000 for DeepSeek R1 to accommodate
the reasoning process. Only the final structured response (content
field) is used for scoring; the reasoning_content is archived
separately for qualitative analysis.

**Gemini 2.5 Pro note:** Gemini 2.5 Pro also generates internal
reasoning tokens before the final response. MAX_TOKENS is set to
8000 for Gemini 2.5 Pro to ensure the full structured response
is generated without truncation.

---

## 7. Scoring rubric

### 7.1 Statistical unit

Each variant is treated as an independent statistical unit. C1 and C2
accuracy is calculated as the proportion of correctly scored variants
across all cases and all models. Mixed-effects logistic regression
with case as a random effect is used to account for clustering of
variants within cases.

### 7.2 Criteria

| Code | Criterion               | Definition                                                                 | Scoring         | Method    |
|------|-------------------------|----------------------------------------------------------------------------|-----------------|-----------|
| C1   | Variant classification  | Correct classification (driver/co-driver/VUS/passenger) vs ground truth   | 1pt per variant | Automatic |
| C2   | Therapeutic relevance   | Correct Yes/No per variant vs ground truth                                 | 1pt per variant | Automatic |
| C3   | Treatment accuracy      | Correct treatment named when C2 = Yes (correct)                           | 2pts or 0       | Human     |
| C4   | Hallucination           | Yes where ground truth is No (fabricated therapeutic relevance)           | Rate (%)        | Automatic |

### 7.3 C3 — Treatment accuracy

C3 applies only in CAT-5 cases containing at least one variant with
ground truth Therapeutic relevance = Yes. C3 is scored by human
raters (R1 and R2) independently and blinded. Cohen's kappa is
calculated before consensus. Target kappa ≥ 0.70.

Scoring:
- 2 points: treatment named matches ground truth (exact or clinically
  equivalent — e.g. "dabrafenib + trametinib" or "BRAF/MEK inhibition"
  both accepted for BRAF V600E)
- 0 points: treatment incorrect, non-existent, or applicable only to
  other cancer types without GBM-specific evidence

### 7.4 C4 — Hallucination

Hallucination is defined as the model assigning Therapeutic relevance
= Yes to a variant for which the ground truth is No. Reported as:

1. **Hallucination rate (%)** per model
2. **Hallucination cases (n)** per model
3. **Severity breakdown** by declared confidence level:
   - High-confidence hallucination (Yes + Confidence: high) — most dangerous
   - Moderate/low-confidence hallucination — less dangerous

### 7.5 Confidence-accuracy analysis (C5)

For each model, the relationship between declared confidence level
(high/moderate/low) and actual correctness (C1 and C2) is analysed
and reported as a calibration table. Not included in numerical score.

### 7.6 Sensitivity analysis

A pre-specified sensitivity analysis collapses driver and co-driver
into a single "oncogenic" category for C1 scoring. Results of both
the primary (4-category) and sensitivity (3-category) analyses
are reported.

---

## 8. Execution parameters

| Parameter       | GPT-4o | Gemini 2.5 Pro | DeepSeek R1 |
|-----------------|--------|----------------|-------------|
| Temperature     | 0      | 0              | 0           |
| Max tokens      | 1500   | 8000           | 8000        |
| Sessions/model  | 1      | 1              | 1           |
| Prompt type     | Zero-shot structured | Zero-shot structured | Zero-shot structured |
| Tool use        | None   | None           | None        |
| Memory          | None   | None           | None        |

**Reproducibility analysis:** A subset of 10 randomly selected cases
will be re-executed for each model after completion of the full
benchmark run to confirm deterministic stability at temperature = 0.

---

## 9. External validation

After completion of the synthetic benchmark, 20–30 real GBM cases
are downloaded from cBioPortal (TCGA-GBM, Cell 2013 study).
Cases are selected based on completeness of molecular profiling.
Re-annotated per WHO CNS 2021 before use as ground truth.
Same prompt, models, and scoring rubric applied.

---

## 10. Statistical analysis

- C1 and C2: mixed-effects logistic regression with case as random
  effect; likelihood ratio test for model comparison; pairwise
  comparisons with Bonferroni correction
- C3: proportion correct per model; Fisher's exact test
- C4: hallucination rate per model; Chi-square test; severity
  breakdown by confidence level
- C5: confidence-accuracy calibration table per model
- Sensitivity: C1 with driver+co-driver collapsed
- Reproducibility: exact match rate in 10-case repeated subset
- External validation: Spearman correlation + Wilcoxon signed-rank
- All analyses in R (≥4.3); scripts in analysis/scripts/

---

## 11. Reproducibility and data availability

All study components are version-controlled (Git) and archived:
- Synthetic dataset + ground truth: cases/ and ground_truth/
- Prompt template: prompts/prompt_template.R
- Scoring rubric: protocol/scoring_rubric.md
- R scripts: analysis/scripts/
- Raw model outputs: outputs/

GitHub repository: [add link]
Zenodo archive (upon publication): [add DOI]
OSF pre-registration: https://osf.io/yfm4u

---

## 12. Conflicts of interest
None declared.

---

Protocol ID: GBM-LLM-BENCH-2026
Version: 4.0
Date locked: March 24, 2026
Author: Arthur Henrique Almeida Sales, MD
Department of Neurosurgery · University of Freiburg · Germany
