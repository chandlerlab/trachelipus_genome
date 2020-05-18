#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=4,vmem=16gb,walltime=100:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N diamond_uniprot_4
#PBS -j oe 

#####################################################
#####################################################

N=004

ASSEMBLY=fmlrc_k17_kct5_mo30_l100

#####################################################

cd /N/dc2/scratch/chrichan/trachelipus_assembly
cd all_dbg2olc
mkdir -p filtering_${ASSEMBLY}
cd filtering_${ASSEMBLY}

module load diamond/0.9.13

diamond blastx \
 --threads 4 \
 --query trachelipus_v0.fasta.split/trachelipus_v0.part_${N}.fasta \
 --db /N/dc2/scratch/chrichan/diamond_uniprot/uniprot_ref_proteomes.diamond.dmnd \
 --outfmt 6 \
 --sensitive \
 --max-target-seqs 1 \
 --evalue 1e-25 > diamond_results_${N}.txt

