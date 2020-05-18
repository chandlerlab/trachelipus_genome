#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=4,vmem=16gb,walltime=100:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N combine_blast_uniprot
#PBS -j oe 

#####################################################
#####################################################

BLOBDIR=/N/dc2/scratch/chrichan/temp/blobtools

REF=trachelipus_unmasked

cd /N/dc2/scratch/chrichan/trachelipus_assembly

cd blobplots

cat diamond_results_001.txt diamond_results_002.txt diamond_results_003.txt diamond_results_004.txt diamond_results_005.txt diamond_results_006.txt > diamond_results_all.txt

${BLOBDIR}/blobtools taxify -f diamond_results_all.txt -m /N/dc2/scratch/chrichan/diamond/uniprot_ref_proteomes.taxids -s 0 -t 2

