# =============================================================
# generate_cat1_cases.R — GBM-LLM-Benchmark
# Generates 10 pilot cases (GBM-002 to GBM-011) — CAT-1
# Classic unambiguous GBM IDH-wildtype profiles
# Format mirrors TCGA-GBM (cBioPortal) clinical + mutation data
# =============================================================

library(jsonlite)
library(here)

cases <- list(

  list(
    case_id = "GBM-002", category = "CAT-1", difficulty = "low",
    clinical_info = list(patient_id="SYN-002", sex="Female", age=62.4, location="temporal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=3.8, expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-146C>T", variant_classification="Promoter",         variant_type="SNP", t_alt_count=68, t_ref_count=26, vaf=0.72),
        list(gene="EGFR",  HGVSp_short="p.A289V",   variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=41, t_ref_count=58, vaf=0.41),
        list(gene="PTEN",  HGVSp_short="p.R130*",   variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=39, t_ref_count=62, vaf=0.39),
        list(gene="NF1",   HGVSp_short="p.R1947*",  variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=33, t_ref_count=71, vaf=0.32),
        list(gene="MUC16", HGVSp_short="p.P5257L",  variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=11, t_ref_count=88, vaf=0.11)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE), EGFR=list(class="driver",oncokb_level="2",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE), NF1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL), NF1=list(relevant=FALSE,treatment=NULL),
        MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      hallucination_traps = list("MUC16 is a bystander — must not be classified as driver", "NF1 loss has no approved targeted therapy in GBM")
    )
  ),

  list(
    case_id = "GBM-003", category = "CAT-1", difficulty = "low",
    clinical_info = list(patient_id="SYN-003", sex="Male", age=55.1, location="parietal lobe", sample="stereotactic biopsy", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=5.1, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT", HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=74, t_ref_count=21, vaf=0.78),
        list(gene="EGFR", HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=22),
        list(gene="TP53", HGVSp_short="p.R273H",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=36, t_ref_count=64, vaf=0.36),
        list(gene="RB1",  HGVSp_short="p.R661W",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=29, t_ref_count=71, vaf=0.29),
        list(gene="TTN",  HGVSp_short="p.R14023C",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=9,  t_ref_count=91, vaf=0.09)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE), EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        TP53=list(class="co-driver",oncokb_level="3",is_trap=FALSE), RB1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL), EGFR=list(relevant=FALSE,treatment=NULL),
        TP53=list(relevant=FALSE,treatment=NULL), RB1=list(relevant=FALSE,treatment=NULL),
        TTN=list(relevant=FALSE,treatment=NULL)
      ),
      hallucination_traps = list("TTN is a large gene mutated by chance — not a driver", "RB1 has no approved targeted therapy in GBM")
    )
  ),

  list(
    case_id = "GBM-004", category = "CAT-1", difficulty = "low",
    clinical_info = list(patient_id="SYN-004", sex="Male", age=71.3, location="occipital lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=2.9, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",   HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=81, t_ref_count=19, vaf=0.81),
        list(gene="EGFR",   HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=31),
        list(gene="PTEN",   HGVSp_short="p.L108R",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=44, t_ref_count=56, vaf=0.44),
        list(gene="PIK3CA", HGVSp_short="p.H1047R",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=28, t_ref_count=72, vaf=0.28),
        list(gene="OBSCN",  HGVSp_short="p.R4444C",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=8,  t_ref_count=92, vaf=0.08)
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
      hallucination_traps = list("OBSCN has no established oncogenic role in GBM", "PIK3CA H1047R has no approved targeted therapy in GBM")
    )
  ),

  list(
    case_id = "GBM-005", category = "CAT-1", difficulty = "low",
    clinical_info = list(patient_id="SYN-005", sex="Female", age=48.7, location="frontal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=6.3, expression_subtype="Proneural"),
      variants = list(
        list(gene="TERT",   HGVSp_short="c.-146C>T",    variant_classification="Promoter",         variant_type="SNP", t_alt_count=69, t_ref_count=31, vaf=0.69),
        list(gene="PDGFRA", HGVSp_short="amplification",variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=14),
        list(gene="PTEN",   HGVSp_short="p.C136R",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=38, t_ref_count=62, vaf=0.38),
        list(gene="ATRX",   HGVSp_short="p.R1302*",     variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=31, t_ref_count=69, vaf=0.31),
        list(gene="MUC16",  HGVSp_short="p.S11377F",    variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=10, t_ref_count=90, vaf=0.10)
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

  list(
    case_id = "GBM-006", category = "CAT-1", difficulty = "low",
    clinical_info = list(patient_id="SYN-006", sex="Male", age=66.9, location="temporal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=4.4, expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT", HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=76, t_ref_count=24, vaf=0.76),
        list(gene="EGFR", HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=19),
        list(gene="NF1",  HGVSp_short="p.Q1966*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=42, t_ref_count=58, vaf=0.42),
        list(gene="TP53", HGVSp_short="p.R175H",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=35, t_ref_count=65, vaf=0.35),
        list(gene="TTN",  HGVSp_short="p.E26006K",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=7,  t_ref_count=93, vaf=0.07)
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
      hallucination_traps = list("TTN mutations are frequent passenger events", "NF1 loss has no approved targeted therapy in GBM")
    )
  ),

  list(
    case_id = "GBM-007", category = "CAT-1", difficulty = "low",
    clinical_info = list(patient_id="SYN-007", sex="Female", age=53.2, location="insular cortex", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=3.2, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=83, t_ref_count=17, vaf=0.83),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=28),
        list(gene="EGFR",  HGVSp_short="p.G598V",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=47, t_ref_count=53, vaf=0.47),
        list(gene="PTEN",  HGVSp_short="p.R173C",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=33, t_ref_count=67, vaf=0.33),
        list(gene="OBSCN", HGVSp_short="p.T5380M",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=6,  t_ref_count=94, vaf=0.06)
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
      hallucination_traps = list("OBSCN has no established role in GBM", "EGFR-targeted therapies failed in GBM trials")
    )
  ),

  list(
    case_id = "GBM-008", category = "CAT-1", difficulty = "low",
    clinical_info = list(patient_id="SYN-008", sex="Male", age=45.8, location="frontal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=7.1, expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT",   HGVSp_short="c.-146C>T",    variant_classification="Promoter",         variant_type="SNP", t_alt_count=71, t_ref_count=29, vaf=0.71),
        list(gene="EGFR",   HGVSp_short="amplification",variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=24),
        list(gene="PTEN",   HGVSp_short="p.C136Y",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=45, t_ref_count=55, vaf=0.45),
        list(gene="NF1",    HGVSp_short="p.R1241*",     variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=34, t_ref_count=66, vaf=0.34),
        list(gene="PIK3R1", HGVSp_short="p.R557*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=22, t_ref_count=78, vaf=0.22),
        list(gene="MUC16",  HGVSp_short="p.R10506H",    variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=8,  t_ref_count=92, vaf=0.08)
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
      hallucination_traps = list("MUC16 is a known passenger in GBM", "PIK3R1 + NF1 co-mutation has no approved combination therapy in GBM")
    )
  ),

  list(
    case_id = "GBM-009", category = "CAT-1", difficulty = "low",
    clinical_info = list(patient_id="SYN-009", sex="Female", age=74.1, location="temporal lobe", sample="stereotactic biopsy", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=2.7, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT", HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=79, t_ref_count=21, vaf=0.79),
        list(gene="EGFR", HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=16),
        list(gene="PTEN", HGVSp_short="p.R233*",       variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=41, t_ref_count=59, vaf=0.41),
        list(gene="TP53", HGVSp_short="p.R249S",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=28, t_ref_count=72, vaf=0.28),
        list(gene="TTN",  HGVSp_short="p.R19544W",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=6,  t_ref_count=94, vaf=0.06)
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
      hallucination_traps = list("TTN mutations reflect gene size artifact", "TP53 R249S has no approved targeted therapy in GBM")
    )
  ),

  list(
    case_id = "GBM-010", category = "CAT-1", difficulty = "low",
    clinical_info = list(patient_id="SYN-010", sex="Male", age=59.6, location="parietal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=4.9, expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=77, t_ref_count=23, vaf=0.77),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=21),
        list(gene="PTEN",  HGVSp_short="p.R130Q",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=43, t_ref_count=57, vaf=0.43),
        list(gene="NF1",   HGVSp_short="p.K1444*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=36, t_ref_count=64, vaf=0.36),
        list(gene="ATRX",  HGVSp_short="p.R781*",       variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=27, t_ref_count=73, vaf=0.27),
        list(gene="OBSCN", HGVSp_short="p.A6506T",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=7,  t_ref_count=93, vaf=0.07)
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

  list(
    case_id = "GBM-011", category = "CAT-1", difficulty = "low",
    clinical_info = list(patient_id="SYN-011", sex="Female", age=67.3, location="frontal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=5.5, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",   HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=82, t_ref_count=18, vaf=0.82),
        list(gene="EGFR",   HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=26),
        list(gene="EGFR",   HGVSp_short="p.R108K",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=51, t_ref_count=49, vaf=0.51),
        list(gene="TP53",   HGVSp_short="p.R248Q",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=29, t_ref_count=71, vaf=0.29),
        list(gene="PIK3CA", HGVSp_short="p.E545K",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=24, t_ref_count=76, vaf=0.24),
        list(gene="TTN",    HGVSp_short="p.R25858C",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=5,  t_ref_count=95, vaf=0.05)
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
      hallucination_traps = list("TTN is a large gene with frequent passenger mutations", "PIK3CA E545K has no approved targeted therapy in GBM")
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

message("\n>>> 10 pilot cases saved to cases/cat1_classic/")
message(">>> GBM-001 (template) + GBM-002 to GBM-011 = 11 CAT-1 cases total")
message(">>> Next step: source(here('analysis', 'scripts', '01_run_benchmark.R'))")
