#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=8:dc2,vmem=64gb,walltime=24:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N eval
#PBS -j oe 

#####################################################
#####################################################

cd /N/dc2/scratch/chrichan/trachelipus_assembly/

mkdir -p sparseassembler_eval

cd sparseassembler_eval

module load quast

quast.py --est-ref-size 5000000000 \
         --contig-thresholds 0,100,200,300,500,1000,5000,10000,25000,50000 \
         -t 4 \
         --fast \
         -l k51,k61 \
         -o . ../sparse_Mpool_k51/Contigs.txt \
              ../sparse_Mpool_k61/Contigs.txt
