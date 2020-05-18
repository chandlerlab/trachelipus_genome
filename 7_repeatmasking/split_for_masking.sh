#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=2,vmem=16gb,walltime=8:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N rm_split
#PBS -j oe 

#####################################################
#####################################################


cd /N/dc2/scratch/chrichan/trachelipus_assembly
cd repeatmasking

seqkit split -2 -p 6 trachelipus_v1_unmasked.fasta 

