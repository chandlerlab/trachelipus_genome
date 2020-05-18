#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=24,vmem=500gb,walltime=240:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N train_snap
#PBS -j oe 

#####################################################
#####################################################


cd /N/dc2/scratch/chrichan/trachelipus_assembly/

mkdir -p maker_r1

cd maker_r1

module load maker/2.31.9

export AUGUSTUS_CONFIG_PATH="/N/dc2/scratch/chrichan/augustus_config/"

############ Do round 1 with RNA-seq data

maker -CTL

cp maker_opts.ctl backup_maker_opts.ctl

mkdir data 
cp ../repeatmasking/trachelipus_v1_unmasked.fasta data/
cp ../evigenes/okayset/combined.okay.fasta data/transcripts.fasta
cp ../repeatmasking/trachelipus_subset.DB-families.fa data

sed 's/^genome= #/genome=\/N\/dc2\/scratch\/chrichan\/trachelipus_assembly\/maker_r1\/data\/trachelipus_v1_unmasked.fasta #/' maker_opts.ctl > TEMP1
sed 's/^est= #/est=\/N\/dc2\/scratch\/chrichan\/trachelipus_assembly\/maker_r1\/data\/transcripts.fasta #/' TEMP1 > TEMP2
sed 's/^rmlib= #/rmlib=\/N\/dc2\/scratch\/chrichan\/trachelipus_assembly\/maker_r1\/data\/trachelipus_subset.DB-families.fa #/' TEMP2 > TEMP1
sed 's/^protein=  #/protein=\/N\/dc2\/scratch\/chrichan\/uniprot_swissprot\/uniprot_sprot.fasta #/' TEMP1 > TEMP2
sed 's/^est2genome=0/est2genome=1/' TEMP2 > TEMP1
sed 's/^protein2genome=0/protein2genome=1/' TEMP1 > maker_opts.ctl


rm TEMP*

mpiexec -n 24 maker

gff3_merge -d trachelipus_v1_unmasked.maker.output/trachelipus_v1_unmasked_master_datastore_index.log

