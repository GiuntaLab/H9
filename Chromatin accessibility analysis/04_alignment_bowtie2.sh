#!/bin/sh



# work directory
work_directory="/path/to/work_directory"

# bowtie2_index
bowtie2_index=$work_directory"/index_H9_bowtie2"

# bowtie2_mapping_results
bowtie2_mapping=$work_directory"/02_mapping"

# coverage_results
bam_coverage=$work_directory"/03_bam_coverage"



mkdir $bowtie2_mapping

mkdir $bam_coverage

# Set variable contains the parameters for bowtie2: we are doing and end-to-end alignment where we are keeping only the proper pair mapped reads, no discordant, and removing the unmapped.

# Cov variable contains the parameters for bamCoverage.

Set='--end-to-end --sensitive --no-mixed --threads 20 --no-discordant --no-unal'
Cov='--binSize 50 --ignoreDuplicates --skipNAs --normalizeUsing CPM -p 20'

# Alignment of ATAC_Seq reads against H9_hap1 genome

for n in $(cat list_sra_to_download.txt); do

	echo "Processing $n against H9_hap1"
	(
	bowtie2 -x $bowtie2_index/index_H9_hap1_bowtie2/H9.hap1.fa \
    -1 $work_directory/01_quality_control/${n}_val_1.fq.gz \
    -2 $work_directory/01_quality_control/${n}_val_2.fq.gz $Set | samtools view -b -F 12 - | samtools sort -@ 20 - -O BAM -o "$bowtie2_mapping/alignment_H9_hap1/${n}.H9_hap1.bam"
	samtools view -bh -q 20 "$bowtie2_mapping/alignment_H9_hap1/${n}.H9_hap1.bam" | samtools sort -@ 20 - -O BAM -o "$bowtie2_mapping/alignment_H9_hap1/${n}.H9_hap1.q20.bam"

	samtools index -@ 20 "$bowtie2_mapping/alignment_H9_hap1/${n}.H9_hap1.bam"
	samtools index -@ 20 "$bowtie2_mapping/alignment_H9_hap1/${n}.H9_hap1.q20.bam"

	bamCoverage -b "$bowtie2_mapping/alignment_H9_hap1/${n}.H9_hap1.bam" -o "$bam_coverage/${n}.H9_hap1.bw" $Cov
	bamCoverage -b "$bowtie2_mapping/alignment_H9_hap1/${n}.H9_hap1.q20.bam" -o "$bam_coverage/${n}.H9_hap1.q20.bw" $Cov
        )
done



# Alignment of ATAC_Seq reads against H9_hap2 genome

for n in $(cat list_sra_to_download.txt); do

	echo "Processing $n against H9_hap2"
	(
	bowtie2 -x $bowtie2_index/index_H9_hap2_bowtie2/H9.hap2.fa \
    -1 $work_directory/01_quality_control/${n}_val_1.fq.gz \
    -2 $work_directory/01_quality_control/${n}_val_2.fq.gz $Set | samtools view -b -F 12 - | samtools sort -@ 20 - -O BAM -o "$bowtie2_mapping/alignment_H9_hap2/${n}.H9_hap2.bam"
	samtools view -bh -q 20 "$bowtie2_mapping/alignment_H9_hap2/${n}.H9_hap2.bam" | samtools sort -@ 20 - -O BAM -o "$bowtie2_mapping/alignment_H9_hap2/${n}.H9_hap2.q20.bam"

	samtools index -@ 20 "$bowtie2_mapping/alignment_H9_hap2/${n}.H9_hap2.bam"
	samtools index -@ 20 "$bowtie2_mapping/alignment_H9_hap2/${n}.H9_hap2.q20.bam"

	bamCoverage -b "$bowtie2_mapping/alignment_H9_hap2/${n}.H9_hap2.bam" -o "$bam_coverage/${n}.H9_hap2.bw" $Cov
	bamCoverage -b "$bowtie2_mapping/alignment_H9_hap2/${n}.H9_hap2.q20.bam" -o "$bam_coverage/${n}.H9_hap2.q20.bw" $Cov
        )
done

