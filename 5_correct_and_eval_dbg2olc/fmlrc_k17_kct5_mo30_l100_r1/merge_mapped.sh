#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=2,vmem=16gb,walltime=12:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N mergeMpool
#PBS -j oe 

#####################################################
#####################################################

ASSEMBLY=fmlrc_k17_kct5_mo30_l100
ROUND=1

#####################################################

cd /N/dc2/scratch/chrichan/trachelipus_assembly
cd all_dbg2olc
cd pilon
cd ${ASSEMBLY}_r${ROUND}

sambamba merge -t 2 -p Mpool_bbmap.bam \
                       Mpool_chunk1_bbmap.bam \
                       Mpool_chunk2_bbmap.bam \
                       Mpool_chunk3_bbmap.bam \
                       Mpool_chunk4_bbmap.bam \
                       Mpool_chunk5_bbmap.bam \
                       Mpool_chunk6_bbmap.bam \
                       Mpool_chunk7_bbmap.bam \
                       Mpool_chunk8_bbmap.bam \
                       Mpool_chunk9_bbmap.bam \
                       Mpool_chunk10_bbmap.bam

sambamba index -t 2 -p Mpool_bbmap.bam

cd /N/dc2/scratch/chrichan/trachelipus_assembly/all_dbg2olc/scripts_pilon
cd ${ASSEMBLY}_r${ROUND}
for N in 001 002 003 004 005 006 007 008 009 010 011 012 013 014 015 016 017 018 019 020 021 022 023 024 025 026 027 028 029 030 031 032 033 034 035
do
    sed "s/XXX/${N}/g" pilon_template.sh > do_pilon_${N}.sh
    qsub do_pilon_${N}.sh
done

