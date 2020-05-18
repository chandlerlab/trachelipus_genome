#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=16,vmem=250gb,walltime=72:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N ropebwtF
#PBS -j oe 


#####################################################
#####################################################

SAMPLE=Fpool

cd /N/dc2/scratch/chrichan/trachelipus_assembly/
mkdir -p fmlrc
cd fmlrc

ILLUMINA_DIR=/N/dc2/scratch/chrichan/trachelipus_assembly/unzipped_filtered_data
ILLUMINA_READS=${ILLUMINA_DIR}/${SAMPLE}_interleaved.fastq

awk 'NR % 4 == 2' ${ILLUMINA_READS} | sort --parallel=8 | tr NT TN | ropebwt2 -LR | tr NT TN | fmlrc-convert ${SAMPLE}.npy

