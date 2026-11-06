#!/bin/sh

pwd; hostname; date


raw_rna_seq_data_h9="/path/to/h9_rna_seq_raw_data"

mkdir $raw_rna_seq_data_h9

for i in $(cat list_sra_to_download.txt); do

	#Downloading fastq files
	echo "Downloading $i file..."
	/data/Packages/sratoolkit.3.1.1-ubuntu64/bin/./fastq-dump --gzip --origfmt $i \
    -O $raw_rna_seq_data_h9
done

echo "Download complete!"

pwd; hostname; date