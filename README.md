# GBM-LLM-Benchmark

**Evaluation of Large Language Models for Automated Interpretation
of Tumor Genomic Profiles in Glioblastoma**

## Project structure

```
GBM-LLM-Benchmark/
├── protocol/              # Study protocol — pre-registered at OSF
├── cases/                 # 100 synthetic cases (CAT-1 to CAT-5)
│   ├── cat1_classic/
│   ├── cat2_therapeutic/
│   ├── cat3_vus_dominant/
│   ├── cat4_rare_mutations/
│   └── cat5_recurrence/
├── ground_truth/          # Ground truth JSON files (one per case)
├── prompts/               # Fixed zero-shot prompt template
├── outputs/               # Raw model outputs
│   ├── gpt4o/
│   ├── gemini25/
│   └── deepseek_r1/
├── scoring/               # Blinded human evaluation
│   ├── rater1/
│   ├── rater2/
│   └── consensus/
├── analysis/              # R scripts, figures and tables
│   ├── scripts/
│   ├── figures/
│   └── tables/
└── validation_external/   # External validation — TCGA-GBM (cBioPortal)
    ├── raw_data/
    ├── outputs/
    └── scoring/
```

## Models evaluated
- GPT-4o (OpenAI)
- Gemini 2.5 Pro (Google DeepMind)
- DeepSeek R1 (DeepSeek AI)

## Scoring criteria
| Criterion | Description                                      | Points | Evaluation |
|-----------|--------------------------------------------------|--------|------------|
| C1        | Variant identification and classification        | 8      | Automatic  |
| C2        | Specific clinical implications                   | 6      | Human      |
| C3        | Guideline alignment (EANO/NCCN/WHO 2021)         | 4      | Human      |
| C4        | Absence of hallucination (**veto if zero**)      | 6      | Mixed      |
| C5        | Uncertainty calibration                          | 6      | Human      |
| **Total** |                                                  | **30** |            |

## Pre-registration
Protocol pre-registered at OSF: https://osf.io/yfm4u

## How to reproduce
1. Clone this repository
2. Add your API keys to `.Renviron`
3. Restart R (Session > Restart R)
4. Run `analysis/scripts/01_run_benchmark.R`
5. Run `analysis/scripts/02_scoring_auto.R`
6. Complete human evaluation via `scoring/`
7. Run `analysis/scripts/03_analysis.R`

## Citation
[To be added upon publication]

