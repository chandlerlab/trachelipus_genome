#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=8,vmem=64gb,walltime=72:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N train_snap
#PBS -j oe 

#####################################################
#####################################################


cd /N/dc2/scratch/chrichan/trachelipus_assembly/

mkdir -p maker_r2

cd maker_r2

module load maker/2.31.9

############ Train SNAP

mkdir snap2
cd snap2

maker2zff -x 0.25 -l 50 -d ../trachelipus_v1_unmasked.maker.output/trachelipus_v1_unmasked_master_datastore_index.log

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

