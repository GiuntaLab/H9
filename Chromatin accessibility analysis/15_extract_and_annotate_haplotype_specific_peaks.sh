#!/bin/sh




# work directory
work_directory="/path/to/work_directory"

## macs3 narrow peaks results
macs3_narrow_peaks=$work_directory/04_call_peak_macs3

## output of coordinates liftover
liftover_between_H9_haplotypes=$work_directory/05_liftover_between_H9_haplotypes

## haplotype specific peaks results
haplotype_specific_peaks=$work_directory/07_haplotype_specific_peaks

# GTF annotation files path for the two H9 haplotypes
gtf_annotation="/path/to/H9_gtf_files_per_haplotype"

# path to H9 hap1 genome fasta file
fasta_file_H9_hap1="/path/to/H9_T2T_v1.0_hap1.fa"

# path to H9 hap2 genome fasta file
fasta_file_H9_hap2="/path/to/H9_T2T_v1.0_hap2.fa"


pwd; hostname; date


# Create the output directory of haplotype specific peaks

mkdir $haplotype_specific_peaks


### Extract haplotype specific peaks

## Extract haplotype 1 specific peaks

bedtools intersect -v -a $macs3_narrow_peaks/call_peak_macs3_merged_hap1/H9_hap1_q20_peaks.narrowPeak \
                      -b $liftover_between_H9_haplotypes/H9_hap2_q20_narrow_peaks_in_H9_hap1_coordinates.bed \
                      > $haplotype_specific_peaks/H9_hap1_q20_specific_peaks.bed


## Extract haplotype 2 specific peaks


bedtools intersect -v -a $macs3_narrow_peaks/call_peak_macs3_merged_hap2/H9_hap2_q20_peaks.narrowPeak \
                      -b $liftover_between_H9_haplotypes/H9_hap1_q20_narrow_peaks_in_H9_hap2_coordinates.bed \
                      > $haplotype_specific_peaks/H9_hap2_q20_specific_peaks.bed






### Run HOMER annotation

export PATH=$PATH:/data/Packages/homer/bin


## Annotation of haplotype 1 specific peaks

/data/Packages/homer/bin/annotatePeaks.pl $haplotype_specific_peaks/H9_hap1_q20_specific_peaks.bed \
    $fasta_file_H9_hap1 \
    -gtf $gtf_annotation/H9_HAP1_consensus.noPB.geneid_name.gff3.gz.gtf \
    -gid \
    -cpu 16 \
    -gsize 3e9 \
    -organism human > $haplotype_specific_peaks/H9_hap1_q20_specific_peaks_annotated.txt



## Annotation of haplotype 2 specific peaks

/data/Packages/homer/bin/annotatePeaks.pl $haplotype_specific_peaks/H9_hap2_q20_specific_peaks.bed \
    $fasta_file_H9_hap2 \
    -gtf $gtf_annotation/H9_HAP2_consensus.noPB.geneid_name.gff3.gz.gtf \
    -gid \
    -cpu 16 \
    -gsize 3e9 \
    -organism human > $haplotype_specific_peaks/H9_hap2_q20_specific_peaks_annotated.txt


pwd; hostname; date

