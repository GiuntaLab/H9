#!/bin/bash

###This script was run as an array job###

HAP="$(echo ${d} | cut -f 7 -d '/' | sed 's/[a-z,A-Z,0-9]\+_//' | sed 's/[A-Z,0-9]\+_//')" #this based on folder structure and naming will produce either "ref", "hap", or "hap"

source /miniconda3/24.4.0/bin/activate compleasm
if [ "$HAP" == "ref" ]; then
	compleasm run -a $d/${ID_ref}.fna.gz -o $d/completeness_${HAP} -l mammalia -L busco_db -t 48
else
	for hap in {1..2}; do compleasm run -a $d/${ID_hap}."${HAP}${hap}".fasta.gz -o $d/"${HAP}${hap}"/completeness_"${HAP}${hap}" -l mammalia -L busco_db -t 48; done
fi
conda deactivate