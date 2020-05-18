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

mkdir -p maker_r1

cd maker_r1

module load maker/2.31.9

############ Train SNAP

mkdir snap1
cd snap1

maker2zff -x 0.25 -l 50 -d ../trachelipus_v1_unmasked.maker.output/trachelipus_v1_unmasked_master_datastore_index.log


#rename 's/genome/trachelipus_v1.zff.length50_aed0.25/g' *

cp genome.ann trachelipus_v1.zff.length50_aed0.25.ann
cp genome.dna trachelipus_v1.zff.length50_aed0.25.dna

# gather some stats and validate
fathom trachelipus_v1.zff.length50_aed0.25.ann trachelipus_v1.zff.length50_aed0.25.dna -gene-stats > gene-stats.log 2>&1
fathom trachelipus_v1.zff.length50_aed0.25.ann trachelipus_v1.zff.length50_aed0.25.dna -validate > validate.log 2>&1
# collect the training sequences and annotations, plus 1000 surrounding bp for training
fathom trachelipus_v1.zff.length50_aed0.25.ann trachelipus_v1.zff.length50_aed0.25.dna -categorize 1000 > categorize.log 2>&1
fathom uni.ann uni.dna -export 1000 -plus > uni-plus.log 2>&1
# create the training parameters
forge export.ann export.dna > forge.log 2>&1
# assemble the HMM
hmm-assembler.pl trachelipus_v1.zff.length50_aed0.25 . > trachelipus_v1.zff.length50_aed0.25.hmm

cd ..

############ Train BUSCO

mkdir busco1
cd busco1

cp -r ../../repeatmasking/run_busco_eval_long_arth/augustus_output/retraining_parameters .
cd retraining_parameters

for X in exon_probs.pbl igenic_probs.pbl intron_probs.pbl metapars.cfg metapars.cgp.cfg metapars.utr.cfg parameters.cfg weightmatrix.txt parameters.cfg.orig1
do
  mv BUSCO_busco_eval_long_arth_??????????_${X} Trachelipus_rathkei_${X}
done

sed -i 's/BUSCO_busco_eval_long_arth_[0-9]\{10\}/Trachelipus_rathkei/g' Trachelipus_rathkei_parameters.cfg
sed -i 's/BUSCO_busco_eval_long_arth_[0-9]\{10\}/Trachelipus_rathkei/g' Trachelipus_rathkei_parameters.cfg.orig1

export AUGUSTUS_CONFIG_PATH="/N/dc2/scratch/chrichan/augustus_config/"
mkdir -p ${AUGUSTUS_CONFIG_PATH}/species/Trachelipus_rathkei
cp Trachelipus_rathkei*  ${AUGUSTUS_CONFIG_PATH}/species/Trachelipus_rathkei/

