
### ============================================================
### DESeq2 differential chromatin accessibility (H9 hap2 vs H9 hap1)
### Paired design: each biological sample contributes one hap1 and one hap2 measurement
### ============================================================


library(DESeq2)
library(ggplot2)
library(EnhancedVolcano)
library(dplyr)
library(ashr)


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

EnhancedVolcano(res_ordered,
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


