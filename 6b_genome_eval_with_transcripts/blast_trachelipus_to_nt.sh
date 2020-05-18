#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=8:dc2,vmem=128gb,walltime=16:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N blast_trachelipus
#PBS -j oe 



#####################################################
#####################################################

cd /N/dc2/scratch/chrichan/trachelipus_assembly
mkdir -p genome_eval_with_transcripts
cd genome_eval_with_transcripts

#cp ../all_dbg2olc/filtering_fmlrc_k17_kct5_mo30_l100/trachelipus_v0.1.fasta ./trachelipus_v1_unmasked.fasta
#cp ../evigenes/okayset/combined.okay.fasta ./transcripts_prefilter.fasta


blastn \
 -num_threads 8 \
 -query transcripts_prefilter.fasta \
 -db /N/dc2/scratch/chrichan/nt/nt \
 -outfmt '6 qseqid staxids bitscore std' \
 -max_target_seqs 10 \
 -max_hsps 1 \
 -evalue 1e-25 > blastn_results.txt
