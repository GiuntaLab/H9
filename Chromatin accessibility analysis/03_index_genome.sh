#!/bin/sh


# Generate an index for the fata file of H9_hap1

bowtie2-build --large-index \
            H9_T2T_v0.1_hap1.fa \
            bowtie2_index_results/index_H9_hap1_bowtie2/H9.hap2.fa \
            --threads 8


# Generate an index for the fata file of H9_hap2

bowtie2-build --large-index \
            H9_T2T_v0.1_hap2.fa \
            bowtie2_index_results/index_H9_hap2_bowtie2/H9.hap2.fa \
            --threads 8