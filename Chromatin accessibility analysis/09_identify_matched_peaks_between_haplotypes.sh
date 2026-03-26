#!/bin/sh


# work directory
work_directory="/path/to/work_directory"

# macs3 narrow peaks results
macs3_narrow_peaks=$work_directory/04_call_peak_macs3

# output of coordinates liftover
liftover_between_H9_haplotypes=$work_directory/05_liftover_between_H9_haplotypes



# Intersect with hap1 peaks liftedover to hap2 coordinates with hap2 peaks using reciprocal overlap (≥ 50 %)

bedtools intersect -a $liftover_between_H9_haplotypes/H9_hap1_q20_narrow_peaks_in_H9_hap2_coordinates.bed \
                   -b $macs3_narrow_peaks/call_peak_macs3_merged_hap2/H9_hap2_q20_peaks.narrowPeak \
                   -f 0.5 -r \
                   -wa -wb \
                   > $liftover_between_H9_haplotypes/H9_hap1_hap2_q20_matched_narrow_peaks.tsv


# Extract clean paired-peak coordinates and IDs

awk 'BEGIN{OFS="\t"} {print $1,$2,$3,$4,$7,$8,$9,$10}' $liftover_between_H9_haplotypes/H9_hap1_hap2_q20_matched_narrow_peaks.tsv \
                                                       > $liftover_between_H9_haplotypes/H9_hap1_hap2_q20_matched_narrow_peaks_clean.tsv


# Report how many matched pairs were found
echo "✔ Found $(wc -l < $liftover_between_H9_haplotypes/H9_hap1_hap2_q20_matched_narrow_peaks_clean.tsv) matched peak pairs between haplotypes."