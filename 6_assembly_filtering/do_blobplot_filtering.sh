#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=24,vmem=500gb,walltime=16:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N do_plotM
#PBS -j oe 

#####################################################
#####################################################

SAMPLE=Mpool

REF=trachelipus_v0.fasta

BLOBDIR=/N/dc2/scratch/chrichan/temp/blobtools
 
cd /N/dc2/scratch/chrichan/trachelipus_assembly/all_dbg2olc/filtering_fmlrc_k17_kct5_mo30_l100

cat blastn_results_001.txt blastn_results_002.txt blastn_results_003.txt blastn_results_004.txt blastn_results_005.txt blastn_results_006.txt > blastn_results_combined.txt
cat diamond_results_001.txt diamond_results_002.txt diamond_results_003.txt diamond_results_004.txt diamond_results_005.txt diamond_results_006.txt > diamond_results_combined.txt

export PYTHONPATH=
module unload python
module load python/3.6.1
source ~/virtualenvs/blobtools/bin/activate

${BLOBDIR}/blobtools taxify -f diamond_results_combined.txt \
 -m /N/dc2/scratch/chrichan/diamond_uniprot/uniprot_ref_proteomes.taxids \
 -s 0 \
 -t 2 \
 -o ./

${BLOBDIR}/blobtools map2cov -i ${REF} \
 -b ${SAMPLE}_bwa.bam \
 -o ./
 
${BLOBDIR}/blobtools create \
 -i ${REF} \
 -c ${SAMPLE}_bwa.bam.cov \
 -t blastn_results_combined.txt \
 -t diamond_results_combined.taxified.out \
 -o blobplot_${SAMPLE}


${BLOBDIR}/blobtools view \
 -i blobplot_${SAMPLE}.blobDB.json \
 -o blobplot_${SAMPLE}_blob

${BLOBDIR}/blobtools view \
 -i blobplot_${SAMPLE}.blobDB.json \
 -r all \
 -o blobplot_${SAMPLE}_blob 
 
${BLOBDIR}/blobtools plot \
 -i blobplot_${SAMPLE}.blobDB.json \
 -r superkingdom \
 --format png \
 -o ./


${BLOBDIR}/blobtools plot \
 -i blobplot_${SAMPLE}.blobDB.json \
 -r phylum \
 --format png \
 -m \
 -o ./


cat blobplot_${SAMPLE}_blob.blobplot_${SAMPLE}.blobDB.bestsum.table.txt | grep -v '^#' | sort -k 9,9 -k 3nr,3nr > ${SAMPLE}_stats_sorted.txt

# Candidates for filtering / removal
# Actinobacteria
# Ascomycota
# Bacteria-undef
# Bacteroidetes
# Basidiomycota
# Chlorophyta
# Firmicutes
# Mucoromycota
# Proteobacteria
# Streptophyta
# Verrucomicrobia
# Viruses-undef
# Zoopagomycota

cut -f 9 ${SAMPLE}_stats_sorted.txt | sort | uniq -c > full_taxa_list.txt

cat ${SAMPLE}_stats_sorted.txt | awk '{if ($9 == "Actinobacteria") {print $0}}' > ${SAMPLE}_removal_candidates.txt
cat ${SAMPLE}_stats_sorted.txt | awk '{if ($9 == "Ascomycota") {print $0}}' >> ${SAMPLE}_removal_candidates.txt
cat ${SAMPLE}_stats_sorted.txt | awk '{if ($9 == "Bacteria-undef") {print $0}}' >> ${SAMPLE}_removal_candidates.txt
cat ${SAMPLE}_stats_sorted.txt | awk '{if ($9 == "Bacteroidetes") {print $0}}' >> ${SAMPLE}_removal_candidates.txt
cat ${SAMPLE}_stats_sorted.txt | awk '{if ($9 == "Basidiomycota") {print $0}}' >> ${SAMPLE}_removal_candidates.txt
cat ${SAMPLE}_stats_sorted.txt | awk '{if ($9 == "Chlorophyta") {print $0}}' >> ${SAMPLE}_removal_candidates.txt
cat ${SAMPLE}_stats_sorted.txt | awk '{if ($9 == "Firmicutes") {print $0}}' >> ${SAMPLE}_removal_candidates.txt
cat ${SAMPLE}_stats_sorted.txt | awk '{if ($9 == "Mucoromycota") {print $0}}' >> ${SAMPLE}_removal_candidates.txt
cat ${SAMPLE}_stats_sorted.txt | awk '{if ($9 == "Proteobacteria") {print $0}}' >> ${SAMPLE}_removal_candidates.txt
cat ${SAMPLE}_stats_sorted.txt | awk '{if ($9 == "Streptophyta") {print $0}}' >> ${SAMPLE}_removal_candidates.txt
cat ${SAMPLE}_stats_sorted.txt | awk '{if ($9 == "Verrucomicrobia") {print $0}}' >> ${SAMPLE}_removal_candidates.txt
cat ${SAMPLE}_stats_sorted.txt | awk '{if ($9 == "Viruses-undef") {print $0}}' >> ${SAMPLE}_removal_candidates.txt
cat ${SAMPLE}_stats_sorted.txt | awk '{if ($9 == "Zoopagomycota") {print $0}}' >> ${SAMPLE}_removal_candidates.txt

grep -v -i 'wolbachia' ${SAMPLE}_removal_candidates.txt > TEMP
mv TEMP ${SAMPLE}_removal_candidates.txt

grep '^>' trachelipus_v0.fasta | sed 's/>//' | sort > all_contigs.txt
cut -f 1 ${SAMPLE}_removal_candidates.txt | sort > removal_contigs.txt

comm -2 -3 all_contigs.txt removal_contigs.txt > keeper_contigs.txt

seqtk subseq trachelipus_v0.fasta keeper_contigs.txt > trachelipus_v0.1.fasta
