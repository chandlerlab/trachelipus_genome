#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=12,vmem=256gb,walltime=12:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N init_mapping
#PBS -j oe 

#####################################################
#####################################################

ASSEMBLY=fmlrc_k17_kct5_mo30_l100

UNCORRECTED=/N/dc2/scratch/chrichan/trachelipus_assembly/all_dbg2olc/pilon/${ASSEMBLY}_r3/corrected.fasta

#####################################################

cd /N/dc2/scratch/chrichan/trachelipus_assembly
cd all_dbg2olc
mkdir -p filtering_${ASSEMBLY}
cd filtering_${ASSEMBLY}

cp ${UNCORRECTED} ./trachelipus_v0.fasta

bwa index trachelipus_v0.fasta

module load samtools/1.9

samtools faidx trachelipus_v0.fasta

cd /N/dc2/scratch/chrichan/trachelipus_assembly/all_dbg2olc/scripts_pilon
cd ${ASSEMBLY}_r${ROUND}
for S in M F
do
    for N in 1 2 3 4 5 6 7 8 9 10
    do
        sed "s/YYY/${N}/g" map_XXX_template_bwa.sh | sed "s/XXX/${S}/g" > map_${S}_${N}.sh
    done
done

for N in 1 2 3 4 5 6 7 8 9 10
do
    for S in M F
    do
        qsub map_${S}_${N}.sh
    done
done

cd /N/dc2/scratch/chrichan/trachelipus_assembly
cd all_dbg2olc
mkdir -p filtering_${ASSEMBLY}
cd filtering_${ASSEMBLY}
seqkit split -2 -j 2 -p 6 trachelipus_v0.fasta 


