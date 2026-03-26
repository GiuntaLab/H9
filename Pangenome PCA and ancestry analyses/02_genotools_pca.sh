#!/bin/bash

source /miniconda3/bin/activate GenoTools
    genotools   --pfile four_samples_no-mis_snps_clean \
    --out four_samples_no-mis_snps_clean \
    --full_output --ancestry \ 
    --ref_panel .genotools/ref/ref_panel/ref_panel_gp2_prune_rm_underperform_pos_update \
    --ref_labels .genotools/ref/ref_panel/ref_panel_ancestry_updated.txt
    --all_sample --all_variant --pca
conda deactivate
