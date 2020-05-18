#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=16,vmem=64gb,walltime=72:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N trim_Fpool
#PBS -j oe 

####################################################################################
####################################################################################

SAMPLE=Fpool

module load trimmomatic/0.36

cd /N/dc2/scratch/chrichan/trachelipus_assembly/raw_data

echo '>PrefixTS2PE/1' > custom_adapters.fa
echo 'AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATCT' >> custom_adapters.fa
echo '>PrefixTS2PE/2' >> custom_adapters.fa
echo 'CAAGCAGAAGACGGCATACGAGATCGGTCTCGGCATTCCTGCTGAACCGCTCTTCCGATCT' >> custom_adapters.fa
echo '>PrefixTS3PE/1' >> custom_adapters.fa
echo 'TACACTCTTTCCCTACACGACGCTCTTCCGATCT' >> custom_adapters.fa
echo '>PrefixTS3PE/2' >> custom_adapters.fa
echo 'GTGACTGGAGTTCAGACGTGTGCTCTTCCGATCT' >> custom_adapters.fa
echo '>PCR_Primer1' >> custom_adapters.fa
echo 'AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATCT' >> custom_adapters.fa
echo '>PCR_Primer1_rc' >> custom_adapters.fa
echo 'AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT' >> custom_adapters.fa
echo '>PCR_Primer2' >> custom_adapters.fa
echo 'CAAGCAGAAGACGGCATACGAGATCGGTCTCGGCATTCCTGCTGAACCGCTCTTCCGATCT' >> custom_adapters.fa
echo '>PCR_Primer2_rc' >> custom_adapters.fa
echo 'AGATCGGAAGAGCGGTTCAGCAGGAATGCCGAGACCGATCTCGTATGCCGTCTTCTGCTTG' >> custom_adapters.fa
echo '>FlowCell1' >> custom_adapters.fa
echo 'TTTTTTTTTTAATGATACGGCGACCACCGAGATCTACAC' >> custom_adapters.fa
echo '>FlowCell2' >> custom_adapters.fa
echo 'TTTTTTTTTTCAAGCAGAAGACGGCATACGA' >> custom_adapters.fa
echo '>PE1' >> custom_adapters.fa
echo 'TACACTCTTTCCCTACACGACGCTCTTCCGATCT' >> custom_adapters.fa
echo '>PE1_rc' >> custom_adapters.fa
echo 'AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTA' >> custom_adapters.fa
echo '>PE2' >> custom_adapters.fa
echo 'GTGACTGGAGTTCAGACGTGTGCTCTTCCGATCT' >> custom_adapters.fa
echo '>PE2_rc' >> custom_adapters.fa
echo 'AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC' >> custom_adapters.fa

ADAPTERS=custom_adapters.fa

READS1=${SAMPLE}_1.fastq
READS2=${SAMPLE}_2.fastq
OUT_P1=../unzipped_filtered_data/${SAMPLE}_1.fastq
OUT_U1=../unzipped_filtered_data/${SAMPLE}_1u.fastq
OUT_P2=../unzipped_filtered_data/${SAMPLE}_2.fastq
OUT_U2=../unzipped_filtered_data/${SAMPLE}_2u.fastq
MINLENGTH=36

trimmomatic-0.36 PE -threads 16 ${READS1} ${READS2} ${OUT_P1} ${OUT_U1} ${OUT_P2} ${OUT_U2} ILLUMINACLIP:${ADAPTERS}:2:40:15 LEADING:5 TRAILING:5 SLIDINGWINDOW:4:5 MINLEN:${MINLENGTH}
