#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=2,vmem=16gb,walltime=12:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N mergeMpool
#PBS -j oe 

#####################################################
#####################################################

SAMPLE=Mpool

cd /N/dc2/scratch/chrichan/trachelipus_assembly/final_cov

#sambamba sort -p -t 16 -m 120G -o ${SAMPLE}_bwa.bam ${SAMPLE}_unsorted_bwa.bam

sambamba merge -t 2 -p ${SAMPLE}_bwa.bam \
                       ${SAMPLE}_chunk1_bwa.bam \
                       ${SAMPLE}_chunk2_bwa.bam \
                       ${SAMPLE}_chunk3_bwa.bam \
                       ${SAMPLE}_chunk4_bwa.bam \
                       ${SAMPLE}_chunk5_bwa.bam \
                       ${SAMPLE}_chunk6_bwa.bam \
                       ${SAMPLE}_chunk7_bwa.bam \
                       ${SAMPLE}_chunk8_bwa.bam \
                       ${SAMPLE}_chunk9_bwa.bam \
                       ${SAMPLE}_chunk10_bwa.bam

sambamba index -t 2 -p ${SAMPLE}_bwa.bam

