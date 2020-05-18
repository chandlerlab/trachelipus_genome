#!/bin/bash
#PBS -k o 
#PBS -l nodes=8:ppn=8:dc2,vmem=250gb,walltime=96:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N maker_r3
#PBS -j oe 

#####################################################
#####################################################


cd /N/dc2/scratch/chrichan/trachelipus_assembly/

mkdir -p maker_r3

cd maker_r3

module load maker/2.31.9

export AUGUSTUS_CONFIG_PATH="/N/dc2/scratch/chrichan/augustus_config/"

############ Final round with trained SNAP and Augustus models

maker -CTL

cp maker_opts.ctl backup_maker_opts.ctl

LASTGFF=../maker_r1/trachelipus_v1_unmasked.all.gff

# transcript alignments
awk '{ if ($2 == "est2genome") print $0 }' ${LASTGFF} > trachelipus_v1.all.maker.est2genome.gff
# protein alignments
awk '{ if ($2 == "protein2genome") print $0 }' ${LASTGFF} > trachelipus_v1.all.maker.protein2genome.gff
# repeat alignments
awk '{ if ($2 ~ "repeat") print $0 }' ${LASTGFF} > trachelipus_v1.all.maker.repeats.gff

sed 's/^genome= #/genome=\/N\/dc2\/scratch\/chrichan\/trachelipus_assembly\/maker_final\/data\/trachelipus_v1_unmasked.fasta #/' maker_opts.ctl > TEMP1

sed 's/^est_gff= #/est_gff=trachelipus_v1.all.maker.est2genome.gff #/' TEMP1 > TEMP2
sed 's/^rm_gff= #/rm_gff=trachelipus_v1.all.maker.repeats.gff #/' TEMP2 > TEMP1
sed 's/^protein_gff=  #/protein_gff=trachelipus_v1.all.maker.protein2genome.gff #/' TEMP1 > TEMP2

sed 's/^snaphmm= #/snaphmm=\/N\/dc2\/scratch\/chrichan\/trachelipus_assembly\/maker_r2\/snap2\/trachelipus_v1.zff.length50_aed0.25.hmm #/' TEMP2 > TEMP1
sed 's/^augustus_species= #/augustus_species=Trachelipus_rathkei #/' TEMP1 > maker_opts.ctl


rm TEMP*

mpiexec -n 64 -f ${PBS_NODEFILE} maker

gff3_merge -s -d trachelipus_v1_unmasked.maker.output/trachelipus_v1_unmasked_master_datastore_index.log > trachelipus_v1.all.maker.gff
fasta_merge -d trachelipus_v1_unmasked.maker.output/trachelipus_v1_unmasked_master_datastore_index.log
gff3_merge -n -s -d trachelipus_v1_unmasked.maker.output/trachelipus_v1_unmasked_master_datastore_index.log > trachelipus_v1.all.maker.noseq.gff

