#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=12,vmem=250gb,walltime=5:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N fm_pbM_001
#PBS -j oe 


#####################################################
#####################################################

CHUNK=001
LONG_SAMPLE=pb_M
SHORT_SAMPLE=Mpool

cd /N/dc2/scratch/chrichan/trachelipus_assembly/
cd fmlrc


LONG_READS=/N/dc2/scratch/chrichan/trachelipus_assembly/lordec_correction/${LONG_SAMPLE}_split/${LONG_SAMPLE}.part_${CHUNK}.fasta

mkdir -p temp_${LONG_SAMPLE}_${CHUNK}

cd temp_${LONG_SAMPLE}_${CHUNK}

fmlrc -m 3 -p 24 ../${SHORT_SAMPLE}.npy ${LONG_READS} ${LONG_SAMPLE}.${CHUNK}.corrected.fasta
