#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=8,vmem=128gb,walltime=4:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N pilon_XXX
#PBS -j oe 

#####################################################
#####################################################

#Correct an individual chunk of the assembly

ASSEMBLY=fmlrc_k19_kct5_mo30_l200
ROUND=2
SLICE=XXX

PILON=/N/dc2/scratch/chrichan/trachelipus_assembly/pilon/pilon-1.23.jar

#####################################################

cd /N/dc2/scratch/chrichan/trachelipus_assembly
cd all_dbg2olc
cd pilon
cd ${ASSEMBLY}_r${ROUND}

mkdir -p slice_${SLICE}
cd slice_${SLICE}

grep '^>' ../uncorrected.fasta.split/uncorrected.part_${SLICE}.fasta | sed 's/>//' > cur_targets.txt

cat cur_targets.txt | awk '{print $1 "\t" 0 "\t" 999999}' > cur_targets.bed

sambamba view -o Mpool_cur_slice.bam -L cur_targets.bed -f bam ../Mpool_bbmap.bam


#####################################################

module load java

java -Xmx110G -jar ${PILON} \
     --genome ../uncorrected.fasta.split/uncorrected.part_${SLICE}.fasta \
     --frags Mpool_cur_slice.bam \
     --output corrected_${SLICE} \
     --outdir ./ \
     --diploid \
     --fix snps,indels \
     --mindepth 2

