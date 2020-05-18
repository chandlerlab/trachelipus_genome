#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=8,vmem=64gb,walltime=2:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N init_mapping
#PBS -j oe 

#####################################################
#####################################################

ASSEMBLY=fmlrc_k17_kct5_mo30_l100
ROUND=2

UNCORRECTED=/N/dc2/scratch/chrichan/trachelipus_assembly/all_dbg2olc/pilon/${ASSEMBLY}_r1/corrected.fasta

BBDIR=/N/dc2/scratch/chrichan/temp/bbmap

#####################################################

cd /N/dc2/scratch/chrichan/trachelipus_assembly
cd all_dbg2olc
cd pilon

mkdir -p ${ASSEMBLY}_r${ROUND}
cd ${ASSEMBLY}_r${ROUND}

cp ${UNCORRECTED} ./uncorrected.fasta

${BBDIR}/bbmap.sh ref=uncorrected.fasta \
                  threads=8 \
                  k=13 

module load samtools/1.9

samtools faidx uncorrected.fasta

cd /N/dc2/scratch/chrichan/trachelipus_assembly/all_dbg2olc/scripts_pilon
cd ${ASSEMBLY}_r${ROUND}
for S in M
do
    for N in 1 2 3 4 5 6 7 8 9 10
    do
        sed "s/YYY/${N}/g" map_XXX_template_bbmap.sh | sed "s/XXX/${S}/g" > map_${S}_${N}.sh
    done
done

for N in 1 2 3 4 5 6 7 8 9 10
do
    for S in M
    do
        qsub map_${S}_${N}.sh
    done
done

cd /N/dc2/scratch/chrichan/trachelipus_assembly
cd all_dbg2olc
cd pilon
cd ${ASSEMBLY}_r${ROUND}
seqkit split -2 -j 2 -p 35 uncorrected.fasta 


