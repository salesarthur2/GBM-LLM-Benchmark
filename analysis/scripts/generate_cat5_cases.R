# =============================================================
# generate_cat5_cases.R — GBM-LLM-Benchmark
# Generates 10 CAT-5 cases (GBM-092 to GBM-101)
# Recurrent GBM post-Stupp protocol
# Therapeutic relevance = Yes for select variants:
#   - BRAF V600E → dabrafenib + trametinib
#   - NTRK fusion → larotrectinib / entrectinib
#   - MSI-H → pembrolizumab
#   - TMB-high (>=10 mut/Mb) → pembrolizumab
# =============================================================

library(jsonlite)
library(here)

cases <- list(

  # GBM-092 | Male 56y | Frontal recurrence | BRAF V600E — YES
  # CAT-5 feature: BRAF V600E post-Stupp → dabrafenib + trametinib
  # Trap: MUC16
  list(
    case_id = "GBM-092", category = "CAT-5", difficulty = "high",
    clinical_info = list(
      patient_id="SYN-092", sex="Male", age=56.4,
      location="frontal lobe", sample="surgical resection",
      sample_type="Recurrence",
      clinical_context="Recurrent GBM following standard Stupp protocol (60Gy RT + concurrent and adjuvant temozolomide). Progression confirmed on MRI at 8 months post-diagnosis."
    ),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=5.2, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=79, t_ref_count=21, vaf=0.79),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=21),
        list(gene="BRAF",  HGVSp_short="p.V600E",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=44, t_ref_count=56, vaf=0.44),
        list(gene="PTEN",  HGVSp_short="p.R130Q",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=38, t_ref_count=62, vaf=0.38),
        list(gene="MUC16", HGVSp_short="p.P5257L",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=9,  t_ref_count=91, vaf=0.09)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        BRAF=list(class="driver",oncokb_level="2",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        EGFR=list(relevant=FALSE,treatment=NULL),
        BRAF=list(relevant=TRUE,treatment="dabrafenib + trametinib"),
        PTEN=list(relevant=FALSE,treatment=NULL),
        MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      cat5_feature = "BRAF V600E in recurrent GBM post-Stupp — therapeutic relevance Yes; dabrafenib + trametinib (FDA tumor-agnostic approval 2022, requires prior treatment)",
      hallucination_traps = list(
        "MUC16 is a passenger",
        "EGFR amplification has no approved targeted therapy — do not suggest EGFR inhibitors",
        "PTEN loss has no approved targeted therapy in GBM"
      )
    )
  ),

  # GBM-093 | Female 62y | Temporal recurrence | NTRK fusion — YES
  # CAT-5 feature: NTRK1 fusion post-Stupp → larotrectinib / entrectinib
  # Trap: TTN
  list(
    case_id = "GBM-093", category = "CAT-5", difficulty = "high",
    clinical_info = list(
      patient_id="SYN-093", sex="Female", age=62.1,
      location="temporal lobe", sample="stereotactic biopsy",
      sample_type="Recurrence",
      clinical_context="Recurrent GBM following Stupp protocol. Progression at 10 months. Re-biopsy performed for molecular profiling at recurrence."
    ),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=4.8, expression_subtype="Proneural"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-146C>T",     variant_classification="Promoter",      variant_type="SNP", t_alt_count=74, t_ref_count=26, vaf=0.74),
        list(gene="NTRK1", HGVSp_short="fusion",        variant_classification="Fusion",        variant_type="SV",  t_alt_count=NULL, t_ref_count=NULL, vaf=NULL),
        list(gene="PTEN",  HGVSp_short="p.C136R",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=40, t_ref_count=60, vaf=0.40),
        list(gene="NF1",   HGVSp_short="p.R1947*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=33, t_ref_count=67, vaf=0.33),
        list(gene="TTN",   HGVSp_short="p.R14023C",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=6,  t_ref_count=94, vaf=0.06)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        NTRK1=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        NF1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        NTRK1=list(relevant=TRUE,treatment="larotrectinib or entrectinib"),
        PTEN=list(relevant=FALSE,treatment=NULL),
        NF1=list(relevant=FALSE,treatment=NULL),
        TTN=list(relevant=FALSE,treatment=NULL)
      ),
      cat5_feature = "NTRK1 fusion in recurrent GBM — therapeutic relevance Yes; larotrectinib or entrectinib (FDA/EMA tumor-agnostic approval, any line)",
      hallucination_traps = list(
        "TTN is a passenger",
        "NF1 loss has no approved targeted therapy in GBM",
        "PTEN loss has no approved targeted therapy in GBM"
      )
    )
  ),

  # GBM-094 | Male 59y | Parietal recurrence | TMB-high — YES
  # CAT-5 feature: TMB >= 10 mut/Mb post-Stupp → pembrolizumab
  # Trap: OBSCN
  list(
    case_id = "GBM-094", category = "CAT-5", difficulty = "high",
    clinical_info = list(
      patient_id="SYN-094", sex="Male", age=59.7,
      location="parietal lobe", sample="surgical resection",
      sample_type="Recurrence",
      clinical_context="Recurrent GBM post-Stupp. Hypermutator phenotype identified at recurrence, likely TMZ-induced. TMB 14.2 mut/Mb confirmed on comprehensive NGS panel."
    ),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=14.2, expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=78, t_ref_count=22, vaf=0.78),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=19),
        list(gene="MSH6",  HGVSp_short="p.T1219I",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=38, t_ref_count=62, vaf=0.38),
        list(gene="PTEN",  HGVSp_short="p.R130*",       variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=41, t_ref_count=59, vaf=0.41),
        list(gene="OBSCN", HGVSp_short="p.A6506T",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=7,  t_ref_count=93, vaf=0.07)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        MSH6=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        OBSCN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        EGFR=list(relevant=FALSE,treatment=NULL),
        MSH6=list(relevant=TRUE,treatment="pembrolizumab (TMB-high >= 10 mut/Mb)"),
        PTEN=list(relevant=FALSE,treatment=NULL),
        OBSCN=list(relevant=FALSE,treatment=NULL)
      ),
      cat5_feature = "TMB-high (14.2 mut/Mb) with MSH6 mutation at recurrence — TMZ-induced hypermutator phenotype; pembrolizumab indicated (FDA tumor-agnostic TMB-high approval)",
      hallucination_traps = list(
        "OBSCN is a passenger",
        "EGFR amplification has no approved targeted therapy — do not suggest EGFR inhibitors",
        "MSH6 mutation here scores therapeutic relevance via TMB-high status, not as a standalone target"
      )
    )
  ),

  # GBM-095 | Female 51y | Frontal recurrence | MSI-H — YES
  # CAT-5 feature: MSI-H at recurrence → pembrolizumab
  # Trap: MUC16
  list(
    case_id = "GBM-095", category = "CAT-5", difficulty = "high",
    clinical_info = list(
      patient_id="SYN-095", sex="Female", age=51.3,
      location="frontal lobe", sample="surgical resection",
      sample_type="Recurrence",
      clinical_context="Recurrent GBM post-Stupp. MSI-H status confirmed by PCR and NGS at recurrence. Prior treatment: 60Gy RT + 6 cycles TMZ."
    ),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=18.6, MSI_status="MSI-H", expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-146C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=72, t_ref_count=28, vaf=0.72),
        list(gene="PTEN",  HGVSp_short="p.R233*",       variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=43, t_ref_count=57, vaf=0.43),
        list(gene="MLH1",  HGVSp_short="p.R217*",       variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=35, t_ref_count=65, vaf=0.35),
        list(gene="TP53",  HGVSp_short="p.R248W",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=28, t_ref_count=72, vaf=0.28),
        list(gene="MUC16", HGVSp_short="p.R10506H",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=9,  t_ref_count=91, vaf=0.09)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        MLH1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        TP53=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL),
        MLH1=list(relevant=TRUE,treatment="pembrolizumab (MSI-H)"),
        TP53=list(relevant=FALSE,treatment=NULL),
        MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      cat5_feature = "MSI-H status with MLH1 loss at recurrence — pembrolizumab indicated (FDA tumor-agnostic MSI-H approval 2017)",
      hallucination_traps = list(
        "MUC16 is a passenger",
        "PTEN loss has no approved targeted therapy in GBM",
        "TP53 has no approved targeted therapy in GBM"
      )
    )
  ),

  # GBM-096 | Male 64y | Temporal recurrence | BRAF V600E + hypermutation
  # CAT-5 feature: BRAF V600E post-Stupp → Yes; TMB 9.1 → No (below threshold)
  # Trap: TTN
  list(
    case_id = "GBM-096", category = "CAT-5", difficulty = "high",
    clinical_info = list(
      patient_id="SYN-096", sex="Male", age=64.8,
      location="temporal lobe", sample="surgical resection",
      sample_type="Recurrence",
      clinical_context="Recurrent GBM post-Stupp at 7 months. BRAF V600E identified on re-biopsy NGS panel. TMB borderline at 9.1 mut/Mb."
    ),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=9.1, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=80, t_ref_count=20, vaf=0.80),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=18),
        list(gene="BRAF",  HGVSp_short="p.V600E",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=41, t_ref_count=59, vaf=0.41),
        list(gene="NF1",   HGVSp_short="p.Q1966*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=34, t_ref_count=66, vaf=0.34),
        list(gene="TTN",   HGVSp_short="p.G22391R",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=6,  t_ref_count=94, vaf=0.06)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        BRAF=list(class="driver",oncokb_level="2",is_trap=FALSE),
        NF1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        EGFR=list(relevant=FALSE,treatment=NULL),
        BRAF=list(relevant=TRUE,treatment="dabrafenib + trametinib"),
        NF1=list(relevant=FALSE,treatment=NULL),
        TTN=list(relevant=FALSE,treatment=NULL)
      ),
      cat5_feature = "BRAF V600E post-Stupp → Yes (dabrafenib + trametinib); TMB 9.1 mut/Mb → No (below 10 mut/Mb FDA threshold for pembrolizumab)",
      hallucination_traps = list(
        "TTN is a passenger",
        "TMB 9.1 mut/Mb is BELOW the 10 mut/Mb threshold — pembrolizumab not indicated",
        "NF1 loss has no approved targeted therapy in GBM",
        "EGFR amplification has no approved targeted therapy in GBM"
      )
    )
  ),

  # GBM-097 | Female 58y | Frontal recurrence | NTRK3 fusion — YES
  # CAT-5 feature: NTRK3 fusion post-Stupp → larotrectinib / entrectinib
  # Trap: OBSCN
  list(
    case_id = "GBM-097", category = "CAT-5", difficulty = "high",
    clinical_info = list(
      patient_id="SYN-097", sex="Female", age=58.6,
      location="frontal lobe", sample="surgical resection",
      sample_type="Recurrence",
      clinical_context="Recurrent GBM post-Stupp at 9 months. RNA sequencing at recurrence identified NTRK3 fusion. Prior treatment: 60Gy RT + 6 cycles TMZ."
    ),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=6.3, expression_subtype="Proneural"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-146C>T",     variant_classification="Promoter",      variant_type="SNP", t_alt_count=73, t_ref_count=27, vaf=0.73),
        list(gene="PDGFRA",HGVSp_short="amplification", variant_classification="Amplification", variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=13),
        list(gene="NTRK3", HGVSp_short="fusion",        variant_classification="Fusion",        variant_type="SV",  t_alt_count=NULL, t_ref_count=NULL, vaf=NULL),
        list(gene="PTEN",  HGVSp_short="p.R173H",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=39, t_ref_count=61, vaf=0.39),
        list(gene="OBSCN", HGVSp_short="p.R5517C",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=7,  t_ref_count=93, vaf=0.07)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PDGFRA=list(class="driver",oncokb_level="2",is_trap=FALSE),
        NTRK3=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        OBSCN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        PDGFRA=list(relevant=FALSE,treatment=NULL),
        NTRK3=list(relevant=TRUE,treatment="larotrectinib or entrectinib"),
        PTEN=list(relevant=FALSE,treatment=NULL),
        OBSCN=list(relevant=FALSE,treatment=NULL)
      ),
      cat5_feature = "NTRK3 fusion in recurrent GBM — therapeutic relevance Yes; larotrectinib or entrectinib (FDA/EMA tumor-agnostic approval)",
      hallucination_traps = list(
        "OBSCN is a passenger",
        "PDGFRA amplification has no approved targeted therapy in GBM",
        "PTEN loss has no approved targeted therapy in GBM"
      )
    )
  ),

  # GBM-098 | Male 55y | Occipital recurrence | TMB-high + POLE — YES
  # CAT-5 feature: TMB-high (11.8) with POLE mutation → pembrolizumab
  # Trap: MUC16
  list(
    case_id = "GBM-098", category = "CAT-5", difficulty = "high",
    clinical_info = list(
      patient_id="SYN-098", sex="Male", age=55.9,
      location="occipital lobe", sample="surgical resection",
      sample_type="Recurrence",
      clinical_context="Recurrent GBM post-Stupp at 11 months. POLE pathogenic variant with TMB-high confirmed at recurrence. Prior: 60Gy RT + 6 cycles TMZ."
    ),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=11.8, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=77, t_ref_count=23, vaf=0.77),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=20),
        list(gene="POLE",  HGVSp_short="p.P286R",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=36, t_ref_count=64, vaf=0.36),
        list(gene="PTEN",  HGVSp_short="p.R130Q",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=40, t_ref_count=60, vaf=0.40),
        list(gene="MUC16", HGVSp_short="p.S11377F",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=8,  t_ref_count=92, vaf=0.08)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        POLE=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        EGFR=list(relevant=FALSE,treatment=NULL),
        POLE=list(relevant=TRUE,treatment="pembrolizumab (TMB-high >= 10 mut/Mb)"),
        PTEN=list(relevant=FALSE,treatment=NULL),
        MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      cat5_feature = "POLE p.P286R pathogenic variant with TMB-high (11.8 mut/Mb) at recurrence — pembrolizumab indicated via TMB-high FDA approval",
      hallucination_traps = list(
        "MUC16 is a passenger",
        "EGFR amplification has no approved targeted therapy in GBM",
        "PTEN loss has no approved targeted therapy in GBM"
      )
    )
  ),

  # GBM-099 | Female 67y | Temporal recurrence | BRAF V600E — YES
  # CAT-5 feature: BRAF V600E post-Stupp + MGMT methylated
  # Trap: TTN
  list(
    case_id = "GBM-099", category = "CAT-5", difficulty = "high",
    clinical_info = list(
      patient_id="SYN-099", sex="Female", age=67.2,
      location="temporal lobe", sample="stereotactic biopsy",
      sample_type="Recurrence",
      clinical_context="Recurrent GBM post-Stupp at 14 months. BRAF V600E confirmed on liquid biopsy and tissue re-biopsy. Prior treatment: 60Gy RT + 6 cycles TMZ."
    ),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=4.9, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=81, t_ref_count=19, vaf=0.81),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=17),
        list(gene="BRAF",  HGVSp_short="p.V600E",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=39, t_ref_count=61, vaf=0.39),
        list(gene="TP53",  HGVSp_short="p.R273H",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=27, t_ref_count=73, vaf=0.27),
        list(gene="TTN",   HGVSp_short="p.R19544W",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=5,  t_ref_count=95, vaf=0.05)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        BRAF=list(class="driver",oncokb_level="2",is_trap=FALSE),
        TP53=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        EGFR=list(relevant=FALSE,treatment=NULL),
        BRAF=list(relevant=TRUE,treatment="dabrafenib + trametinib"),
        TP53=list(relevant=FALSE,treatment=NULL),
        TTN=list(relevant=FALSE,treatment=NULL)
      ),
      cat5_feature = "BRAF V600E in recurrent GBM post-Stupp — therapeutic relevance Yes; dabrafenib + trametinib (FDA tumor-agnostic approval)",
      hallucination_traps = list(
        "TTN is a passenger",
        "EGFR amplification has no approved targeted therapy in GBM",
        "TP53 has no approved targeted therapy in GBM"
      )
    )
  ),

  # GBM-100 | Male 53y | Frontal recurrence | NTRK2 fusion — YES + BRAF V600E — YES
  # CAT-5 feature: Two actionable variants — NTRK2 + co-occurring BRAF V600E
  # Trap: OBSCN
  list(
    case_id = "GBM-100", category = "CAT-5", difficulty = "high",
    clinical_info = list(
      patient_id="SYN-100", sex="Male", age=53.4,
      location="frontal lobe", sample="surgical resection",
      sample_type="Recurrence",
      clinical_context="Recurrent GBM post-Stupp at 6 months. Comprehensive NGS + RNA sequencing identified two potentially actionable variants. Prior: 60Gy RT + 6 cycles TMZ."
    ),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=5.7, expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-146C>T",     variant_classification="Promoter",      variant_type="SNP", t_alt_count=75, t_ref_count=25, vaf=0.75),
        list(gene="NTRK2", HGVSp_short="fusion",        variant_classification="Fusion",        variant_type="SV",  t_alt_count=NULL, t_ref_count=NULL, vaf=NULL),
        list(gene="BRAF",  HGVSp_short="p.V600E",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=36, t_ref_count=64, vaf=0.36),
        list(gene="PTEN",  HGVSp_short="p.C136Y",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=42, t_ref_count=58, vaf=0.42),
        list(gene="OBSCN", HGVSp_short="p.T3821M",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=7,  t_ref_count=93, vaf=0.07)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        NTRK2=list(class="driver",oncokb_level="1",is_trap=FALSE),
        BRAF=list(class="driver",oncokb_level="2",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        OBSCN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        NTRK2=list(relevant=TRUE,treatment="larotrectinib or entrectinib"),
        BRAF=list(relevant=TRUE,treatment="dabrafenib + trametinib"),
        PTEN=list(relevant=FALSE,treatment=NULL),
        OBSCN=list(relevant=FALSE,treatment=NULL)
      ),
      cat5_feature = "Two actionable variants: NTRK2 fusion (larotrectinib/entrectinib) and BRAF V600E (dabrafenib+trametinib) in recurrent GBM — both therapeutic relevance Yes",
      hallucination_traps = list(
        "OBSCN is a passenger",
        "PTEN loss has no approved targeted therapy in GBM",
        "Priority discussion for tumor board: NTRK inhibition vs BRAF/MEK inhibition — both valid but not combinable as standard"
      )
    )
  ),

  # GBM-101 | Female 60y | Temporal recurrence | MSI-H + TMB-high — YES
  # CAT-5 feature: MSI-H confirmed + TMB 22.4 — pembrolizumab
  # Trap: MUC16
  list(
    case_id = "GBM-101", category = "CAT-5", difficulty = "high",
    clinical_info = list(
      patient_id="SYN-101", sex="Female", age=60.5,
      location="temporal lobe", sample="surgical resection",
      sample_type="Recurrence",
      clinical_context="Recurrent GBM post-Stupp at 12 months. MSI-H confirmed by PCR. TMB 22.4 mut/Mb on NGS. Likely TMZ-induced hypermutator with MMR deficiency. Prior: 60Gy RT + 6 cycles TMZ."
    ),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=22.4, MSI_status="MSI-H", expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=76, t_ref_count=24, vaf=0.76),
        list(gene="PTEN",  HGVSp_short="p.R130*",       variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=44, t_ref_count=56, vaf=0.44),
        list(gene="MSH2",  HGVSp_short="p.R359*",       variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=37, t_ref_count=63, vaf=0.37),
        list(gene="TP53",  HGVSp_short="p.R175H",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=26, t_ref_count=74, vaf=0.26),
        list(gene="MUC16", HGVSp_short="p.A8525T",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=9,  t_ref_count=91, vaf=0.09)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        MSH2=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        TP53=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL),
        MSH2=list(relevant=TRUE,treatment="pembrolizumab (MSI-H and TMB-high >= 10 mut/Mb)"),
        TP53=list(relevant=FALSE,treatment=NULL),
        MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      cat5_feature = "MSI-H + TMB-high (22.4 mut/Mb) with MSH2 loss at recurrence — pembrolizumab indicated via both MSI-H and TMB-high FDA tumor-agnostic approvals",
      hallucination_traps = list(
        "MUC16 is a passenger",
        "PTEN loss has no approved targeted therapy in GBM",
        "TP53 has no approved targeted therapy in GBM"
      )
    )
  )
)

# Save all cases to cases/cat5_recurrent/
output_dir <- here("cases", "cat5_recurrent")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

for (case in cases) {
  out_path <- file.path(output_dir, paste0(case$case_id, ".json"))
  write_json(case, out_path, auto_unbox = TRUE, pretty = TRUE)
  message("[saved] ", case$case_id, " — ", case$clinical_info$sex,
          " ", case$clinical_info$age, "y — ", case$clinical_info$location,
          " — ", case$ground_truth$cat5_feature)
}

message("\n>>> 10 CAT-5 cases saved to cases/cat5_recurrent/")
message(">>> GBM-092 to GBM-101 complete")
message("\n>>> DATASET COMPLETE: 100 cases total")
message(">>> CAT-1: 20 cases (GBM-002 to GBM-021)")
message(">>> CAT-2: 25 cases (GBM-022 to GBM-046)")
message(">>> CAT-3: 25 cases (GBM-047 to GBM-071)")
message(">>> CAT-4: 20 cases (GBM-072 to GBM-091)")
message(">>> CAT-5: 10 cases (GBM-092 to GBM-101)")
message("\n>>> Next step: run full benchmark with 01_run_gpt4o.R, 01_run_gemini25.R, 01_run_deepseek_r1.R")
message(">>> Set RUN_PILOT <- FALSE in each script before running full benchmark")
