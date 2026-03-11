#!/bin/sh


# work directory
work_directory="/path/to/work_directory"

# path to H9 genome fasta files
fasta_files_H9=$work_directory/H9_T2T_v0.1_genome_fasta

# output of coordinates liftover
liftover_between_H9_haplotypes=$work_directory/05_liftover_between_H9_haplotypes



mkdir $liftover_between_H9_haplotypes



# Align H9 haplotype 1 genome (query) to H9 haplotype 2 genome (reference)

minimap2 -x asm5 -c \
         -t 20 \
         $fasta_files_H9/H9_T2T_v0.1_hap2.fa $fasta_files_H9/H9_T2T_v0.1_hap1.fa \
         > $liftover_between_H9_haplotypes/H9_hap1_to_H9_hap2.paf