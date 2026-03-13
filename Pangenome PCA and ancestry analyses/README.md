# <p align="center">Requirements to run PCA analyses<p>
<div align="center">
  Below, the specifics to the varions aspects to compute PCAs from the graph, using <a href="https://github.com/dvitale199/GenoTools">GenoTools</a>, or as determined by <a href="https://github.com/AI-sandbox/hprc-pclai">PCLAI</a>.
</div>

## 1) pangenome PCA
<p align="justify">The pangenome PCA has been computed form pangenomes-by-chromosome (including only the 22 autosomes) constructed independently and then combined into a single data structure with <code>odgi squeeze</code> as indicated in the main work _PREPRINT TO BE ADDED_; additionally, <code>odgi similarity</code> was used to compute a sparse matrix of sequence alignment in graph space. More informations can be found at the <a href="https://odgi.readthedocs.io/en/latest/rst/commands/odgi_similarity.html">documentation page</a> for the tool.</p>

<p align="justify">Aside from this, the script <code>select_fasta_files.sh</code> extract from each individual genome the contigs associated to each one of the 22 autosomes based on a combined PAF alignment file of all genomes against a reference sequence (in this case CHM13). This can be easily computed with <a href="https://github.com/lh3/minimap2">minimap2</a> preset options and edited to retain only the field of interest.</br>The following <code>AWK</code> custom script was written to split each individual haplotype to its own independent file required by the <code>select_fasta_files.sh</code>:</p>

```sh
awk -F'\t' '
{
  split($1, a, "#")
  sample = a[1]
  pattern = a[2]
  chr = $2
  outfile = (sample "_" pattern "_" chr ".txt")
  print > outfile
}
' <input_file>
```

<p align="justify">Once done, those files listing chromosomes assignments for each individual can be used to extract the appropriate contigs from their assembly and store them into a chromosome FASTA later processed by the <code>build_pangenomes_by_chromosome.sh</code>. For clarity, an extract of the relevant fields of the input PAF file is provided below:</p>

```html
HG00438#2#CM089186.1	chr1
HG00438#2#CM089187.1	chr2
HG00438#2#CM089188.1	chr3
HG00438#2#CM089189.1	chr4
HG00438#2#CM089190.1	chr5
HG00438#2#CM089191.1	chr6
HG00438#2#CM089192.1	chr7
HG00438#2#CM089193.1	chr8
HG00438#2#CM089194.1	chr10
HG00438#2#CM089195.1	chr11
```

where contigs of haplotype 2 `#2#` of the `HG00438` individuals are assigned to the corresponding CHM13 chromosome.

## 2) GenoTools ancestry inference


## 3) PCLAI ancestry assignment
