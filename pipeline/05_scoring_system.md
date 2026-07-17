# FusionScore Calculation

FusionScore = 0.58·Evidence + 0.42·Biology

Evidence:
- log-scaled spanning reads
- +10 High confidence
- -5 Low confidence
- -10 read-through
- -25 pseudogene/ribosomal
- -5 Gm genes

Biology:
- 100 if in-frame
- 0 if out-of-frame

Used for ordering only; not inferential.
