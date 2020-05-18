#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=8,vmem=64gb,walltime=36:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N init_mapping
#PBS -j oe 

#####################################################
#####################################################

ASSEMBLY=fmlrc_k19_kct5_mo30_l200
ROUND=1

UNCORRECTED=/N/dc2/scratch/chrichan/trachelipus_assembly/all_dbg2olc/${ASSEMBLY}/backbone_raw.fasta

#####################################################

cd /N/dc2/scratch/chrichan/trachelipus_assembly
cd all_dbg2olc
cd pilon

mkdir -p ${ASSEMBLY}_r${ROUND}
cd ${ASSEMBLY}_r${ROUND}

cp ${UNCORRECTED} ./uncorrected.fasta

bwa-mem2 index uncorrected.fasta

module load samtools/1.9

samtools faidx uncorrected.fasta

cd /N/dc2/scratch/chrichan/trachelipus_assembly/all_dbg2olc/scripts_pilon
cd ${ASSEMBLY}_r${ROUND}
for S in M
do
    for N in 1 2 3 4 5 6 7 8 9 10
    do
        sed "s/YYY/${N}/g" map_XXX_template_bwa.sh | sed "s/XXX/${S}/g" > map_${S}_${N}_bwa.sh
    done
done

for N in 1 2 3 4 5 6 7 8 9 10
do
    for S in M
    do
        qsub map_${S}_${N}_bwa.sh
    done
done

cd /N/dc2/scratch/chrichan/trachelipus_assembly
cd all_dbg2olc
cd pilon
cd ${ASSEMBLY}_r${ROUND}
seqkit split -2 -j 2 -p 35 uncorrected.fasta 


