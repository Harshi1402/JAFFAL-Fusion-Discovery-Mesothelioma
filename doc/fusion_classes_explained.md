# JAFFAL Fusion Confidence Classes

JAFFAL assigns each fusion event to one of four confidence categories based on spanning-read support and exon-boundary alignment.

## High Confidence
- ≥2 spanning reads  
- Breakpoints land at or near annotated exon edges  
- Strong splice-aware evidence  

## Low Confidence
- ≥2 spanning reads  
- Exon-edge evidence is weak or ambiguous  
- Often indicates non-canonical or noisy junctions  

## Potential Trans-Splicing
- 1 spanning read  
- Exon-edge consistent  
- Requires caution; may represent biological or technical single-read events  

## Discarded
- 1 spanning read  
- Breakpoints not exon-edge consistent  
- Typically artefactual  

These classes form the foundation for downstream triage and scoring.
