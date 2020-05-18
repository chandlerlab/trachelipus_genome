#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=4,vmem=64gb,walltime=24:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N get_busco_cov
#PBS -j oe 

#####################################################
#####################################################

cd /N/dc2/scratch/chrichan/trachelipus_assembly/final_cov

mkdir -p busco_cov 
cd busco_cov

cp /N/dc2/scratch/chrichan/trachelipus_assembly/repeatmasking/run_busco_eval_long_arth/augustus_output/gffs.tar.gz .
tar xvfz gffs.tar.gz
cp /N/dc2/scratch/chrichan/trachelipus_assembly/repeatmasking/run_busco_eval_long_arth/full_table_busco_eval_long_arth.tsv .
grep 'Complete' full_table_busco_eval_long_arth.tsv | cut -f 1 > complete_singlecopy_buscos.txt

touch busco_cov_Fpool.txt
touch busco_cov_Mpool.txt
rm busco_cov_Fpool.txt
rm busco_cov_Mpool.txt
while read X
do
  grep 'exon' gffs/${X}.gff | awk '{print $1 "\t" $4 "\t" $5}' > cur_regions.txt 
  N=`wc -l cur_regions.txt | awk '{print $1}'`
  #some of the complete single-copy buscos seem to be missing GFFs, for some reason
  if [ $N -lt 1 ]
  then
    echo 'Missing ' $X
  else
    echo 'Doing ' $X
    for SAMPLE in Fpool Mpool
    do
      sambamba depth region -L cur_regions.txt -t 4 \
        -o cur_depth.txt \
        -F '(mapping_quality > 0) and (not duplicate) and (not failed_quality_control) and (not supplementary) and (proper_pair)' \
        ../${SAMPLE}_bwa.bam 
      grep -v '^#' cur_depth.txt | awk -v busco=${X} 'BEGIN {len=0; cov=0} {curlen = $3 - $2 + 1; len += curlen; cov += (curlen * $5)} END {print busco "\t" (cov/len)}' >> busco_cov_${SAMPLE}.txt
    done
  fi
done < complete_singlecopy_buscos.txt


