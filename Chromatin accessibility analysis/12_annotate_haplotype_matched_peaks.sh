#!/bin/sh




# work directory
work_directory="/path/to/work_directory"

## output of coordinates liftover
liftover_between_H9_haplotypes=$work_directory"/05_liftover_between_H9_haplotypes"

# GTF annotation files path for the two H9 haplotypes
gtf_annotation="/path/to/H9_gtf_files_per_haplotype"

# path to H9 hap1 genome fasta file
fasta_file_H9_hap1="/path/to/H9_T2T_v1.0_hap1.fa"

# path to H9 hap2 genome fasta file
fasta_file_H9_hap2="/path/to/H9_T2T_v1.0_hap2.fa"



pwd; hostname; date

## Prepare bed-like files of haplotype matched peaks in haplotype 2 coordiantes for annotation with HOMER

cp $liftover_between_H9_haplotypes/H9_combined_q20_matched_narrow_peaks_counts_with_beds.tsv \
   $liftover_between_H9_haplotypes/H9_combined_q20_matched_narrow_peaks_counts_with_beds.bed

cut -f1-4 $liftover_between_H9_haplotypes/H9_combined_q20_matched_narrow_peaks_counts_with_beds.bed \
     > $liftover_between_H9_haplotypes/H9_combined_q20_matched_narrow_peaks.bed


## Run HOMER annotation
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
export PATH=$PATH:/data/Packages/homer/bin

/data/Packages/homer/bin/annotatePeaks.pl $liftover_between_H9_haplotypes/H9_combined_q20_matched_narrow_peaks.bed \
    $fasta_file_H9_hap2 \
    -gtf $gtf_annotation/H9_HAP2_consensus.noPB.geneid_name.gff3.gz.gtf \
    -gid \
    -cpu 22 \
    -gsize 3e9 \
    -organism human > $liftover_between_H9_haplotypes/H9_combined_q20_matched_narrow_peaks_annotated.txt


pwd; hostname; date

