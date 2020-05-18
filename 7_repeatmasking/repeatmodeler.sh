#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=24,vmem=500gb,walltime=144:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N repeatmodel_sub
#PBS -j oe 

#####################################################
#####################################################


cd /N/dc2/scratch/chrichan/trachelipus_assembly

mkdir -p repeatmasking
cd repeatmasking

seqtk rename /N/dc2/scratch/chrichan/trachelipus_assembly/all_dbg2olc/filtering_fmlrc_k17_kct5_mo30_l100/trachelipus_v0.1.fasta contig > trachelipus_v1_unmasked.fasta

seqtk sample trachelipus_v1_unmasked.fasta 0.4 > trachelipus_subset.fasta

module load repeatmodeler/1.0.10

BuildDatabase -name trachelipus_subset.DB trachelipus_subset.fasta

RepeatModeler -database trachelipus_subset.DB -pa 23

