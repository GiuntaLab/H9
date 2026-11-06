
#### Load R libraries

library(edgeR)
library(ggplot2)
library(ggrepel)
library(patchwork)


#### Feature count from reads mapped against H9 haplotype1

count_data_hap1 <- read.table("04_counts_featureCounts/feature_counts_H9_HAP1_filtered.txt", header=TRUE, row.names=1, sep="\t")
count_data_hap1_f <- count_data_hap1[, c(6,7,8)]
fpkms_hap1 = rpkm(count_data_hap1_f, gene.length=count_data_hap1$Length)

#### Feature count from reads mapped against H9 haplotype2

count_data_hap2 <- read.table("04_counts_featureCounts/feature_counts_H9_HAP2_filtered_ordered.txt", header=TRUE, row.names=1, sep="\t")
count_data_hap2_f <- count_data_hap2[, c(6,7,8)]
fpkms_hap2 = rpkm(count_data_hap2_f, gene.length=count_data_hap2$Length)



#### Feature count from reads mapped against hg38

count_data_hg38 <- read.table("04_counts_featureCounts/feature_counts_hg38_filtered_ordered.txt", header=TRUE, row.names=1, sep="\t")
count_data_hg38_f <- count_data_hg38[, c(6,7,8)]
fpkms_hg38 = rpkm(count_data_hg38_f, gene.length=count_data_hg38$Length)


#### Combine counts of reads mapped tagainst H9 haplotypes and hg38 in a data frame

fpkms_finale <- as.data.frame(cbind(fpkms_hap1, fpkms_hap2, fpkms_hg38))
keep_fpkms <- rowSums(fpkms_finale > 1) >= 4
fpkms_finale <- fpkms_finale[keep_fpkms,]


fpkm.table <- data.frame(A1=rowMeans(fpkms_finale[,1:3]), 
                         A2=rowMeans(fpkms_finale[,4:6]),
                         A3=rowMeans(fpkms_finale[,7:9]))


rownames(fpkm.table) = rownames(fpkms_finale)

count_data_hap1_f <- count_data_hap1_f[rownames(fpkms_finale),]
colnames(count_data_hap1_f) <- c( "parent_1_hap1", "parent_2_hap1", "parent_3_hap1")

count_data_hap2_f <- count_data_hap2_f[rownames(fpkms_finale),]
colnames(count_data_hap2_f) <- c( "parent_1_hap2", "parent_2_hap2", "parent_3_hap2")

count_data_hg38_f <- count_data_hg38_f[rownames(fpkms_finale),]
colnames(count_data_hg38_f) <- c( "parent_1_hg38", "parent_2_hg38", "parent_3_hg38")

counts_final <- cbind(count_data_hap1_f, count_data_hap2_f, count_data_hg38_f)


condition_final <- factor(c("B1","B1","B1",
                            "B2","B2","B2",
                            "B3","B3","B3"))


dge_final = DGEList(counts=counts_final,group=condition_final)

cpms_dge = cpm(dge_final)

logcpm_dge <- log2(cpms_dge + 1)

norm_counts <- cpm(dge_final, log = TRUE)

#### Heatmap to show all the logCPM of all genes

pheatmap(logcpm_dge, cluster_cols = F, 
         color = colorRampPalette(c("navy","white","firebrick"))(90),
         show_rownames=F, main = "logCPM All Genes")



#### Differential expression/mapping using edgeR

dge_final <- calcNormFactors(dge_final)


design <- model.matrix(~0+condition_final, data=dge_final$samples)

rownames(design) <- colnames(counts_final) ####assign the column names of the count
design

dge_final_final <- estimateDisp(dge_final, design)

fit <- glmFit(dge_final_final, design)

my.contrasts <- makeContrasts(B1vsB2=condition_finalB1-condition_finalB2,
                              B1vsB3=condition_finalB1-condition_finalB3,
                              B2vsB3=condition_finalB2-condition_finalB3,
                              levels=design)


lrt.B1vsB2 <- glmLRT(fit, contrast=my.contrasts[,"B1vsB2"]) #HAP1-HAP2 left-right
lrt.B1vsB3 <- glmLRT(fit, contrast=my.contrasts[,"B1vsB3"]) #HAP1-HG38
lrt.B2vsB3 <- glmLRT(fit, contrast=my.contrasts[,"B2vsB3"]) #HAP2-HG38

tp_lrt.B1vsB2 = topTags(lrt.B1vsB2, n=nrow(lrt.B1vsB2$table))
tp_lrt.B1vsB3 = topTags(lrt.B1vsB3, n=nrow(lrt.B1vsB3$table))
tp_lrt.B2vsB3 = topTags(lrt.B2vsB3, n=nrow(lrt.B2vsB3$table))


tp_lrt.B1vsB2_frame = as.data.frame(tp_lrt.B1vsB2)
tp_lrt.B1vsB3_frame = as.data.frame(tp_lrt.B1vsB3)
tp_lrt.B2vsB3_frame = as.data.frame(tp_lrt.B2vsB3)

tp_lrt.B1vsB2_frame$diffexpressed <- mapply(get_upregulated_and_downregulated,
                                            tp_lrt.B1vsB2_frame$FDR,
                                            tp_lrt.B1vsB2_frame$logFC)
tp_lrt.B1vsB2_frame$genes <- rownames(tp_lrt.B1vsB2_frame)


tp_lrt.B1vsB3_frame$diffexpressed <- mapply(get_upregulated_and_downregulated,
                                            tp_lrt.B1vsB3_frame$FDR,
                                            tp_lrt.B1vsB3_frame$logFC)
tp_lrt.B1vsB3_frame$genes <- rownames(tp_lrt.B1vsB3_frame)

tp_lrt.B2vsB3_frame$diffexpressed <- mapply(get_upregulated_and_downregulated,
                                            tp_lrt.B2vsB3_frame$FDR,
                                            tp_lrt.B2vsB3_frame$logFC)
tp_lrt.B2vsB3_frame$genes <- rownames(tp_lrt.B2vsB3_frame)





#### Volcano plots



create_volcano_plot <- function(df, comparison_name) {
  
  # ============================================================
  # 0. CLEAN DATA
  # ============================================================
  
  # Replace zero P-values to avoid -log10(0) = Inf
  df$PValue[df$PValue == 0] <- 1e-300
  
  # Remove problematic rows
  df <- df[is.finite(df$logFC) &
             is.finite(df$PValue) &
             is.finite(df$FDR), ]
  
  # ============================================================
  # 1. DEFINE SIGNIFICANCE BASED ON FDR
  # ============================================================
  
  df$Significance <- "Not significant"
  df$Significance[df$FDR < 0.05 & df$logFC > 0] <- "Enriched"
  df$Significance[df$FDR < 0.05 & df$logFC < 0] <- "Depleted"
  
  # Count genes
  n_up <- sum(df$Significance == "Enriched")
  n_down <- sum(df$Significance == "Depleted")
  
  # ============================================================
  # 2. SELECT TOP GENES BASED ON FDR
  # ============================================================
  
  top_up <- df[df$Significance == "Enriched", ]
  top_up <- top_up[order(top_up$FDR), ]
  top_up <- head(top_up, 5)
  
  top_down <- df[df$Significance == "Depleted", ]
  top_down <- top_down[order(top_down$FDR), ]
  top_down <- head(top_down, 5)
  
  top_genes <- rbind(top_up, top_down)
  
  # ============================================================
  # 3. TRANSFORM Y-AXIS
  # ============================================================
  
  df$negLogP <- -log10(df$PValue)
  top_genes$negLogP <- -log10(top_genes$PValue)
  
  max_y <- max(df$negLogP, na.rm = TRUE)
  y_limit <- ceiling(max_y * 1.1)
  
  # ============================================================
  # 4. TITLE WITH COUNTS
  # ============================================================
  
  full_title <- paste0(
    comparison_name,
    "   (Enriched: ", n_up,
    " | Depleted: ", n_down, ")"
  )
  
  # ============================================================
  # 5. BUILD PLOT
  # ============================================================
  
  p <- ggplot(df, aes(x = logFC,
                      y = negLogP,
                      color = Significance)) +
    
    geom_point(size = 1.4, alpha = 0.8) +
    
    geom_text_repel(
      data = top_genes,
      aes(label = genes),
      size = 3,
      box.padding = 0.6,
      point.padding = 0.5,
      min.segment.length = 0,
      segment.color = "grey40",
      segment.size = 0.3,
      force = 2,
      max.overlaps = Inf
    ) +
    
    scale_color_manual(
      name = "Expression",
      values = c(
        "Depleted" = "#00AFBB",
        "Not significant" = "grey70",
        "Enriched" = "#bb0c00"
      )
    ) +
    
    # LogFC threshold
    geom_vline(xintercept = 0,
               linetype = "dashed",
               color = "black",
               linewidth = 0.4) +
    
    # FDR threshold (visual reference)
    geom_hline(yintercept = -log10(0.05),
               linetype = "dashed",
               color = "black",
               linewidth = 0.4) +
    
    coord_cartesian(ylim = c(0, y_limit)) +
    
    labs(
      title = full_title,
      x = "log2 Fold Change",
      y = "-log10(P-value)"
    ) +
    
    theme_bw() +
    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.border = element_rect(color = "black", fill = NA, linewidth = 0.8),
      plot.title = element_text(hjust = 0.5,
                                face = "bold",
                                size = 12),
      legend.position = "right",
      legend.title = element_text(face = "bold")
    )
  
  return(p)
}


?geom_text_repel

?coord_cartesian


p1 <- create_volcano_plot(tp_lrt.B1vsB2_frame,
                          "H9 Hap1 vs H9 Hap2")

p1

ggsave(filename = "H9 Hap1 vs H9 Hap2_volcano_plot.svg",
       p1,
       width = 5.85,
       height = 3.27)


ggsave(filename = "H9 Hap1 vs H9 Hap2_volcano_plot.png",
       p1,
       width = 5.85,
       height = 3.27)

ggsave(filename = "H9 Hap1 vs H9 Hap2_volcano_plot.pdf",
       p1)


p2 <- create_volcano_plot(tp_lrt.B1vsB3_frame,
                          "H9 Hap1 vs GRCh38")

p2


ggsave(filename = "H9 Hap1 vs GRCh38_volcano_plot.svg",
       p2,
       width = 5.85,
       height = 3.27)

ggsave(filename = "H9 Hap1 vs GRCh38_volcano_plot.pdf",
       p2)

p3 <- create_volcano_plot(tp_lrt.B2vsB3_frame,
                          "H9 Hap2 vs GRCh38")

p3


ggsave(filename = "H9 Hap2 vs GRCh38_volcano_plot.svg",
       p3,
       width = 5.85,
       height = 3.27)

ggsave(filename = "H9 Hap2 vs GRCh38_volcano_plot.pdf",
       p3)
