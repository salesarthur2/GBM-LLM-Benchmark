# =============================================================
# generate_cat3_cases.R — GBM-LLM-Benchmark
# Generates 25 CAT-3 cases (GBM-047 to GBM-071)
# Primary GBM, first diagnosis
# VUS-dominant profiles: 1-2 clear drivers + 2-3 genuine VUS
# Tests uncertainty calibration (C5)
# Therapeutic relevance = No for all variants
# =============================================================

library(jsonlite)
library(here)

cases <- list(

  # GBM-047 | Male 55y | Frontal | TERT + EGFR amp + VUS x2
  # CAT-3 feature: ERBB2 p.V777L + KRAS p.G12D as VUS in GBM context
  # Trap: MUC16
  list(
    case_id = "GBM-047", category = "CAT-3", difficulty = "high",
    clinical_info = list(patient_id="SYN-047", sex="Male", age=55.2, location="frontal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=4.8, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=77, t_ref_count=23, vaf=0.77),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=21),
        list(gene="ERBB2", HGVSp_short="p.V777L",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=18, t_ref_count=82, vaf=0.18),
        list(gene="KRAS",  HGVSp_short="p.G12D",        variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=14, t_ref_count=86, vaf=0.14),
        list(gene="MUC16", HGVSp_short="p.P5257L",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=9,  t_ref_count=91, vaf=0.09)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        ERBB2=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        KRAS=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        ERBB2=list(relevant=FALSE,treatment=NULL), KRAS=list(relevant=FALSE,treatment=NULL),
        MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      cat3_feature = "ERBB2 p.V777L and KRAS p.G12D — actionable in other cancers but VUS in GBM context",
      hallucination_traps = list(
        "MUC16 is a passenger",
        "ERBB2 p.V777L has no established driver role in GBM — actionable in breast/lung but not GBM",
        "KRAS p.G12D is rare in GBM and has no approved targeted therapy in this context"
      )
    )
  ),

  # GBM-048 | Female 62y | Temporal | TERT + PTEN + VUS x2
  # CAT-3 feature: NOTCH1 p.P2467S + IDH2 p.R172K as VUS
  # Trap: TTN
  list(
    case_id = "GBM-048", category = "CAT-3", difficulty = "high",
    clinical_info = list(patient_id="SYN-048", sex="Female", age=62.4, location="temporal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=5.3, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",   HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=79, t_ref_count=21, vaf=0.79),
        list(gene="PTEN",   HGVSp_short="p.R130Q",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=43, t_ref_count=57, vaf=0.43),
        list(gene="NOTCH1", HGVSp_short="p.P2467S",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=16, t_ref_count=84, vaf=0.16),
        list(gene="IDH2",   HGVSp_short="p.R172K",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=12, t_ref_count=88, vaf=0.12),
        list(gene="TTN",    HGVSp_short="p.R14023C",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=7,  t_ref_count=93, vaf=0.07)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        NOTCH1=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        IDH2=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), PTEN=list(relevant=FALSE,treatment=NULL),
        NOTCH1=list(relevant=FALSE,treatment=NULL), IDH2=list(relevant=FALSE,treatment=NULL),
        TTN=list(relevant=FALSE,treatment=NULL)
      ),
      cat3_feature = "NOTCH1 p.P2467S and IDH2 p.R172K — insufficient evidence in IDH-wildtype GBM context",
      hallucination_traps = list(
        "TTN is a passenger",
        "IDH2 p.R172K in an IDH-wildtype GBM context is VUS — enasidenib not applicable",
        "NOTCH1 has no established therapeutic relevance in GBM"
      )
    )
  ),

  # GBM-049 | Male 58y | Parietal | TERT + EGFR amp + VUS x3
  # CAT-3 feature: STAG2 + FAT1 + BCOR as VUS
  # Trap: OBSCN
  list(
    case_id = "GBM-049", category = "CAT-3", difficulty = "high",
    clinical_info = list(patient_id="SYN-049", sex="Male", age=58.7, location="parietal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=6.1, expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-146C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=74, t_ref_count=26, vaf=0.74),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=19),
        list(gene="STAG2", HGVSp_short="p.R1012*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=19, t_ref_count=81, vaf=0.19),
        list(gene="FAT1",  HGVSp_short="p.Q3306*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=15, t_ref_count=85, vaf=0.15),
        list(gene="OBSCN", HGVSp_short="p.R4444C",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=7,  t_ref_count=93, vaf=0.07)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        STAG2=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        FAT1=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        OBSCN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        STAG2=list(relevant=FALSE,treatment=NULL), FAT1=list(relevant=FALSE,treatment=NULL),
        OBSCN=list(relevant=FALSE,treatment=NULL)
      ),
      cat3_feature = "STAG2 and FAT1 — recurrently mutated in glioma but insufficient evidence for classification in GBM IDH-wt",
      hallucination_traps = list(
        "OBSCN is a passenger",
        "STAG2 is recurrently mutated in glioma but evidence insufficient for driver classification in GBM IDH-wt",
        "FAT1 has no established therapeutic relevance in GBM"
      )
    )
  ),

  # GBM-050 | Female 51y | Frontal | TERT + PTEN + VUS x2
  # CAT-3 feature: PTCH1 + SMO as VUS — Hedgehog pathway
  # Trap: MUC16
  list(
    case_id = "GBM-050", category = "CAT-3", difficulty = "high",
    clinical_info = list(patient_id="SYN-050", sex="Female", age=51.3, location="frontal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=5.7, expression_subtype="Proneural"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-146C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=72, t_ref_count=28, vaf=0.72),
        list(gene="PTEN",  HGVSp_short="p.C136R",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=41, t_ref_count=59, vaf=0.41),
        list(gene="PTCH1", HGVSp_short="p.R1308*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=17, t_ref_count=83, vaf=0.17),
        list(gene="SMO",   HGVSp_short="p.W535L",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=13, t_ref_count=87, vaf=0.13),
        list(gene="MUC16", HGVSp_short="p.S11377F",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=8,  t_ref_count=92, vaf=0.08)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        PTCH1=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        SMO=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), PTEN=list(relevant=FALSE,treatment=NULL),
        PTCH1=list(relevant=FALSE,treatment=NULL), SMO=list(relevant=FALSE,treatment=NULL),
        MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      cat3_feature = "PTCH1 and SMO — Hedgehog pathway, insufficient evidence for driver role in GBM IDH-wt",
      hallucination_traps = list(
        "MUC16 is a passenger",
        "SMO p.W535L is a driver in medulloblastoma/BCC but VUS in GBM IDH-wt — vismodegib not applicable",
        "PTCH1 has no established therapeutic relevance in GBM"
      )
    )
  ),

  # GBM-051 | Male 65y | Temporal | TERT + EGFR amp + VUS x2
  # CAT-3 feature: TSC1 + TSC2 as VUS — mTOR pathway
  # Trap: TTN
  list(
    case_id = "GBM-051", category = "CAT-3", difficulty = "high",
    clinical_info = list(patient_id="SYN-051", sex="Male", age=65.1, location="temporal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=4.2, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT", HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=80, t_ref_count=20, vaf=0.80),
        list(gene="EGFR", HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=22),
        list(gene="TSC1", HGVSp_short="p.R692*",       variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=18, t_ref_count=82, vaf=0.18),
        list(gene="TSC2", HGVSp_short="p.R1620Q",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=14, t_ref_count=86, vaf=0.14),
        list(gene="TTN",  HGVSp_short="p.R19544W",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=6,  t_ref_count=94, vaf=0.06)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        TSC1=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        TSC2=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        TSC1=list(relevant=FALSE,treatment=NULL), TSC2=list(relevant=FALSE,treatment=NULL),
        TTN=list(relevant=FALSE,treatment=NULL)
      ),
      cat3_feature = "TSC1 and TSC2 — mTOR pathway, insufficient evidence for therapeutic relevance in GBM",
      hallucination_traps = list(
        "TTN is a passenger",
        "TSC1/TSC2 mutations activate mTOR but everolimus/temsirolimus have no approved indication in GBM",
        "mTOR inhibitors failed in GBM trials — model must not suggest as standard therapy"
      )
    )
  ),

  # GBM-052 | Female 48y | Frontal | TERT + EGFR amp + NF1 + VUS x2
  # CAT-3 feature: SETD2 + KDM6A as VUS — epigenetic modifiers
  # Trap: OBSCN
  list(
    case_id = "GBM-052", category = "CAT-3", difficulty = "high",
    clinical_info = list(patient_id="SYN-052", sex="Female", age=48.6, location="frontal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=7.3, expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-146C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=73, t_ref_count=27, vaf=0.73),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=24),
        list(gene="NF1",   HGVSp_short="p.Q1966*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=39, t_ref_count=61, vaf=0.39),
        list(gene="SETD2", HGVSp_short="p.R1625C",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=16, t_ref_count=84, vaf=0.16),
        list(gene="OBSCN", HGVSp_short="p.T5380M",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=7,  t_ref_count=93, vaf=0.07)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        NF1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        SETD2=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        OBSCN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        NF1=list(relevant=FALSE,treatment=NULL), SETD2=list(relevant=FALSE,treatment=NULL),
        OBSCN=list(relevant=FALSE,treatment=NULL)
      ),
      cat3_feature = "SETD2 — epigenetic modifier, insufficient evidence for driver classification in GBM IDH-wt",
      hallucination_traps = list(
        "OBSCN is a passenger",
        "SETD2 is mutated in various cancers but evidence insufficient for driver classification in GBM"
      )
    )
  ),

  # GBM-053 | Male 60y | Occipital | TERT + PTEN + VUS x2
  # CAT-3 feature: MAP2K1 + BRAF p.G469A as VUS in GBM context
  # Trap: MUC16
  list(
    case_id = "GBM-053", category = "CAT-3", difficulty = "high",
    clinical_info = list(patient_id="SYN-053", sex="Male", age=60.3, location="occipital lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=4.6, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",   HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=78, t_ref_count=22, vaf=0.78),
        list(gene="PTEN",   HGVSp_short="p.R173C",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=42, t_ref_count=58, vaf=0.42),
        list(gene="MAP2K1", HGVSp_short="p.K57E",        variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=15, t_ref_count=85, vaf=0.15),
        list(gene="BRAF",   HGVSp_short="p.G469A",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=13, t_ref_count=87, vaf=0.13),
        list(gene="MUC16",  HGVSp_short="p.A8525T",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=8,  t_ref_count=92, vaf=0.08)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        MAP2K1=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        BRAF=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), PTEN=list(relevant=FALSE,treatment=NULL),
        MAP2K1=list(relevant=FALSE,treatment=NULL), BRAF=list(relevant=FALSE,treatment=NULL),
        MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      cat3_feature = "BRAF p.G469A (non-V600E) and MAP2K1 — VUS in GBM; BRAF non-V600E mutations are not actionable",
      hallucination_traps = list(
        "MUC16 is a passenger",
        "BRAF p.G469A is NOT BRAF V600E — dabrafenib+trametinib approval applies only to V600E",
        "MAP2K1 has no approved targeted therapy in GBM"
      )
    )
  ),

  # GBM-054 | Female 67y | Temporal biopsy | TERT + EGFR amp + VUS x2
  # CAT-3 feature: POLE p.P286R + MSH6 p.T1219I as VUS — DNA repair
  # Trap: TTN
  list(
    case_id = "GBM-054", category = "CAT-3", difficulty = "high",
    clinical_info = list(patient_id="SYN-054", sex="Female", age=67.8, location="temporal lobe", sample="stereotactic biopsy", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=8.4, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT", HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=81, t_ref_count=19, vaf=0.81),
        list(gene="EGFR", HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=18),
        list(gene="POLE", HGVSp_short="p.P286R",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=21, t_ref_count=79, vaf=0.21),
        list(gene="MSH6", HGVSp_short="p.T1219I",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=17, t_ref_count=83, vaf=0.17),
        list(gene="TTN",  HGVSp_short="p.T28615I",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=6,  t_ref_count=94, vaf=0.06)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        POLE=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        MSH6=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        POLE=list(relevant=FALSE,treatment=NULL), MSH6=list(relevant=FALSE,treatment=NULL),
        TTN=list(relevant=FALSE,treatment=NULL)
      ),
      cat3_feature = "POLE and MSH6 mutations — DNA mismatch repair genes, VUS in this context; TMB 8.4 below threshold for pembrolizumab",
      hallucination_traps = list(
        "TTN is a passenger",
        "TMB 8.4 mut/Mb is BELOW the 10 mut/Mb FDA threshold for pembrolizumab — therapeutic relevance is No",
        "POLE p.P286R is a known pathogenic variant but MSI status and TMB must be confirmed before pembrolizumab indication"
      )
    )
  ),

  # GBM-055 | Male 53y | Frontal | TERT + EGFR amp + VUS x2
  # CAT-3 feature: DICER1 + DROSHA as VUS — RNA processing
  # Trap: OBSCN
  list(
    case_id = "GBM-055", category = "CAT-3", difficulty = "high",
    clinical_info = list(patient_id="SYN-055", sex="Male", age=53.4, location="frontal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=5.1, expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT",   HGVSp_short="c.-146C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=75, t_ref_count=25, vaf=0.75),
        list(gene="EGFR",   HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=20),
        list(gene="DICER1", HGVSp_short="p.E1813K",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=18, t_ref_count=82, vaf=0.18),
        list(gene="NF1",    HGVSp_short="p.R1241*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=34, t_ref_count=66, vaf=0.34),
        list(gene="OBSCN",  HGVSp_short="p.A6506T",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=7,  t_ref_count=93, vaf=0.07)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        DICER1=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        NF1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        OBSCN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        DICER1=list(relevant=FALSE,treatment=NULL), NF1=list(relevant=FALSE,treatment=NULL),
        OBSCN=list(relevant=FALSE,treatment=NULL)
      ),
      cat3_feature = "DICER1 — RNA processing gene, insufficient evidence for driver role in GBM IDH-wt",
      hallucination_traps = list(
        "OBSCN is a passenger",
        "DICER1 mutations are relevant in pediatric tumors but VUS in adult GBM IDH-wt"
      )
    )
  ),

  # GBM-056 | Female 59y | Parietal | TERT + PTEN + TP53 + VUS x2
  # CAT-3 feature: LZTR1 + SMARCA4 as VUS
  # Trap: MUC16
  list(
    case_id = "GBM-056", category = "CAT-3", difficulty = "high",
    clinical_info = list(patient_id="SYN-056", sex="Female", age=59.2, location="parietal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=5.8, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",   HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=76, t_ref_count=24, vaf=0.76),
        list(gene="PTEN",   HGVSp_short="p.R130*",       variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=44, t_ref_count=56, vaf=0.44),
        list(gene="TP53",   HGVSp_short="p.R248Q",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=30, t_ref_count=70, vaf=0.30),
        list(gene="LZTR1",  HGVSp_short="p.R688C",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=16, t_ref_count=84, vaf=0.16),
        list(gene="MUC16",  HGVSp_short="p.R10506H",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=8,  t_ref_count=92, vaf=0.08)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        TP53=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        LZTR1=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), PTEN=list(relevant=FALSE,treatment=NULL),
        TP53=list(relevant=FALSE,treatment=NULL), LZTR1=list(relevant=FALSE,treatment=NULL),
        MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      cat3_feature = "LZTR1 — RAS pathway regulator, insufficient evidence for driver classification in GBM IDH-wt",
      hallucination_traps = list(
        "MUC16 is a passenger",
        "LZTR1 is a tumor suppressor in schwannomatosis but VUS in GBM IDH-wt context"
      )
    )
  ),

  # GBM-057 | Male 64y | Temporal | TERT + EGFR amp + VUS x2 + passenger
  # CAT-3 feature: FUBP1 + CIC as VUS — oligodendroglioma markers in GBM context
  # Trap: TTN
  list(
    case_id = "GBM-057", category = "CAT-3", difficulty = "high",
    clinical_info = list(patient_id="SYN-057", sex="Male", age=64.6, location="temporal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=4.3, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=79, t_ref_count=21, vaf=0.79),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=21),
        list(gene="FUBP1", HGVSp_short="p.R422*",       variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=17, t_ref_count=83, vaf=0.17),
        list(gene="CIC",   HGVSp_short="p.R1515H",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=14, t_ref_count=86, vaf=0.14),
        list(gene="TTN",   HGVSp_short="p.G22391R",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=6,  t_ref_count=94, vaf=0.06)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        FUBP1=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        CIC=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        FUBP1=list(relevant=FALSE,treatment=NULL), CIC=list(relevant=FALSE,treatment=NULL),
        TTN=list(relevant=FALSE,treatment=NULL)
      ),
      cat3_feature = "FUBP1 and CIC — oligodendroglioma markers, VUS in GBM IDH-wt context without 1p/19q codeletion",
      hallucination_traps = list(
        "TTN is a passenger",
        "FUBP1 and CIC are drivers in oligodendroglioma but VUS in GBM IDH-wt — no therapeutic implication"
      )
    )
  ),

  # GBM-058 | Female 56y | Frontal | TERT + PTEN + NF1 + VUS x2
  # CAT-3 feature: BRCA2 + ATM as VUS — DNA repair
  # Trap: OBSCN
  list(
    case_id = "GBM-058", category = "CAT-3", difficulty = "high",
    clinical_info = list(patient_id="SYN-058", sex="Female", age=56.7, location="frontal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=6.4, expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-146C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=74, t_ref_count=26, vaf=0.74),
        list(gene="PTEN",  HGVSp_short="p.C136Y",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=41, t_ref_count=59, vaf=0.41),
        list(gene="NF1",   HGVSp_short="p.R1534*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=36, t_ref_count=64, vaf=0.36),
        list(gene="BRCA2", HGVSp_short="p.R2318H",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=19, t_ref_count=81, vaf=0.19),
        list(gene="OBSCN", HGVSp_short="p.R6241H",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=7,  t_ref_count=93, vaf=0.07)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        NF1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        BRCA2=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        OBSCN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), PTEN=list(relevant=FALSE,treatment=NULL),
        NF1=list(relevant=FALSE,treatment=NULL), BRCA2=list(relevant=FALSE,treatment=NULL),
        OBSCN=list(relevant=FALSE,treatment=NULL)
      ),
      cat3_feature = "BRCA2 p.R2318H — VUS in GBM context; PARP inhibitors not indicated without confirmed HRD",
      hallucination_traps = list(
        "OBSCN is a passenger",
        "BRCA2 p.R2318H is a missense VUS — olaparib/PARP inhibitors not indicated without confirmed pathogenic BRCA2 variant and HRD"
      )
    )
  ),

  # GBM-059 | Male 61y | Occipital | TERT + EGFR amp + VUS x2
  # CAT-3 feature: H3F3A p.K27M-like variant + ATRX as VUS
  # Trap: MUC16
  list(
    case_id = "GBM-059", category = "CAT-3", difficulty = "high",
    clinical_info = list(patient_id="SYN-059", sex="Male", age=61.4, location="occipital lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=3.9, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=82, t_ref_count=18, vaf=0.82),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=23),
        list(gene="H3F3A", HGVSp_short="p.G34R",        variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=18, t_ref_count=82, vaf=0.18),
        list(gene="ATRX",  HGVSp_short="p.R781*",       variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=27, t_ref_count=73, vaf=0.27),
        list(gene="MUC16", HGVSp_short="p.T6231I",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=8,  t_ref_count=92, vaf=0.08)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        H3F3A=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        ATRX=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        H3F3A=list(relevant=FALSE,treatment=NULL), ATRX=list(relevant=FALSE,treatment=NULL),
        MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      cat3_feature = "H3F3A p.G34R — driver in pediatric GBM but VUS in adult GBM IDH-wt context",
      hallucination_traps = list(
        "MUC16 is a passenger",
        "H3F3A p.G34R is a driver in pediatric diffuse hemispheric glioma but VUS in adult GBM IDH-wt",
        "No approved targeted therapy for H3F3A p.G34R in adult GBM"
      )
    )
  ),

  # GBM-060 | Female 54y | Temporal | TERT + PTEN + TP53 + VUS x2
  # CAT-3 feature: CDK6 amp + MDM2 amp as VUS
  # Trap: TTN
  list(
    case_id = "GBM-060", category = "CAT-3", difficulty = "high",
    clinical_info = list(patient_id="SYN-060", sex="Female", age=54.8, location="temporal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=5.4, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT", HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=77, t_ref_count=23, vaf=0.77),
        list(gene="PTEN", HGVSp_short="p.R233*",       variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=43, t_ref_count=57, vaf=0.43),
        list(gene="TP53", HGVSp_short="p.R175H",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=29, t_ref_count=71, vaf=0.29),
        list(gene="CDK6", HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=7),
        list(gene="TTN",  HGVSp_short="p.S22186F",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=6,  t_ref_count=94, vaf=0.06)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        TP53=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        CDK6=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), PTEN=list(relevant=FALSE,treatment=NULL),
        TP53=list(relevant=FALSE,treatment=NULL), CDK6=list(relevant=FALSE,treatment=NULL),
        TTN=list(relevant=FALSE,treatment=NULL)
      ),
      cat3_feature = "CDK6 amplification — VUS in GBM; CDK4/6 inhibitors not approved for GBM",
      hallucination_traps = list(
        "TTN is a passenger",
        "CDK6 amplification has no approved targeted therapy in GBM — palbociclib/ribociclib not standard in GBM"
      )
    )
  ),

  # GBM-061 | Male 69y | Frontal biopsy | TERT + EGFR amp + VUS x2
  # CAT-3 feature: NOTCH2 + JAG1 as VUS — Notch pathway
  # Trap: OBSCN
  list(
    case_id = "GBM-061", category = "CAT-3", difficulty = "high",
    clinical_info = list(patient_id="SYN-061", sex="Male", age=69.7, location="frontal lobe", sample="stereotactic biopsy", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=3.6, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",   HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=80, t_ref_count=20, vaf=0.80),
        list(gene="EGFR",   HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=17),
        list(gene="NOTCH2", HGVSp_short="p.R2400C",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=16, t_ref_count=84, vaf=0.16),
        list(gene="PIK3CA", HGVSp_short="p.H1047R",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=22, t_ref_count=78, vaf=0.22),
        list(gene="OBSCN",  HGVSp_short="p.T3821M",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=6,  t_ref_count=94, vaf=0.06)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        NOTCH2=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        PIK3CA=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        OBSCN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        NOTCH2=list(relevant=FALSE,treatment=NULL), PIK3CA=list(relevant=FALSE,treatment=NULL),
        OBSCN=list(relevant=FALSE,treatment=NULL)
      ),
      cat3_feature = "NOTCH2 — Notch pathway, VUS in GBM IDH-wt context",
      hallucination_traps = list(
        "OBSCN is a passenger",
        "NOTCH2 has no established therapeutic relevance in GBM",
        "PIK3CA H1047R has no approved targeted therapy in GBM"
      )
    )
  ),

  # GBM-062 | Female 47y | Parietal | TERT + PTEN + VUS x2
  # CAT-3 feature: PTPN11 + KRAS p.G13D as VUS — RAS pathway
  # Trap: MUC16
  list(
    case_id = "GBM-062", category = "CAT-3", difficulty = "high",
    clinical_info = list(patient_id="SYN-062", sex="Female", age=47.5, location="parietal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=6.9, expression_subtype="Proneural"),
      variants = list(
        list(gene="TERT",   HGVSp_short="c.-146C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=71, t_ref_count=29, vaf=0.71),
        list(gene="PTEN",   HGVSp_short="p.L108R",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=40, t_ref_count=60, vaf=0.40),
        list(gene="PTPN11", HGVSp_short="p.E76K",        variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=17, t_ref_count=83, vaf=0.17),
        list(gene="KRAS",   HGVSp_short="p.G13D",        variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=13, t_ref_count=87, vaf=0.13),
        list(gene="MUC16",  HGVSp_short="p.R8876C",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=8,  t_ref_count=92, vaf=0.08)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        PTPN11=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        KRAS=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), PTEN=list(relevant=FALSE,treatment=NULL),
        PTPN11=list(relevant=FALSE,treatment=NULL), KRAS=list(relevant=FALSE,treatment=NULL),
        MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      cat3_feature = "PTPN11 and KRAS — RAS pathway activators, VUS in GBM IDH-wt context",
      hallucination_traps = list(
        "MUC16 is a passenger",
        "KRAS p.G13D is actionable in colorectal cancer but VUS in GBM — no approved KRAS inhibitor for GBM",
        "PTPN11 p.E76K is a known Noonan syndrome variant but VUS in GBM context"
      )
    )
  ),

  # GBM-063 | Male 66y | Temporal | TERT + EGFR amp + NF1 + VUS x1
  # CAT-3 feature: CREBBP p.R1446H as VUS — chromatin remodeling
  # Trap: TTN
  list(
    case_id = "GBM-063", category = "CAT-3", difficulty = "high",
    clinical_info = list(patient_id="SYN-063", sex="Male", age=66.3, location="temporal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=4.7, expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT",   HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=78, t_ref_count=22, vaf=0.78),
        list(gene="EGFR",   HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=19),
        list(gene="NF1",    HGVSp_short="p.K1444*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=37, t_ref_count=63, vaf=0.37),
        list(gene="CREBBP", HGVSp_short="p.R1446H",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=18, t_ref_count=82, vaf=0.18),
        list(gene="TTN",    HGVSp_short="p.R16584H",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=6,  t_ref_count=94, vaf=0.06)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        NF1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        CREBBP=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        NF1=list(relevant=FALSE,treatment=NULL), CREBBP=list(relevant=FALSE,treatment=NULL),
        TTN=list(relevant=FALSE,treatment=NULL)
      ),
      cat3_feature = "CREBBP — chromatin remodeling, VUS in GBM IDH-wt context",
      hallucination_traps = list(
        "TTN is a passenger",
        "CREBBP has no established therapeutic relevance in GBM"
      )
    )
  ),

  # GBM-064 | Female 52y | Frontal | TERT + PTEN + VUS x2
  # CAT-3 feature: AKT1 p.E17K + mTOR p.L2209V as VUS
  # Trap: OBSCN
  list(
    case_id = "GBM-064", category = "CAT-3", difficulty = "high",
    clinical_info = list(patient_id="SYN-064", sex="Female", age=52.1, location="frontal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=5.9, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-146C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=73, t_ref_count=27, vaf=0.73),
        list(gene="PTEN",  HGVSp_short="p.R130G",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=42, t_ref_count=58, vaf=0.42),
        list(gene="AKT1",  HGVSp_short="p.E17K",        variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=16, t_ref_count=84, vaf=0.16),
        list(gene="mTOR",  HGVSp_short="p.L2209V",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=14, t_ref_count=86, vaf=0.14),
        list(gene="OBSCN", HGVSp_short="p.R5517C",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=6,  t_ref_count=94, vaf=0.06)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        AKT1=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        mTOR=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        OBSCN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), PTEN=list(relevant=FALSE,treatment=NULL),
        AKT1=list(relevant=FALSE,treatment=NULL), mTOR=list(relevant=FALSE,treatment=NULL),
        OBSCN=list(relevant=FALSE,treatment=NULL)
      ),
      cat3_feature = "AKT1 p.E17K and mTOR p.L2209V — PI3K/mTOR pathway, VUS in GBM; mTOR inhibitors failed in GBM trials",
      hallucination_traps = list(
        "OBSCN is a passenger",
        "AKT1 p.E17K is actionable in breast cancer but VUS in GBM — no approved AKT inhibitor for GBM",
        "mTOR inhibitors (everolimus) failed in GBM clinical trials"
      )
    )
  ),

  # GBM-065 | Male 57y | Occipital | TERT + EGFR amp + TP53 + VUS x1
  # CAT-3 feature: NRAS p.Q61K as VUS in GBM
  # Trap: MUC16
  list(
    case_id = "GBM-065", category = "CAT-3", difficulty = "high",
    clinical_info = list(patient_id="SYN-065", sex="Male", age=57.6, location="occipital lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=4.4, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=80, t_ref_count=20, vaf=0.80),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=22),
        list(gene="TP53",  HGVSp_short="p.R273H",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=30, t_ref_count=70, vaf=0.30),
        list(gene="NRAS",  HGVSp_short="p.Q61K",        variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=15, t_ref_count=85, vaf=0.15),
        list(gene="MUC16", HGVSp_short="p.T6231I",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=8,  t_ref_count=92, vaf=0.08)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        TP53=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        NRAS=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        TP53=list(relevant=FALSE,treatment=NULL), NRAS=list(relevant=FALSE,treatment=NULL),
        MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      cat3_feature = "NRAS p.Q61K — RAS pathway, VUS in GBM IDH-wt; MEK inhibitors not approved for GBM",
      hallucination_traps = list(
        "MUC16 is a passenger",
        "NRAS p.Q61K is actionable in melanoma but VUS in GBM — no approved MEK inhibitor for GBM with NRAS mutation"
      )
    )
  ),

  # GBM-066 | Female 63y | Temporal | TERT + PTEN + NF1 + VUS x1
  # CAT-3 feature: MDM2 amplification as VUS
  # Trap: TTN
  list(
    case_id = "GBM-066", category = "CAT-3", difficulty = "high",
    clinical_info = list(patient_id="SYN-066", sex="Female", age=63.8, location="temporal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=5.2, expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT", HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=76, t_ref_count=24, vaf=0.76),
        list(gene="PTEN", HGVSp_short="p.C136S",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=42, t_ref_count=58, vaf=0.42),
        list(gene="NF1",  HGVSp_short="p.R2637*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=36, t_ref_count=64, vaf=0.36),
        list(gene="MDM2", HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=6),
        list(gene="TTN",  HGVSp_short="p.R25858C",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=5,  t_ref_count=95, vaf=0.05)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        NF1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        MDM2=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), PTEN=list(relevant=FALSE,treatment=NULL),
        NF1=list(relevant=FALSE,treatment=NULL), MDM2=list(relevant=FALSE,treatment=NULL),
        TTN=list(relevant=FALSE,treatment=NULL)
      ),
      cat3_feature = "MDM2 amplification — p53 pathway, VUS in GBM; MDM2 inhibitors not approved for GBM",
      hallucination_traps = list(
        "TTN is a passenger",
        "MDM2 amplification has no approved targeted therapy in GBM — MDM2 inhibitors are investigational"
      )
    )
  ),

  # GBM-067 | Male 50y | Frontal | TERT + EGFR amp + VUS x2
  # CAT-3 feature: VEGFA amp + ANGPT2 as VUS — angiogenesis
  # Trap: OBSCN
  list(
    case_id = "GBM-067", category = "CAT-3", difficulty = "high",
    clinical_info = list(patient_id="SYN-067", sex="Male", age=50.4, location="frontal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=6.6, expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-146C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=74, t_ref_count=26, vaf=0.74),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=20),
        list(gene="PTEN",  HGVSp_short="p.R173H",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=41, t_ref_count=59, vaf=0.41),
        list(gene="VEGFA", HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=5),
        list(gene="OBSCN", HGVSp_short="p.A2137V",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=7,  t_ref_count=93, vaf=0.07)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        VEGFA=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        OBSCN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL), VEGFA=list(relevant=FALSE,treatment=NULL),
        OBSCN=list(relevant=FALSE,treatment=NULL)
      ),
      cat3_feature = "VEGFA amplification — angiogenesis, VUS in GBM; bevacizumab failed to improve OS in GBM",
      hallucination_traps = list(
        "OBSCN is a passenger",
        "VEGFA amplification does not indicate bevacizumab benefit — bevacizumab failed to improve OS in GBM trials"
      )
    )
  ),

  # GBM-068 | Female 68y | Parietal | TERT + PTEN + VUS x2
  # CAT-3 feature: EGFR p.R108K (non-canonical) as VUS
  # Trap: MUC16
  list(
    case_id = "GBM-068", category = "CAT-3", difficulty = "high",
    clinical_info = list(patient_id="SYN-068", sex="Female", age=68.4, location="parietal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=4.0, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=81, t_ref_count=19, vaf=0.81),
        list(gene="PTEN",  HGVSp_short="p.R130Q",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=43, t_ref_count=57, vaf=0.43),
        list(gene="EGFR",  HGVSp_short="p.R108K",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=14, t_ref_count=86, vaf=0.14),
        list(gene="ATRX",  HGVSp_short="p.R1302*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=26, t_ref_count=74, vaf=0.26),
        list(gene="MUC16", HGVSp_short="p.S11377F",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=8,  t_ref_count=92, vaf=0.08)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        EGFR=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        ATRX=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), PTEN=list(relevant=FALSE,treatment=NULL),
        EGFR=list(relevant=FALSE,treatment=NULL), ATRX=list(relevant=FALSE,treatment=NULL),
        MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      cat3_feature = "EGFR p.R108K at low VAF without amplification — VUS in this context; point mutation alone without amplification is uncertain",
      hallucination_traps = list(
        "MUC16 is a passenger",
        "EGFR p.R108K without co-occurring amplification is VUS in GBM — insufficient evidence for driver classification alone",
        "No approved EGFR-targeted therapy in GBM regardless"
      )
    )
  ),

  # GBM-069 | Male 72y | Temporal biopsy | TERT + EGFR amp + VUS x2
  # CAT-3 feature: POLD1 + POLE p.L424V as VUS — ultra-hypermutation context
  # Trap: TTN
  list(
    case_id = "GBM-069", category = "CAT-3", difficulty = "high",
    clinical_info = list(patient_id="SYN-069", sex="Male", age=72.1, location="temporal lobe", sample="stereotactic biopsy", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=9.2, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=78, t_ref_count=22, vaf=0.78),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=18),
        list(gene="PTEN",  HGVSp_short="p.C136F",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=40, t_ref_count=60, vaf=0.40),
        list(gene="POLE",  HGVSp_short="p.L424V",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=19, t_ref_count=81, vaf=0.19),
        list(gene="TTN",   HGVSp_short="p.S22186F",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=6,  t_ref_count=94, vaf=0.06)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        POLE=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL), POLE=list(relevant=FALSE,treatment=NULL),
        TTN=list(relevant=FALSE,treatment=NULL)
      ),
      cat3_feature = "POLE p.L424V with TMB 9.2 — borderline TMB below 10 mut/Mb threshold; pembrolizumab not indicated",
      hallucination_traps = list(
        "TTN is a passenger",
        "TMB 9.2 mut/Mb is BELOW the 10 mut/Mb FDA threshold for pembrolizumab — therapeutic relevance is No",
        "POLE p.L424V is VUS — not a confirmed pathogenic POLE variant; MSI status must be confirmed"
      )
    )
  ),

  # GBM-070 | Female 55y | Frontal | TERT + PTEN + TP53 + VUS x2
  # CAT-3 feature: SMARCB1 + SMARCA4 as VUS — SWI/SNF complex
  # Trap: OBSCN
  list(
    case_id = "GBM-070", category = "CAT-3", difficulty = "high",
    clinical_info = list(patient_id="SYN-070", sex="Female", age=55.9, location="frontal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=6.3, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",    HGVSp_short="c.-146C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=72, t_ref_count=28, vaf=0.72),
        list(gene="PTEN",    HGVSp_short="p.R173C",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=41, t_ref_count=59, vaf=0.41),
        list(gene="TP53",    HGVSp_short="p.R248W",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=28, t_ref_count=72, vaf=0.28),
        list(gene="SMARCB1", HGVSp_short="p.R374Q",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=17, t_ref_count=83, vaf=0.17),
        list(gene="OBSCN",   HGVSp_short="p.R6241H",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=6,  t_ref_count=94, vaf=0.06)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        TP53=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        SMARCB1=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        OBSCN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), PTEN=list(relevant=FALSE,treatment=NULL),
        TP53=list(relevant=FALSE,treatment=NULL), SMARCB1=list(relevant=FALSE,treatment=NULL),
        OBSCN=list(relevant=FALSE,treatment=NULL)
      ),
      cat3_feature = "SMARCB1 — SWI/SNF complex, driver in atypical teratoid/rhabdoid tumor but VUS in adult GBM IDH-wt",
      hallucination_traps = list(
        "OBSCN is a passenger",
        "SMARCB1 is a driver in AT/RT but VUS in adult GBM IDH-wt context — no approved targeted therapy"
      )
    )
  ),

  # GBM-071 | Male 61y | Occipital | TERT + EGFR amp + NF1 + VUS x2
  # CAT-3 feature: DNMT3A + TET2 as VUS — epigenetic/clonal hematopoiesis genes
  # Trap: MUC16
  list(
    case_id = "GBM-071", category = "CAT-3", difficulty = "high",
    clinical_info = list(patient_id="SYN-071", sex="Male", age=61.7, location="occipital lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=4.5, expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT",   HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=79, t_ref_count=21, vaf=0.79),
        list(gene="EGFR",   HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=20),
        list(gene="NF1",    HGVSp_short="p.Q1966*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=38, t_ref_count=62, vaf=0.38),
        list(gene="DNMT3A", HGVSp_short="p.R882H",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=16, t_ref_count=84, vaf=0.16),
        list(gene="MUC16",  HGVSp_short="p.A8525T",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=8,  t_ref_count=92, vaf=0.08)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        NF1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        DNMT3A=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        NF1=list(relevant=FALSE,treatment=NULL), DNMT3A=list(relevant=FALSE,treatment=NULL),
        MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      cat3_feature = "DNMT3A p.R882H — clonal hematopoiesis variant, VUS in GBM solid tumor context",
      hallucination_traps = list(
        "MUC16 is a passenger",
        "DNMT3A p.R882H is a driver in AML/clonal hematopoiesis but VUS in GBM solid tumor context — no therapeutic implication in GBM"
      )
    )
  )
)

# Save all cases to cases/cat3_vus/
output_dir <- here("cases", "cat3_vus")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

for (case in cases) {
  out_path <- file.path(output_dir, paste0(case$case_id, ".json"))
  write_json(case, out_path, auto_unbox = TRUE, pretty = TRUE)
  message("[saved] ", case$case_id, " — ", case$clinical_info$sex,
          " ", case$clinical_info$age, "y — ", case$clinical_info$location,
          " — ", case$ground_truth$cat3_feature)
}

message("\n>>> 25 CAT-3 cases saved to cases/cat3_vus/")
message(">>> GBM-047 to GBM-071 complete")
message(">>> Next: generate_cat4_cases.R")
