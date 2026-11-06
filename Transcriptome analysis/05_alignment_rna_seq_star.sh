#!/bin/sh


#path to the working directory
work_directory="/path/to/work_directory"

index_genomes=$work_directory"/index_genomes_star"

index_genomes_H9_hap1=$index_genomes"/index_star_H9_hap1"

index_genomes_H9_hap2=$index_genomes"/index_star_H9_hap2"

index_genomes_hg38=$index_genomes"/index_star_hg38"

# Path to the trimmed reads
trimmed_reads=$work_directory"/02_trimmed_reads"

# Path to the alignment files
rna_seq_alignment=$work_directory"/03_rna_seq_alignment_star"

rna_seq_alignment_H9_hap1_star=$rna_seq_alignment"/rna_seq_alignment_H9_hap1_star"

rna_seq_alignment_H9_hap2_star=$rna_seq_alignment"/rna_seq_alignment_H9_hap2_star"

rna_seq_alignment_hg38_star=$rna_seq_alignment"/rna_seq_alignment_hg38_star"



pwd; hostname; date

mkdir $rna_seq_alignment
mkdir $rna_seq_alignment_H9_hap1_star
mkdir $rna_seq_alignment_H9_hap2_star
mkdir $rna_seq_alignment_hg38_star


## Alignment against H9 hap1

echo "Mapping the single-end reads against H9 hap1 and hap2 and hg38 reference genomes using STAR"

for trimmed_fastq in $trimmed_reads/*trimmed.fq.gz
do
trimmed_fastq_file_path_without_read_number_and_extension=${trimmed_fastq%%_trimmed.fq.gz}
sample_name=$(basename $trimmed_fastq_file_path_without_read_number_and_extension)

echo "
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

Alignment of $sample_name against H9 hap1 using STAR

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
"

STAR --runThreadN 16 \
	--genomeDir $index_genomes_H9_hap1 \
	--readFilesIn $trimmed_fastq \
	--readFilesCommand zcat \
	--outFileNamePrefix $rna_seq_alignment_H9_hap1_star/$sample_name"_H9_hap1_" \
	--outSAMtype BAM Unsorted --outSAMunmapped Within --outSAMattributes Standard

echo "
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

Alignment of $sample_name against H9 hap1 using STAR completed!!

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
"


samtools sort --threads 16 $rna_seq_alignment_H9_hap1_star/$sample_name"_H9_hap1_Aligned.out.bam" \
              -o $rna_seq_alignment_H9_hap1_star/$sample_name"_H9_hap1_aligned.sorted.out.bam"


samtools index -@ 16 $rna_seq_alignment_H9_hap1_star/$sample_name"_H9_hap1_aligned.sorted.out.bam"

done

pwd; hostname; date



## Alignment against H9 hap2

echo "Mapping the paired-end reads against the H9 hap2 reference genome using STAR"

for trimmed_fastq in $trimmed_reads/*trimmed.fq.gz
do
trimmed_fastq_file_path_without_read_number_and_extension=${trimmed_fastq%%_trimmed.fq.gz}
sample_name=$(basename $trimmed_fastq_file_path_without_read_number_and_extension)

echo "
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

Alignment of $sample_name against H9 hap2 using STAR

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
"

STAR --runThreadN 16 \
	--genomeDir $index_genomes_H9_hap2 \
	--readFilesIn $trimmed_fastq \
	--readFilesCommand zcat \
	--outFileNamePrefix $rna_seq_alignment_H9_hap2_star/$sample_name"_H9_hap2_" \
	--outSAMtype BAM Unsorted --outSAMunmapped Within --outSAMattributes Standard

echo "
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

Alignment of $sample_name against H9 hap2 using STAR completed!!

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
"


samtools sort --threads 16 $rna_seq_alignment_H9_hap2_star/$sample_name"_H9_hap2_Aligned.out.bam" \
              -o $rna_seq_alignment_H9_hap2_star/$sample_name"_H9_hap2_aligned.sorted.out.bam"


samtools index -@ 16 $rna_seq_alignment_H9_hap2_star/$sample_name"_H9_hap2_aligned.sorted.out.bam"

done

pwd; hostname; date



## Alignment against hg38

echo "Mapping the paired-end reads against the hg38 reference genome using STAR"

for trimmed_fastq in $trimmed_reads/*trimmed.fq.gz
do
trimmed_fastq_file_path_without_read_number_and_extension=${trimmed_fastq%%_trimmed.fq.gz}
sample_name=$(basename $trimmed_fastq_file_path_without_read_number_and_extension)

echo "
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

Alignment of $sample_name against hg38 using STAR

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
"

STAR --runThreadN 16 \
	--genomeDir $index_genomes_hg38 \
	--readFilesIn $trimmed_fastq \
	--readFilesCommand zcat \
	--outFileNamePrefix $rna_seq_alignment_hg38_star/$sample_name"_hg38_" \
	--outSAMtype BAM Unsorted --outSAMunmapped Within --outSAMattributes Standard

echo "
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

Alignment of $sample_name against hg38 using STAR completed!!

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
"


samtools sort --threads 16 $rna_seq_alignment_hg38_star/$sample_name"_hg38_Aligned.out.bam" \
              -o $rna_seq_alignment_hg38_star/$sample_name"_hg38_aligned.sorted.out.bam"


samtools index -@ 16 $rna_seq_alignment_hg38_star/$sample_name"_hg38_aligned.sorted.out.bam"

done

pwd; hostname; date




