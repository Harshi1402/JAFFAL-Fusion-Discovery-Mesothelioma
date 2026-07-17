# NOTE: This is a wrapper script showing how JAFFAL was executed.
# It does not contain JAFFAL's internal DSL1 code.


#!/bin/bash

# Genome alignment to confirm breakpoints
# JAFFAL uses this to anchor exon-edge positions

minimap2 -ax splice \
  mm10_genome.fa \
  fusion_reads.fasta \
  > genome_alignment.sam
