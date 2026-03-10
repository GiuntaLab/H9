# H9
**<p align="center"> The reference genome for the human embryonic stem cell H9 </p>**

<p align="justify"> We have assembled the first fully phased, telomere-to-telomere (T2T) diploid reference genome for H9 (WAe009-A), one of the most widely used and ethically approved human embryonic stem cell (hESC) lines in biomedical research, registered in both the European and NIH Human Pluripotent Stem Cell Registries.

The H9 T2T diploid assembly was generated using high-coverage PacBio HiFi, Oxford Nanopore, and Hi-C data. It achieves a QV score exceeding 63, end-to-end chromosomes with complete telomeres and centromeres, and greater than 99.8% k-mer and BUSCO gene completeness, placing it on par with the most accurate human genome assemblies to date.

Our H9 assembly showcases comprehensive annotations, including genes, segmental duplications, methylation, chromatin conformation, specific variants and structural rearrangements, and centromeric sequence. Crucially, it enables haplotype-resolved gene expression and chromatin accessibility analyses, which highlights the power of this resource for allele-specific, high-precision transcriptomic, genetic, and epigenetic analyses.

This repository contains documentation, scripts and processed data relative to the H9 diploid genome assembly, annotations and multi-omics analyses. </p>

## Genome availability

A UCSC Browser hub with data associated with this assembly is available at:  
https://public.gi.ucsc.edu/hausslerlab/t2t-h9-hub/.


GenBank accessions of assembly:   
[GCA_054883195.1](https://www.ncbi.nlm.nih.gov/datasets/genome/GCA_054883195.1/) (haplotype 1)   
[GCA_054883265.1](https://www.ncbi.nlm.nih.gov/datasets/genome/GCA_054883265.1/) (haplotype 2)  

## Sequencing data

SRA accessions/Bioproject of reads used to construct the assembly:  
BioProject [PRJNA1431686](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA1431686)  
SRA BioProject [SRP680790](https://trace.ncbi.nlm.nih.gov/Traces/?study=SRP680790)  


## Genome assembly and curation  

The reference genome from the H9 hESC line was generated using a combination of Pacific Biosciences (PacBio) HiFi reads (coverage 75×), Oxford Nanopore Technology (ONT) R10 ligation reads (coverage 123×, including 47× >100 Kbps), and Arima high-throughput chromosome conformation capture (Hi-C) long-range information (coverage 87×). Two genome assembly strategies were attempted using the **[Verkko](https://github.com/marbl/verkko)** pipeline.
  
**The first assembly (asm1)** uses HiFi reads for graph construction with ONT reads for graph resolution.    
**The second assembly (asm2)** incorporates HiFiasm-corrected ONT reads into the graph construction.  


## Genome quality  

The quality of the H9 genome was assessed using a variety of tools:  

- **[gfastats](https://github.com/vgl-hub/gfastats)**

Assembly basic statistics, computed using gfastats, showed that H9 is essentially gapless (contig N50=155.2 Mbps for hap1; 153.7 Mbps for hap2).   
  
 - **[NucFreq](https://github.com/mrvollger/NucFreq)** and **[NucFlag](https://github.com/logsdon-lab/NucFlag)**  
 
 Primary alignments of HiFi reads to H9 haploid genomes were used to generate genome-wide coverage plots with NucFreq. In addition, primary alignments of HiFi and ONT reads to the H9 diploid genome were used to generate a genome-wide coverage plot with NucFlag. Coverage plots display the frequencies of the most and second most common bases at each genomic position, and they showed an overall homogeneous distribution across chromosomes in both haplotypes.  
  
- **[Merqury](https://github.com/marbl/merqury)**
    
By comparing the k-mers in the HiFi reads to the k-mers found in the assembly, we obtained a quality value (QV) of 63.6 for Hap1 and 66.1 for Hap2, and 99.87% completeness for both haplotypes. Furthermore, k-mer spectra revealed a multiplicity profile consistent with a near-complete assembly, with no detectable duplications.  
  
- **[HMM-Flagger](https://github.com/mobinasri/flagger)**
  
Based on the alignment of HiFi reads to the H9 assembly, HMM-Flagger classified 99.29% of the diploid assembly (6.06 Gbps) as a reliable haploid sequence. Regions flagged as assembly errors were rare, totaling 5.45 Mbps (0.09%), and collapsed regions totaled 4.10 Mbps (0.07%). The genomic coordinates of these low-confidence regions were used to define a low-confidence annotation track in the final assembly.  

- **[Compleasm](https://github.com/huangnengCSU/compleasm)**  
  
Gene completeness was determined by Compleasm using mammalia_odb12 as the gene dataset. Compleasm identified 99.11% complete genes in both haplotypes, with a small difference in duplicated genes (0.7% in haplotype 1; 0.69% in haplotype 2). The missing genes are 0.04% and 0.03%, while the fragmented ones are 0.15% and 0.16% for haplotype 1 and haplotype 2, respectively.  

   

  
## Pangenome PCA and ancestry analyses  

The pangenome PCA was computed based on a PGGB graph built from the initial year one HPRC samples plus the two human references (GRCh38 and CHM13), with the inclusion of the H9 genome. As a result, the H9 genome groups with the HPRC samples and CHM13, indicating better alignment in graph space across these high-quality diploid assemblies.  

Ancestry inference was performed using two tools:  

- **[GenoTools](https://github.com/dvitale199/GenoTools)**     

GenoTools assigned a population label to H9 genome according to a pre-computed set of genetic distances integrating samples from the 1000 Genomes Project (1KG), the Human Genome Diversity Panel (HGDP), and an Ashkenazi Jewish reference panel (AJ). In line with the previous
SNP chips analysis, H9 clusters in proximity to European populations, and it was also close to Ashkenazi Jewish (AJ) samples.  
  
- **[PCLAI](https://github.com/AI-sandbox/hprc-pclai)**  
  
PCLAI computed local ancestry inference by assigning continuous PCA coordinates along phased H9 haplotypes. The employed model was trained on an autosomal subset of 26062361 biallelic SNPs from a 1KG and HGDP merge with 2356 training samples. PCLAI indicated that H9 has predominantly European-like ancestry, albeit with substantial West Asian-like chromosomal segments and little evidence for African-like ancestry.  
  
  
## Gene annotation  

Gene annotation, performed using the **[Comparative Annotation Toolkit](https://github.com/ComparativeGenomicsToolkit/Comparative-Annotation-Toolkit)**, identified:
   * 20098 protein-coding genes, 15445 pseudogenes, and 44273 non-coding RNAs of which 35354 are lncRNAs in haplotype 1.  
   * 20148 protein-coding genes, 15480 pseudogenes, and 44356 non-coding RNAs of which 35382 are lncRNAs in haplotype 2.  
   * There are 7 haplotype 1-only and 8 haplotype 2-only genes.   
   * Excluding genes absent from one haplotype, the H9 genome harbors 20 and 31 genes with higher copy numbers on haplotype 1 and haplotype 2, respectively.      
  
  
## Centromere annotation  

Centromere identification and annotation was performed using multiple orthogonal methods,each providing a different layer of information:  
  
- **[dna-nn](https://github.com/lh3/dna-nn)**      

dna-nn was used to identify alpha saltellites, located primarily at the centromeres.    

- **[Hum-AS-HMMER for AnVIL](https://github.com/fedorrik/HumAS-HMMER_for_AnVIL)**      

Hum-AS-HMMER for AnVIL took as input the bed file of alpha satellites, and outputed complete higher order repeats (HORs) annotation.      

- **[Genomic Centromere Profiling (GCP) pipeline](https://github.com/GiuntaLab/GCP-Centeny)**      

The GCP pipeline comprises utilities for centromere architecture characterisation based on the the pattern of numerical values derived from the nucleotide distance between CENP-B box motifs within centromeres, and their organization within the alpha-satellite monomers, defining centeny maps.  

  
  
## Telomere annotation  

Telomere annotation was performed using the **[Teloscope](https://github.com/vgl-hub/teloscope)** tool, scanning for canonical (CCCTAA/TTAGGG) and noncanonical telomeric repeats. To validate the annotation output, HiFi and ONT reads were re-aligned against the H9 haplotypes, followed by coverage assessment for the 25 Kbps most distal region of each chromosome end using **[NucFlag](https://github.com/logsdon-lab/NucFlag)**. 


## Genome-wide sequence and structural variation  
  
Sequence and structural variants were assessed between H9 haplotypes, and between each of the H9 hplotypes and CHM13. Based on genome-to-genome alignments obtained with **[minimap2](https://github.com/lh3/minimap2)**, **[SyRI](https://github.com/schneebergerlab/syri)** was used to identify synthenic regions, SNPs and structural rearrangements. Subsequently, the SyRI output was post-processed to compute chromosome-wide SNP and HDR (Highly Divergent Regions) densities in nonoverlapping 10 Kbps windows.   
  
- **H9 hap1 vs. H9 hap2:** the average SNPs density across chromosome arms between H9 haplotypes was 0.11% (one heterozygous marker every 1000 bps). However, it increased to 0.53% within centromeric regions (active alpha satellite HORs). The H9 haplotypes show 3010848 SNVs, 69 inversions, and 1141 translocations. The highly divergent regions (HDRs) are predominantly associated with centromeres.  

- **H9 hap1 vs. CHM13:** H9 haplotype 1 is 99.90% syntenic with the CHM13 reference. There are 3124343 SNPs, 66 inversions, and 1847 translocations between the two genomes.
  
- **H9 hap2 vs. CHM13:** H9 haplotype 2 is 99.88% syntenic with the CHM13 reference. There are 3089128 SNPs, 62 inversions, and 1697 translocations between the two genomes.

SNP and HDR density plots were generated using the **[karyoploteR](https://github.com/bernatgel/karyoploteR)** R package.


## Identification of segmental duplications in H9

Segmental duplications (SD) in the H9 assembly were annotated using the **[SEDEF](https://github.com/vpc-ccg/sedef)** tool. The two H9 haplotypes comprised 5.6% and 5.7% SD, respectively. This is consistent with the 5.6% SD coverage in the CHM13 assembly.  

The cross-reference of the H9 and CHM13 genomes, against 83 loci from a systematic review of recurrent CNVs associated with neurodevelopmental disorders, identified four structural variants involving interhaplotype inversions among these loci.  

CNV location and structure between the two H9 haplotypes, CHM13, and GRCh38 were visualized with the **[SVByEye](https://github.com/daewoooo/SVbyEye)** R package.    
  
  
## Chromatin accessibility analysis  

 Publicly available ATAC-Seq raw data, generated from H9 cells undergoing early neural differentiation ([GSE291907](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE291907)) were downloaded to perform chromatin accessibility analysis across H9 haplotypes.

Specifically, we downloaded paired-end ATAC-Seq data from 10 samples, with the following accession numbers: SRR32687946, SRR32687947, SRR32687948, SRR32687949, SRR32687950, SRR32687951, SRR32687952, SRR32687953, SRR32687954, and SRR32687955.

The ATAC-Seq data analysis was performed as follows:

1. Quality control and adapter trimming were performed with **[TrimGalore](https://github.com/FelixKrueger/TrimGalore)**. 

2. Alignment of the trimmed reads against the separate H9 haplotypes using **[bowtie2](https://github.com/BenLangmead/bowtie2)**.   

3. Narrow peak calling from mapped paired-end reads with quality score > 20, using **[MACS3](https://github.com/macs3-project/MACS)**.

4. Liftover of the coordinates of narrow peaks called in haplotype 1 to haplotype 2. 

5. Intersection of the liftedover peaks with those of the original haplotype 2 peaks using the **[bedtools intersect](https://bedtools.readthedocs.io/en/latest/content/tools/intersect.html)** module, generating a set of matched peaks across H9 haplotypes. 

6. Quantification of the aligned reads to each H9 haplotype with the **[bedtools multicov](https://bedtools.readthedocs.io/en/latest/content/tools/multicov.html)** module, restricting the analysis to the alignments within the matched peaks. 

7. The resulting counts were combined into a single matrix, which was used for the differential chromatin accessibility analysis with **[DESeq2](https://bioconductor.org/packages/release/bioc/html/DESeq2.html)**. 



Scripts and further workflow information are available in the "Chromatin accessibility analysis" folder within this repository.

  

  
> [!WARNING]
> This repository is under current editing.
