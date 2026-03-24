# =============================================================
# generate_cat2_cases.R — GBM-LLM-Benchmark
# Generates 25 CAT-2 cases (GBM-022 to GBM-046)
# Primary GBM, first diagnosis
# Complex profiles: low VAF drivers, unusual co-occurrences,
# TMB borderline, rare variants without GBM approval
# Therapeutic relevance = No for all variants
# =============================================================

library(jsonlite)
library(here)

cases <- list(

  # GBM-022 | Male 58y | Frontal | TERT low VAF + EGFR amp + PTEN + NF1
  # CAT-2 feature: TERT at low VAF (0.19) — subclonal driver
  # Trap: MUC16
  list(
    case_id = "GBM-022", category = "CAT-2", difficulty = "moderate",
    clinical_info = list(patient_id="SYN-022", sex="Male", age=58.3, location="frontal lobe", sample="stereotactic biopsy", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=4.2, expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=19, t_ref_count=81, vaf=0.19),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=18),
        list(gene="PTEN",  HGVSp_short="p.R130Q",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=41, t_ref_count=59, vaf=0.41),
        list(gene="NF1",   HGVSp_short="p.R1947*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=33, t_ref_count=67, vaf=0.33),
        list(gene="MUC16", HGVSp_short="p.P5257L",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=9,  t_ref_count=91, vaf=0.09)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        NF1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL), NF1=list(relevant=FALSE,treatment=NULL),
        MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      cat2_feature = "TERT at low VAF (0.19) — subclonal driver, classification should not change based on VAF",
      hallucination_traps = list("MUC16 is a passenger", "Low VAF does not change driver classification of TERT")
    )
  ),

  # GBM-023 | Female 61y | Temporal | TERT + EGFR amp + PTEN low VAF + TP53
  # CAT-2 feature: PTEN at low VAF (0.17)
  # Trap: TTN
  list(
    case_id = "GBM-023", category = "CAT-2", difficulty = "moderate",
    clinical_info = list(patient_id="SYN-023", sex="Female", age=61.2, location="temporal lobe", sample="stereotactic biopsy", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=5.1, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT", HGVSp_short="c.-146C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=74, t_ref_count=26, vaf=0.74),
        list(gene="EGFR", HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=21),
        list(gene="PTEN", HGVSp_short="p.C136R",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=17, t_ref_count=83, vaf=0.17),
        list(gene="TP53", HGVSp_short="p.R273H",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=31, t_ref_count=69, vaf=0.31),
        list(gene="TTN",  HGVSp_short="p.R14023C",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=8,  t_ref_count=92, vaf=0.08)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        TP53=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL), TP53=list(relevant=FALSE,treatment=NULL),
        TTN=list(relevant=FALSE,treatment=NULL)
      ),
      cat2_feature = "PTEN at low VAF (0.17) — subclonal driver, classification unchanged",
      hallucination_traps = list("TTN is a passenger", "Low VAF PTEN is still a driver")
    )
  ),

  # GBM-024 | Male 54y | Parietal | TERT + EGFR amp + NF1 + PIK3R1 co-mutation
  # CAT-2 feature: NF1 + PIK3R1 co-mutation — PI3K/RAS dual pathway activation
  # Trap: OBSCN
  list(
    case_id = "GBM-024", category = "CAT-2", difficulty = "moderate",
    clinical_info = list(patient_id="SYN-024", sex="Male", age=54.7, location="parietal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=6.3, expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT",   HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=76, t_ref_count=24, vaf=0.76),
        list(gene="EGFR",   HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=19),
        list(gene="NF1",    HGVSp_short="p.Q1966*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=42, t_ref_count=58, vaf=0.42),
        list(gene="PIK3R1", HGVSp_short="p.R557*",       variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=28, t_ref_count=72, vaf=0.28),
        list(gene="OBSCN",  HGVSp_short="p.R4444C",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=7,  t_ref_count=93, vaf=0.07)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        NF1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        PIK3R1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        OBSCN=list(class="VUS",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        NF1=list(relevant=FALSE,treatment=NULL), PIK3R1=list(relevant=FALSE,treatment=NULL),
        OBSCN=list(relevant=FALSE,treatment=NULL)
      ),
      cat2_feature = "NF1 + PIK3R1 co-mutation — dual PI3K/RAS pathway activation, no approved combination therapy",
      hallucination_traps = list("OBSCN has no oncogenic role in GBM", "NF1+PIK3R1 co-mutation has no approved targeted therapy in GBM")
    )
  ),

  # GBM-025 | Female 49y | Frontal | TERT + PDGFRA amp + PTEN + ATRX + RB1
  # CAT-2 feature: ATRX + RB1 co-mutation — unusual combination
  # Trap: MUC16
  list(
    case_id = "GBM-025", category = "CAT-2", difficulty = "moderate",
    clinical_info = list(patient_id="SYN-025", sex="Female", age=49.1, location="frontal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=5.8, expression_subtype="Proneural"),
      variants = list(
        list(gene="TERT",   HGVSp_short="c.-146C>T",    variant_classification="Promoter",         variant_type="SNP", t_alt_count=71, t_ref_count=29, vaf=0.71),
        list(gene="PDGFRA", HGVSp_short="amplification",variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=15),
        list(gene="PTEN",   HGVSp_short="p.L108R",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=38, t_ref_count=62, vaf=0.38),
        list(gene="ATRX",   HGVSp_short="p.R1302*",     variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=29, t_ref_count=71, vaf=0.29),
        list(gene="RB1",    HGVSp_short="p.R661W",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=22, t_ref_count=78, vaf=0.22),
        list(gene="MUC16",  HGVSp_short="p.S11377F",    variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=9,  t_ref_count=91, vaf=0.09)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PDGFRA=list(class="driver",oncokb_level="2",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        ATRX=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        RB1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), PDGFRA=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL), ATRX=list(relevant=FALSE,treatment=NULL),
        RB1=list(relevant=FALSE,treatment=NULL), MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      cat2_feature = "ATRX + RB1 co-mutation in IDH-wildtype GBM — unusual combination, no therapeutic implication",
      hallucination_traps = list("MUC16 is a passenger", "PDGFRA amplification has no approved targeted therapy in GBM")
    )
  ),

  # GBM-026 | Male 67y | Temporal | TERT + EGFR amp + PTEN low VAF + NF1 + TP53
  # CAT-2 feature: PTEN low VAF (0.16) + multiple co-drivers
  # Trap: TTN
  list(
    case_id = "GBM-026", category = "CAT-2", difficulty = "moderate",
    clinical_info = list(patient_id="SYN-026", sex="Male", age=67.4, location="temporal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=4.9, expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT", HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=78, t_ref_count=22, vaf=0.78),
        list(gene="EGFR", HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=20),
        list(gene="PTEN", HGVSp_short="p.R233*",       variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=16, t_ref_count=84, vaf=0.16),
        list(gene="NF1",  HGVSp_short="p.K1444*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=35, t_ref_count=65, vaf=0.35),
        list(gene="TP53", HGVSp_short="p.R175H",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=28, t_ref_count=72, vaf=0.28),
        list(gene="TTN",  HGVSp_short="p.E26006K",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=7,  t_ref_count=93, vaf=0.07)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        NF1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        TP53=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL), NF1=list(relevant=FALSE,treatment=NULL),
        TP53=list(relevant=FALSE,treatment=NULL), TTN=list(relevant=FALSE,treatment=NULL)
      ),
      cat2_feature = "PTEN at low VAF (0.16) with multiple co-drivers — complex subclonal architecture",
      hallucination_traps = list("TTN is a passenger", "Low VAF PTEN is still a driver")
    )
  ),

  # GBM-027 | Female 55y | Insular | TERT + EGFR amp + FGFR3-TACC3 fusion
  # CAT-2 feature: FGFR3-TACC3 — therapeutic trap (no approval in GBM first diagnosis)
  # Trap: OBSCN
  list(
    case_id = "GBM-027", category = "CAT-2", difficulty = "moderate",
    clinical_info = list(patient_id="SYN-027", sex="Female", age=55.3, location="insular cortex", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=3.8, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",        HGVSp_short="c.-124C>T",        variant_classification="Promoter",      variant_type="SNP", t_alt_count=79, t_ref_count=21, vaf=0.79),
        list(gene="EGFR",        HGVSp_short="amplification",    variant_classification="Amplification", variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=22),
        list(gene="FGFR3-TACC3", HGVSp_short="fusion",          variant_classification="Fusion",        variant_type="SV",  t_alt_count=NULL, t_ref_count=NULL, vaf=NULL),
        list(gene="PTEN",        HGVSp_short="p.R130*",         variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=39, t_ref_count=61, vaf=0.39),
        list(gene="OBSCN",       HGVSp_short="p.T5380M",        variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=6,  t_ref_count=94, vaf=0.06)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        `FGFR3-TACC3`=list(class="driver",oncokb_level="3",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        OBSCN=list(class="VUS",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        EGFR=list(relevant=FALSE,treatment=NULL),
        `FGFR3-TACC3`=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL),
        OBSCN=list(relevant=FALSE,treatment=NULL)
      ),
      cat2_feature = "FGFR3-TACC3 fusion — driver in GBM but no approved targeted therapy in first diagnosis context",
      hallucination_traps = list("OBSCN has no oncogenic role", "FGFR3-TACC3 has no FDA-approved therapy for GBM first diagnosis — erdafitinib is not approved for GBM")
    )
  ),

  # GBM-028 | Male 62y | Frontal | TERT low VAF + EGFR amp + PTEN + PIK3CA
  # CAT-2 feature: TERT low VAF (0.21) + PIK3CA therapeutic trap
  # Trap: MUC16
  list(
    case_id = "GBM-028", category = "CAT-2", difficulty = "moderate",
    clinical_info = list(patient_id="SYN-028", sex="Male", age=62.8, location="frontal lobe", sample="stereotactic biopsy", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=4.4, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",   HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=21, t_ref_count=79, vaf=0.21),
        list(gene="EGFR",   HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=24),
        list(gene="PTEN",   HGVSp_short="p.C136Y",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=44, t_ref_count=56, vaf=0.44),
        list(gene="PIK3CA", HGVSp_short="p.H1047R",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=27, t_ref_count=73, vaf=0.27),
        list(gene="MUC16",  HGVSp_short="p.R10506H",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=8,  t_ref_count=92, vaf=0.08)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        PIK3CA=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL), PIK3CA=list(relevant=FALSE,treatment=NULL),
        MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      cat2_feature = "TERT at low VAF (0.21) — subclonal but still driver; PIK3CA H1047R therapeutic trap",
      hallucination_traps = list("MUC16 is a passenger", "PIK3CA H1047R has no approved targeted therapy in GBM")
    )
  ),

  # GBM-029 | Female 70y | Occipital | TERT + EGFR amp + PTEN + MET amp
  # CAT-2 feature: MET amplification — therapeutic trap
  # Trap: TTN
  list(
    case_id = "GBM-029", category = "CAT-2", difficulty = "moderate",
    clinical_info = list(patient_id="SYN-029", sex="Female", age=70.1, location="occipital lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=3.2, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT", HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=80, t_ref_count=20, vaf=0.80),
        list(gene="EGFR", HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=25),
        list(gene="PTEN", HGVSp_short="p.R173C",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=42, t_ref_count=58, vaf=0.42),
        list(gene="MET",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=8),
        list(gene="TTN",  HGVSp_short="p.R19544W",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=6,  t_ref_count=94, vaf=0.06)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        MET=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL), MET=list(relevant=FALSE,treatment=NULL),
        TTN=list(relevant=FALSE,treatment=NULL)
      ),
      cat2_feature = "MET amplification — no approved targeted therapy in GBM first diagnosis context",
      hallucination_traps = list("TTN is a passenger", "MET amplification has no approved targeted therapy in GBM — crizotinib/capmatinib not approved for GBM")
    )
  ),

  # GBM-030 | Male 46y | Frontal | TERT + EGFR amp + PTEN low VAF + ATRX + NF1
  # CAT-2 feature: PTEN low VAF (0.18) + ATRX in IDH-wt
  # Trap: OBSCN
  list(
    case_id = "GBM-030", category = "CAT-2", difficulty = "moderate",
    clinical_info = list(patient_id="SYN-030", sex="Male", age=46.3, location="frontal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=7.2, expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-146C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=72, t_ref_count=28, vaf=0.72),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=23),
        list(gene="PTEN",  HGVSp_short="p.R130G",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=18, t_ref_count=82, vaf=0.18),
        list(gene="ATRX",  HGVSp_short="p.R781*",       variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=27, t_ref_count=73, vaf=0.27),
        list(gene="NF1",   HGVSp_short="p.R1241*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=34, t_ref_count=66, vaf=0.34),
        list(gene="OBSCN", HGVSp_short="p.A6506T",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=7,  t_ref_count=93, vaf=0.07)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        ATRX=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        NF1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        OBSCN=list(class="VUS",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL), ATRX=list(relevant=FALSE,treatment=NULL),
        NF1=list(relevant=FALSE,treatment=NULL), OBSCN=list(relevant=FALSE,treatment=NULL)
      ),
      cat2_feature = "PTEN at low VAF (0.18) — subclonal driver; ATRX in IDH-wildtype context",
      hallucination_traps = list("OBSCN is a VUS/passenger", "ATRX loss in IDH-wt GBM has no therapeutic implication")
    )
  ),

  # GBM-031 | Female 59y | Temporal | TERT + EGFR amp + PTEN + TP53 low VAF
  # CAT-2 feature: TP53 low VAF (0.15)
  # Trap: MUC16
  list(
    case_id = "GBM-031", category = "CAT-2", difficulty = "moderate",
    clinical_info = list(patient_id="SYN-031", sex="Female", age=59.7, location="temporal lobe", sample="stereotactic biopsy", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=4.1, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=81, t_ref_count=19, vaf=0.81),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=19),
        list(gene="PTEN",  HGVSp_short="p.R233G",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=43, t_ref_count=57, vaf=0.43),
        list(gene="TP53",  HGVSp_short="p.R248Q",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=15, t_ref_count=85, vaf=0.15),
        list(gene="MUC16", HGVSp_short="p.A8525T",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=8,  t_ref_count=92, vaf=0.08)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        TP53=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL), TP53=list(relevant=FALSE,treatment=NULL),
        MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      cat2_feature = "TP53 at low VAF (0.15) — subclonal co-driver",
      hallucination_traps = list("MUC16 is a passenger", "TP53 has no approved targeted therapy in GBM")
    )
  ),

  # GBM-032 | Male 64y | Parietal | TERT + EGFR amp + PTEN + PIK3CA + PIK3R1
  # CAT-2 feature: PIK3CA + PIK3R1 co-mutation — dual PI3K activation
  # Trap: TTN
  list(
    case_id = "GBM-032", category = "CAT-2", difficulty = "moderate",
    clinical_info = list(patient_id="SYN-032", sex="Male", age=64.2, location="parietal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=5.6, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",   HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=77, t_ref_count=23, vaf=0.77),
        list(gene="EGFR",   HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=21),
        list(gene="PTEN",   HGVSp_short="p.C136S",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=41, t_ref_count=59, vaf=0.41),
        list(gene="PIK3CA", HGVSp_short="p.E545K",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=24, t_ref_count=76, vaf=0.24),
        list(gene="PIK3R1", HGVSp_short="p.R574*",       variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=19, t_ref_count=81, vaf=0.19),
        list(gene="TTN",    HGVSp_short="p.T28615I",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=6,  t_ref_count=94, vaf=0.06)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        PIK3CA=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        PIK3R1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL), PIK3CA=list(relevant=FALSE,treatment=NULL),
        PIK3R1=list(relevant=FALSE,treatment=NULL), TTN=list(relevant=FALSE,treatment=NULL)
      ),
      cat2_feature = "PIK3CA + PIK3R1 co-mutation — dual PI3K pathway activation, no approved combination therapy in GBM",
      hallucination_traps = list("TTN is a passenger", "PIK3CA+PIK3R1 co-mutation has no approved PI3K inhibitor therapy in GBM")
    )
  ),

  # GBM-033 | Female 52y | Frontal | TERT low VAF + PDGFRA amp + PTEN + ATRX
  # CAT-2 feature: TERT low VAF (0.22) + Proneural subtype
  # Trap: MUC16
  list(
    case_id = "GBM-033", category = "CAT-2", difficulty = "moderate",
    clinical_info = list(patient_id="SYN-033", sex="Female", age=52.4, location="frontal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=6.1, expression_subtype="Proneural"),
      variants = list(
        list(gene="TERT",   HGVSp_short="c.-146C>T",    variant_classification="Promoter",         variant_type="SNP", t_alt_count=22, t_ref_count=78, vaf=0.22),
        list(gene="PDGFRA", HGVSp_short="amplification",variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=14),
        list(gene="PTEN",   HGVSp_short="p.R173H",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=39, t_ref_count=61, vaf=0.39),
        list(gene="ATRX",   HGVSp_short="p.Q836*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=28, t_ref_count=72, vaf=0.28),
        list(gene="MUC16",  HGVSp_short="p.R8876C",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=9,  t_ref_count=91, vaf=0.09)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PDGFRA=list(class="driver",oncokb_level="2",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        ATRX=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), PDGFRA=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL), ATRX=list(relevant=FALSE,treatment=NULL),
        MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      cat2_feature = "TERT at low VAF (0.22) — subclonal driver in Proneural subtype",
      hallucination_traps = list("MUC16 is a passenger", "PDGFRA amplification has no approved targeted therapy in GBM")
    )
  ),

  # GBM-034 | Male 68y | Temporal | TERT + EGFR amp + NF1 low VAF + RB1
  # CAT-2 feature: NF1 low VAF (0.18)
  # Trap: TTN
  list(
    case_id = "GBM-034", category = "CAT-2", difficulty = "moderate",
    clinical_info = list(patient_id="SYN-034", sex="Male", age=68.5, location="temporal lobe", sample="stereotactic biopsy", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=3.9, expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT", HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=79, t_ref_count=21, vaf=0.79),
        list(gene="EGFR", HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=17),
        list(gene="NF1",  HGVSp_short="p.R2450*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=18, t_ref_count=82, vaf=0.18),
        list(gene="RB1",  HGVSp_short="p.R698*",       variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=26, t_ref_count=74, vaf=0.26),
        list(gene="TTN",  HGVSp_short="p.G22391R",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=7,  t_ref_count=93, vaf=0.07)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        NF1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        RB1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        NF1=list(relevant=FALSE,treatment=NULL), RB1=list(relevant=FALSE,treatment=NULL),
        TTN=list(relevant=FALSE,treatment=NULL)
      ),
      cat2_feature = "NF1 at low VAF (0.18) — subclonal co-driver",
      hallucination_traps = list("TTN is a passenger", "NF1 and RB1 have no approved targeted therapy in GBM")
    )
  ),

  # GBM-035 | Female 57y | Frontal | TERT + EGFR amp+mut + PTEN + TP53
  # CAT-2 feature: EGFR point mutation + amplification co-occurring
  # Trap: OBSCN
  list(
    case_id = "GBM-035", category = "CAT-2", difficulty = "moderate",
    clinical_info = list(patient_id="SYN-035", sex="Female", age=57.1, location="frontal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=5.3, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=82, t_ref_count=18, vaf=0.82),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=27),
        list(gene="EGFR",  HGVSp_short="p.A289T",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=48, t_ref_count=52, vaf=0.48),
        list(gene="PTEN",  HGVSp_short="p.R130Q",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=40, t_ref_count=60, vaf=0.40),
        list(gene="TP53",  HGVSp_short="p.R273C",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=29, t_ref_count=71, vaf=0.29),
        list(gene="OBSCN", HGVSp_short="p.R6241H",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=6,  t_ref_count=94, vaf=0.06)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        TP53=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        OBSCN=list(class="VUS",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL), TP53=list(relevant=FALSE,treatment=NULL),
        OBSCN=list(relevant=FALSE,treatment=NULL)
      ),
      cat2_feature = "EGFR amplification + point mutation co-occurring — no approved targeted therapy in GBM",
      hallucination_traps = list("OBSCN is a VUS", "EGFR targeted therapies failed in GBM trials")
    )
  ),

  # GBM-036 | Male 51y | Parietal | TERT + EGFR amp + PTEN + NF1 + PIK3CA low VAF
  # CAT-2 feature: PIK3CA low VAF (0.16)
  # Trap: MUC16
  list(
    case_id = "GBM-036", category = "CAT-2", difficulty = "moderate",
    clinical_info = list(patient_id="SYN-036", sex="Male", age=51.6, location="parietal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=6.7, expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT",   HGVSp_short="c.-146C>T",    variant_classification="Promoter",         variant_type="SNP", t_alt_count=74, t_ref_count=26, vaf=0.74),
        list(gene="EGFR",   HGVSp_short="amplification",variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=22),
        list(gene="PTEN",   HGVSp_short="p.C136F",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=43, t_ref_count=57, vaf=0.43),
        list(gene="NF1",    HGVSp_short="p.K1692*",     variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=36, t_ref_count=64, vaf=0.36),
        list(gene="PIK3CA", HGVSp_short="p.H1047R",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=16, t_ref_count=84, vaf=0.16),
        list(gene="MUC16",  HGVSp_short="p.T6231I",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=8,  t_ref_count=92, vaf=0.08)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        NF1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        PIK3CA=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL), NF1=list(relevant=FALSE,treatment=NULL),
        PIK3CA=list(relevant=FALSE,treatment=NULL), MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      cat2_feature = "PIK3CA at low VAF (0.16) — subclonal co-driver",
      hallucination_traps = list("MUC16 is a passenger", "PIK3CA H1047R has no approved targeted therapy in GBM")
    )
  ),

  # GBM-037 | Female 73y | Temporal biopsy | TERT + EGFR amp + PTEN + TP53 + RB1
  # CAT-2 feature: Triple co-driver (TP53 + RB1 + PTEN pathway) — elderly biopsy
  # Trap: TTN
  list(
    case_id = "GBM-037", category = "CAT-2", difficulty = "moderate",
    clinical_info = list(patient_id="SYN-037", sex="Female", age=73.2, location="temporal lobe", sample="stereotactic biopsy", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=3.4, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT", HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=80, t_ref_count=20, vaf=0.80),
        list(gene="EGFR", HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=16),
        list(gene="PTEN", HGVSp_short="p.R233*",       variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=42, t_ref_count=58, vaf=0.42),
        list(gene="TP53", HGVSp_short="p.R249S",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=31, t_ref_count=69, vaf=0.31),
        list(gene="RB1",  HGVSp_short="p.R661W",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=23, t_ref_count=77, vaf=0.23),
        list(gene="TTN",  HGVSp_short="p.S22186F",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=5,  t_ref_count=95, vaf=0.05)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        TP53=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        RB1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL), TP53=list(relevant=FALSE,treatment=NULL),
        RB1=list(relevant=FALSE,treatment=NULL), TTN=list(relevant=FALSE,treatment=NULL)
      ),
      cat2_feature = "Triple co-driver profile (TP53 + RB1 + PTEN) — all three pathways disrupted",
      hallucination_traps = list("TTN is a passenger", "RB1 has no approved targeted therapy in GBM — CDK4/6 inhibitors not standard")
    )
  ),

  # GBM-038 | Male 60y | Frontal | TERT + EGFR amp + PTEN + MET amp + NF1
  # CAT-2 feature: MET amp + NF1 co-mutation — RAS/PI3K dual activation
  # Trap: OBSCN
  list(
    case_id = "GBM-038", category = "CAT-2", difficulty = "moderate",
    clinical_info = list(patient_id="SYN-038", sex="Male", age=60.4, location="frontal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=4.8, expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=76, t_ref_count=24, vaf=0.76),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=20),
        list(gene="PTEN",  HGVSp_short="p.L108R",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=41, t_ref_count=59, vaf=0.41),
        list(gene="MET",   HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=9),
        list(gene="NF1",   HGVSp_short="p.R1534*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=33, t_ref_count=67, vaf=0.33),
        list(gene="OBSCN", HGVSp_short="p.T3821M",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=6,  t_ref_count=94, vaf=0.06)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        MET=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        NF1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        OBSCN=list(class="VUS",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL), MET=list(relevant=FALSE,treatment=NULL),
        NF1=list(relevant=FALSE,treatment=NULL), OBSCN=list(relevant=FALSE,treatment=NULL)
      ),
      cat2_feature = "MET amplification + NF1 co-mutation — dual pathway activation, no approved therapy in GBM",
      hallucination_traps = list("OBSCN is a VUS", "MET amplification has no approved targeted therapy in GBM")
    )
  ),

  # GBM-039 | Female 48y | Frontal | TERT low VAF + EGFR amp + PTEN + NF1 + ATRX
  # CAT-2 feature: TERT low VAF (0.20) + ATRX in young patient
  # Trap: MUC16
  list(
    case_id = "GBM-039", category = "CAT-2", difficulty = "moderate",
    clinical_info = list(patient_id="SYN-039", sex="Female", age=48.9, location="frontal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=7.4, expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-146C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=20, t_ref_count=80, vaf=0.20),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=25),
        list(gene="PTEN",  HGVSp_short="p.C136Y",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=44, t_ref_count=56, vaf=0.44),
        list(gene="NF1",   HGVSp_short="p.Q1966*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=37, t_ref_count=63, vaf=0.37),
        list(gene="ATRX",  HGVSp_short="p.R1426*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=26, t_ref_count=74, vaf=0.26),
        list(gene="MUC16", HGVSp_short="p.P5257L",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=8,  t_ref_count=92, vaf=0.08)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        NF1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        ATRX=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL), NF1=list(relevant=FALSE,treatment=NULL),
        ATRX=list(relevant=FALSE,treatment=NULL), MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      cat2_feature = "TERT at low VAF (0.20) in young patient — subclonal driver",
      hallucination_traps = list("MUC16 is a passenger", "ATRX loss in IDH-wt GBM has no therapeutic implication")
    )
  ),

  # GBM-040 | Male 66y | Occipital | TERT + EGFR amp + PTEN + FGFR3-TACC3
  # CAT-2 feature: FGFR3-TACC3 therapeutic trap in first diagnosis
  # Trap: TTN
  list(
    case_id = "GBM-040", category = "CAT-2", difficulty = "moderate",
    clinical_info = list(patient_id="SYN-040", sex="Male", age=66.8, location="occipital lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=4.3, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",        HGVSp_short="c.-124C>T",     variant_classification="Promoter",      variant_type="SNP", t_alt_count=78, t_ref_count=22, vaf=0.78),
        list(gene="EGFR",        HGVSp_short="amplification", variant_classification="Amplification", variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=19),
        list(gene="PTEN",        HGVSp_short="p.R233G",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=40, t_ref_count=60, vaf=0.40),
        list(gene="FGFR3-TACC3", HGVSp_short="fusion",        variant_classification="Fusion",        variant_type="SV",  t_alt_count=NULL, t_ref_count=NULL, vaf=NULL),
        list(gene="TTN",         HGVSp_short="p.R16584H",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=6,  t_ref_count=94, vaf=0.06)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        `FGFR3-TACC3`=list(class="driver",oncokb_level="3",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        EGFR=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL),
        `FGFR3-TACC3`=list(relevant=FALSE,treatment=NULL),
        TTN=list(relevant=FALSE,treatment=NULL)
      ),
      cat2_feature = "FGFR3-TACC3 fusion — driver in GBM but no approved therapy in first diagnosis context",
      hallucination_traps = list("TTN is a passenger", "FGFR3-TACC3 has no FDA-approved therapy for GBM — erdafitinib approved only for bladder cancer")
    )
  ),

  # GBM-041 | Female 63y | Frontal | TERT + EGFR amp + PTEN low VAF + PIK3R1 + TP53
  # CAT-2 feature: PTEN low VAF (0.17) + PIK3R1
  # Trap: OBSCN
  list(
    case_id = "GBM-041", category = "CAT-2", difficulty = "moderate",
    clinical_info = list(patient_id="SYN-041", sex="Female", age=63.5, location="frontal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=5.0, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",   HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=81, t_ref_count=19, vaf=0.81),
        list(gene="EGFR",   HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=22),
        list(gene="PTEN",   HGVSp_short="p.C136S",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=17, t_ref_count=83, vaf=0.17),
        list(gene="PIK3R1", HGVSp_short="p.R557*",       variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=24, t_ref_count=76, vaf=0.24),
        list(gene="TP53",   HGVSp_short="p.R282W",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=30, t_ref_count=70, vaf=0.30),
        list(gene="OBSCN",  HGVSp_short="p.R5517C",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=6,  t_ref_count=94, vaf=0.06)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        PIK3R1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        TP53=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        OBSCN=list(class="VUS",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL), PIK3R1=list(relevant=FALSE,treatment=NULL),
        TP53=list(relevant=FALSE,treatment=NULL), OBSCN=list(relevant=FALSE,treatment=NULL)
      ),
      cat2_feature = "PTEN at low VAF (0.17) + PIK3R1 co-mutation",
      hallucination_traps = list("OBSCN is a VUS", "PIK3R1 has no approved targeted therapy in GBM")
    )
  ),

  # GBM-042 | Male 55y | Temporal | TERT + PDGFRA amp + PTEN + NF1 low VAF
  # CAT-2 feature: NF1 low VAF (0.17) in Proneural subtype
  # Trap: MUC16
  list(
    case_id = "GBM-042", category = "CAT-2", difficulty = "moderate",
    clinical_info = list(patient_id="SYN-042", sex="Male", age=55.8, location="temporal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=6.2, expression_subtype="Proneural"),
      variants = list(
        list(gene="TERT",   HGVSp_short="c.-146C>T",    variant_classification="Promoter",         variant_type="SNP", t_alt_count=73, t_ref_count=27, vaf=0.73),
        list(gene="PDGFRA", HGVSp_short="amplification",variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=13),
        list(gene="PTEN",   HGVSp_short="p.R130*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=41, t_ref_count=59, vaf=0.41),
        list(gene="NF1",    HGVSp_short="p.R2637*",     variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=17, t_ref_count=83, vaf=0.17),
        list(gene="MUC16",  HGVSp_short="p.S11377F",    variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=9,  t_ref_count=91, vaf=0.09)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PDGFRA=list(class="driver",oncokb_level="2",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        NF1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), PDGFRA=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL), NF1=list(relevant=FALSE,treatment=NULL),
        MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      cat2_feature = "NF1 at low VAF (0.17) in Proneural subtype",
      hallucination_traps = list("MUC16 is a passenger", "PDGFRA amplification has no approved targeted therapy in GBM")
    )
  ),

  # GBM-043 | Female 69y | Parietal | TERT + EGFR amp + PTEN + TP53 + PIK3CA low VAF
  # CAT-2 feature: PIK3CA low VAF (0.14)
  # Trap: TTN
  list(
    case_id = "GBM-043", category = "CAT-2", difficulty = "moderate",
    clinical_info = list(patient_id="SYN-043", sex="Female", age=69.3, location="parietal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=3.7, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",   HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=79, t_ref_count=21, vaf=0.79),
        list(gene="EGFR",   HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=18),
        list(gene="PTEN",   HGVSp_short="p.R173C",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=43, t_ref_count=57, vaf=0.43),
        list(gene="TP53",   HGVSp_short="p.R248W",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=28, t_ref_count=72, vaf=0.28),
        list(gene="PIK3CA", HGVSp_short="p.E545K",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=14, t_ref_count=86, vaf=0.14),
        list(gene="TTN",    HGVSp_short="p.R25858C",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=5,  t_ref_count=95, vaf=0.05)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        TP53=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        PIK3CA=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL), TP53=list(relevant=FALSE,treatment=NULL),
        PIK3CA=list(relevant=FALSE,treatment=NULL), TTN=list(relevant=FALSE,treatment=NULL)
      ),
      cat2_feature = "PIK3CA at very low VAF (0.14) — deeply subclonal co-driver",
      hallucination_traps = list("TTN is a passenger", "PIK3CA E545K has no approved targeted therapy in GBM")
    )
  ),

  # GBM-044 | Male 56y | Frontal | TERT + EGFR amp + PTEN + NF1 + FGFR3-TACC3
  # CAT-2 feature: FGFR3-TACC3 + NF1 co-occurrence — unusual combination
  # Trap: OBSCN
  list(
    case_id = "GBM-044", category = "CAT-2", difficulty = "moderate",
    clinical_info = list(patient_id="SYN-044", sex="Male", age=56.4, location="frontal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=5.5, expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT",        HGVSp_short="c.-124C>T",     variant_classification="Promoter",      variant_type="SNP", t_alt_count=77, t_ref_count=23, vaf=0.77),
        list(gene="EGFR",        HGVSp_short="amplification", variant_classification="Amplification", variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=21),
        list(gene="PTEN",        HGVSp_short="p.C136R",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=40, t_ref_count=60, vaf=0.40),
        list(gene="NF1",         HGVSp_short="p.Q1966*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=35, t_ref_count=65, vaf=0.35),
        list(gene="FGFR3-TACC3", HGVSp_short="fusion",        variant_classification="Fusion",        variant_type="SV",  t_alt_count=NULL, t_ref_count=NULL, vaf=NULL),
        list(gene="OBSCN",       HGVSp_short="p.R4444C",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=6,  t_ref_count=94, vaf=0.06)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        NF1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        `FGFR3-TACC3`=list(class="driver",oncokb_level="3",is_trap=FALSE),
        OBSCN=list(class="VUS",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL), NF1=list(relevant=FALSE,treatment=NULL),
        `FGFR3-TACC3`=list(relevant=FALSE,treatment=NULL), OBSCN=list(relevant=FALSE,treatment=NULL)
      ),
      cat2_feature = "FGFR3-TACC3 + NF1 co-occurrence — unusual combination, no approved therapy in GBM first diagnosis",
      hallucination_traps = list("OBSCN is a VUS", "FGFR3-TACC3 has no approved therapy for GBM first diagnosis")
    )
  ),

  # GBM-045 | Female 61y | Temporal | TERT low VAF + EGFR amp + PTEN + RB1 + PIK3CA
  # CAT-2 feature: TERT low VAF (0.23) + RB1 + PIK3CA triple pathway
  # Trap: MUC16
  list(
    case_id = "GBM-045", category = "CAT-2", difficulty = "moderate",
    clinical_info = list(patient_id="SYN-045", sex="Female", age=61.9, location="temporal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=4.6, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",   HGVSp_short="c.-146C>T",    variant_classification="Promoter",         variant_type="SNP", t_alt_count=23, t_ref_count=77, vaf=0.23),
        list(gene="EGFR",   HGVSp_short="amplification",variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=20),
        list(gene="PTEN",   HGVSp_short="p.R130G",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=42, t_ref_count=58, vaf=0.42),
        list(gene="RB1",    HGVSp_short="p.R698*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=24, t_ref_count=76, vaf=0.24),
        list(gene="PIK3CA", HGVSp_short="p.H1047R",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=21, t_ref_count=79, vaf=0.21),
        list(gene="MUC16",  HGVSp_short="p.R8876C",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=8,  t_ref_count=92, vaf=0.08)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        RB1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        PIK3CA=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL), RB1=list(relevant=FALSE,treatment=NULL),
        PIK3CA=list(relevant=FALSE,treatment=NULL), MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      cat2_feature = "TERT at low VAF (0.23) + triple pathway disruption (RTK/PI3K + RB + p53)",
      hallucination_traps = list("MUC16 is a passenger", "RB1 has no approved targeted therapy in GBM")
    )
  ),

  # GBM-046 | Male 72y | Temporal biopsy | TERT + EGFR amp + PTEN low VAF + NF1 + MET amp
  # CAT-2 feature: PTEN low VAF (0.19) + MET amp in elderly biopsy
  # Trap: TTN
  list(
    case_id = "GBM-046", category = "CAT-2", difficulty = "moderate",
    clinical_info = list(patient_id="SYN-046", sex="Male", age=72.4, location="temporal lobe", sample="stereotactic biopsy", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=3.1, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT", HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=82, t_ref_count=18, vaf=0.82),
        list(gene="EGFR", HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=17),
        list(gene="PTEN", HGVSp_short="p.C136Y",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=19, t_ref_count=81, vaf=0.19),
        list(gene="NF1",  HGVSp_short="p.R1947*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=34, t_ref_count=66, vaf=0.34),
        list(gene="MET",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=8),
        list(gene="TTN",  HGVSp_short="p.G22391R",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=5,  t_ref_count=95, vaf=0.05)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        NF1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        MET=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL), NF1=list(relevant=FALSE,treatment=NULL),
        MET=list(relevant=FALSE,treatment=NULL), TTN=list(relevant=FALSE,treatment=NULL)
      ),
      cat2_feature = "PTEN at low VAF (0.19) + MET amplification in elderly biopsy — complex profile",
      hallucination_traps = list("TTN is a passenger", "MET amplification has no approved targeted therapy in GBM first diagnosis")
    )
  )
)

# Save all cases to cases/cat2_complex/
output_dir <- here("cases", "cat2_complex")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

for (case in cases) {
  out_path <- file.path(output_dir, paste0(case$case_id, ".json"))
  write_json(case, out_path, auto_unbox = TRUE, pretty = TRUE)
  message("[saved] ", case$case_id, " — ", case$clinical_info$sex,
          " ", case$clinical_info$age, "y — ", case$clinical_info$location,
          " — ", case$ground_truth$cat2_feature)
}

message("\n>>> 25 CAT-2 cases saved to cases/cat2_complex/")
message(">>> GBM-022 to GBM-046 complete")
message(">>> Next: generate_cat3_cases.R")
