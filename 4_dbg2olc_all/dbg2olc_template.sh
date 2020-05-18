#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=4,vmem=64gb,walltime=80:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N dbg2olc_NNN
#PBS -j oe 

#####################################################
#####################################################

CORRECTOR=AAA
# lordec fmlrc

K=BBB
# 17 19

KMERCOVTHRESH=CCC
# 2 5 

MINOVERLAP=DDD
# 10 30

MINLEN=EEE
# 100 200

ADAPTIVETHRESH=0.01


cd /N/dc2/scratch/chrichan/trachelipus_assembly
cd all_dbg2olc


DIRNAME=${CORRECTOR}_k${K}_kct${KMERCOVTHRESH}_mo${MINOVERLAP}_l${MINLEN}
mkdir -p ${DIRNAME}
cd ${DIRNAME}

#Change this depending on results of sparseassembler (k51, k61, or k71)
INITIALCONTIGS=/N/dc2/scratch/chrichan/trachelipus_assembly/redundans_k61/contigs.reduced.fa

cat /N/dc2/scratch/chrichan/trachelipus_assembly/${CORRECTOR}_corrected_longreads/pb_F.1500.corrected.fasta \
    /N/dc2/scratch/chrichan/trachelipus_assembly/${CORRECTOR}_corrected_longreads/pb_M.1500.corrected.fasta \
    /N/dc2/scratch/chrichan/trachelipus_assembly/${CORRECTOR}_corrected_longreads/ont_F.1500.corrected.fasta \
    /N/dc2/scratch/chrichan/trachelipus_assembly/${CORRECTOR}_corrected_longreads/ont_M.1500.corrected.fasta > longreads.fasta

cp ${INITIALCONTIGS} ./initial_contigs_prefilter.fasta

seqkit seq -m ${MINLEN} -o initial_contigs_filtered.fasta initial_contigs_prefilter.fasta

DBG2OLC_compiled k ${K} AdaptiveTh ${ADAPTIVETHRESH} KmerCovTh ${KMERCOVTHRESH} MinOverlap ${MINOVERLAP} Contigs initial_contigs_filtered.fasta f longreads.fasta

#####################################################
#####################################################

module load quast/5.0.0-py13
quast.py -o ./quast_results \
         -t 4 \
         --no-plots --no-html --no-icarus --no-snps \
         backbone_raw.fasta
