#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=24,vmem=500gb,walltime=96:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N busco
#PBS -j oe 

#####################################################
#####################################################

ASSEMBLY=fmlrc_k17_kct5_mo30_l100
ROUND=1

LINEAGES=/N/dc2/projects/ncgas/genomes/busco-lineage

#####################################################

cd /N/dc2/scratch/chrichan/trachelipus_assembly
cd all_dbg2olc
mkdir -p busco
cd busco

mkdir -p ${ASSEMBLY}_r${ROUND}
cd ${ASSEMBLY}_r${ROUND}


REF=/N/dc2/scratch/chrichan/trachelipus_assembly/all_dbg2olc/pilon/${ASSEMBLY}_r${ROUND}/corrected.fasta

cp ${REF} ./ref.fasta

module load busco/3.0.2
module unload boost
module load boost/gnu/1.64.0

export AUGUSTUS_CONFIG_PATH="/N/dc2/scratch/chrichan/augustus_config/"

run_BUSCO.py -i ref.fasta \
             -o busco_eval \
             -l ${LINEAGES}/arthropoda_odb9 \
             -m genome \
             -c 24 \
             -z \
             --blast_single_core
             
#Note: add -r to run_BUSCO.py to restart from last successful step