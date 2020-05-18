#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=24,vmem=500gb,walltime=144:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N sparse_k61
#PBS -j oe 

#####################################################
#####################################################

#  Variables to store information and settings about the current project

K=61
JOBNAME=sparse_Mpool_k${K}

READSPATH=/N/dc2/scratch/chrichan/trachelipus_assembly/unzipped_filtered_data

#####################################################
#####################################################

cd /N/dc2/scratch/chrichan/trachelipus_assembly
mkdir -p ${JOBNAME}
cd ${JOBNAME}

# Assemble
SparseAssembler g 10 k ${K} LD 0 GS 10000000000 \
 f ${READSPATH}/Mpool_1u.fastq \
 f ${READSPATH}/Mpool_2u.fastq \
 i1 ${READSPATH}/Mpool_1.fastq \
 i2 ${READSPATH}/Mpool_2.fastq
