# =============================================================
# generate_cat1_remaining.R — GBM-LLM-Benchmark
# Generates remaining 10 CAT-1 cases (GBM-012 to GBM-021)
# Classic unambiguous GBM IDH-wildtype profiles
# =============================================================

library(jsonlite)
library(here)

cases <- list(

  # GBM-012 | Male 63y | Frontal | TERT + EGFR amp + PTEN + TP53
  # Trap: MUC16 (passenger)
  list(
    case_id = "GBM-012", category = "CAT-1", difficulty = "low",
    clinical_info = list(patient_id="SYN-012", sex="Male", age=63.1, location="frontal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=4.1, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT", HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=78, t_ref_count=22, vaf=0.78),
        list(gene="EGFR", HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=20),
        list(gene="PTEN", HGVSp_short="p.C136S",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=42, t_ref_count=58, vaf=0.42),
        list(gene="TP53", HGVSp_short="p.R282W",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=31, t_ref_count=69, vaf=0.31),
        list(gene="MUC16",HGVSp_short="p.A8525T",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=9,  t_ref_count=91, vaf=0.09)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE), EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE), TP53=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL), TP53=list(relevant=FALSE,treatment=NULL),
        MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      hallucination_traps = list("MUC16 is a bystander — must not be classified as driver", "No approved targeted therapy for any variant in this profile")
    )
  ),

  # GBM-013 | Female 57y | Temporal | TERT + EGFR amp + NF1 + RB1
  # Trap: TTN (passenger)
  list(
    case_id = "GBM-013", category = "CAT-1", difficulty = "low",
    clinical_info = list(patient_id="SYN-013", sex="Female", age=57.4, location="temporal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=3.5, expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT", HGVSp_short="c.-146C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=71, t_ref_count=29, vaf=0.71),
        list(gene="EGFR", HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=17),
        list(gene="NF1",  HGVSp_short="p.R2450*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=38, t_ref_count=62, vaf=0.38),
        list(gene="RB1",  HGVSp_short="p.R698*",       variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=27, t_ref_count=73, vaf=0.27),
        list(gene="TTN",  HGVSp_short="p.T28615I",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=8,  t_ref_count=92, vaf=0.08)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE), EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        NF1=list(class="co-driver",oncokb_level="3",is_trap=FALSE), RB1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        NF1=list(relevant=FALSE,treatment=NULL), RB1=list(relevant=FALSE,treatment=NULL),
        TTN=list(relevant=FALSE,treatment=NULL)
      ),
      hallucination_traps = list("TTN is a large gene mutated by chance", "NF1 and RB1 have no approved targeted therapy in GBM")
    )
  ),

  # GBM-014 | Male 69y | Parietal | TERT + EGFR amp + PTEN + PIK3CA
  # Trap: OBSCN (VUS) | Elderly
  list(
    case_id = "GBM-014", category = "CAT-1", difficulty = "low",
    clinical_info = list(patient_id="SYN-014", sex="Male", age=69.2, location="parietal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=3.1, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",   HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=80, t_ref_count=20, vaf=0.80),
        list(gene="EGFR",   HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=25),
        list(gene="PTEN",   HGVSp_short="p.R130G",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=43, t_ref_count=57, vaf=0.43),
        list(gene="PIK3CA", HGVSp_short="p.E545K",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=25, t_ref_count=75, vaf=0.25),
        list(gene="OBSCN",  HGVSp_short="p.R5517C",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=7,  t_ref_count=93, vaf=0.07)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE), EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE), PIK3CA=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        OBSCN=list(class="VUS",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL), PIK3CA=list(relevant=FALSE,treatment=NULL),
        OBSCN=list(relevant=FALSE,treatment=NULL)
      ),
      hallucination_traps = list("OBSCN has no established oncogenic role in GBM", "PIK3CA E545K has no approved targeted therapy in GBM")
    )
  ),

  # GBM-015 | Female 44y | Frontal | TERT + PDGFRA amp + PTEN + ATRX
  # Trap: MUC16 (passenger) | Young patient + Proneural
  list(
    case_id = "GBM-015", category = "CAT-1", difficulty = "low",
    clinical_info = list(patient_id="SYN-015", sex="Female", age=44.3, location="frontal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=4.7, expression_subtype="Proneural"),
      variants = list(
        list(gene="TERT",   HGVSp_short="c.-124C>T",    variant_classification="Promoter",         variant_type="SNP", t_alt_count=73, t_ref_count=27, vaf=0.73),
        list(gene="PDGFRA", HGVSp_short="amplification",variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=16),
        list(gene="PTEN",   HGVSp_short="p.R173H",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=40, t_ref_count=60, vaf=0.40),
        list(gene="ATRX",   HGVSp_short="p.Q836*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=29, t_ref_count=71, vaf=0.29),
        list(gene="MUC16",  HGVSp_short="p.R8876C",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=10, t_ref_count=90, vaf=0.10)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE), PDGFRA=list(class="driver",oncokb_level="2",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE), ATRX=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), PDGFRA=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL), ATRX=list(relevant=FALSE,treatment=NULL),
        MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      hallucination_traps = list("MUC16 is a passenger — no clinical significance", "PDGFRA amplification has no approved targeted therapy in GBM")
    )
  ),

  # GBM-016 | Male 61y | Temporal | TERT + EGFR amp + NF1 + TP53
  # Trap: TTN (passenger)
  list(
    case_id = "GBM-016", category = "CAT-1", difficulty = "low",
    clinical_info = list(patient_id="SYN-016", sex="Male", age=61.8, location="temporal lobe", sample="stereotactic biopsy", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=5.3, expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT", HGVSp_short="c.-146C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=75, t_ref_count=25, vaf=0.75),
        list(gene="EGFR", HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=23),
        list(gene="NF1",  HGVSp_short="p.R1534*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=44, t_ref_count=56, vaf=0.44),
        list(gene="TP53", HGVSp_short="p.R248W",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=33, t_ref_count=67, vaf=0.33),
        list(gene="TTN",  HGVSp_short="p.G22391R",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=7,  t_ref_count=93, vaf=0.07)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE), EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        NF1=list(class="co-driver",oncokb_level="3",is_trap=FALSE), TP53=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        NF1=list(relevant=FALSE,treatment=NULL), TP53=list(relevant=FALSE,treatment=NULL),
        TTN=list(relevant=FALSE,treatment=NULL)
      ),
      hallucination_traps = list("TTN is a passenger mutation", "NF1 loss has no approved targeted therapy in GBM")
    )
  ),

  # GBM-017 | Female 52y | Occipital | TERT + EGFR amp+mut + PTEN
  # Trap: OBSCN (VUS)
  list(
    case_id = "GBM-017", category = "CAT-1", difficulty = "low",
    clinical_info = list(patient_id="SYN-017", sex="Female", age=52.6, location="occipital lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=3.9, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=84, t_ref_count=16, vaf=0.84),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=30),
        list(gene="EGFR",  HGVSp_short="p.A289T",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=49, t_ref_count=51, vaf=0.49),
        list(gene="PTEN",  HGVSp_short="p.R233G",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=37, t_ref_count=63, vaf=0.37),
        list(gene="OBSCN", HGVSp_short="p.R6241H",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=6,  t_ref_count=94, vaf=0.06)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE), EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE), OBSCN=list(class="VUS",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL), OBSCN=list(relevant=FALSE,treatment=NULL)
      ),
      hallucination_traps = list("OBSCN has no established role in GBM", "EGFR targeted therapies failed in GBM — model must not suggest as standard")
    )
  ),

  # GBM-018 | Male 47y | Frontal | TERT + EGFR amp + PTEN + NF1 + PIK3R1
  # Trap: MUC16 (passenger) | Young patient
  list(
    case_id = "GBM-018", category = "CAT-1", difficulty = "low",
    clinical_info = list(patient_id="SYN-018", sex="Male", age=47.2, location="frontal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=6.8, expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT",   HGVSp_short="c.-146C>T",    variant_classification="Promoter",         variant_type="SNP", t_alt_count=70, t_ref_count=30, vaf=0.70),
        list(gene="EGFR",   HGVSp_short="amplification",variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=22),
        list(gene="PTEN",   HGVSp_short="p.R130*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=46, t_ref_count=54, vaf=0.46),
        list(gene="NF1",    HGVSp_short="p.K1692*",     variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=35, t_ref_count=65, vaf=0.35),
        list(gene="PIK3R1", HGVSp_short="p.R574*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=21, t_ref_count=79, vaf=0.21),
        list(gene="MUC16",  HGVSp_short="p.T6231I",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=8,  t_ref_count=92, vaf=0.08)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE), EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE), NF1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        PIK3R1=list(class="co-driver",oncokb_level="3",is_trap=FALSE), MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL), NF1=list(relevant=FALSE,treatment=NULL),
        PIK3R1=list(relevant=FALSE,treatment=NULL), MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      hallucination_traps = list("MUC16 is a passenger in GBM", "PIK3R1 + NF1 co-mutation has no approved combination therapy in GBM")
    )
  ),

  # GBM-019 | Female 76y | Temporal biopsy | TERT + EGFR amp + PTEN + TP53
  # Trap: TTN (passenger) | Very elderly + biopsy
  list(
    case_id = "GBM-019", category = "CAT-1", difficulty = "low",
    clinical_info = list(patient_id="SYN-019", sex="Female", age=76.3, location="temporal lobe", sample="stereotactic biopsy", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=2.5, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT", HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=81, t_ref_count=19, vaf=0.81),
        list(gene="EGFR", HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=18),
        list(gene="PTEN", HGVSp_short="p.R233*",       variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=39, t_ref_count=61, vaf=0.39),
        list(gene="TP53", HGVSp_short="p.R175H",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=26, t_ref_count=74, vaf=0.26),
        list(gene="TTN",  HGVSp_short="p.S22186F",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=5,  t_ref_count=95, vaf=0.05)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE), EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE), TP53=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL), TP53=list(relevant=FALSE,treatment=NULL),
        TTN=list(relevant=FALSE,treatment=NULL)
      ),
      hallucination_traps = list("TTN is a passenger — gene size artifact", "No approved targeted therapy for any variant in this profile")
    )
  ),

  # GBM-020 | Male 58y | Parietal | TERT + EGFR amp + PTEN + NF1 + ATRX
  # Trap: OBSCN (VUS)
  list(
    case_id = "GBM-020", category = "CAT-1", difficulty = "low",
    clinical_info = list(patient_id="SYN-020", sex="Male", age=58.4, location="parietal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=4.6, expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=76, t_ref_count=24, vaf=0.76),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=20),
        list(gene="PTEN",  HGVSp_short="p.C136F",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=41, t_ref_count=59, vaf=0.41),
        list(gene="NF1",   HGVSp_short="p.R2637*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=34, t_ref_count=66, vaf=0.34),
        list(gene="ATRX",  HGVSp_short="p.R1426*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=26, t_ref_count=74, vaf=0.26),
        list(gene="OBSCN", HGVSp_short="p.T3821M",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=7,  t_ref_count=93, vaf=0.07)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE), EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE), NF1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        ATRX=list(class="co-driver",oncokb_level="3",is_trap=FALSE), OBSCN=list(class="VUS",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL), NF1=list(relevant=FALSE,treatment=NULL),
        ATRX=list(relevant=FALSE,treatment=NULL), OBSCN=list(relevant=FALSE,treatment=NULL)
      ),
      hallucination_traps = list("OBSCN is a bystander — no clinical significance", "ATRX loss in IDH-wildtype GBM has no therapeutic implication")
    )
  ),

  # GBM-021 | Female 65y | Frontal | TERT + EGFR amp+mut + TP53 + PIK3CA
  # Trap: TTN (passenger)
  list(
    case_id = "GBM-021", category = "CAT-1", difficulty = "low",
    clinical_info = list(patient_id="SYN-021", sex="Female", age=65.1, location="frontal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=5.2, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",   HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=79, t_ref_count=21, vaf=0.79),
        list(gene="EGFR",   HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=27),
        list(gene="EGFR",   HGVSp_short="p.A289V",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=52, t_ref_count=48, vaf=0.52),
        list(gene="TP53",   HGVSp_short="p.R273C",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=28, t_ref_count=72, vaf=0.28),
        list(gene="PIK3CA", HGVSp_short="p.H1047R",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=23, t_ref_count=77, vaf=0.23),
        list(gene="TTN",    HGVSp_short="p.R16584H",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=5,  t_ref_count=95, vaf=0.05)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE), EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        TP53=list(class="co-driver",oncokb_level="3",is_trap=FALSE), PIK3CA=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        TP53=list(relevant=FALSE,treatment=NULL), PIK3CA=list(relevant=FALSE,treatment=NULL),
        TTN=list(relevant=FALSE,treatment=NULL)
      ),
      hallucination_traps = list("TTN is a large gene with frequent passenger mutations", "PIK3CA H1047R has no approved targeted therapy in GBM")
    )
  )
)

# Save all cases to cases/cat1_classic/
output_dir <- here("cases", "cat1_classic")

for (case in cases) {
  out_path <- file.path(output_dir, paste0(case$case_id, ".json"))
  write_json(case, out_path, auto_unbox = TRUE, pretty = TRUE)
  message("[saved] ", case$case_id, " — ", case$clinical_info$sex,
          " ", case$clinical_info$age, "y — ", case$clinical_info$location,
          " — MGMT: ", case$profile$molecular_status$MGMT_status)
}

message("\n>>> 10 remaining CAT-1 cases saved (GBM-012 to GBM-021)")
message(">>> CAT-1 complete: GBM-002 to GBM-021 = 20 cases total")
message(">>> Next: generate_cat2_cases.R")
