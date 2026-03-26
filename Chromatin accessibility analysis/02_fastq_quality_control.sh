#!/bin/sh


# Quality control of the raw ATAC-Seq reads

fastqc  -t 8 \
        --outdir results_atac_seq_analysis/01_quality_control \
        raw_atac_seq_data/*fastq.gz




# Adapter trimming on paired-end ATAC-Seq reads

for i in $(cat list_sra_to_download.txt); do

        #Processing fastq files
        trim_galore --cores 8 \
        --paired \
        --basename $i \
        --gzip \
        raw_atac_seq_data/$i\_1.fastq.gz \
        raw_atac_seq_data/$i\_2.fastq.gz \
        -output_dir results_atac_seq_analysis/01_quality_control
done


# Quality control of trimmed ATAC-Seq reads

fastqc -t 8 
       --outdir results_atac_seq_analysis/01_quality_control \
       results_atac_seq_analysis/01_quality_control/*_val_*.fq.gz

       