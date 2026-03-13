#!/bin/bash

###This script was run as an array job,###
###which requires PAF alignments of all###
###individuals part of the analysis ag-###
###ainst a reference — CHM13 was chosen###


HAP=( "hap0" "hap1" "hap2")

SEX="$(echo ${d} | sed 's#/<path_to_your_workdir>/[A-Z,0-9,a-z]\+_##')"

CHR_13=("chr1" "chr2" "chr3" "chr4" "chr5" "chr6" "chr7" "chr8" "chr9" "chr10" "chr11" "chr12" "chr13" "chr14" "chr15" "chr16" "chr17" "chr18" "chr19" "chr20" "chr21" "chr22" "chrX" "chrY" "chrM" )
CHR_38=("chr1" "chr2" "chr3" "chr4" "chr5" "chr6" "chr7" "chr8" "chr9" "chr10" "chr11" "chr12" "chr13" "chr14" "chr15" "chr16" "chr17" "chr18" "chr19" "chr20" "chr21" "chr22" "chrX" "chrY" "chrUn" "chrM" "chrEBV" )
CHR_P=("chr1" "chr2" "chr3" "chr4" "chr5" "chr6" "chr7" "chr8" "chr9" "chr10" "chr11" "chr12" "chr13" "chr14" "chr15" "chr16" "chr17" "chr18" "chr19" "chr20" "chr21" "chr22" "chrY" "chrUn" )
CHR_M=("chr1" "chr2" "chr3" "chr4" "chr5" "chr6" "chr7" "chr8" "chr9" "chr10" "chr11" "chr12" "chr13" "chr14" "chr15" "chr16" "chr17" "chr18" "chr19" "chr20" "chr21" "chr22" "chrX" "chrUn" "chrM" )

SEQKIT="./tools/seqkit"
BGZIP="./tools/bgzip"


cd ~


#PREPARES THE INPUT
if [ -e $d/select.done ]
        then

                echo "regions selecion done!"

        else
          for h in "${HAP[@]}"; do
      if [ "$h" == "hap0" ]
        then
        if [ "$SEX" == "ref" ]
          then
          for c in "${CHR_38[@]}"; do
                                    ###generate chromosome FASTA
              ${SEQKIT} grep -f $d/${ID}_${c}_${h}_contigs_one.list $d/${ID}_${h}_hprc_r2.fa.gz -j 10 | ${BGZIP} -@10 > $d/${ID}_${c}.fna.gz
          done
        elif [ "$SEX" == "t2t" ]; then
          for c in "${CHR_13[@]}"; do
                                    ###generate chromosome FASTA
              ${SEQKIT} grep -f $d/${ID}_${c}_${h}_contigs_one.list $d/${ID}_${h}_hprc_r2.fa.gz -j 10 | ${BGZIP} -@10 > $d/${ID}_${c}.fna.gz
          done
        elif [ "$SEX" == "m" ] || [ "$SEX" == "f" ]; then
          
          echo "nothing to be done, running in diploid mode"
        
        fi
      else
        if [ "$SEX" == "m" ]
                            then
                            if [ "$h" == "hap1" ]
                                    then
                                    for c in "${CHR_P[@]}"; do
                                            ###generate chromosome FASTA
                                              ${SEQKIT} grep -f $d/${ID}_${c}_${h}_contigs_one.list $d/${ID}_${h}_hprc_r2.fa.gz -j 10 | ${BGZIP} -@10 > $d/${ID}_${c}_${h}.fna.gz
                                          done
                                  else
                                          for c in "${CHR_M[@]}"; do
                                            ###generate chromosome FASTA
                                                  ${SEQKIT} grep -f $d/${ID}_${c}_${h}_contigs_one.list $d/${ID}_${h}_hprc_r2.fa.gz -j 10 | ${BGZIP} -@10 > $d/${ID}_${c}_${h}.fna.gz
            done
                                  fi
        elif [ "$SEX" == "f" ]; then
                            for c in "${CHR_M[@]}"; do
                                    ###generate chromosome FASTA
              ${SEQKIT} grep -f $d/${ID}_${c}_${h}_contigs_one.list $d/${ID}_${h}_hprc_r2.fa.gz -j 10 | ${BGZIP} -@10 > $d/${ID}_${c}_${h}.fna.gz
          done
        elif [ "$SEX" == "ref" ] || [ "$SEX" == "t2t" ]; then

          echo "nothing to be done, running in haploid mode"
        fi
      fi
          done
  touch $d/select.done
fi
