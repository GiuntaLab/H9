#!/bin/sh


# work directory
work_directory="/path/to/work_directory"

# bowtie2_mapping_results
bowtie2_mapping=$work_directory/02_mapping

# output of coordinates liftover
liftover_between_H9_haplotypes=$work_directory/05_liftover_between_H9_haplotypes


# Extract hap1 peak coordinates from the peak name in column 4 of matched_narrow_peaks_clean.tsv

echo "Extract hap1 peak coordinates from the peak name in column 4 of matched_narrow_peaks_clean.tsv"

awk 'BEGIN{OFS="\t"} { split($4,a,"_"); chr=a[1]"_"a[2]; start=a[3]; end=a[4]; print chr, start, end, $4}' \
    $liftover_between_H9_haplotypes/H9_hap1_hap2_q20_matched_narrow_peaks_clean.tsv \
   > $liftover_between_H9_haplotypes/H9_hap1_q20_matched_narrow_peaks_for_count.bed



# Extract hap2 peak coordinates from the peak name in column 8 of matched_narrow_peaks_clean.tsv

echo "Extract hap2 peak coordinates from the peak name in column 8 of matched_peaks_clean.tsv"

awk 'BEGIN{OFS="\t"} {n=split($8,b,"/"); name=b[n]; print $5, $6, $7, name}' $liftover_between_H9_haplotypes/H9_hap1_hap2_q20_matched_narrow_peaks_clean.tsv \
                                          > $liftover_between_H9_haplotypes/H9_hap2_q20_matched_narrow_peaks_for_count.bed


# Extract the names of alignment files against each H9 haplotype with mapping quality > 20 

ls $bowtie2_mapping/alignment_H9_hap1/*q20.bam > H9_hap1_q20_bams.txt
ls $bowtie2_mapping/alignment_H9_hap2/*q20.bam > H9_hap2_q20_bams.txt


# Count read coverage of matched peaks on hap1 coordinates using hap1 BAMs

echo "Count read coverage of matched peaks on hap1 coordinates using hap1 BAMs"

bedtools multicov -bams $(cat H9_hap1_q20_bams.txt) \
                  -bed $liftover_between_H9_haplotypes/H9_hap1_q20_matched_narrow_peaks_for_count.bed \
                   > $liftover_between_H9_haplotypes/H9_hap1_q20_matched_narrow_peaks_counts_matrix.tsv


# Count read coverage of matched peaks on hap2 coordinates using hap2 BAMs

echo "Count read coverage of matched peaks on hap2 coordinates using hap2 BAMs"

bedtools multicov -bams $(cat H9_hap2_q20_bams.txt) \
                  -bed $liftover_between_H9_haplotypes/H9_hap2_q20_matched_narrow_peaks_for_count.bed \
                   > $liftover_between_H9_haplotypes/H9_hap2_q20_matched_narrow_peaks_counts_matrix.tsv

