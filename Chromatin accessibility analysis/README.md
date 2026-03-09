## Prerequisites:

TrimGalore v0.6.10 and FastQC v0.11.9 for quality control and adapter trimming;  
bowtie2 v2.5.4 for  and haploid alignments;   
samtools v1.21 for data processing and filtering;  
MACS3 v3.0.3 for peak calling;  

## 1) Downloading the ATAC-Seq data

The SRR identifiers of the ATAC-Seq data were stored in a text file named "list_sra_to_download.txt". Then, we downloaded them using fastq-dump from the SRA toolkit. 

## 2) Quality control and adapter trimming

Once the publicly available datasets were downloaded locally, TrimGalore and FastQC were used with default parameters to assess the quality of the paired-end reads and to remove adapters.


## 3) Read alignment against H9 haplotypes

Prior the alignement, indexes for each of the haplotype-specific H9 fasta files were generated using the bowtie2-build module of bowtie2 v2.5.4. Then, we separately aligned the ATAC-Seq paired end reads against the reference genomes of H9 haplotypes.

## 4) Peak calling

We used MACS3 v3.0.3 to call statistically significant narrow peaks from mapped paired-end reads, with quality score > 20.
