#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=8,vmem=128gb,walltime=48:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N translig_M
#PBS -j oe 

#####################################################
#####################################################

TRANSLIGDIR=/N/dc2/scratch/chrichan/temp/TransLiG_1.3

SAMPLE=Tr_M

cd /N/dc2/scratch/chrichan/trachelipus_assembly/

mkdir -p translig_${SAMPLE}
cd translig_${SAMPLE}

READS1=../transcript_data/${SAMPLE}_1.fastq
READS2=../transcript_data/${SAMPLE}_2.fastq

module load boost/gnu/1.64.0

${TRANSLIGDIR}/TransLiG \
  -s fq -p pair \
  -l ${READS1} \
  -r ${READS2}
