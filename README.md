# JAFFAL-Based Long-Read Fusion Discovery in Murine Mesothelioma

This repository documents my personal workflow for detecting and prioritising RNA fusion events in two murine mesothelioma cell lines (AE17 and AB1-HA) using Oxford Nanopore long-read sequencing and the JAFFAL fusion caller.

>This GitHub project is a *portfolio summary* of my Master's dissertation work at UWA.  
>It is **not** intended for academic reuse, submission, or replication in coursework.

**JAFFAL (long-read fusion caller):** https://github.com/Oshlack/JAFFAL

**Reference paper:** Davidson, N.M. et al. (2022). JAFFAL: Detecting fusion genes with long-read transcriptome sequencing. *Genome Biology*, 23, 10.

### Why This Matters

Mesothelioma is an aggressive cancer with few recurrent, targetable oncogenic drivers.  
Transcript-level fusions can act as biomarkers or therapeutic entry points, but short-read callers often overproduce artefacts such as read-throughs and homology-driven chimeras.

Long-read sequencing preserves isoform structure and exon-edge context, enabling more reliable fusion detection.


## Aim of the Study

To develop a long-read, splice-aware fusion discovery workflow and produce a **clean, ranked shortlist** of fusion events from AE17 and AB1-HA that can be prioritised for **future experimental validation** (e.g., RT-PCR + Sanger).


## Main Research Question (RQ)

Which **splice-consistent**, **reproducible** RNA fusion events can JAFFAL detect across biological replicates in AE17 and AB1-HA using Oxford Nanopore pass reads, and **which of these should be prioritised** based on confidence class, recurrence, breakpoint concordance, and biological plausibility?


## Hypothesis

Splice-aware long-read fusion calling will yield **fewer**, **higher-confidence**, and **more reproducible** fusion candidates than short-read approaches, due to preserved isoform structure and exon-boundary context.


## Data & Experimental Design

- Two murine mesothelioma cell lines: **AE17** and **AB1-HA**  
- Three biological replicates each (native ONT barcodes NB01–NB06)  
- Oxford Nanopore PCR-cDNA sequencing (PromethION, R9.4.1)  
- Pass reads only  
- All analyses performed on UWA’s **KAYA HPC**  
- Fusion caller: **JAFFAL (splice-aware)**  
- Reference: **mm10 genome + GENCODE vM4 annotation**


## JAFFAL Long-Read Workflow (High-Level)

1. Align pass reads to the transcriptome (minimap2).  
2. Identify reads spanning two genes.  
3. Confirm candidate fusions on the genome and mark breakpoints.  
4. Cluster nearby breakpoints and assign confidence classes.  
5. Export CSV/FASTA for downstream scoring and ranking.

### JAFFAL Confidence Classes
- **High Confidence** — ≥2 spanning reads, exon-edge consistent  
- **Low Confidence** — ≥2 reads, weak exon-edge evidence  
- **Potential Trans-Splicing** — 1 read, exon-edge consistent  
- **Discarded** — 1 read, non-boundary

## Cleaning Rules (My Filters)

To reduce artefacts and retain biologically plausible candidates:

- Remove adjacent same-strand read-throughs (≤200 kb).  
- Flag pseudogene and ribosomal chimeras.  
- Flag homology-prone provisional “Gm” genes.  
- Retain only splice-consistent exon–exon junctions.  

These rules match the triage described in my dissertation.

## Scoring System (FusionScore)

Each fusion is assigned a composite score blending evidence and biology:

**FusionScore = 0.58·Evidence + 0.42·Biology**

### Evidence Component
- log-scaled spanning reads  
- +10 High confidence  
- -5 Low confidence  
- -10 read-through  
- -25 pseudogene/ribosomal  
- -5 Gm genes  

### Biology Component
- 100 if in-frame  
- 0 if out-of-frame  

FusionScore is used for ordering only (not statistical inference).


## Cohort-Level Ranking (CohortScore)

To prioritise reproducible events across replicates:

**CohortScore = 0.25·FS_mean + 0.30·Recurrence + 0.20·Concordance + 0.25·Support**

Where:
- **FS_mean** = mean FusionScore across replicates  
- **Recurrence** = number of libraries containing the event  
- **Concordance** = breakpoint consistency within a 20 bp window  
- **Support** = median log1p(spanning reads)  

Goal: elevate recurrent, splice-consistent, biologically plausible fusions.

## Key Findings (High-Level Summary)

- **AE17**: fewer high-confidence fusions but deeper support at specific loci.  
- **AB1-HA**: broader fusion burden with more in-frame, reproducible events.  
- Recurrent candidates across both lines include:  
  - **Fam221b–Serf2**  
  - **Vautrc5–Lasp1**  
- AB1-HA also shows additional recurrent events:  
  - **Fam19a1–Ptpmt1**  
  - **Tmcc1–Rerg**  
  - **Stx18–Nsg1**

These form the shortlist for future wet-lab validation.

## Validation (High-Level)

IGV visualisation confirmed exon-consistent split reads for **Fam221b–Serf2**, supporting JAFFAL’s classification.

---

## Limitations

- Single caller (JAFFAL) → potential tool bias  
- No matched normal → genomic vs RNA mechanism unresolved  
- No DNA-SV confirmation  
- ONT error profile may miss low-abundance or non-canonical junctions  
- Limited wet-lab validation within project scope  


## Future Work

- RT-PCR + Sanger validation of top candidates  
- Add DNA structural variant checks  
- Compare with another long-read caller (e.g., LongGF)  
- Explore direct RNA sequencing to reduce RT artefacts  

## Tools Used

- **JAFFAL** — splice-aware long-read fusion caller  
- **Minimap2** — transcriptome + genome alignment  
- **Samtools** — BAM processing  
- **RStudio(normal R + Bioconductor package) + ggplot2 + ComplexHeatmap** — visualisation  
- **IGV** — read-level validation  


##  Repository Structure

JAFFAL-Fusion-Discovery-Mesothelioma/
│
├── README.md
│
├── pipeline/
│   ├── 01_alignment_transcriptome.sh
│   ├── 02_alignment_genome.sh
│   ├── 03_jaffal_run.sh
│   ├── cleaning_rules.md
│   ├── scoring_system.md
│   ├── ranking_method.md
│
├── docs/
│   ├── workflow_overview.md
│   ├── fusion_classes_explained.md
│   ├── cohort_analysis.md
│   ├── limitations.md
│   ├── future_work.md
│
└── data/
└── README_data_structure.md

## My Contribution

This project represents my independent development of a long-read, splice-aware fusion discovery workflow for murine mesothelioma. JAFFAL is written in **Nextflow DSL1**, which is monolithic and difficult to inspect or modify. I did not build custom wrapper scripts; instead, I focused on understanding, debugging, and correctly executing the existing JAFFAL pipeline while developing my own external triage and scoring layers.

My contributions include:

- Debugging JAFFAL’s DSL1 pipeline on HPC, resolving repeated access, configuration, and execution errors caused by its non‑modular structure.
- Learning how JAFFAL internally processes fusion reads, breakpoint clustering, and confidence assignment despite limited visibility into its DSL1 code.
- Designing a reproducible workflow *around* JAFFAL using minimap2, samtools, and R to test outputs and understand JAFFAL’s internal behaviour.
- Implementing custom cleaning rules to remove read-through, pseudogene, ribosomal, and homology-driven artefacts that JAFFAL reports but does not fully filter.
- Developing FusionScore and CohortScore as external analytical layers to prioritise biologically plausible, recurrent fusion events across replicates.
- Performing multi-replicate fusion analysis for AE17 and AB1-HA, including breakpoint concordance, recurrence profiling, and support scaling.
- Creating visual summaries (oncoprints, UpSet plots, support matrices) to interpret fusion behaviour across libraries.
- Conducting IGV validation of top-ranked candidates such as Fam221b–Serf2.
- Documenting the entire workflow, scoring system, and triage logic in a structured, portfolio-safe format.

This repository reflects the computational and analytical components I personally built during my Master’s dissertation, including the additional layers required to make JAFFAL’s DSL1 output usable, interpretable, and biologically meaningful.



##  Ethical Notice

This repository contains **only** my scripts, documentation, and summaries.  
It does **not** contain raw FASTQ, BAM, JAFFAL CSV outputs, IGV screenshots, or unpublished biological data.

##  Personal Reflection

This project taught me how long-read fusion detection differs from short-read approaches, how exon-boundary concordance improves confidence, and how multi-replicate scoring can elevate biologically meaningful candidates.

## Acknowledgements 

I am deeply grateful to **Professor Jenette Creaney** and **Xiao Zhong** for their guidance, expertise, and encouragement throughout this project. Their mentorship shaped both the scientific direction and the computational design of this work.

Special thanks to the UWA **KAYA HPC team** for providing computational resources, and to my colleagues, friends, and family for their support during my Master’s research journey.


##  Author
**Harshita Khot**  
Master of Bioinformatics — UWA

