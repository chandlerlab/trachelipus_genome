#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=2,vmem=32gb,walltime=24:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N prep_finalcov
#PBS -j oe 

#####################################################
#####################################################

cd /N/dc2/scratch/chrichan/trachelipus_assembly/
cd final_cov

cat /N/dc2/scratch/chrichan/trachelipus_assembly/maker_final/data/trachelipus_v1_unmasked.fasta \
    /N/dc2/scratch/chrichan/trachelipus_assembly/m_agh_kmers/assembly_1/contigs.fasta \
    > trachelipus_v1_unmasked_plus_malespecific.fasta

bwa index trachelipus_v1_unmasked_plus_malespecific.fasta

module load samtools/1.9

samtools faidx trachelipus_v1_unmasked_plus_malespecific.fasta


#submit the scripts to do the mapping
cd /N/dc2/scratch/chrichan/trachelipus_assembly/final_cov/scripts
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
