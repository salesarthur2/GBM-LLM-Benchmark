# =============================================================
# generate_cat4_cases.R — GBM-LLM-Benchmark
# Generates 20 CAT-4 cases (GBM-072 to GBM-091)
# Primary GBM, first diagnosis
# Rare/uncommon variants without GBM-specific approval
# Most sophisticated hallucination traps in the dataset
# Therapeutic relevance = No for ALL variants
# =============================================================

library(jsonlite)
library(here)

cases <- list(

  # GBM-072 | Male 54y | Frontal | TERT + EGFR amp + H3K27M (non-GBM variant)
  # CAT-4 feature: H3F3A p.K27M — driver in diffuse midline glioma, not adult GBM
  # Trap: MUC16
  list(
    case_id = "GBM-072", category = "CAT-4", difficulty = "high",
    clinical_info = list(patient_id="SYN-072", sex="Male", age=54.3, location="thalamus", sample="stereotactic biopsy", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=3.8, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=74, t_ref_count=26, vaf=0.74),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=19),
        list(gene="H3F3A", HGVSp_short="p.K27M",        variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=41, t_ref_count=59, vaf=0.41),
        list(gene="PTEN",  HGVSp_short="p.R130Q",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=38, t_ref_count=62, vaf=0.38),
        list(gene="MUC16", HGVSp_short="p.P5257L",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=9,  t_ref_count=91, vaf=0.09)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        H3F3A=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        EGFR=list(relevant=FALSE,treatment=NULL),
        H3F3A=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL),
        MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      cat4_feature = "H3F3A p.K27M — defines diffuse midline glioma H3K27-altered but VUS in adult GBM IDH-wt thalamic context; no approved targeted therapy",
      hallucination_traps = list(
        "MUC16 is a passenger",
        "H3F3A p.K27M has no approved targeted therapy — ONC201 (tabelecleucel) is investigational and not approved",
        "H3F3A p.K27M in adult thalamic GBM IDH-wt context is VUS — does not reclassify as diffuse midline glioma without midline location confirmation"
      )
    )
  ),

  # GBM-073 | Female 58y | Frontal | TERT + EGFR amp + CDK4 amp
  # CAT-4 feature: CDK4 amplification — RB pathway, no approved therapy in GBM
  # Trap: TTN
  list(
    case_id = "GBM-073", category = "CAT-4", difficulty = "high",
    clinical_info = list(patient_id="SYN-073", sex="Female", age=58.1, location="frontal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=4.6, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT", HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=78, t_ref_count=22, vaf=0.78),
        list(gene="EGFR", HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=21),
        list(gene="CDK4", HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=12),
        list(gene="PTEN", HGVSp_short="p.C136R",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=41, t_ref_count=59, vaf=0.41),
        list(gene="TTN",  HGVSp_short="p.R14023C",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=6,  t_ref_count=94, vaf=0.06)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        CDK4=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        EGFR=list(relevant=FALSE,treatment=NULL),
        CDK4=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL),
        TTN=list(relevant=FALSE,treatment=NULL)
      ),
      cat4_feature = "CDK4 amplification — co-driver in GBM via RB pathway, no approved CDK4/6 inhibitor for GBM",
      hallucination_traps = list(
        "TTN is a passenger",
        "CDK4 amplification has no approved targeted therapy in GBM — palbociclib/ribociclib approved in breast cancer only"
      )
    )
  ),

  # GBM-074 | Male 62y | Temporal | TERT + EGFR amp + EGFRvIII-like + PTEN
  # CAT-4 feature: EGFR exon 2-7 deletion (EGFRvIII) — no approved therapy
  # Trap: OBSCN
  list(
    case_id = "GBM-074", category = "CAT-4", difficulty = "high",
    clinical_info = list(patient_id="SYN-074", sex="Male", age=62.7, location="temporal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=4.1, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",    HGVSp_short="c.-124C>T",        variant_classification="Promoter",         variant_type="SNP", t_alt_count=80, t_ref_count=20, vaf=0.80),
        list(gene="EGFR",    HGVSp_short="amplification",    variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=25),
        list(gene="EGFR",    HGVSp_short="exon2-7deletion",  variant_classification="In_Frame_Del",     variant_type="DEL", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL),
        list(gene="PTEN",    HGVSp_short="p.R233*",          variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=40, t_ref_count=60, vaf=0.40),
        list(gene="OBSCN",   HGVSp_short="p.T5380M",         variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=7,  t_ref_count=93, vaf=0.07)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        OBSCN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        EGFR=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL),
        OBSCN=list(relevant=FALSE,treatment=NULL)
      ),
      cat4_feature = "EGFRvIII (exon 2-7 deletion) — most common EGFR variant in GBM, no approved targeted therapy; rindopepimut vaccine failed phase III",
      hallucination_traps = list(
        "OBSCN is a passenger",
        "EGFRvIII has no approved targeted therapy — rindopepimut failed in ACT IV trial; AMG 596 and other agents are investigational only"
      )
    )
  ),

  # GBM-075 | Female 49y | Frontal | TERT + PDGFRA amp + PTEN + FGFR1 mut
  # CAT-4 feature: FGFR1 p.N546K — actionable in pediatric glioma but not adult GBM
  # Trap: MUC16
  list(
    case_id = "GBM-075", category = "CAT-4", difficulty = "high",
    clinical_info = list(patient_id="SYN-075", sex="Female", age=49.4, location="frontal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=5.9, expression_subtype="Proneural"),
      variants = list(
        list(gene="TERT",   HGVSp_short="c.-146C>T",    variant_classification="Promoter",         variant_type="SNP", t_alt_count=71, t_ref_count=29, vaf=0.71),
        list(gene="PDGFRA", HGVSp_short="amplification",variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=14),
        list(gene="PTEN",   HGVSp_short="p.C136Y",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=39, t_ref_count=61, vaf=0.39),
        list(gene="FGFR1",  HGVSp_short="p.N546K",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=22, t_ref_count=78, vaf=0.22),
        list(gene="MUC16",  HGVSp_short="p.S11377F",    variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=9,  t_ref_count=91, vaf=0.09)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PDGFRA=list(class="driver",oncokb_level="2",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        FGFR1=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        PDGFRA=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL),
        FGFR1=list(relevant=FALSE,treatment=NULL),
        MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      cat4_feature = "FGFR1 p.N546K — driver in pediatric low-grade glioma but VUS in adult GBM IDH-wt; no approved FGFR inhibitor for adult GBM",
      hallucination_traps = list(
        "MUC16 is a passenger",
        "FGFR1 p.N546K has no approved targeted therapy in adult GBM — relevant in pediatric pilocytic astrocytoma only",
        "PDGFRA amplification has no approved targeted therapy in GBM"
      )
    )
  ),

  # GBM-076 | Male 66y | Temporal | TERT + EGFR amp + MET exon14 + PTEN
  # CAT-4 feature: MET exon 14 skipping — no approval in GBM first diagnosis
  # Trap: TTN
  list(
    case_id = "GBM-076", category = "CAT-4", difficulty = "high",
    clinical_info = list(patient_id="SYN-076", sex="Male", age=66.2, location="temporal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=4.3, expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT", HGVSp_short="c.-124C>T",         variant_classification="Promoter",         variant_type="SNP", t_alt_count=79, t_ref_count=21, vaf=0.79),
        list(gene="EGFR", HGVSp_short="amplification",     variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=20),
        list(gene="MET",  HGVSp_short="exon14skipping",    variant_classification="Splice_Site",      variant_type="SNP", t_alt_count=31, t_ref_count=69, vaf=0.31),
        list(gene="PTEN", HGVSp_short="p.R173C",           variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=42, t_ref_count=58, vaf=0.42),
        list(gene="TTN",  HGVSp_short="p.R19544W",         variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=6,  t_ref_count=94, vaf=0.06)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        MET=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        EGFR=list(relevant=FALSE,treatment=NULL),
        MET=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL),
        TTN=list(relevant=FALSE,treatment=NULL)
      ),
      cat4_feature = "MET exon 14 skipping — approved in NSCLC (capmatinib/tepotinib) but no approval in GBM first diagnosis",
      hallucination_traps = list(
        "TTN is a passenger",
        "MET exon 14 skipping has no approved targeted therapy in GBM first diagnosis — capmatinib/tepotinib approved in NSCLC only"
      )
    )
  ),

  # GBM-077 | Female 55y | Parietal | TERT + EGFR amp + BRAF V600E + PTEN
  # CAT-4 feature: BRAF V600E in first diagnosis — No in this context
  # Trap: OBSCN
  list(
    case_id = "GBM-077", category = "CAT-4", difficulty = "high",
    clinical_info = list(patient_id="SYN-077", sex="Female", age=55.6, location="parietal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=5.2, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=77, t_ref_count=23, vaf=0.77),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=22),
        list(gene="BRAF",  HGVSp_short="p.V600E",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=38, t_ref_count=62, vaf=0.38),
        list(gene="PTEN",  HGVSp_short="p.R130*",       variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=43, t_ref_count=57, vaf=0.43),
        list(gene="OBSCN", HGVSp_short="p.A6506T",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=7,  t_ref_count=93, vaf=0.07)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        BRAF=list(class="driver",oncokb_level="2",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        OBSCN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        EGFR=list(relevant=FALSE,treatment=NULL),
        BRAF=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL),
        OBSCN=list(relevant=FALSE,treatment=NULL)
      ),
      cat4_feature = "BRAF V600E in first diagnosis GBM — standard first-line treatment is Stupp protocol regardless; dabrafenib+trametinib applies post-progression only",
      hallucination_traps = list(
        "OBSCN is a passenger",
        "BRAF V600E in first diagnosis GBM: therapeutic relevance is No — Stupp protocol is standard first-line regardless of BRAF status; dabrafenib+trametinib FDA approval requires prior treatment"
      )
    )
  ),

  # GBM-078 | Male 60y | Frontal | TERT + EGFR amp + MDM4 amp + PTEN
  # CAT-4 feature: MDM4 amplification — p53 pathway, no approved therapy
  # Trap: MUC16
  list(
    case_id = "GBM-078", category = "CAT-4", difficulty = "high",
    clinical_info = list(patient_id="SYN-078", sex="Male", age=60.8, location="frontal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=4.7, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=81, t_ref_count=19, vaf=0.81),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=23),
        list(gene="MDM4",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=8),
        list(gene="PTEN",  HGVSp_short="p.L108R",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=40, t_ref_count=60, vaf=0.40),
        list(gene="MUC16", HGVSp_short="p.R10506H",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=8,  t_ref_count=92, vaf=0.08)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        MDM4=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        EGFR=list(relevant=FALSE,treatment=NULL),
        MDM4=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL),
        MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      cat4_feature = "MDM4 amplification — p53 pathway co-driver in GBM, no approved MDM2/4 inhibitor for GBM",
      hallucination_traps = list(
        "MUC16 is a passenger",
        "MDM4 amplification has no approved targeted therapy in GBM — MDM2/4 inhibitors are investigational"
      )
    )
  ),

  # GBM-079 | Female 63y | Temporal | TERT + EGFR amp + FGFR3-TACC3 + NF1
  # CAT-4 feature: FGFR3-TACC3 in first diagnosis — No despite being a known GBM driver
  # Trap: TTN
  list(
    case_id = "GBM-079", category = "CAT-4", difficulty = "high",
    clinical_info = list(patient_id="SYN-079", sex="Female", age=63.4, location="temporal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=5.0, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",        HGVSp_short="c.-124C>T",     variant_classification="Promoter",      variant_type="SNP", t_alt_count=76, t_ref_count=24, vaf=0.76),
        list(gene="EGFR",        HGVSp_short="amplification", variant_classification="Amplification", variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=18),
        list(gene="FGFR3-TACC3", HGVSp_short="fusion",        variant_classification="Fusion",        variant_type="SV",  t_alt_count=NULL, t_ref_count=NULL, vaf=NULL),
        list(gene="NF1",         HGVSp_short="p.R1947*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=35, t_ref_count=65, vaf=0.35),
        list(gene="TTN",         HGVSp_short="p.G22391R",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=6,  t_ref_count=94, vaf=0.06)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        `FGFR3-TACC3`=list(class="driver",oncokb_level="3",is_trap=FALSE),
        NF1=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        EGFR=list(relevant=FALSE,treatment=NULL),
        `FGFR3-TACC3`=list(relevant=FALSE,treatment=NULL),
        NF1=list(relevant=FALSE,treatment=NULL),
        TTN=list(relevant=FALSE,treatment=NULL)
      ),
      cat4_feature = "FGFR3-TACC3 fusion — established driver in GBM but no FDA/EMA approved therapy for GBM first diagnosis; erdafitinib approved in bladder cancer only",
      hallucination_traps = list(
        "TTN is a passenger",
        "FGFR3-TACC3 has no approved targeted therapy for GBM — erdafitinib approved in bladder cancer; GBM trials ongoing but no approval"
      )
    )
  ),

  # GBM-080 | Male 57y | Occipital | TERT + EGFR amp + PIK3CA + CDK4 amp
  # CAT-4 feature: CDK4 amp + PIK3CA co-mutation — dual pathway, no approved therapy
  # Trap: OBSCN
  list(
    case_id = "GBM-080", category = "CAT-4", difficulty = "high",
    clinical_info = list(patient_id="SYN-080", sex="Male", age=57.3, location="occipital lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=5.6, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",   HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=80, t_ref_count=20, vaf=0.80),
        list(gene="EGFR",   HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=21),
        list(gene="PIK3CA", HGVSp_short="p.E545K",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=26, t_ref_count=74, vaf=0.26),
        list(gene="CDK4",   HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=11),
        list(gene="OBSCN",  HGVSp_short="p.R5517C",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=7,  t_ref_count=93, vaf=0.07)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PIK3CA=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        CDK4=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        OBSCN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        EGFR=list(relevant=FALSE,treatment=NULL),
        PIK3CA=list(relevant=FALSE,treatment=NULL),
        CDK4=list(relevant=FALSE,treatment=NULL),
        OBSCN=list(relevant=FALSE,treatment=NULL)
      ),
      cat4_feature = "CDK4 amplification + PIK3CA co-mutation — dual co-driver profile, no approved targeted therapy for either in GBM",
      hallucination_traps = list(
        "OBSCN is a passenger",
        "CDK4 amplification has no approved targeted therapy in GBM",
        "PIK3CA E545K has no approved targeted therapy in GBM — alpelisib approved in PIK3CA-mutant breast cancer only"
      )
    )
  ),

  # GBM-081 | Female 52y | Frontal | TERT + EGFR amp + EGFR exon19del + PTEN
  # CAT-4 feature: EGFR exon 19 deletion — actionable in NSCLC but not GBM
  # Trap: MUC16
  list(
    case_id = "GBM-081", category = "CAT-4", difficulty = "high",
    clinical_info = list(patient_id="SYN-081", sex="Female", age=52.8, location="frontal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=4.4, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-124C>T",        variant_classification="Promoter",         variant_type="SNP", t_alt_count=79, t_ref_count=21, vaf=0.79),
        list(gene="EGFR",  HGVSp_short="amplification",    variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=24),
        list(gene="EGFR",  HGVSp_short="p.E746_A750del",   variant_classification="In_Frame_Del",     variant_type="DEL", t_alt_count=44, t_ref_count=56, vaf=0.44),
        list(gene="PTEN",  HGVSp_short="p.R130Q",          variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=41, t_ref_count=59, vaf=0.41),
        list(gene="MUC16", HGVSp_short="p.T6231I",         variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=8,  t_ref_count=92, vaf=0.08)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        EGFR=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL),
        MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      cat4_feature = "EGFR exon 19 deletion — sensitizing mutation for osimertinib/erlotinib in NSCLC but no approved EGFR TKI for GBM",
      hallucination_traps = list(
        "MUC16 is a passenger",
        "EGFR exon 19 deletion has no approved targeted therapy in GBM — osimertinib/erlotinib approved in NSCLC only; EGFR TKIs failed in GBM trials"
      )
    )
  ),

  # GBM-082 | Male 68y | Temporal | TERT + EGFR amp + RET fusion + PTEN
  # CAT-4 feature: RET fusion — actionable in thyroid/NSCLC but not GBM
  # Trap: TTN
  list(
    case_id = "GBM-082", category = "CAT-4", difficulty = "high",
    clinical_info = list(patient_id="SYN-082", sex="Male", age=68.6, location="temporal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=3.9, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT", HGVSp_short="c.-124C>T",     variant_classification="Promoter",      variant_type="SNP", t_alt_count=82, t_ref_count=18, vaf=0.82),
        list(gene="EGFR", HGVSp_short="amplification", variant_classification="Amplification", variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=19),
        list(gene="RET",  HGVSp_short="fusion",        variant_classification="Fusion",        variant_type="SV",  t_alt_count=NULL, t_ref_count=NULL, vaf=NULL),
        list(gene="PTEN", HGVSp_short="p.R233G",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=40, t_ref_count=60, vaf=0.40),
        list(gene="TTN",  HGVSp_short="p.S22186F",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=6,  t_ref_count=94, vaf=0.06)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        RET=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        EGFR=list(relevant=FALSE,treatment=NULL),
        RET=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL),
        TTN=list(relevant=FALSE,treatment=NULL)
      ),
      cat4_feature = "RET fusion — actionable in NSCLC/thyroid cancer (selpercatinib/pralsetinib) but VUS in GBM; no approved RET inhibitor for GBM",
      hallucination_traps = list(
        "TTN is a passenger",
        "RET fusion has no approved targeted therapy in GBM — selpercatinib/pralsetinib approved in NSCLC and thyroid only"
      )
    )
  ),

  # GBM-083 | Female 46y | Frontal | TERT + EGFR amp + ALK fusion + PTEN
  # CAT-4 feature: ALK fusion — actionable in NSCLC but extremely rare/not actionable in GBM
  # Trap: OBSCN
  list(
    case_id = "GBM-083", category = "CAT-4", difficulty = "high",
    clinical_info = list(patient_id="SYN-083", sex="Female", age=46.7, location="frontal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=6.1, expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-146C>T",     variant_classification="Promoter",      variant_type="SNP", t_alt_count=73, t_ref_count=27, vaf=0.73),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification", variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=22),
        list(gene="ALK",   HGVSp_short="fusion",        variant_classification="Fusion",        variant_type="SV",  t_alt_count=NULL, t_ref_count=NULL, vaf=NULL),
        list(gene="PTEN",  HGVSp_short="p.C136F",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=41, t_ref_count=59, vaf=0.41),
        list(gene="OBSCN", HGVSp_short="p.T3821M",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=7,  t_ref_count=93, vaf=0.07)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        ALK=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        OBSCN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        EGFR=list(relevant=FALSE,treatment=NULL),
        ALK=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL),
        OBSCN=list(relevant=FALSE,treatment=NULL)
      ),
      cat4_feature = "ALK fusion — major actionable target in NSCLC but extremely rare and VUS in GBM; no approved ALK inhibitor for GBM",
      hallucination_traps = list(
        "OBSCN is a passenger",
        "ALK fusion has no approved targeted therapy in GBM — alectinib/lorlatinib approved in NSCLC only; ALK fusions are rare and not validated as GBM drivers"
      )
    )
  ),

  # GBM-084 | Male 61y | Parietal | TERT + EGFR amp + MDM2 amp + TP53 WT
  # CAT-4 feature: MDM2 amplification with TP53 wildtype — classic GBM feature
  # Trap: MUC16
  list(
    case_id = "GBM-084", category = "CAT-4", difficulty = "high",
    clinical_info = list(patient_id="SYN-084", sex="Male", age=61.5, location="parietal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=4.2, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=78, t_ref_count=22, vaf=0.78),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=20),
        list(gene="MDM2",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=9),
        list(gene="PTEN",  HGVSp_short="p.R130G",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=39, t_ref_count=61, vaf=0.39),
        list(gene="MUC16", HGVSp_short="p.A8525T",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=8,  t_ref_count=92, vaf=0.08)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        MDM2=list(class="co-driver",oncokb_level="3",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        EGFR=list(relevant=FALSE,treatment=NULL),
        MDM2=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL),
        MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      cat4_feature = "MDM2 amplification — p53 pathway co-driver in GBM (alternative to TP53 mutation); no approved MDM2 inhibitor for GBM",
      hallucination_traps = list(
        "MUC16 is a passenger",
        "MDM2 amplification has no approved targeted therapy in GBM — MDM2 inhibitors (navtemadlin) are investigational"
      )
    )
  ),

  # GBM-085 | Female 59y | Temporal | TERT + PDGFRA amp + PDGFRA p.D842V + PTEN
  # CAT-4 feature: PDGFRA p.D842V — actionable in GIST but not GBM
  # Trap: TTN
  list(
    case_id = "GBM-085", category = "CAT-4", difficulty = "high",
    clinical_info = list(patient_id="SYN-085", sex="Female", age=59.3, location="temporal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=5.4, expression_subtype="Proneural"),
      variants = list(
        list(gene="TERT",   HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=75, t_ref_count=25, vaf=0.75),
        list(gene="PDGFRA", HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=16),
        list(gene="PDGFRA", HGVSp_short="p.D842V",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=36, t_ref_count=64, vaf=0.36),
        list(gene="PTEN",   HGVSp_short="p.C136R",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=40, t_ref_count=60, vaf=0.40),
        list(gene="TTN",    HGVSp_short="p.R16584H",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=6,  t_ref_count=94, vaf=0.06)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        PDGFRA=list(class="driver",oncokb_level="2",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        PDGFRA=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL),
        TTN=list(relevant=FALSE,treatment=NULL)
      ),
      cat4_feature = "PDGFRA p.D842V — driver mutation actionable in GIST (avapritinib) but no approved PDGFRA inhibitor for GBM",
      hallucination_traps = list(
        "TTN is a passenger",
        "PDGFRA p.D842V has no approved targeted therapy in GBM — avapritinib approved in PDGFRA D842V-mutant GIST only; PDGFR inhibitors failed in GBM trials"
      )
    )
  ),

  # GBM-086 | Male 64y | Frontal | TERT + EGFR amp + KIT amp + PTEN
  # CAT-4 feature: KIT amplification — GIST/melanoma target, not GBM
  # Trap: OBSCN
  list(
    case_id = "GBM-086", category = "CAT-4", difficulty = "high",
    clinical_info = list(patient_id="SYN-086", sex="Male", age=64.1, location="frontal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=4.8, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=80, t_ref_count=20, vaf=0.80),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=22),
        list(gene="KIT",   HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=7),
        list(gene="PTEN",  HGVSp_short="p.R173H",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=41, t_ref_count=59, vaf=0.41),
        list(gene="OBSCN", HGVSp_short="p.R4444C",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=7,  t_ref_count=93, vaf=0.07)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        KIT=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        OBSCN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        EGFR=list(relevant=FALSE,treatment=NULL),
        KIT=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL),
        OBSCN=list(relevant=FALSE,treatment=NULL)
      ),
      cat4_feature = "KIT amplification — VUS in GBM; imatinib approved in GIST/CML but no KIT-targeted therapy for GBM",
      hallucination_traps = list(
        "OBSCN is a passenger",
        "KIT amplification has no approved targeted therapy in GBM — imatinib approved in GIST only; KIT inhibitors failed in GBM trials"
      )
    )
  ),

  # GBM-087 | Female 53y | Temporal | TERT + EGFR amp + IDH1 p.R132C + PTEN
  # CAT-4 feature: IDH1 p.R132C (non-canonical) — rare IDH1 variant, different from R132H
  # Trap: MUC16
  list(
    case_id = "GBM-087", category = "CAT-4", difficulty = "high",
    clinical_info = list(patient_id="SYN-087", sex="Female", age=53.9, location="temporal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=5.7, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=77, t_ref_count=23, vaf=0.77),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=20),
        list(gene="IDH1",  HGVSp_short="p.R132C",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=14, t_ref_count=86, vaf=0.14),
        list(gene="PTEN",  HGVSp_short="p.R233*",       variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=42, t_ref_count=58, vaf=0.42),
        list(gene="MUC16", HGVSp_short="p.R8876C",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=8,  t_ref_count=92, vaf=0.08)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        IDH1=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        EGFR=list(relevant=FALSE,treatment=NULL),
        IDH1=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL),
        MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      cat4_feature = "IDH1 p.R132C at low VAF in IDH-wildtype GBM context — VUS; ivosidenib approved in IDH1-mutant AML/cholangiocarcinoma but not GBM; molecular status is IDH-wildtype",
      hallucination_traps = list(
        "MUC16 is a passenger",
        "IDH1 p.R132C at low VAF in IDH-wildtype GBM is VUS — molecular status remains IDH-wildtype; ivosidenib not applicable",
        "This is NOT IDH-mutant glioma — TERT + EGFR amp + CDKN2A del confirm GBM IDH-wildtype classification"
      )
    )
  ),

  # GBM-088 | Male 67y | Occipital | TERT + EGFR amp + NF2 + PTEN
  # CAT-4 feature: NF2 mutation — meningioma/schwannoma driver, VUS in GBM
  # Trap: TTN
  list(
    case_id = "GBM-088", category = "CAT-4", difficulty = "high",
    clinical_info = list(patient_id="SYN-088", sex="Male", age=67.4, location="occipital lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=3.8, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT", HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=82, t_ref_count=18, vaf=0.82),
        list(gene="EGFR", HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=19),
        list(gene="NF2",  HGVSp_short="p.R341*",       variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=21, t_ref_count=79, vaf=0.21),
        list(gene="PTEN", HGVSp_short="p.C136Y",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=40, t_ref_count=60, vaf=0.40),
        list(gene="TTN",  HGVSp_short="p.R25858C",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=5,  t_ref_count=95, vaf=0.05)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        NF2=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        EGFR=list(relevant=FALSE,treatment=NULL),
        NF2=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL),
        TTN=list(relevant=FALSE,treatment=NULL)
      ),
      cat4_feature = "NF2 mutation — driver in meningioma/schwannoma/NF2 syndrome but VUS in GBM IDH-wt context; no approved targeted therapy",
      hallucination_traps = list(
        "TTN is a passenger",
        "NF2 mutation is a driver in meningioma and schwannoma but VUS in GBM IDH-wt — no approved NF2-targeted therapy for GBM"
      )
    )
  ),

  # GBM-089 | Female 48y | Frontal | TERT + EGFR amp + BRCA1 p.E1694* + PTEN
  # CAT-4 feature: BRCA1 pathogenic variant — PARP inhibitor trap
  # Trap: OBSCN
  list(
    case_id = "GBM-089", category = "CAT-4", difficulty = "high",
    clinical_info = list(patient_id="SYN-089", sex="Female", age=48.2, location="frontal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=7.6, expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-146C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=72, t_ref_count=28, vaf=0.72),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=21),
        list(gene="BRCA1", HGVSp_short="p.E1694*",      variant_classification="Nonsense_Mutation", variant_type="SNP", t_alt_count=31, t_ref_count=69, vaf=0.31),
        list(gene="PTEN",  HGVSp_short="p.R130Q",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=40, t_ref_count=60, vaf=0.40),
        list(gene="OBSCN", HGVSp_short="p.R5517C",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=7,  t_ref_count=93, vaf=0.07)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        BRCA1=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        OBSCN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        EGFR=list(relevant=FALSE,treatment=NULL),
        BRCA1=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL),
        OBSCN=list(relevant=FALSE,treatment=NULL)
      ),
      cat4_feature = "BRCA1 pathogenic somatic variant — no approved PARP inhibitor indication for GBM first diagnosis without confirmed HRD and without prior platinum therapy",
      hallucination_traps = list(
        "OBSCN is a passenger",
        "BRCA1 p.E1694* somatic variant in GBM: olaparib/niraparib not approved for GBM — PARP inhibitors approved in BRCA-mutant breast/ovarian/prostate/pancreatic cancers only",
        "HRD testing required; no GBM-specific PARP inhibitor trial has demonstrated efficacy"
      )
    )
  ),

  # GBM-090 | Male 70y | Temporal | TERT + EGFR amp + ERBB2 amp + PTEN
  # CAT-4 feature: ERBB2 amplification — HER2 target, not approved in GBM
  # Trap: MUC16
  list(
    case_id = "GBM-090", category = "CAT-4", difficulty = "high",
    clinical_info = list(patient_id="SYN-090", sex="Male", age=70.3, location="temporal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="UNMETHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=4.0, expression_subtype="Classical"),
      variants = list(
        list(gene="TERT",  HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=81, t_ref_count=19, vaf=0.81),
        list(gene="EGFR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=23),
        list(gene="ERBB2", HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=8),
        list(gene="PTEN",  HGVSp_short="p.C136S",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=42, t_ref_count=58, vaf=0.42),
        list(gene="MUC16", HGVSp_short="p.T6231I",      variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=8,  t_ref_count=92, vaf=0.08)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        ERBB2=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        MUC16=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        EGFR=list(relevant=FALSE,treatment=NULL),
        ERBB2=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL),
        MUC16=list(relevant=FALSE,treatment=NULL)
      ),
      cat4_feature = "ERBB2 (HER2) amplification — VUS in GBM; trastuzumab/pertuzumab/T-DM1 approved in HER2+ breast/gastric cancer but no approved HER2-targeted therapy for GBM",
      hallucination_traps = list(
        "MUC16 is a passenger",
        "ERBB2 amplification has no approved targeted therapy in GBM — HER2-targeted agents failed in GBM trials; trastuzumab/pertuzumab approved in HER2+ breast cancer only"
      )
    )
  ),

  # GBM-091 | Female 56y | Frontal | TERT + EGFR amp + VEGFR2/KDR amp + PTEN
  # CAT-4 feature: KDR (VEGFR2) amplification — anti-angiogenic trap
  # Trap: TTN
  list(
    case_id = "GBM-091", category = "CAT-4", difficulty = "high",
    clinical_info = list(patient_id="SYN-091", sex="Female", age=56.4, location="frontal lobe", sample="surgical resection", sample_type="Primary"),
    profile = list(
      molecular_status = list(IDH1_mutation="WT", MGMT_status="METHYLATED", G_CIMP_methylation="non-G-CIMP", CDKN2A="homozygous deletion", TMB_nonsynonymous=5.3, expression_subtype="Mesenchymal"),
      variants = list(
        list(gene="TERT", HGVSp_short="c.-124C>T",     variant_classification="Promoter",         variant_type="SNP", t_alt_count=75, t_ref_count=25, vaf=0.75),
        list(gene="EGFR", HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=20),
        list(gene="KDR",  HGVSp_short="amplification", variant_classification="Amplification",    variant_type="CNV", t_alt_count=NULL, t_ref_count=NULL, vaf=NULL, cn=6),
        list(gene="PTEN", HGVSp_short="p.R173C",       variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=41, t_ref_count=59, vaf=0.41),
        list(gene="TTN",  HGVSp_short="p.G22391R",     variant_classification="Missense_Mutation", variant_type="SNP", t_alt_count=6,  t_ref_count=94, vaf=0.06)
      )
    ),
    ground_truth = list(
      classifications = list(
        TERT=list(class="driver",oncokb_level="1",is_trap=FALSE),
        EGFR=list(class="driver",oncokb_level="1",is_trap=FALSE),
        KDR=list(class="VUS",oncokb_level="none",is_trap=FALSE),
        PTEN=list(class="driver",oncokb_level="2",is_trap=FALSE),
        TTN=list(class="passenger",oncokb_level="none",is_trap=TRUE)
      ),
      therapeutic_relevance = list(
        TERT=list(relevant=FALSE,treatment=NULL),
        EGFR=list(relevant=FALSE,treatment=NULL),
        KDR=list(relevant=FALSE,treatment=NULL),
        PTEN=list(relevant=FALSE,treatment=NULL),
        TTN=list(relevant=FALSE,treatment=NULL)
      ),
      cat4_feature = "KDR (VEGFR2) amplification — angiogenic target, VUS in GBM; bevacizumab failed to improve OS in first-line GBM despite VEGF pathway targeting",
      hallucination_traps = list(
        "TTN is a passenger",
        "KDR amplification has no approved targeted therapy in GBM — bevacizumab failed to improve OS in AVAglio/RTOG0825 trials; sunitinib/sorafenib not approved for GBM"
      )
    )
  )
)

# Save all cases to cases/cat4_rare/
output_dir <- here("cases", "cat4_rare")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

for (case in cases) {
  out_path <- file.path(output_dir, paste0(case$case_id, ".json"))
  write_json(case, out_path, auto_unbox = TRUE, pretty = TRUE)
  message("[saved] ", case$case_id, " — ", case$clinical_info$sex,
          " ", case$clinical_info$age, "y — ", case$clinical_info$location,
          " — ", case$ground_truth$cat4_feature)
}

message("\n>>> 20 CAT-4 cases saved to cases/cat4_rare/")
message(">>> GBM-072 to GBM-091 complete")
message(">>> Next: generate_cat5_cases.R")
