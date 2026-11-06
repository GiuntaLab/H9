#!/bin/sh

pwd; hostname; date


#Path to raw fastq files
fastq_directory="/path/to/h9_rna_seq_raw_data"


#path to the working directory
work_directory="/path/to/work_directory"


#Path to the results of the fastq files quality control
fastq_quality_control_results=$work_directory"/01_rna_seq_quality_control"


mkdir $work_directory

mkdir $fastq_quality_control_results

fastqc --threads 24 $fastq_directory/* -o $fastq_quality_control_results


pwd; hostname; date