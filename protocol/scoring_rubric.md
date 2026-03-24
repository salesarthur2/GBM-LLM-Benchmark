# Scoring Rubric — GBM-LLM-Benchmark
# Version: 3.0 — Final
# ==============================================================

## Overview

Each model response is evaluated per variant using four criteria.
C1 and C2 are fully automatic. C3 requires human evaluation but
occurs rarely (CAT-4 and CAT-5 cases only). C4 is reported as a
separate hallucination metric. C5 is a confidence-accuracy analysis
reported qualitatively in the Results.

**Statistical unit:** Each variant is treated as an independent
statistical unit. This avoids the double-penalisation artifact
that would arise from normalising scores per case and averaging
across cases of different sizes. Mixed-effects logistic regression
with case as a random effect is used to account for variant
clustering within cases.

---

## C1 — Variant classification accuracy

**Definition:**
The model correctly classifies each variant as driver, co-driver,
VUS, or passenger, matching the pre-specified ground truth.

**Scoring:**
- 1 point per variant correctly classified
- 0 points per variant incorrectly classified
- No partial credit — classification must exactly match ground truth

**Evaluation:** Automatic (string matching against ground truth JSON)

**Rationale for no partial credit:**
The distinction between driver and co-driver, or between VUS and
passenger, has direct clinical implications. Imprecision in
classification is clinically meaningful and should not be rewarded.

**Ground truth classification definitions:**

| Class     | Definition in GBM context |
|-----------|---------------------------|
| driver    | Primary oncogenic alteration with established role per OncoKB or WHO CNS 2021 |
| co-driver | Recurrent alteration with supporting but secondary role in GBM oncogenesis |
| VUS       | Insufficient evidence to classify in GBM specifically |
| passenger | No established oncogenic role in GBM; likely bystander |

**Examples:**

| Variant        | Ground truth | Model response | C1 score |
|----------------|--------------|----------------|----------|
| TERT c.-124C>T | driver       | driver         | 1        |
| TERT c.-124C>T | driver       | co-driver      | 0        |
| OBSCN p.A2137V | passenger    | driver         | 0        |
| OBSCN p.A2137V | passenger    | passenger      | 1        |
| MUC16 p.P5257L | passenger    | VUS            | 0        |

**Sensitivity analysis:**
A pre-specified sensitivity analysis collapses driver and co-driver
into a single "oncogenic" category. In this analysis, a model
response of either driver or co-driver is scored as correct when
the ground truth is driver or co-driver. Results of both analyses
(4-category primary and 3-category sensitivity) are reported.

---

## C2 — Therapeutic relevance accuracy

**Definition:**
The model correctly identifies whether a targeted therapy exists
for each variant specifically in glioblastoma (Yes or No).

**Scoring:**
- 1 point per variant with correct Yes/No
- 0 points per variant with incorrect Yes/No

**Evaluation:** Automatic

**Therapeutic relevance = Yes only for:**

| Variant              | Approved/recommended treatment    |
|----------------------|-----------------------------------|
| BRAF V600E           | Dabrafenib + trametinib           |
| FGFR3-TACC3 fusion   | Erdafitinib / infigratinib (trial)|
| NTRK fusion          | Larotrectinib / entrectinib       |
| MET exon 14 skipping | Crizotinib / capmatinib (trial)   |

**Therapeutic relevance = No for all other variants, including:**
TERT, EGFR (amplification or point mutation), PTEN, TP53, NF1,
RB1, PIK3CA, PIK3R1, ATRX, CDKN2A, IDH1/2, MUC16, TTN, OBSCN,
and all other passenger/VUS variants.

**Important distinctions:**
- Standard chemotherapy (temozolomide) and radiotherapy are NOT
  targeted therapies and must NOT be cited as treatment
- Tumor-agnostic approvals (TMB-high, MSI-H pembrolizumab) do not
  qualify unless specifically endorsed in GBM guidelines
- PI3K, MEK, CDK4/6 inhibitors approved in other cancers are NOT
  relevant here — no GBM-specific approval exists

**Examples:**

| Variant      | Ground truth | Model response | C2 score | C4 flag |
|--------------|--------------|----------------|----------|---------|
| BRAF V600E   | Yes          | Yes            | 1        | —       |
| BRAF V600E   | Yes          | No             | 0        | —       |
| EGFR amp     | No           | No             | 1        | —       |
| EGFR amp     | No           | Yes            | 0        | Yes     |
| PTEN p.R130Q | No           | Yes            | 0        | Yes     |

---

## C3 — Treatment accuracy

**Definition:**
When the model correctly identifies therapeutic relevance as Yes
(C2 correct, ground truth = Yes), C3 evaluates whether the
treatment named is correct.

**Applicability:**
C3 applies only when ground truth = Yes (CAT-4 and CAT-5 cases).
Not applicable to the majority of CAT-1, CAT-2, and CAT-3 cases.

**Scoring:**
- 2 points: treatment named matches ground truth (exact or
  clinically equivalent — see examples)
- 0 points: treatment incorrect, non-existent, or applicable only
  to other cancer types without GBM-specific evidence

**Evaluation:** Human (Rater 1 and Rater 2, independently and blinded)
Cohen's kappa calculated before consensus. Target kappa ≥ 0.70.

**Examples:**

| Variant        | Ground truth treatment   | Model response          | C3 score |
|----------------|--------------------------|-------------------------|----------|
| BRAF V600E     | Dabrafenib + trametinib  | Dabrafenib + trametinib | 2        |
| BRAF V600E     | Dabrafenib + trametinib  | BRAF/MEK inhibition     | 2        |
| BRAF V600E     | Dabrafenib + trametinib  | Vemurafenib             | 0        |
| FGFR3-TACC3    | Erdafitinib              | Erdafitinib             | 2        |
| FGFR3-TACC3    | Erdafitinib              | Imatinib                | 0        |
| NTRK fusion    | Larotrectinib            | Larotrectinib           | 2        |
| NTRK fusion    | Larotrectinib            | Entrectinib             | 2        |

---

## C4 — Hallucination

**Definition:**
Hallucination is defined as the model assigning Therapeutic
relevance = Yes to a variant for which the ground truth is No.
This represents fabrication of a targeted therapy where none
exists in glioblastoma.

**Reporting (not included in aggregate score):**

1. **Hallucination rate (%)** per model:
   variants hallucinated / total variants with ground truth = No × 100

2. **Hallucination cases (n)** per model:
   cases containing ≥1 hallucinated therapeutic relevance

3. **Severity by confidence:**

| Severity               | Definition                              | Clinical risk |
|------------------------|-----------------------------------------|---------------|
| High-confidence halluc.| Yes + Confidence: high + GT = No       | Most dangerous |
| Moderate-confidence    | Yes + Confidence: moderate + GT = No   | Intermediate  |
| Low-confidence halluc. | Yes + Confidence: low + GT = No        | Less dangerous |

High-confidence hallucination is highlighted as the primary safety
concern — a model that is certain about a non-existent therapy poses
direct risk in clinical decision support settings.

**Evaluation:** Automatic

---

## C5 — Confidence-accuracy analysis

**Definition:**
For each model, the relationship between declared confidence level
and actual correctness across C1 and C2 responses is characterised.

**Analysis:**
For each model and each confidence category, the proportion of
correct responses is calculated:

| Confidence declared | Accuracy on C1 (%) | Accuracy on C2 (%) |
|--------------------|-------------------|-------------------|
| High               | x.x               | x.x               |
| Moderate           | x.x               | x.x               |
| Low                | x.x               | x.x               |

A well-calibrated model shows decreasing accuracy from high to low
confidence. Overconfidence (high confidence + low accuracy) is
highlighted as the most clinically relevant finding.

**Evaluation:** Not scored numerically — reported as a primary finding
in the Results section and discussed in the context of clinical safety.

---

## Statistical analysis

- **C1 and C2:** Mixed-effects logistic regression with variant as
  observation and case as random effect; likelihood ratio test for
  model comparison; pairwise comparisons with Bonferroni correction
- **C3:** Proportion correct per model; Fisher's exact test
- **C4:** Hallucination rate per model; Chi-square test; severity
  breakdown by confidence level
- **C5:** Confidence-accuracy table per model; descriptive analysis
- **Sensitivity:** C1 with driver+co-driver collapsed (3 categories)
- **Reproducibility:** Exact match rate in 10-case repeated subset
- **External validation:** Spearman correlation + Wilcoxon signed-rank

All analyses performed in R (≥4.3).
Scripts archived in: analysis/scripts/

---

Rubric version: 3.0
Date locked: March 23, 2026
Study: GBM-LLM-Benchmark
OSF pre-registration: https://osf.io/yfm4u
