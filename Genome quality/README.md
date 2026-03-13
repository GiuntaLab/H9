# <p align="center">Requirements to run each one of the QV analyses<p>
<p align="center">Below, the specific to the varions QV metrics run for this projects not only associated to the H9 genomes but also to others T2T assemblies we compared with as well as the GRCh38 and CHM13 references when applicable.</p>

## 1) merqury.sh
Provided the folders' structure has been opportunely arranged for an array run, before using the `merqury.sh` a [meryl](https://github.com/marbl/meryl) _k_-mers database for the sequencing dataset of each samples need to be generated as follow:
```sh
meryl count k=21 threads=<n_of_threads> output ${ID}.meryl ${ID}.fastq.gz
```
where `${ID}.meryl` has to be placed in the **merqury/** directory where the execution will commence. In all cases, the sequencing datasets included only PacBio HiFi reads from REVIO instruments.

## 2) contig_nx.sh

## 3) compleasm.sh
[Compleasm](https://github.com/huangnengCSU/compleasm) has been run with the specifics as reported in the main H9 page with local gene datasets since over limited bandwidth and/or cluster nodes witout access to the network this option is the more efficient. If necessary, all gene data collections can be downloaded [here](https://busco-data.ezlab.org/v5/data/lineages/).

## 4) flagger.sh
