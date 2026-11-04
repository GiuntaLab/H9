#!/bin/sh

# work directory
work_directory="/path/to/work_directory"

# differential_accessibility_analysis_deseq2 results
differential_accessibility_analysis_deseq2=$work_directory/06_differential_accessibility_analysis_deseq2

# GTF annotation files path for the two H9 haplotypes
gtf_annotation="/path/to/H9_gtf_files_per_haplotype"

# path to H9 hap1 genome fasta file
fasta_file_H9_hap1="/path/to/H9_T2T_v1.0_hap1.fa"

# path to H9 hap2 genome fasta file
fasta_file_H9_hap2="/path/to/H9_T2T_v1.0_hap2.fa"



pwd; hostname; date






## Run HOMER annotation

export PATH=$PATH:/data/Packages/homer/bin

/data/Packages/homer/bin/annotatePeaks.pl $differential_accessibility_analysis_deseq2/hap1_enriched_peaks_with_coordinates.bed \
    $fasta_file_H9_hap1 \
    -gtf $gtf_annotation/H9_HAP1_consensus.noPB.geneid_name.gff3.gz.gtf \
    -gid \
    -cpu 16 \
    -gsize 3e9 \
    -organism human > $differential_accessibility_analysis_deseq2/hap1_enriched_peaks_annotated.txt





/data/Packages/homer/bin/annotatePeaks.pl $differential_accessibility_analysis_deseq2/hap2_enriched_peaks_with_coordinates.bed \
    $fasta_file_H9_hap2 \
    -gtf $gtf_annotation/H9_HAP2_consensus.noPB.geneid_name.gff3.gz.gtf \
    -gid \
    -cpu 16 \
    -gsize 3e9 \
    -organism human > $differential_accessibility_analysis_deseq2/hap2_enriched_peaks_annotated.txt



## Convert annotated text to CSV


awk 'BEGIN{OFS=","} NR==1{gsub("\t",","); print; next} {gsub("\t",","); print}' $differential_accessibility_analysis_deseq2/hap1_enriched_peaks_annotated.txt > $differential_accessibility_analysis_deseq2/hap1_enriched_peaks_annotated.csv



awk 'BEGIN{OFS=","} NR==1{gsub("\t",","); print; next} {gsub("\t",","); print}' $differential_accessibility_analysis_deseq2/hap2_enriched_peaks_annotated.txt > $differential_accessibility_analysis_deseq2/hap2_enriched_peaks_annotated.csv


pwd; hostname; date




