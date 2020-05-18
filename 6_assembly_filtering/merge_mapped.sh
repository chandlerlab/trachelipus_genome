#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=2,vmem=16gb,walltime=24:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N mergeMpool
#PBS -j oe 

#####################################################
#####################################################

ASSEMBLY=fmlrc_k17_kct5_mo30_l100

#####################################################

cd /N/dc2/scratch/chrichan/trachelipus_assembly
cd all_dbg2olc
mkdir -p filtering_${ASSEMBLY}
cd filtering_${ASSEMBLY}

sambamba merge -t 2 -p Mpool_bwa.bam \
                       Mpool_chunk1_bwa.bam \
                       Mpool_chunk2_bwa.bam \
                       Mpool_chunk3_bwa.bam \
                       Mpool_chunk4_bwa.bam \
                       Mpool_chunk5_bwa.bam \
                       Mpool_chunk6_bwa.bam \
                       Mpool_chunk7_bwa.bam \
                       Mpool_chunk8_bwa.bam \
                       Mpool_chunk9_bwa.bam \
                       Mpool_chunk10_bwa.bam

sambamba index -t 2 -p Mpool_bwa.bam

sambamba merge -t 2 -p Fpool_bwa.bam \
                       Fpool_chunk1_bwa.bam \
                       Fpool_chunk2_bwa.bam \
                       Fpool_chunk3_bwa.bam \
                       Fpool_chunk4_bwa.bam \
                       Fpool_chunk5_bwa.bam \
                       Fpool_chunk6_bwa.bam \
                       Fpool_chunk7_bwa.bam \
                       Fpool_chunk8_bwa.bam \
                       Fpool_chunk9_bwa.bam \
                       Fpool_chunk10_bwa.bam

sambamba index -t 2 -p Fpool_bwa.bam
