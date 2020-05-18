#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=8,vmem=128gb,walltime=48:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N eval_transcripts
#PBS -j oe 

#####################################################
#####################################################

cd /N/dc2/scratch/chrichan/trachelipus_assembly
cd genome_eval_with_transcripts

makeblastdb -in trachelipus_v1_unmasked.fasta -dbtype nucl

#blast all transcripts against the assembly
blastn -num_threads 8 -task blastn -evalue 0.01 -query transcripts_arthropod.fasta -db trachelipus_v1_unmasked.fasta -outfmt '6 qseqid sseqid evalue bitscore length pident qlen qstart qend qcovs' > transcript_blast.txt

#after this, run R scripts to summarize results

