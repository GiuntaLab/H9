# run nucflag on H9 T2T genomes

#-----------------
# plot for entire chromosome HiFi

# download HiFi bam file
wget https://public.gi.ucsc.edu/~ipacar/notch2nl-hub/t2t_h9_v01_diploid/t2t_h9_hifi/t2t_h9_v01_diploid.t2t_h9_hifi.bam
wget https://public.gi.ucsc.edu/~ipacar/notch2nl-hub/t2t_h9_v01_diploid/t2t_h9_hifi/t2t_h9_v01_diploid.t2t_h9_hifi.bam.bai

# filter unmapped, secondary and supplementary alignment
samtools view -F 2308 -u t2t_h9_v01_diploid.t2t_h9_hifi.bam | samtools sort -o h9_hifi.sorted.bam

# create a bed file for the entire chromosome
awk '{print $1"\t"0"\t"$2}' H9_T2T_v0.1.fasta.fai > chr.bed
# create a config file to change the window size
conda activate nucflag_1.0.0a2
nucflag config > input_cfg.toml
# modify window size to 50000

# run nucflag
BAM="h9_hifi.sorted.bam"
FASTA=H9_T2T_v0.1.fasta
LINE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" chr.bed)
nucflag call -i "${BAM}" -f "${FASTA}" \
	-x hifi \
	-p 30 \
	-t 30 \
	-o misassemblies.bed \
	-d ./plots \
	-b <(printf "%s\n" "$LINE") \
	-c input_cfg.toml

#-----------------
# plot for entire chromosome ONT
# map reads and filter bam
REF=../H9_T2T_v0.1.fasta
READ1=genomic_data/ont/06_21_23_06_28_23_R1041_H9_UL.dorado_0.8.1_5mC_5hmC.fastq.gz
READ2=genomic_data/ont/11_20_2024_R1041_UL_H9.dorado_0.8.1_sup.5mC_5hmC.fastq.gz
minimap2 -ax lr:hq --eqx -t 10 $REF $READ1 $READ2 > ONT.sam
samtools view -@ 10 -F 2308 -u ONT.sam | samtools sort -@ 10 -o h9_ONT_filtered.bam
samtools index h9_ONT_filtered.bam

# run nucflag
nucflag config -x ont_r10 > input_cfg_ont_50kbp.toml
BAM="h9_ONT_filtered.bam"
FASTA=../HiFi_cov/H9_T2T_v0.1.fasta
LINE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" chr.bed)
nucflag call -i "${BAM}" -f "${FASTA}" \
	-x ont_r10 \
	-p 30 \
	-t 30 \
	-o misassemblies.bed \
	-d ./plots_chr/ \
	-b <(printf "%s\n" "$LINE") \
	-c input_cfg_ont_50kbp.toml


#-----------------
# plot for telomere regions HiFi

BAM="h9_hifi.sorted.bam"
FASTA=H9_T2T_v0.1.fasta
CHROM=$(awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line {print $1}' chr.bed)
# p telomere
P=$(grep -P "^${CHROM}\t" ./telomere_annotation/p.bed | cut -f1-3 | \
    awk -v OFS='\t' '{print $0,"telomere","0",".",$2,$3,"86,180,233"}')
echo "generating nucflag plots for $CHROM, highlight region $P"
nucflag call -i "${BAM}" -f "${FASTA}" -p 30 -t 30 \
    -x hifi \
    -o bed_files/p_${CHROM}.bed \
    -d ./plots_telomere \
    -b <(printf "%s\t0\t25000\n" "${CHROM}") \
    --overlap_tracks <(printf "%s\n" "$P") \
    -c input_cfg_default.toml
# q telomere
LINE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" chr.bed | awk -v OFS='\t' '{print $1, $3 - 25000,$3}')
Q=$(grep -P "^${CHROM}\t" ./telomere_annotation/q.bed | cut -f1-3 | \
    awk -v OFS='\t' '{print $0,"telomere","0",".",$2,$3,"86,180,233"}')
echo "generating nucflag plots for $LINE, highlight region $Q"
nucflag call -i "${BAM}" -f "${FASTA}" -p 30 -t 30 \
    -x hifi \
    -o bed_files/q_${CHROM}.bed \
    -d ./plots_telomere \
    -b <(printf "%s\n" "$LINE") \
    --overlap_tracks <(printf "%s\n" "$Q") \
    -c input_cfg_default.toml


#-----------------
# plot for telomere regions ONT

BAM="h9_ONT_filtered.bam"
FASTA=../HiFi_cov/H9_T2T_v0.1.fasta
CHROM=$(awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line {print $1}' chr.bed)
# p telomere
P=$(grep -P "^${CHROM}\t" ../HiFi_cov/telomere_annotation/p.bed | cut -f1-3 | \
    awk -v OFS='\t' '{print $0,"telomere","0",".",$2,$3,"86,180,233"}')
echo "generating nucflag plots for $CHROM, highlight region $P"
nucflag call -i "${BAM}" -f "${FASTA}" -p 30 -t 30 \
    -x ont_r10 \
    -o bed_files/p_${CHROM}.bed \
    -d ./plots_telomere/ \
    -b <(printf "%s\t0\t25000\n" "${CHROM}") \
    --overlap_tracks <(printf "%s\n" "$P")
# q telomere
LINE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" chr.bed | awk -v OFS='\t' '{print $1, $3 - 25000,$3}')
Q=$(grep -P "^${CHROM}\t" ../HiFi_cov/telomere_annotation/q.bed | cut -f1-3 | \
    awk -v OFS='\t' '{print $0,"telomere","0",".",$2,$3,"86,180,233"}')
echo "generating nucflag plots for $LINE, highlight region $Q"
nucflag call -i "${BAM}" -f "${FASTA}" -p 30 -t 30 \
    -x ont_r10 \
    -o bed_files/q_${CHROM}.bed \
    -d ./plots_telomere/ \
    -b <(printf "%s\n" "$LINE") \
    --overlap_tracks <(printf "%s\n" "$Q")







