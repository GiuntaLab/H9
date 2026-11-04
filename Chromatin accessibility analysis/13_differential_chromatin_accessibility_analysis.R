
### ============================================================
### DESeq2 differential chromatin accessibility (H9 hap2 vs H9 hap1)
### Paired design: each biological sample contributes one hap1 and one hap2 measurement
### ============================================================


library(DESeq2)
library(ggplot2)
library(EnhancedVolcano)
library(dplyr)
library(ashr)
library(tidyr)


# -----------------------------------------------------------
# 1.  Input files and metadata
# -----------------------------------------------------------

# Path to the merged count table (no header)
counts_file <- "H9_combined_q20_matched_narrow_peaks_counts_with_beds.tsv"

# A text file with sample names (one per line) in the same order as BAMs
sample_names_file <- "list_sra_to_download.txt"

# Read counts
counts_raw <- read.table(counts_file, header = FALSE, sep = "\t")

# Remove the first 4 columns (chr, start, end, name)
counts_mat <- as.matrix(counts_raw[, 5:ncol(counts_raw)])

# assign rownames to peaks
rownames(counts_mat) <- paste(counts_raw$V1, counts_raw$V2, counts_raw$V3, sep = "_")

# Number of biological samples
sample_names <- readLines(sample_names_file)
nsamp <- length(sample_names)


# -------------------------------------------------------------
# 2. Build sample metadata
# -------------------------------------------------------------

# Construct column names and metadata
colnames(counts_mat) <- c(paste0(sample_names, "_hap1"), paste0(sample_names, "_hap2"))

colData <- data.frame(
  Sample = rep(sample_names, 2),
  Haplotype = rep(c("hap1", "hap2"), each = nsamp)
)
rownames(colData) <- colnames(counts_mat)


# ----------------------------
# 3. Run DESeq2
# ----------------------------

dds <- DESeqDataSetFromMatrix(countData = counts_mat,
                              colData = colData,
                              design = ~ Sample + Haplotype)


# Filter out low-count peaks
dds <- dds[rowSums(counts(dds)) >= 10, ]


# Run DESeq2
dds <- DESeq(dds)

resultsNames(dds)

res <- results(dds, contrast = c("Haplotype", "hap2", "hap1"))

# shrink log2FCs
res <- lfcShrink(dds, coef = "Haplotype_hap2_vs_hap1", type = "ashr")


# Order by adjusted p-value
res_ordered <- res[order(res$padj), ]


# -----------------------------------------------------------
# 4. Save results of differential haplotype chromatin accessibility
# -----------------------------------------------------------

write.csv(as.data.frame(res_ordered),
          file = "differential_haplotype_chromatin_accessibility_DESeq2_results.csv",
          row.names = TRUE)


# -----------------------------------------------------------
# 5. Volcano plot
# -----------------------------------------------------------

volcano_plot_atac_seq_H9_hap2_vs_H9_hap1 <- EnhancedVolcano(res_ordered,
                lab = ifelse(res_ordered$padj < 0.05, 
                             rownames(res_ordered), ""),
                x = "log2FoldChange",
                y = "padj",
                xlab = bquote(~Log[2]~ "Fold Change (Hap2 / Hap1)"),
                ylab = bquote(~-Log[10]~ "Adjusted p-value"),
                pCutoff = 0.05,
                FCcutoff = 1,
                pointSize = 1.8,
                labSize = 5,
                col = c("grey70", "royalblue", "red2"),
                colAlpha = 0.8,
                drawConnectors = TRUE,
                max.overlaps = 14,
                boxedLabels = FALSE,
                title = "Differential haplotype chromatin accessibility: H9 Hap2 vs H9 Hap1",
                subtitle = "",
                legendPosition = "right",
                caption = paste0("Total = ", nrow(res_ordered), " matched chromatin regions between H9 haplotypes"),
                gridlines.major = FALSE,
                gridlines.minor = FALSE)


ggsave(paste0("06_differential_accessibility_analysis_deseq2/",
              "volcano_plot_atac_seq_H9_hap2_vs_H9_hap1.png"),
       volcano_plot_atac_seq_H9_hap2_vs_H9_hap1,
       width=12.6,
       height=7.2)



# -----------------------------------------------------------
# 6. create enriched peaks csv files
# -----------------------------------------------------------

resultsNames(dds)


# Assuming your DESeq2 result is in `res` (already shrunk)
res_df <- as.data.frame(res)
res_df$peak_id <- rownames(res_df)

# Set significance thresholds
padj_cutoff <- 0.05
lfc_cutoff <- 1

# Check direction (replace with what resultsNames() showed)
direction <- "hap2_vs_hap1"  # or "hap1_vs_hap2"

if (grepl("hap2_vs_hap1", direction)) {
  hap2_enriched <- subset(res_df, padj < padj_cutoff & log2FoldChange > lfc_cutoff)
  hap1_enriched <- subset(res_df, padj < padj_cutoff & log2FoldChange < -lfc_cutoff)
} else {
  hap1_enriched <- subset(res_df, padj < padj_cutoff & log2FoldChange > lfc_cutoff)
  hap2_enriched <- subset(res_df, padj < padj_cutoff & log2FoldChange < -lfc_cutoff)
}

hap1_enriched
hap2_enriched


# Save to CSV
write.csv(hap1_enriched,
          "06_differential_accessibility_analysis_deseq2/hap1_enriched_peaks.csv",
          row.names = FALSE)


write.csv(hap2_enriched,
          "06_differential_accessibility_analysis_deseq2/hap2_enriched_peaks.csv",
          row.names = FALSE)



## Add coordinates columns to the haplotype enriched peaks

H9_hap2_q20_narrow_peaks_in_H9_hap1_coordinates <- 
  read.table(paste0("05_liftover_between_H9_haplotypes/",
                  "H9_hap2_q20_narrow_peaks_in_H9_hap1_coordinates.bed"),
             header=FALSE)


colnames(H9_hap2_q20_narrow_peaks_in_H9_hap1_coordinates)<-
  c("Chromosome", "Start", "End", "peak_id", "score", "strand")



hap1_enriched_with_coordinates <- H9_hap2_q20_narrow_peaks_in_H9_hap1_coordinates %>%
  inner_join(
    hap1_enriched,
    by = "peak_id"
  )



hap2_enriched_with_coordinates <- hap2_enriched %>%
  separate(
    peak_id,
    into = c("Chromosome", "hap", "Start", "End"),
    sep = "_",
    remove = FALSE
  ) %>%
  mutate(Chromosome = paste(Chromosome, hap, sep = "_")) %>%
  select(
    Chromosome, Start, End, peak_id,
    baseMean, log2FoldChange, lfcSE, pvalue, padj
  )



hap2_enriched_with_coordinates <- hap2_enriched_with_coordinates %>%
  left_join(
    H9_hap2_q20_narrow_peaks_in_H9_hap1_coordinates %>%
      select(peak_id, score, strand),
    by = "peak_id"
  ) %>%
  relocate(score, strand, .after = peak_id)


# Save to CSV
write.csv(hap1_enriched_with_coordinates,
          "06_differential_accessibility_analysis_deseq2/hap1_enriched_peaks_with_coordinates.csv",
          row.names = FALSE)


write.csv(hap2_enriched_with_coordinates,
          "06_differential_accessibility_analysis_deseq2/hap2_enriched_peaks_with_coordinates.csv",
          row.names = FALSE)


# -----------------------------------------------------------
# 7. Create enriched peaks bed files for annotation
# -----------------------------------------------------------

# Save to BED

write.table(
  hap1_enriched_with_coordinates %>%
    select(Chromosome, Start, End, peak_id, score, strand),
  file = "06_differential_accessibility_analysis_deseq2/hap1_enriched_peaks_with_coordinates.bed",
  sep = "\t",
  quote = FALSE,
  row.names = FALSE,
  col.names = FALSE
)


write.table(
  hap2_enriched_with_coordinates %>%
    select(Chromosome, Start, End, peak_id, score, strand),
  file = "06_differential_accessibility_analysis_deseq2/hap2_enriched_peaks_with_coordinates.bed",
  sep = "\t",
  quote = FALSE,
  row.names = FALSE,
  col.names = FALSE
)





message("✅ DESeq2 analysis complete!")
