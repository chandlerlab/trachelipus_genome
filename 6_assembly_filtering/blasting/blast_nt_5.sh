#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=8,vmem=128gb,walltime=96:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N blast_nt_5
#PBS -j oe 

#####################################################
#####################################################

N=005

ASSEMBLY=fmlrc_k17_kct5_mo30_l100

#####################################################

cd /N/dc2/scratch/chrichan/trachelipus_assembly
cd all_dbg2olc
mkdir -p filtering_${ASSEMBLY}
cd filtering_${ASSEMBLY}

blastn \
 -num_threads 8 \
 -query trachelipus_v0.fasta.split/trachelipus_v0.part_${N}.fasta \
 -db /N/dc2/scratch/chrichan/nt/nt \
 -outfmt '6 qseqid staxids bitscore std' \
 -max_target_seqs 10 \
 -max_hsps 1 \
 -evalue 1e-25 > blastn_results_${N}.txt
