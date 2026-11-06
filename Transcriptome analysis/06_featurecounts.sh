#!/bin/sh


#path to the working directory
work_directory="/path/to/work_directory"

# Path to the alignment files
rna_seq_alignment=$work_directory"/03_rna_seq_alignment_star"

rna_seq_alignment_H9_hap1_star=$rna_seq_alignment"/rna_seq_alignment_H9_hap1_star"

rna_seq_alignment_H9_hap2_star=$rna_seq_alignment"/rna_seq_alignment_H9_hap2_star"

rna_seq_alignment_hg38_star=$rna_seq_alignment"/rna_seq_alignment_hg38_star"


# path to gtf files 
gtf_files="/path/to/gtf_intersection_grch38_H9_hap1_hap2"

# path to the read counts
counts=$work_directory"/04_counts_featureCounts"


pwd; hostname; date

mkdir $counts

# featureCounts for H9 hap1

/home/hdallali/miniconda3/envs/subread-env/bin/featureCounts -T 16 \
		-a $gtf_files/H9_HAP1_consensus.noPB.geneid_name.common_H9_HAP2_GRCh38.gff3.gz.gtf \
		-o $counts/feature_counts_H9_HAP1.txt \
        $rna_seq_alignment_H9_hap1_star/*_aligned.sorted.out.bam


# featureCounts for H9 hap2

/home/hdallali/miniconda3/envs/subread-env/bin/featureCounts -T 16 \
		-a $gtf_files/H9_HAP2_consensus.noPB.geneid_name.common_H9_HAP1_GRCh38.gff3.gz.gtf \
		-o $counts/feature_counts_H9_HAP2.txt \
        $rna_seq_alignment_H9_hap2_star/*_aligned.sorted.out.bam


# featureCounts for hg38

/home/hdallali/miniconda3/envs/subread-env/bin/featureCounts -T 16 \
		-a $gtf_files/gencode.v49.annotation.simple.geneid.name.common_GRCh38_H9_HAP1_HAP2.gtf \
		-o $counts/feature_counts_hg38.txt \
        $rna_seq_alignment_hg38_star/*_aligned.sorted.out.bam


pwd; hostname; date

