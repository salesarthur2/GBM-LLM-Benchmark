# Study Protocol — GBM-LLM-Benchmark
# Pre-registered at OSF: https://osf.io/yfm4u
# Version: 3.0 — Final (incorporating peer feedback prior to execution)
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
combining clinical data fields (age, sex, tumor location, sample type)
with molecular status (IDH1, MGMT, CDKN2A, TMB, expression subtype)
and a variant list in MAF-derived format (gene, HGVSp_short,
variant_classification, variant_type, VAF).

### 5.4 Case categories

| Category | n  | Description |
|----------|----|-------------|
| CAT-1    | 20 | Classic unambiguous GBM IDH-wildtype — benchmark floor |
| CAT-2    | 25 | Profiles with direct therapeutic implication (MGMT, TMB-high) |
| CAT-3    | 25 | VUS-dominant profiles — uncertainty and calibration test |
| CAT-4    | 20 | Rare/uncommon GBM alterations (BRAF V600E, FGFR3-TACC3, NTRK, MET) |
| CAT-5    | 10 | Recurrent/resistant disease — longitudinal reasoning |

### 5.5 Hallucination traps

Each case contains at least one deliberate hallucination trap: a variant
with no established oncogenic role in GBM (e.g. MUC16, TTN, OBSCN)
presented at low VAF alongside genuine drivers. Models that classify
these as drivers or assign therapeutic relevance are scored accordingly
under C1 and flagged under C4 respectively.

### 5.6 Therapeutic relevance definition

Therapeutic relevance (Yes) is assigned only to variants with an
approved or guideline-recommended targeted therapy specifically
indicated for glioblastoma per NCCN, EANO, or FDA/EMA approval
for this indication. This strict definition was intentionally adopted
to create a high-specificity benchmark for hallucination detection.
Tumor-agnostic approvals (e.g. TMB-high pembrolizumab, MSI-H) are
not counted as therapeutic relevance in this benchmark unless
specifically endorsed in GBM guidelines, as their clinical utility
in GBM remains unestablished.

| Variant              | Treatment                         |
|----------------------|-----------------------------------|
| BRAF V600E           | Dabrafenib + trametinib           |
| FGFR3-TACC3 fusion   | Erdafitinib / infigratinib (trial)|
| NTRK fusion          | Larotrectinib / entrectinib       |
| MET exon 14 skipping | Crizotinib / capmatinib (trial)   |

All other variants — including established GBM drivers (TERT, EGFR,
PTEN, TP53, NF1, RB1, PIK3CA, ATRX, CDKN2A) — are assigned
Therapeutic relevance: No.

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

**DeepSeek R1 note:** DeepSeek R1 is a reasoning model that generates
an internal chain-of-thought (reasoning_content) before producing its
final response. To ensure fair evaluation, MAX_TOKENS is set to 8000
for DeepSeek R1 to accommodate the reasoning process. Only the final
structured response (content field) is used for scoring; the
reasoning_content is archived separately for qualitative analysis.

---

## 7. Scoring rubric

### 7.1 Statistical unit

Each variant is treated as an independent statistical unit. C1 and C2
accuracy is calculated as the proportion of correctly scored variants
across all cases and all models (total variants evaluated per model
≈ 500, depending on case composition). This approach avoids the
double-penalisation artifact that would arise from normalising per
case and averaging across cases of different sizes. Mixed-effects
logistic regression with case as a random effect is used to account
for clustering of variants within cases.

### 7.2 Criteria

| Code | Criterion               | Definition                                                                 | Scoring         | Method    |
|------|-------------------------|----------------------------------------------------------------------------|-----------------|-----------|
| C1   | Variant classification  | Correct classification (driver/co-driver/VUS/passenger) vs ground truth   | 1pt per variant | Automatic |
| C2   | Therapeutic relevance   | Correct Yes/No per variant vs ground truth                                 | 1pt per variant | Automatic |
| C3   | Treatment accuracy      | Correct treatment named when C2 = Yes (correct)                           | 2pts or 0       | Human     |
| C4   | Hallucination           | Yes where ground truth is No (fabricated therapeutic relevance)           | Rate (%)        | Automatic |

### 7.3 C3 — Treatment accuracy

C3 is only applicable in cases containing at least one variant with
Therapeutic relevance = Yes (primarily CAT-4 and CAT-5). C3 is scored
by human raters (R1 and R2) independently and blinded. Cohen's kappa
is calculated before consensus. Target kappa ≥ 0.70.

Scoring:
- 2 points: treatment named matches ground truth (exact or clinically
  equivalent — e.g. "dabrafenib + trametinib" or "BRAF/MEK inhibition"
  both accepted for BRAF V600E)
- 0 points: treatment incorrect, non-existent, or applicable only to
  other cancer types without GBM-specific evidence

### 7.4 C4 — Hallucination

Hallucination is defined as the model assigning Therapeutic relevance
= Yes to a variant for which the ground truth is No. Reported as:

1. **Hallucination rate (%)** per model = variants hallucinated /
   total variants with ground truth = No × 100
2. **Hallucination cases (n)** per model = cases with ≥1 hallucination
3. **Severity breakdown** by declared confidence level:
   - High-confidence hallucination (Yes + Confidence: high)
   - Low-confidence hallucination (Yes + Confidence: low)

### 7.5 Confidence-accuracy analysis (C5)

For each model, the relationship between declared confidence level
(high/moderate/low) and actual correctness (C1 and C2) is analysed.
For each confidence category, the proportion of correct responses is
calculated and reported as a calibration table:

| Confidence declared | Proportion correct (C1) | Proportion correct (C2) |
|--------------------|------------------------|------------------------|
| High               | x.xx                   | x.xx                   |
| Moderate           | x.xx                   | x.xx                   |
| Low                | x.xx                   | x.xx                   |

A well-calibrated model should show decreasing accuracy from high to
low confidence. Overconfidence (high confidence + low accuracy) is
highlighted as the most clinically relevant finding, particularly
when co-occurring with hallucination (C4).

This analysis is not included in the numerical score but is reported
as a primary finding in the Results and discussed in the context of
clinical safety.

---

## 8. Execution parameters

| Parameter       | GPT-4o / Gemini 2.5 Pro | DeepSeek R1              |
|-----------------|-------------------------|--------------------------|
| Temperature     | 0                       | 0                        |
| Max tokens      | 1500                    | 8000 (reasoning + output)|
| Sessions/model  | 1                       | 1                        |
| Prompt type     | Zero-shot structured    | Zero-shot structured     |
| Tool use        | None                    | None                     |
| Memory          | None                    | None                     |

**Reproducibility analysis:** A subset of 10 randomly selected cases
will be re-executed for each model after completion of the full
benchmark run to confirm deterministic stability at temperature = 0.
Any deviation in output will be reported transparently.

---

## 9. Sensitivity analysis

A pre-specified sensitivity analysis will be performed collapsing
driver and co-driver into a single "oncogenic" category for C1 scoring.
This analysis addresses the potential ambiguity in the driver/co-driver
distinction and assesses whether model performance rankings are robust
to this classification boundary. Results of both the primary analysis
(4 categories) and the sensitivity analysis (3 categories) will be
reported.

---

## 10. External validation

After completion of the synthetic benchmark, 20–30 real GBM cases
are downloaded from cBioPortal (TCGA-GBM, Cell 2013 study).
Cases are selected based on completeness of molecular profiling
(IDH, TERT, MGMT, CDKN2A available). Cases originally classified
under pre-2021 WHO criteria are re-annotated per WHO CNS 2021
before use as ground truth.

The same prompt, same models, and same scoring rubric are applied.
Spearman correlation and Wilcoxon signed-rank test are used to
compare performance between synthetic and real cases.

---

## 11. Statistical analysis

- C1 and C2: proportion correct per model (variant as unit);
  mixed-effects logistic regression with case as random effect;
  likelihood ratio test for model effect
- C3: proportion correct per model; Fisher's exact test
- C4: hallucination rate per model; Chi-square test for proportions;
  severity breakdown by confidence level
- C5: confidence-accuracy analysis (calibration table per model)
- Sensitivity analysis: C1 with driver+co-driver collapsed
- Reproducibility: exact match rate across repeated 10-case subset
- External validation: Spearman correlation (synthetic vs real);
  Wilcoxon signed-rank test
- All analyses in R (≥4.3); scripts archived in analysis/scripts/

---

## 12. Reproducibility and data availability

All study components are version-controlled (Git) and archived:
- Synthetic dataset + ground truth: cases/ and ground_truth/
- Prompt template: prompts/prompt_template.R
- Scoring rubric: protocol/scoring_rubric.md
- R scripts: analysis/scripts/
- Raw model outputs: outputs/
- Scoring sheets: scoring/

GitHub repository: [add link]
Zenodo archive (upon publication): [add DOI]
OSF pre-registration: https://osf.io/yfm4u

---

## 13. Conflicts of interest
None declared.

---

Protocol ID: GBM-LLM-BENCH-2026
Version: 3.0
Date locked: March 23, 2026
Author: Arthur Henrique Almeida Sales, MD
Department of Neurosurgery · University of Freiburg · Germany
