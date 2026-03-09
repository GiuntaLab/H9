#!/bin/sh



# Once you have the SRR id of interest in a text file "list_sra_to_download.txt", you can download them using fastq-dump drom the SRA toolkit

for i in $(cat list_sra_to_download.txt); do

	#Downloading fastq files
	echo "Downloading $i file..."
	fastq-dump --gzip --split-3 --origfmt $i \
    -O raw_atac_seq_data
done