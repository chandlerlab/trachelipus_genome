#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=16,vmem=128gb,walltime=96:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N repeatmask3
#PBS -j oe 

#####################################################
#####################################################

CHUNK=003

cd /N/dc2/scratch/chrichan/trachelipus_assembly
cd repeatmasking
cd trachelipus_v1_unmasked.fasta.split

module load repeatmasker/4.0.7

RepeatMasker -pa 15 -gff -lib ../trachelipus_subset.DB-families.fa trachelipus_v1_unmasked.part_${CHUNK}.fasta
