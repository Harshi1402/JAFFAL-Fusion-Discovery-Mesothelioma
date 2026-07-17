# NOTE: This is a wrapper script showing how JAFFAL was executed.
# It does not contain JAFFAL's internal DSL1 code.

#!/bin/bash

# Transcriptome alignment for fusion-read discovery
# Long-read splice-aware alignment using minimap2

minimap2 -ax splice -uf -k14 \
  mm10_transcriptome.fa \
  input_pass_reads.fastq \
  > transcriptome_alignment.sam
