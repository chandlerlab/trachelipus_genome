#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=24,vmem=500gb,walltime=240:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N train_snap
#PBS -j oe 

#####################################################
#####################################################


cd /N/dc2/scratch/chrichan/trachelipus_assembly/

cd maker_r2

module load maker/2.31.9

############ Train BUSCO

cd busco_augustus

cp -r run_busco_eval_long_arth/augustus_output/retraining_parameters .
cd retraining_parameters

for X in exon_probs.pbl igenic_probs.pbl intron_probs.pbl metapars.cfg metapars.cgp.cfg metapars.utr.cfg parameters.cfg weightmatrix.txt parameters.cfg.orig1
do
  mv BUSCO_busco_eval_long_arth_??????????_${X} Trachelipus_rathkei_${X}
done

sed -i 's/BUSCO_busco_eval_long_arth_[0-9]\{10\}/Trachelipus_rathkei2/g' Trachelipus_rathkei2_parameters.cfg
sed -i 's/BUSCO_busco_eval_long_arth_[0-9]\{10\}/Trachelipus_rathkei2/g' Trachelipus_rathkei2_parameters.cfg.orig1

export AUGUSTUS_CONFIG_PATH="/N/dc2/scratch/chrichan/augustus_config/"
mkdir -p ${AUGUSTUS_CONFIG_PATH}/species/Trachelipus_rathkei2
cp Trachelipus_rathkei2*  ${AUGUSTUS_CONFIG_PATH}/species/Trachelipus_rathkei2/

