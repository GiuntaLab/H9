## 1) Download of the ATAC-Seq data

We stored the SRR identifiers of the ATAC-Seq data in a text file named "list_sra_to_download.txt". Then, we downloaded them using fastq-dump drom the SRA toolkit 

## 2) Quality control and adapter trimming
Once the publicly available datasets were downloaded locally, TrimGalore and FastQC were used with default parameters to assess the quality of the paired-end reads and to remove adapters.


## 3) Read alignment against H9 haplotypes

Prior the alignement, we generated indexes for each of the haplotype-specific H9 fasta files using the bowtie2-build module of bowtie2 v2.5.4. Then, we separately aligned the ATAC-Seq paired end reads against the H9 haplotypes.

## 4) Peak calling

we used MACS3 v3.0.3 to call statistically significant narrow peaks from mapped paired-end reads, with quality score > 20.
