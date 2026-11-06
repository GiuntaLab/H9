#!/bin/sh


pwd; hostname; date

# path to H9 genome fasta files
fasta_genomes="/path/to/H9_T2T_v0.1_genome_fasta"

# path to hg38 genome fasta file
fasta_genomes="/path/to/reference_genomes/hg38"

# path to H9 GTF files
gtf_files_path="/path/to/H9_gene_annotation"

# path to GRCh38 GTF files
gtf_files_path="/path/to/gtf_intersection_grch38_H9_hap1_hap2"


#path to the working directory
work_directory="/path/to/work_directory"

# path to the index of genomes

index_genomes=$work_directory"/index_genomes_star"

index_genomes_H9_hap1=$index_genomes"/index_star_H9_hap1"

index_genomes_H9_hap2=$index_genomes"/index_star_H9_hap2"

index_genomes_hg38=$index_genomes"/index_star_hg38"




pwd; hostname; date

mkdir $index_genomes
mkdir $index_genomes_H9_hap1
mkdir $index_genomes_H9_hap2
mkdir $index_genomes_hg38



# indexing H9_hap1 reference genome

STAR --runThreadN 16 \
	 --runMode genomeGenerate \
	 --genomeDir $index_genomes_H9_hap1 \
	 --genomeFastaFiles $fasta_genomes/H9_T2T_v0.1_hap1.fa \
	 --sjdbGTFfile $gtf_files_path/H9_HAP1_consensus.noPB.geneid_name.gff3.gz.gtf \
     --sjdbOverhang 50 # Read length minus 1


# indexing H9_hap2 reference genome

STAR --runThreadN 16 \
	 --runMode genomeGenerate \
	 --genomeDir $index_genomes_H9_hap2 \
	 --genomeFastaFiles $fasta_genomes/H9_T2T_v0.1_hap2.fa \
	 --sjdbGTFfile $gtf_files_path/H9_HAP2_consensus.noPB.geneid_name.gff3.gz.gtf \
     --sjdbOverhang 50 # Read length minus 1


# indexing hg38 reference genome

STAR --runThreadN 16 \
	 --runMode genomeGenerate \
	 --genomeDir $index_genomes_hg38 \
	 --genomeFastaFiles $fasta_genomes/hg38.fa \
	 --sjdbGTFfile $gtf_files_path/gencode.v49.annotation.simple.geneid.name.common_GRCh38_H9_HAP1_HAP2.gtf \
     --sjdbOverhang 50 # Read length minus 1


pwd; hostname; date