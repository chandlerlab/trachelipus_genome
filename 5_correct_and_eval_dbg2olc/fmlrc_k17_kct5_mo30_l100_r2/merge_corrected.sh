#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=1,vmem=8gb,walltime=2:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N mergeCorrected
#PBS -j oe 

#####################################################
#####################################################

#Put the corrected chunks back together into a single fasta file

ASSEMBLY=fmlrc_k17_kct5_mo30_l100
ROUND=2

#####################################################

cd /N/dc2/scratch/chrichan/trachelipus_assembly
cd all_dbg2olc
cd pilon
cd ${ASSEMBLY}_r${ROUND}

touch corrected.fasta
rm corrected.fasta
for N in 001 002 003 004 005 006 007 008 009 010 011 012 013 014 015 016 017 018 019 020 021 022 023 024 025 026 027 028 029 030 031 032 033 034 035
do
    cat slice_${N}/corrected_${N}.fasta >> corrected.fasta
done


