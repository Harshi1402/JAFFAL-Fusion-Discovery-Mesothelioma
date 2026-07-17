# Cohort-Level Fusion Analysis

Fusion candidates are evaluated across biological replicates using a composite CohortScore.

## Components of CohortScore

- **FS_mean**  
  Mean FusionScore across replicates.

- **Recurrence**  
  Number of libraries (1–3) in which the fusion appears.

- **Concordance**  
  Breakpoint consistency within a 20 bp window across replicates.

- **Support**  
  Median log1p(spanning reads).

## Formula

CohortScore =  
0.25·FS_mean +  
0.30·Recurrence +  
0.20·Concordance +  
0.25·Support

## Purpose

This ranking method elevates:
- recurrent events  
- splice-consistent junctions  
- in-frame fusions  
- breakpoints shared across replicates  

It suppresses:
- singletons  
- read-through artefacts  
- pseudogene-driven chimeras  

The result is a compact, reproducible shortlist of fusion candidates.
