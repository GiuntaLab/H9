#!/bin/bash

HAP=( "hap1" "hap2" )

###This part relates to the H9 haplotypes alignments to CHM13###

for h in "${HAP[@]}"; do
	minimap2 -ax asm5 -t 96 --eqx CHM13v2.0.fna.gz H9v1.0.${h}.fasta.gz | samtools sort -O BAM - > CHM13_H9-${h}.bam
	
	source miniconda3/24.4.0/bin/activate syri_env
		syri -c CHM13_H9-${h}.bam -r CHM13v2.0.fna.gz -q H9v1.0.${h}.fasta.gz -F B --dir ./ --prefix CHM13_H9-${h}_ --nc 96
	conda deactivate
done

###This part relates to the H9 haplotypes self-alignment using haplotype 1 as reference###

minimap2 -ax asm5 -t 96 --eqx H9v1.0.hap1.fasta.gz H9v1.0.hap2.fasta.gz | samtools sort -O BAM - > H9_hap2_on_hap1.bam

source miniconda3/24.4.0/bin/activate syri_env
	syri -c H9_hap2_on_hap1.bam -r H9v1.0.hap1.fasta.gz -q H9v1.0.hap2.fasta.gz -F B --dir ./ --prefix H9_hap2_on_hap1_ --nc 96
conda deactivate