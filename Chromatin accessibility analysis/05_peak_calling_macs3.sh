#!/bin/sh

# work directory
work_directory="/path/to/work_directory"

# bowtie2_mapping_results
bowtie2_mapping=$work_directory"/02_mapping"

# macs3 results
macs3_call_peak=$work_directory"/04_call_peak_macs3"


mkdir tmp_dir/

mkdir $macs3_call_peak


# -B stands for having also bedgraph files as output.
# BAMPE stands for paired-end bam.
# -g stands for genome size (when you map against haploid human genome, it should be 3.00e9).
# -q stands for q-value significance threshold.


## Call narrow peaks in H9 haplotype 1

macs3 callpeak \
     -t $bowtie2_mapping/alignment_H9_hap1/*q20.bam \
     -f BAMPE \
     -B \
     -g 3.00e9 \
     -q 0.01 \
     -n $macs3_call_peak/call_peak_macs3_merged_hap1/H9_hap1_q20 \
     --tempdir tmp_dir/


## Call narrow peaks in H9 haplotype 2

macs3 callpeak \
     -t $bowtie2_mapping/alignment_H9_hap2/*q20.bam \
     -f BAMPE \
     -B \
     -g 3.00e9 \
     -q 0.01 \
     -n $macs3_call_peak/call_peak_macs3_merged_hap2/H9_hap2_q20 \
     --tempdir tmp_dir/


