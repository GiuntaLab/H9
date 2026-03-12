#!/bin/bash

###This script was run as an array job, it also### 
###assumes a DB .meryl has been already created###

HAP= "$(echo ${d} | cut -f 7 -d '/' | sed 's/[a-z,A-Z,0-9]\+_//' | sed 's/[A-Z,0-9]\+_//')" #this based on folder structure and naming will produce either "ref" or "hap"

source /miniconda3/24.4.0/bin/activate merqury
if [ "$HAP" == "ref" ]; then
	cd $d/merqury; merqury.sh ${ID}.meryl ../*.fna.gz merqury_${ID}
else
	cd $d/merqury; merqury.sh ${ID}.meryl ../hap1/*.fasta.gz ../hap2/*.fasta.gz merqury_${ID}
fi
conda deactivate
