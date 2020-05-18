#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=8:dc2,vmem=128gb,walltime=16:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N filter_trachelipus
#PBS -j oe 



#####################################################
#####################################################

cd /N/dc2/scratch/chrichan/trachelipus_assembly
cd genome_eval_with_transcripts

# blastn_results.txt
# diamond_results.txt

BLOBDIR=/N/dc2/scratch/chrichan/temp/blobtools
 
export PYTHONPATH=
module unload python
module load python/3.6.1
source ~/virtualenvs/blobtools/bin/activate

${BLOBDIR}/blobtools taxify -f diamond_results.txt \
 -m /N/dc2/scratch/chrichan/diamond_uniprot/uniprot_ref_proteomes.taxids \
 -s 0 \
 -t 2 \
 -o ./

cat transcripts_prefilter.fasta | awk '{if ($1 ~ ">") {print $1 "\t" 1 "\t" 1}}' | sed 's/>//' > dummy_cov.txt

${BLOBDIR}/blobtools create \
 -i transcripts_prefilter.fasta \
 -c dummy_cov.txt \
 -t blastn_results.txt \
 -t diamond_results.taxified.out \
 -o blobplot_transcripts

${BLOBDIR}/blobtools view \
 -i blobplot_transcripts.blobDB.json \
 -r all \
 -o blobplot_transcripts_blob 

cat blobplot_transcripts_blob.blobplot_transcripts.blobDB.bestsum.table.txt | grep -v '^#' | sort -k 9,9 -k 3nr,3nr > transcripts_stats_sorted.txt

cut -f 9 transcripts_stats_sorted.txt | sort | uniq -c > full_taxa_list.txt

cat transcripts_stats_sorted.txt | awk '{if ($9 == "Arthropoda") {print $1}}' > arthropod_transcripts.txt
#15805 arthropod transcripts

seqtk subseq transcripts_prefilter.fasta arthropod_transcripts.txt > transcripts_arthropod.fasta




