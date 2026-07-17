# JAFFAL Long-Read Fusion Detection Workflow

This document summarises the long-read fusion discovery workflow applied to AE17 and AB1‑HA murine mesothelioma transcriptomes using Oxford Nanopore pass reads and the splice-aware fusion caller JAFFAL. The workflow reflects the experimental and computational design described in my Master’s dissertation.

## 1. Input Data

- Oxford Nanopore PCR‑cDNA pass reads (PromethION, R9.4.1)
- Three biological replicates per cell line (NB01–NB06)
- Mouse reference genome: **mm10**
- Gene annotation: **GENCODE vM4**

All analyses were performed on UWA’s KAYA HPC.


## 2. Transcriptome Alignment (minimap2)

Long reads are first aligned to the mouse transcriptome to identify **multi‑gene spanning reads**.  
This step detects candidate fusion reads by locating molecules that map to two distinct genes.

This corresponds to the JAFFAL step:

> “Find reads that span two genes (transcriptome alignment).”


## 3. Genome Confirmation of Candidate Fusion Reads

Candidate fusion reads are re‑aligned to the **mm10 genome** to confirm:

- breakpoint coordinates  
- strand orientation  
- exon‑edge consistency  

JAFFAL anchors breakpoints to exon boundaries when reads fall within ±20 bp of annotated edges.

This matches the thesis description:

> “These candidate alignments were then confirmed in the mouse genome to substantiate events and get the genomic breakpoints.”


## 4. Breakpoint Normalisation and Clustering

JAFFAL groups nearby breakpoints into clusters:

- exon-edge consistent breakpoints are normalised  
- ambiguous breakpoints are clustered within a 50 bp window  
- multi-gene fusions (≥3 partners) are flagged separately  

This step reduces noise and consolidates repeated signals across reads.


## 5. Confidence Classification

JAFFAL assigns each fusion to one of four confidence classes:

- **High Confidence** — ≥2 reads, exon-edge consistent  
- **Low Confidence** — ≥2 reads, weak exon-edge evidence  
- **Potential Trans-Splicing** — 1 read, exon-edge consistent  
- **Discarded** — 1 read, non-boundary  

This classification is central to downstream triage.

---

## 6. Cleaning and Artefact Removal

To reduce false positives, additional filters are applied:

- remove adjacent same-strand read-through (≤200 kb)
- flag pseudogene and ribosomal chimeras
- flag homology-prone “Gm” provisional genes
- retain only splice-consistent exon–exon junctions

These rules match the “My cleaning rules” slide and the thesis section on artefact filtering.


## 7. FusionScore (Per-Replicate Scoring)

Each fusion is assigned a composite **FusionScore** combining:

- evidence (spanning reads, JAFFAL confidence, artefact penalties)
- biology (in-frame status)

This score is used for ordering within each replicate.


## 8. CohortScore (Cross-Replicate Ranking)

Fusion candidates are summarised across replicates using **CohortScore**, which incorporates:

- mean FusionScore  
- recurrence across libraries  
- breakpoint concordance (20 bp window)  
- median log1p(spanning reads)  

This ranking elevates reproducible, biologically plausible fusions.

## 9. Shortlist Generation

The final output is a **clean, ranked shortlist** of fusion candidates suitable for:

- IGV visualisation  
- RT‑PCR + Sanger validation  
- future DNA‑level structural variant checks  

This satisfies the dissertation aim:

> “To build a clean, ranked list of fusion events that can be tested in the lab.”

## Summary

This workflow transforms noisy ONT transcriptomes into a reproducible, splice-aware catalogue of fusion candidates. It integrates alignment, breakpoint confirmation, artefact filtering, confidence classification, and multi-replicate scoring to prioritise high-quality events such as **Fam221b–Serf2** and **Vautrc5–Lasp1** for downstream validation.
