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

The reference genome from the H9 hESC line was generated using a combination of Pacific Biosciences (PacBio) HiFi reads (coverage 75×), Oxford Nanopore Technology (ONT) R10 ligation reads (coverage 123×, including 47× >100 Kbps), and Arima high-throughput chromosome conformation capture (Hi-C) long-range information(coverage 87×). Two genome assembly strategies were attempted using [Verkko](https://github.com/marbl/verkko) v2.2.1.:  
**The first assembly (asm1)** uses HiFi reads for graph construction with ONT reads for graph resolution.    
**The second assembly (asm2)** incorporates HiFiasm-corrected ONT reads into the graph construction.  


## Genome quality  

The quality of the H9 genome was assessed using a variety of tools:  

 - **[NucFreq](https://github.com/mrvollger/NucFreq)** and **[NucFlag](https://github.com/logsdon-lab/NucFlag)**  
 
 Primary alignments of HiFi reads to H9 haploid genomes were used to generate genome-wide coverage plots with NucFreq. In addition, primary alignments of HiFi and ONT reads to the H9 diploid genome were used to generate a genome-wide coverage plot with NucFlag. Coverage plots display the frequencies of the most and second most common bases at each genomic position, and they showed an overall homogeneous distribution across chromosomes in both haplotypes.  
  
- **[Merqury](https://github.com/marbl/merqury)**
    
By comparing the k-mers in the HiFi reads to the k-mers found in the assembly, we obtained a quality value (QV) of 63.6 for Hap1 and 66.1 for Hap2, and 99.87% completeness for both haplotypes. Furthermore, k-mer spectra revealed a multiplicity profile consistent with a near-complete assembly, with no detectable duplications.  
  
- **[HMM-Flagger](https://github.com/mobinasri/flagger)**
  
Based on the alignment of HiFi reads to the H9 assembly, HMM-Flagger classified 99.29 % of the diploid assembly (6.06 Gbps) as a reliable haploid sequence. Regions flagged as assembly errors were rare, totaling 5.45 Mbps (0.09%), and collapsed regions totaled 4.10 Mbps (0.07 %). The genomic coordinates of these low-confidence regions were used to define a low-confidence annotation track in the final assembly.

  
## Pangenome PCA and ancestry analyses  
...  
  
  
## Gene annotation  
...    
  
  
## Centromere annotation  
...  
  
  
## Telomere annotation  
...  
  
  
## Characterization of H9 specific variants and structural rearrangements  
...  
  
  
## Chromatin accessibility analysis  
Publicly available ATAC-Seq raw data, generated from H9 cells undergoing early neural differentiation (Bioproject: PRJNA1235757) were downloaded to perform chromatin accessibility analysis across H9 haplotypes. Specifically, we downloaded paired-end ATAC-Seq data from 10 samples, with the following accession numbers: SRR32687946, SRR32687947, SRR32687948, SRR32687949, SRR32687950, SRR32687951, SRR32687952, SRR32687953, SRR32687954, and SRR32687955.  
Scripts are available in the "Chromatin accessibility analysis" folder within this repository.  

  

  
> [!WARNING]
> This repository is under current editing.
