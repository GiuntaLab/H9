#!/bin/sh


pwd; hostname; date

#Path to raw fastq files

fastq_directory="/path/to/h9_rna_seq_raw_data"


#path to the working directory

work_directory="/path/to/work_directory"


#path to trimmed reads

trimmed_reads=$work_directory"/02_trimmed_reads"


pwd; hostname; date


mkdir $trimmed_reads


trim_galore --cores 8 --gzip \
              $fastq_directory/* \
              --fastqc \
              -output_dir $trimmed_reads

pwd; hostname; date

