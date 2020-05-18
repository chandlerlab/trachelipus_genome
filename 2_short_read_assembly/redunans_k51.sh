#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=8:dc2,vmem=32gb,walltime=16:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N redundans51
#PBS -j oe 

#####################################################
#####################################################

K=51

REDUNDANSPATH=/N/dc2/scratch/chrichan/temp/redundans

MINLEN=100

READS1=/N/dc2/scratch/chrichan/trachelipus_assembly/unzipped_filtered_data/Mpool_1.fastq
READS2=/N/dc2/scratch/chrichan/trachelipus_assembly/unzipped_filtered_data/Mpool_2.fastq
OUTDIR=/N/dc2/scratch/chrichan/trachelipus_assembly/redundans_k${K}

module load gcc/6.3.0
#module load python/2.7.13

cd /N/dc2/scratch/chrichan/trachelipus_assembly/

cd sparse_Mpool_k${K}

rm -rf ${OUTDIR}

seqtk seq -L ${MINLEN} Contigs.txt > contigs_min${MINLEN}.fasta

${REDUNDANSPATH}/redundans.py \
  --threads 8 \
  --identity 0.95 \
  --minLength ${MINLEN} \
  --fastq ${READS1} ${READS2} \
  --fasta contigs_min${MINLEN}.fasta \
  --noscaffolding \
  --nogapclosing \
  -q 40 \
  -o ${OUTDIR}
