#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=24,vmem=500gb,walltime=96:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N busco_arth
#PBS -j oe 

#####################################################
#####################################################

LINEAGES=/N/dc2/projects/ncgas/genomes/busco-lineage

#####################################################

cd /N/dc2/scratch/chrichan/trachelipus_assembly/repeatmasking

module load busco/3.0.2
module unload boost
module load boost/gnu/1.64.0

export AUGUSTUS_CONFIG_PATH="/N/dc2/scratch/chrichan/augustus_config/"

run_BUSCO.py -i trachelipus_v1_unmasked.fasta \
             -o busco_eval_long_arth \
             -l ${LINEAGES}/arthropoda_odb9 \
             -m genome \
             -c 24 \
             -z \
             --blast_single_core \
             --long
                          
