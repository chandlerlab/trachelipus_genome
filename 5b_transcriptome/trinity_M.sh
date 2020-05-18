#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=8,vmem=128gb,walltime=48:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N assemble_transM
#PBS -j oe 

#####################################################
#####################################################

NEWNAME=Tr_M
ADAPTERS=/N/soft/rhel7/trimmomatic/0.36/adapters/TruSeq3-PE-2.fa

cd /N/dc2/scratch/chrichan/trachelipus_assembly/transcript_data

#Download data from NCBI
module load sra-toolkit/2.9.6
SAMPLE=SRR5198727
fastq-dump --defline-seq '@$sn[_$rn]/$ri' --outdir ./ --split-files ${SAMPLE}

mv ${SAMPLE}_1.fastq ${NEWNAME}_raw_1.fastq
mv ${SAMPLE}_2.fastq ${NEWNAME}_raw_2.fastq

module load trimmomatic/0.36

READS1=${NEWNAME}_raw_1.fastq
READS2=${NEWNAME}_raw_2.fastq
OUT_P1=${NEWNAME}_1.fastq
OUT_U1=${NEWNAME}_1u.fastq
OUT_P2=${NEWNAME}_2.fastq
OUT_U2=${NEWNAME}_2u.fastq
MINLEN=36

trimmomatic-0.36 PE -threads 2 \
  ${READS1} ${READS2} \
  ${OUT_P1} ${OUT_U1} \
  ${OUT_P2} ${OUT_U2} \
  ILLUMINACLIP:${ADAPTERS}:2:40:15 \
  LEADING:5 \
  TRAILING:5 \
  SLIDINGWINDOW:4:5 \
  MINLEN:${MINLEN}

#reformat read names to prevent trinity error later
mv ${NEWNAME}_2.fastq ${NEWNAME}_preformatted_2.fastq
sed 's/reverse/forward/' ${NEWNAME}_preformatted_2.fastq > ${NEWNAME}_2.fastq

#####################################################
#####################################################


SAMPLE=Tr_M

cd /N/dc2/scratch/chrichan/trachelipus_assembly/

mkdir -p transcripts_${SAMPLE}
cd transcripts_${SAMPLE}

module load module load trinityrnaseq/2.8.4

READS1=../transcript_data/${SAMPLE}_1.fastq
READS2=../transcript_data/${SAMPLE}_2.fastq

Trinity --seqType fq \
  --max_memory 120G \
  --left ${READS1} \
  --right ${READS2} \
  --CPU 8 
  