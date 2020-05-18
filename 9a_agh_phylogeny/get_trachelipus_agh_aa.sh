cd /N/dc2/scratch/chrichan/trachelipus_assembly/agh_phylogeny

echo '>evgTRINITY_DN583_c0_g1_i3' > trachelipus_agh.fasta
echo 'ATGAAATTTCTCGTCTTCTTAATCACTCTACTATTCTTGACTCTCCCCAAGAGTATATGGACCTATCAGATGAAAGGGATGAGATCGGACGTGATATGCGCCGACATTCCCTTTACGGTGCATTGTATCTGCAACGAATTGGGATACTTCCCCACATCAAGATTGTCCCGACCATGTCCATGGTCAAGCCGGGAAAGAAGATCAGTTGATAATGAAGAATTAGCATTTGAAGATGAATACAGTGATCGTTACCATCCTCGAGCCCTCAGGATTCCCACTGGAGAAAATAATGGCGATGAGAAATTGGAAGATGTATTTTCTATTCTTAGCCGATCGAAACGTGAGGTCTCCTTCCATGAAGAGTGTTGTAACATTCGCACAGAGCATCAATGTAACAGAACAACAGTGGAACTTTACTGTCGAAGATACTGA' >> trachelipus_agh.fasta

echo '>evgTRINITY_DN583_c0_g1_i3' > trachelipus_agh_prot.fasta
echo 'MKFLVFLITLLFLTLPKSIWTYQMKGMRSDVICADIPFTVHCICNELGYFPTSRLSRPCPWSSRERRSVDNEELAFEDEYSDRYHPRALRIPTGENNGDEKLEDVFSILSRSKREVSFHEECCNIRTEHQCNRTTVELYCRRY' >> trachelipus_agh_prot.fasta


############################################################

#BLAST the T. rathkei transcript against against Trachelipus genome

CONTIGS=/N/dc2/scratch/chrichan/trachelipus_assembly/final_cov/trachelipus_v1_unmasked_plus_malespecific.fasta
RESULTS=aa_blast.txt

makeblastdb -in ${CONTIGS} -dbtype nucl

tblastn \
        -query trachelipus_agh_prot.fasta \
        -db ${CONTIGS} \
        -num_threads 4 \
        -evalue 0.1 \
        -outfmt '6 qseqid sseqid evalue bitscore length pident qstart qend sstart send qseq sseq' \
        > ${RESULTS}
       
cat ${RESULTS} | sort -k 2,2 -k 7nr,7nr > ${RESULTS}.sorted

cut -f 2 ${RESULTS} | sort | uniq > ${RESULTS}.match_ids.txt
seqtk subseq ${CONTIGS} ${RESULTS}.match_ids.txt > ${RESULTS}.possible_agh_contigs.fasta


############################################################

#generate a fasta file with the matching portions of the amino acid sequence

python make_agh_seqs.py aa_blast.txt 143 > trachelipus_agh_genome_prot_sequences.fasta

#keep only the ones the have at least 40 amino acids; short contigs may not provide
# much phylogenetic resolution
cat trachelipus_agh_genome_prot_sequences.fasta | sed 's/-//g' | awk '{if ($0 ~ ">") {contig=$1} else {if (length($1) > 40) {print contig}}}' | sed 's/>//' > trachelipus_agh_genome_prot_sequences_40.txt
seqtk subseq trachelipus_agh_genome_prot_sequences.fasta trachelipus_agh_genome_prot_sequences_40.txt > trachelipus_agh_genome_prot_sequences_40.fasta

echo '>Expressed_transcript' > TEMP
echo 'MKFLVFLITLLFLTLPKSIWTYQMKGMRSDVICADIPFTVHCICNELGYFPTSRLSRPCPWSSRERRSVDNEELAFEDEYSDRYHPRALRIPTGENNGDEKLEDVFSILSRSKREVSFHEECCNIRTEHQCNRTTVELYCRRY' >> TEMP
cat TEMP trachelipus_agh_genome_prot_sequences_40.fasta > trachelipus_all_agh_prot.fasta

#add the other isopod agh sequences
cat agh_prot.fasta trachelipus_all_agh_prot.fasta > all_agh_prot.fasta

############################################################
# Make a tree -- NOTE Need to re-do this for AA sequences so that we can add other species

#step 1 alignment 
module load muscle/3.8.31
muscle -in all_agh_prot.fasta \
       -out all_agh_prot_aligned.fasta

seqtk seq -l 0 all_agh_prot_aligned.fasta
       

#step 2 model selection
modeltest-ng -d aa \
             -i all_agh_prot_aligned.fasta \
             -o modeltest_ng_results.txt \
             -p 2 


#step 3 phylogenetic analysis
module load raxmlng
grep '  > raxml-ng' modeltest_ng_results.txt.out | tail -1 | sed 's/  > //' > command.txt
cat command.txt | awk '{print $0 " --all --tree pars{10} --bs-trees 100 --threads 4 --redo"}' > command_final.txt
#note: modeltest gives JTTI+G but should be JTT+I+G
sed -i 's/JTTI/JTT+I/' command_final.txt
chmod a+x command_final.txt
./command_final.txt


