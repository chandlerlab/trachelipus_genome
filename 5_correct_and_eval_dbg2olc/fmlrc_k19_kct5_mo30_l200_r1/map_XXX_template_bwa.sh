#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=8,vmem=64gb,walltime=72:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N mapXXX_cYYY
#PBS -j oe 

#####################################################
#####################################################

ASSEMBLY=fmlrc_k19_kct5_mo30_l200
ROUND=1

SAMPLE=XXXpool_chunkYYY

cd /N/dc2/scratch/chrichan/trachelipus_assembly
cd all_dbg2olc
cd pilon
cd ${ASSEMBLY}_r${ROUND}

REF=uncorrected.fasta

READS1=/N/dc2/scratch/chrichan/trachelipus_assembly/unzipped_filtered_data/${SAMPLE}_1.fastq
READS2=/N/dc2/scratch/chrichan/trachelipus_assembly/unzipped_filtered_data/${SAMPLE}_2.fastq

#module load samtools/1.9

bwa-mem2 mem -A 1 \
        -B 1 \
        -O 1 \
        -E 1 \
        -k 11 \
        -W 20 \
        -D 0.5 \
        -L 99999 \
        -t 8 \
        ${REF} \
        ${READS1} ${READS2} | samclip -ref ${REF} | \
        sambamba view -F "proper_pair" -S -f bam -o ${SAMPLE}_unsorted_bwa.bam /dev/stdin

sambamba sort -p -t 8 -m 25G -o ${SAMPLE}_bwa.bam ${SAMPLE}_unsorted_bwa.bam
