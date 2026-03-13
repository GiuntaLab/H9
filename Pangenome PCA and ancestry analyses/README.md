# <p align="center">Requirements to run PCA analyses<p>
<div align="center">
  Below, the specifics to the varions aspects to compute PCAs from the graph, using <a href="https://github.com/dvitale199/GenoTools">GenoTools</a>, or as determined by <a href="https://github.com/AI-sandbox/hprc-pclai">PCLAI</a>.
</div>

## 1) pangenome PCA
The pangenome PCA has been computed form pangenomes-by-chromosome (including only the 22 autosomes) constructed independently and then combined into a single data structure with `odgi squeeze` as indicated in the main work _PREPRINT TO BE ADDED_; additionally, `odgi similarity` was used to compute a sparse matrix of sequence alignment in graph space. More informations can be found at the [documentation page](https://odgi.readthedocs.io/en/latest/rst/commands/odgi_similarity.html) for the tool.

Aside from this, the script `select_fasta_files.sh` uses a 

## 2) GenoTools ancestry inference


## 3) PCLAI ancestry assignment
