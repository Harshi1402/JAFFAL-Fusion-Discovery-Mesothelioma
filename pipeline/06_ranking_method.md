# CohortScore Calculation

CohortScore = 0.25·FS_mean + 0.30·Recurrence + 0.20·Concordance + 0.25·Support

Components:
- FS_mean: mean FusionScore across replicates
- Recurrence: number of libraries containing the event
- Concordance: breakpoint consistency within 20 bp
- Support: median log1p(spanning reads)

Goal: elevate recurrent, splice-consistent, biologically plausible fusions.
