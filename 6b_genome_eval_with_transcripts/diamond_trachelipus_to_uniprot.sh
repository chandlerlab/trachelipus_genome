#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=4:dc2,vmem=16gb,walltime=16:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N diamond_trachelipus
#PBS -j oe 



#####################################################
#####################################################

cd /N/dc2/scratch/chrichan/trachelipus_assembly
cd genome_eval_with_transcripts

module load diamond/0.9.13

diamond blastx \
 --threads 4 \
 --query transcripts_prefilter.fasta \
 --db /N/dc2/scratch/chrichan/diamond_uniprot/uniprot_ref_proteomes.diamond.dmnd \
 --outfmt 6 \
 --sensitive \
 --max-target-seqs 1 \
 --evalue 1e-25 > diamond_results.txt

