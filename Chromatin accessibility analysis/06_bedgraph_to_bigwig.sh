#!/bin/sh




# work directory
work_directory="/path/to/work_directory"


# macs3 results
macs3_call_peak=$work_directory"/04_call_peak_macs3"



# Create BigWig files from the bedgraph coverage files relative to the narrow peaks called on H9 haplotype 1 for all samples 

for bedgraph in $macs3_call_peak/call_peak_macs3_merged_hap1/*.bdg; do
    prefix=$(basename "$bedgraph" .bdg)
    echo "processing the sample $prefix"
    
    sort -k1,1 -k2,2n $bedgraph > $macs3_call_peak/call_peak_macs3_merged_hap1/$prefix.sorted.bdg
    
    bedGraphToBigWig $macs3_call_peak/call_peak_macs3_merged_hap1/$prefix.sorted.bdg \
    $work_directory/../H9_T2T_v0.1_hap1_chr_length.tsv \
    $macs3_call_peak/call_peak_macs3_merged_hap1/$prefix.bw
done


# Create BigWig files from the bedgraph coverage files relative to the narrow peaks called on H9 haplotype 2 for all samples

for bedgraph in $macs3_call_peak/call_peak_macs3_merged_hap2/*.bdg; do
    prefix=$(basename "$bedgraph" .bdg)
    echo "processing the sample $prefix"
    
    sort -k1,1 -k2,2n $bedgraph > $macs3_call_peak/call_peak_macs3_merged_hap2/$prefix.sorted.bdg
    
    bedGraphToBigWig $macs3_call_peak/call_peak_macs3_merged_hap2/$prefix.sorted.bdg \
    $work_directory/../H9_T2T_v0.1_hap2_chr_length.tsv \
    $macs3_call_peak/call_peak_macs3_merged_hap2/$prefix.bw
done