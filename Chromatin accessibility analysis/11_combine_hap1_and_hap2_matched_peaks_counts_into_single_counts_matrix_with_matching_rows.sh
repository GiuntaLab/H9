#!/bin/sh


# work directory
work_directory="/path/to/work_directory"

# output of coordinates liftover
liftover_between_H9_haplotypes=$work_directory/05_liftover_between_H9_haplotypes



# Extract only the count columns from each file for hap1 and hap2

echo "Extract only the count columns from each file for hap1 and hap2"

cut -f5- $liftover_between_H9_haplotypes/H9_hap1_q20_matched_narrow_peaks_counts_matrix.tsv \
         > $liftover_between_H9_haplotypes/H9_hap1_q20_matched_narrow_peaks_counts_only.tsv


cut -f5- $liftover_between_H9_haplotypes/H9_hap2_q20_matched_narrow_peaks_counts_matrix.tsv \
         > $liftover_between_H9_haplotypes/H9_hap2_q20_matched_narrow_peaks_counts_only.tsv


# Combine hap1 and hap2 counts in a single matrix with bed columns (paste preserves row order)


echo "Combine hap1 and hap2 counts in a single matrix with bed columns (paste preserves row order)"

paste $liftover_between_H9_haplotypes/H9_hap2_q20_matched_narrow_peaks_for_count.bed \
      $liftover_between_H9_haplotypes/H9_hap1_q20_matched_narrow_peaks_counts_only.tsv \
      $liftover_between_H9_haplotypes/H9_hap2_q20_matched_narrow_peaks_counts_only.tsv \
      > $liftover_between_H9_haplotypes/H9_combined_q20_matched_narrow_peaks_counts_with_beds.tsv