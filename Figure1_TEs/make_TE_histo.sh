#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=1:dc2,vmem=8gb,walltime=5:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N TE_histo
#PBS -j oe 

#####################################################
#####################################################

cd /N/dc2/scratch/chrichan/trachelipus_assembly/repeatmasking
mkdir -p TE_histo
cd TE_histo

#Subsample the raw data
echo 'score,pdiv,pdel,pins,qseq,qstart,qend,qleft,strand,repeat,family,sstart,send,sleft,id' > te_data.csv

for N in 001 002 003 004 005 006
do
  cat ../trachelipus_v1_unmasked.fasta.split/trachelipus_v1_unmasked.part_${N}.fasta.out | awk '{if (NR > 3) {if (rand() < 0.01) {print $1 "," $2 "," $3 "," $4 "," $5 "," $6 "," $7 "," $8 "," $9 "," $10 "," $11 "," $12 "," $13 "," $14 "," $15}}}' >> te_data.csv
done
