#!/bin/bash

###This script was run as an array job

source /miniconda3/bin/activate pgg
	pggb -i $d/pangenome/samples_all.fna.gz -o $d/pangenome -t 256 -p 50 -s 1000 -n 334 -k 311 -O 0.03 -T 128 -G 13117,13219 -S -m -v -V 'CHM13:#'
conda deactivate
