# =============================================================
# generate_tcga_validation_cases.R — GBM-LLM-Benchmark
# Formats 25 TCGA-GBM cases for external validation
# Version 2.0 — fixed numeric coercion for VAF
# =============================================================

library(tidyverse)
library(jsonlite)
library(here)

clinical <- read_tsv(
  here("validation_external","raw_data","data_clinical_sample.txt"),
  skip=4, show_col_types=FALSE)

maf2 <- read_tsv(
  here("validation_external","raw_data","gbm_tcga_pub2013","data_mutations.txt"),
  show_col_types=FALSE) |>
  mutate(
    t_alt_count = suppressWarnings(as.numeric(t_alt_count)),
    t_ref_count = suppressWarnings(as.numeric(t_ref_count))
  )

cna <- read_tsv(
  here("validation_external","raw_data","gbm_tcga_pub2013","data_cna.txt"),
  show_col_types=FALSE)

selected_ids <- c(
  "TCGA-19-1790-01","TCGA-32-1977-01","TCGA-19-2623-01","TCGA-32-4211-01",
  "TCGA-14-0813-01","TCGA-19-5955-01","TCGA-06-2559-01","TCGA-32-1979-01",
  "TCGA-14-0789-01","TCGA-06-0125-01","TCGA-06-2564-01","TCGA-76-4932-01",
  "TCGA-06-0879-01","TCGA-28-2509-01","TCGA-27-1833-01","TCGA-76-4926-01",
  "TCGA-02-0003-01","TCGA-14-1825-01","TCGA-76-6282-01","TCGA-14-0871-01",
  "TCGA-06-6390-01","TCGA-41-2573-01","TCGA-06-5411-01","TCGA-27-1832-01",
  "TCGA-06-0743-01"
)

get_cna <- function(sample_id, gene) {
  if (!sample_id %in% colnames(cna)) return(0)
  val <- cna |> filter(Hugo_Symbol == gene) |> pull(!!sym(sample_id))
  if (length(val) == 0) return(0)
  return(val[1])
}

classify_variant <- function(gene, hgvsp, variant_class) {
  if (gene == "TERT" && grepl("c\\.-124|c\\.-146", hgvsp))
    return(list(class="driver", oncokb_level="1", is_trap=FALSE))
  if (variant_class %in% c("Amplification")) {
    if (gene %in% c("EGFR","PDGFRA"))
      return(list(class="driver", oncokb_level="1", is_trap=FALSE))
    if (gene %in% c("CDK4","MDM2","MDM4","MET"))
      return(list(class="co-driver", oncokb_level="3", is_trap=FALSE))
    return(list(class="VUS", oncokb_level="none", is_trap=FALSE))
  }
  if (variant_class == "HomDel") {
    if (gene == "CDKN2A")
      return(list(class="driver", oncokb_level="1", is_trap=FALSE))
    if (gene == "PTEN")
      return(list(class="driver", oncokb_level="2", is_trap=FALSE))
  }
  driver_genes <- c("TERT","EGFR","PTEN","NF1")
  codriver_genes <- c("TP53","PIK3CA","PIK3R1","RB1","ATRX","IDH1","IDH2","PDGFRA")
  coding_classes <- c("Missense_Mutation","Nonsense_Mutation","Frame_Shift_Del",
                      "Frame_Shift_Ins","Splice_Site","In_Frame_Del","In_Frame_Ins",
                      "Nonstop_Mutation")
  passenger_genes <- c("TTN","MUC16","OBSCN","FLG","SYNE1","SYNE2","RYR2",
                       "HMCN1","DNAH5","DNAH11","MARCH4","MARCH6","SEPT4",
                       "SEPT9","SEPT10","SEPT11","SEPT14","A1BG","DEC1")
  if (gene %in% passenger_genes)
    return(list(class="passenger", oncokb_level="none", is_trap=TRUE))
  if (gene %in% driver_genes && variant_class %in% coding_classes)
    return(list(class="driver", oncokb_level="2", is_trap=FALSE))
  if (gene %in% codriver_genes && variant_class %in% coding_classes)
    return(list(class="co-driver", oncokb_level="3", is_trap=FALSE))
  return(list(class="VUS", oncokb_level="none", is_trap=FALSE))
}

get_top_variants <- function(sample_id) {
  priority_genes <- c("TERT","EGFR","PTEN","NF1","TP53","PIK3CA","PIK3R1",
                      "RB1","PDGFRA","IDH1","IDH2","BRAF","ATRX",
                      "CDKN2A","CDK4","MDM2","MET","FGFR3","NTRK1","NTRK2","NTRK3")
  maf2 |>
    filter(Tumor_Sample_Barcode == sample_id) |>
    filter(Variant_Classification != "Silent") |>
    mutate(
      vaf = ifelse(!is.na(t_alt_count) & !is.na(t_ref_count) &
                   (t_alt_count + t_ref_count) > 0,
                   t_alt_count / (t_alt_count + t_ref_count), NA_real_),
      is_priority = Hugo_Symbol %in% priority_genes
    ) |>
    arrange(desc(is_priority), desc(vaf)) |>
    slice_head(n=5)
}

get_cna_variants <- function(sample_id) {
  cna_vars <- list()
  if (get_cna(sample_id, "EGFR") >= 2)
    cna_vars[["EGFR"]] <- list(gene="EGFR", HGVSp_short="amplification",
      variant_classification="Amplification", variant_type="CNV",
      t_alt_count=NULL, t_ref_count=NULL, vaf=NULL)
  if (get_cna(sample_id, "CDKN2A") <= -2)
    cna_vars[["CDKN2A"]] <- list(gene="CDKN2A", HGVSp_short="homozygous_deletion",
      variant_classification="HomDel", variant_type="CNV",
      t_alt_count=NULL, t_ref_count=NULL, vaf=NULL)
  if (get_cna(sample_id, "PDGFRA") >= 2)
    cna_vars[["PDGFRA"]] <- list(gene="PDGFRA", HGVSp_short="amplification",
      variant_classification="Amplification", variant_type="CNV",
      t_alt_count=NULL, t_ref_count=NULL, vaf=NULL)
  return(cna_vars)
}

output_dir <- here("validation_external","cases")
dir.create(output_dir, recursive=TRUE, showWarnings=FALSE)

case_counter <- 1

for (sample_id in selected_ids) {
  case_id <- paste0("TCGA-VAL-", sprintf("%03d", case_counter))
  clin <- clinical |> filter(SAMPLE_ID == sample_id)
  if (nrow(clin) == 0) { message("[skip] ", sample_id); next }

  snv_vars <- get_top_variants(sample_id)
  cna_vars <- get_cna_variants(sample_id)

  variants <- list()
  for (v in cna_vars) variants[[length(variants)+1]] <- v
  for (i in seq_len(nrow(snv_vars))) {
    row <- snv_vars[i,]
    vaf_val <- if (!is.na(row$vaf)) round(row$vaf, 2) else NULL
    variants[[length(variants)+1]] <- list(
      gene = row$Hugo_Symbol,
      HGVSp_short = ifelse(!is.na(row$HGVSp_Short), row$HGVSp_Short, "p.?"),
      variant_classification = row$Variant_Classification,
      variant_type = row$Variant_Type,
      t_alt_count = if(!is.na(row$t_alt_count)) as.integer(row$t_alt_count) else NULL,
      t_ref_count = if(!is.na(row$t_ref_count)) as.integer(row$t_ref_count) else NULL,
      vaf = vaf_val
    )
  }
  variants <- variants[seq_len(min(5, length(variants)))]

  classifications <- list()
  therapeutic_relevance <- list()
  for (v in variants) {
    gt <- classify_variant(v$gene, v$HGVSp_short, v$variant_classification)
    classifications[[v$gene]] <- gt
    therapeutic_relevance[[v$gene]] <- list(relevant=FALSE, treatment=NULL)
  }

  cdkn2a_status <- if (get_cna(sample_id, "CDKN2A") <= -2) "homozygous deletion" else "intact"
  mgmt_val <- if (!is.na(clin$MGMT_STATUS)) clin$MGMT_STATUS else "UNKNOWN"

  case <- list(
    case_id = case_id,
    tcga_id = sample_id,
    category = "TCGA_VAL",
    difficulty = "real_world",
    clinical_info = list(
      patient_id=sample_id, sex=NA_character_, age=NA_real_,
      location="not reported", sample="surgical resection", sample_type="Primary"
    ),
    profile = list(
      molecular_status = list(
        IDH1_mutation="WT", MGMT_status=mgmt_val,
        G_CIMP_methylation=ifelse(!is.na(clin$G_CIMP_METHYLATION),
                                   clin$G_CIMP_METHYLATION, "non-G-CIMP"),
        CDKN2A=cdkn2a_status,
        TMB_nonsynonymous=if(!is.na(clin$TMB_NONSYNONYMOUS))
          round(clin$TMB_NONSYNONYMOUS, 2) else NA,
        expression_subtype=clin$EXPRESSION_SUBTYPE
      ),
      variants = variants
    ),
    ground_truth = list(
      classifications = classifications,
      therapeutic_relevance = therapeutic_relevance,
      note = "Ground truth annotated by PI — review before running models"
    )
  )

  out_path <- file.path(output_dir, paste0(case_id, ".json"))
  write_json(case, out_path, auto_unbox=TRUE, pretty=TRUE, null="null")
  message("[saved] ", case_id, " (", sample_id, ") — ",
          length(variants), " variants — MGMT: ", mgmt_val)
  case_counter <- case_counter + 1
}

message("\n>>> ", case_counter-1, " cases saved to validation_external/cases/")
message(">>> Review ground truth before running models")
