#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=4,vmem=16gb,walltime=4:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N agh
#PBS -j oe 

#####################################################
#####################################################

REF=/N/dc2/scratch/chrichan/trachelipus_assembly/final_cov/trachelipus_v1_unmasked_plus_malespecific.fasta

cd /N/dc2/scratch/chrichan/trachelipus_assembly/agh_plots_manual

module load samtools/1.9

#get the AGH contig and associated annotation
samtools faidx ${REF} contig113427 | seqtk seq -r > agh1_contig.fasta

#get the others and reverse complement them if needed
samtools faidx ${REF} contig14679 | seqtk seq -r > agh2.fasta
samtools faidx ${REF} contig67161 | seqtk seq -r > agh3.fasta
samtools faidx ${REF} NODE_44048_length_535_cov_2.969828 > aghY1.fasta
samtools faidx ${REF} NODE_38289_length_618_cov_5.647166 | seqtk seq -r > aghY2.fasta
samtools faidx ${REF} NODE_65428_length_363_cov_4.945205 > aghY3.fasta

#combine them all
cat agh1_contig.fasta \
    agh2.fasta \
    agh3.fasta \
    aghY1.fasta \
    aghY2.fasta \
    aghY3.fasta > all_agh.fasta

echo '>expressed_cds' >> all_agh.fasta
echo 'ATGAAATTTCTCGTCTTCTTAATCACTCTACTATTCTTGACTCTCCCCAAGAGTATATGGACCTATCAGATGAAAGGGATGAGATCGGACGTGATATGCGCCGACATTCCCTTTACGGTGCATTGTATCTGCAACGAATTGGGATACTTCCCCACATCAAGATTGTCCCGACCATGTCCATGGTCAAGCCGGGAAAGAAGATCAGTTGATAATGAAGAATTAGCATTTGAAGATGAATACAGTGATCGTTACCATCCTCGAGCCCTCAGGATTCCCACTGGAGAAAATAATGGCGATGAGAAATTGGAAGATGTATTTTCTATTCTTAGCCGATCGAAACGTGAGGTCTCCTTCCATGAAGAGTGTTGTAACATTCGCACAGAGCATCAATGTAACAGAACAACAGTGGAACTTTACTGTCGAAGATACTGA' >> all_agh.fasta


#get lengths
seqtk comp all_agh.fasta

#do full blast comparisons
makeblastdb -in all_agh.fasta -dbtype nucl
blastn -task blastn -query all_agh.fasta -db all_agh.fasta -outfmt 6 -num_threads 2 -evalue 1e-3 > all_unmasked_comparison.txt

#get annotation information for contigs
ANNOTATION=/N/dc2/scratch/chrichan/trachelipus_assembly/maker_r3b/trachelipus_v1.all.maker.noseq.gff
grep 'contig113427' ${ANNOTATION} > agh_annotations.gff
grep 'contig14679' ${ANNOTATION} >> agh_annotations.gff
grep 'contig67161' ${ANNOTATION} >> agh_annotations.gff
grep 'NODE_44048_length_535_cov_2.969828' ${ANNOTATION} >> agh_annotations.gff
grep 'NODE_38289_length_618_cov_5.647166' ${ANNOTATION} >> agh_annotations.gff
grep 'NODE_65428_length_363_cov_4.945205' ${ANNOTATION} >> agh_annotations.gff

cat 'agh_annotations.gff' | awk '{if (($3 == "gene") || ($3 == "exon")) {print $0}}' > agh_annotation_genes.gff


