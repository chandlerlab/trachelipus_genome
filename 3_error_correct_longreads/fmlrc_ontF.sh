#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=12,vmem=250gb,walltime=5:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N lordec_ontF
#PBS -j oe 


#####################################################
#####################################################

LONG_SAMPLE=ont_F
SHORT_SAMPLE=Fpool

cd /N/dc2/scratch/chrichan/trachelipus_assembly/
cd fmlrc


LONG_READS=/N/dc2/scratch/chrichan/trachelipus_assembly/ont_data/ont_F.fasta

mkdir -p temp_${LONG_SAMPLE}

cd temp_${LONG_SAMPLE}

fmlrc -m 3 -p 24 ../${SHORT_SAMPLE}.npy ${LONG_READS} ${LONG_SAMPLE}.corrected.fasta
