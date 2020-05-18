#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=8,vmem=64gb,walltime=36:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N mapXXX_cYYY
#PBS -j oe 

#####################################################
#####################################################

ASSEMBLY=fmlrc_k19_kct5_mo30_l200
ROUND=1

SAMPLE=XXXpool_chunkYYY

BBDIR=/N/dc2/scratch/chrichan/temp/bbmap

cd /N/dc2/scratch/chrichan/trachelipus_assembly
cd all_dbg2olc
cd pilon
cd ${ASSEMBLY}_r${ROUND}

READS1=/N/dc2/scratch/chrichan/trachelipus_assembly/unzipped_filtered_data/${SAMPLE}_1.fastq
READS2=/N/dc2/scratch/chrichan/trachelipus_assembly/unzipped_filtered_data/${SAMPLE}_2.fastq

module load samtools/1.9

${BBDIR}/bbmap.sh threads=8 \
                  k=13 \
                  maxindel=10 \
                  pairlen=1500 \
                  minid=0.8 \
                  minhits=2 \
                  bandwidthratio=0.10 \
                  excludefraction=0.15 \
                  in=${READS1} \
                  in2=${READS2} \
                  out=stdout.sam | \
                  sambamba view -F "proper_pair" -S -f bam -o ${SAMPLE}_unsorted_bbmap.bam /dev/stdin

sambamba sort -p -t 8 -m 55G -o ${SAMPLE}_bbmap.bam ${SAMPLE}_unsorted_bbmap.bam
