# NOTE: This is a wrapper script showing how JAFFAL was executed.
# It does not contain JAFFAL's internal DSL1 code.

#!/bin/bash

# JAFFAL long-read fusion calling
# Produces CSV + FASTA outputs for downstream scoring

jaffal \
  --reads input_pass_reads.fastq \
  --genome mm10.fa \
  --annotation gencode_vm4.gtf \
  --output jaffal_output/
