cd /N/dc2/scratch/chrichan/trachelipus_assembly/agh_phylogeny

echo '>evgTRINITY_DN583_c0_g1_i3' > trachelipus_agh.fasta
echo 'ATGAAATTTCTCGTCTTCTTAATCACTCTACTATTCTTGACTCTCCCCAAGAGTATATGGACCTATCAGATGAAAGGGATGAGATCGGACGTGATATGCGCCGACATTCCCTTTACGGTGCATTGTATCTGCAACGAATTGGGATACTTCCCCACATCAAGATTGTCCCGACCATGTCCATGGTCAAGCCGGGAAAGAAGATCAGTTGATAATGAAGAATTAGCATTTGAAGATGAATACAGTGATCGTTACCATCCTCGAGCCCTCAGGATTCCCACTGGAGAAAATAATGGCGATGAGAAATTGGAAGATGTATTTTCTATTCTTAGCCGATCGAAACGTGAGGTCTCCTTCCATGAAGAGTGTTGTAACATTCGCACAGAGCATCAATGTAACAGAACAACAGTGGAACTTTACTGTCGAAGATACTGA' >> trachelipus_agh.fasta

echo '>evgTRINITY_DN583_c0_g1_i3' > trachelipus_agh_prot.fasta
echo 'MKFLVFLITLLFLTLPKSIWTYQMKGMRSDVICADIPFTVHCICNELGYFPTSRLSRPCPWSSRERRSVDNEELAFEDEYSDRYHPRALRIPTGENNGDEKLEDVFSILSRSKREVSFHEECCNIRTEHQCNRTTVELYCRRY' >> trachelipus_agh_prot.fasta


############################################################

#BLAST the T. rathkei transcript against against Trachelipus genome

CONTIGS=/N/dc2/scratch/chrichan/trachelipus_assembly/final_cov/trachelipus_v1_unmasked_plus_malespecific.fasta
RESULTS=transcript_blast.txt

makeblastdb -in ${CONTIGS} -dbtype nucl

blastn  -task blastn \
        -query trachelipus_agh.fasta \
        -db ${CONTIGS} \
        -num_threads 2 \
        -evalue 0.01 \
        -outfmt '6 qseqid sseqid evalue bitscore length pident qstart qend sstart send qseq sseq' \
        > ${RESULTS}
       
cat ${RESULTS} | sort -k 2,2 -k 7nr,7nr > ${RESULTS}.sorted

cut -f 2 ${RESULTS} | sort | uniq > match_ids.txt
seqtk subseq ${CONTIGS} match_ids.txt > possible_agh_contigs.fasta

CONTIGS=possible_agh_contigs.fasta
RESULTS=transcript_prot_blast.txt

makeblastdb -in ${CONTIGS} -dbtype nucl
tblastn -query trachelipus_agh_prot.fasta \
        -db ${CONTIGS} \
        -num_threads 2 \
        -evalue 0.01 \
        -outfmt '6 qseqid sseqid evalue bitscore length pident qstart qend sstart send qseq sseq' \
        > ${RESULTS}
       
cat ${RESULTS} | sort -k 2,2 -k 7nr,7nr > ${RESULTS}.sorted


############################################################

#filter out to just the contigs that have above a minimum number of the query bases covered
#and then generate the sequence

python make_agh_seqs.py transcript_blast.txt.sorted 432 > trachelipus_agh_genome_sequences.fasta
python make_agh_seqs.py transcript_prot_blast.txt 143 > trachelipus_agh_genome_prot_sequences.fasta

cat trachelipus_agh_genome_sequences.fasta | sed 's/-//g' | awk '{if ($0 ~ ">") {contig=$1} else {if (length($1) > 100) {print contig; print $1}}}' > trachelipus_agh_genome_sequences_100.fasta

cat trachelipus_agh.fasta trachelipus_agh_genome_sequences_100.fasta > transcript_plus_genome_100.fasta


############################################################
# Make a tree -- NOTE Need to re-do this for AA sequences so that we can add other species

#step 1 alignment 
module load muscle/3.8.31
muscle -in transcript_plus_genome_100.fasta \
       -out transcript_plus_genome_100_aligned.fasta

seqtk seq -l 0 transcript_plus_genome_100_aligned.fasta
       

#step 2 model selection
modeltest-ng -d nt \
             -i transcript_plus_genome_100_aligned.fasta \
             -o modeltest_ng_results.txt \
             -p 2 


#step 3 phylogenetic analysis
module load raxmlng
grep '  > raxml-ng' modeltest_ng_results.txt.out | tail -1 | sed 's/  > //' > command.txt
cat command.txt | awk '{print $0 " --all --tree pars{10} --bs-trees 100 --threads 2"}' > command_final.txt
chmod a+x command_final.txt
./command_final.txt

#note: modeltest gives JTTI+G but should be JTT+I+G

