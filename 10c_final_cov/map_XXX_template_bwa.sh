#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=16,vmem=128gb,walltime=36:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N mapXXX_cYYY
#PBS -j oe 

#####################################################
#####################################################

SAMPLE=XXXpool_chunkYYY

cd /N/dc2/scratch/chrichan/trachelipus_assembly/final_cov

READS1=/N/dc2/scratch/chrichan/trachelipus_assembly/unzipped_filtered_data/${SAMPLE}_1.fastq
READS2=/N/dc2/scratch/chrichan/trachelipus_assembly/unzipped_filtered_data/${SAMPLE}_2.fastq

bwa mem -A 1 -B 1 -O 1 -E 1 -k 11 -W 20 -D 0.5 -L 9999 -t 16 trachelipus_v1_unmasked_plus_malespecific.fasta \
             ${READS1} ${READS2} | \
             sambamba view -S -f bam -o ${SAMPLE}_unsorted_bwa.bam /dev/stdin 

sambamba sort -p -t 16 -m 120G -o ${SAMPLE}_bwa.bam ${SAMPLE}_unsorted_bwa.bam
