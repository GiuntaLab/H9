#!/bin/sh


# work directory
work_directory="/path/to/work_directory"

# output of coordinates liftover
liftover_between_H9_haplotypes=$work_directory/05_liftover_between_H9_haplotypes

# macs3 narrow peaks results
macs3_narrow_peaks=$work_directory/04_call_peak_macs3


# Liftover hap1 peaks to hap2 coordinates

echo "Liftover hap1 peaks to hap2 coordinates"

paftools.js liftover $liftover_between_H9_haplotypes/H9_hap1_to_H9_hap2.paf \
                     $macs3_narrow_peaks/call_peak_macs3_merged_hap1/H9_hap1_q20_peaks.narrowPeak \
                     > $liftover_between_H9_haplotypes/H9_hap1_q20_narrow_peaks_in_H9_hap2_coordinates.bed