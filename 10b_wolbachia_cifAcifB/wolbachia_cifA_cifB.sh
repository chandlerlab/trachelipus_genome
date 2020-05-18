#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=4,vmem=16gb,walltime=4:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N wolbachia_trees
#PBS -j oe 

#####################################################
#####################################################

REF=/N/dc2/scratch/chrichan/trachelipus_assembly/final_cov/trachelipus_v1_unmasked_plus_malespecific.fasta

cd /N/dc2/scratch/chrichan/trachelipus_assembly/
mkdir -p wolbachia_cifA_cifB
cd wolbachia_cifA_cifB

cp ../wolbachia_trees/wolbachia_hits_filtered_sorted.txt .

#for now, keep only the hits that are at least XXX bp long
cat wolbachia_hits_filtered_sorted.txt | awk '{if (($5 >= 200) && ($3 <= 1e-25)) {print $0}}' > best_wolbachia_hits.txt

#extract the sequences
cut -f 1 best_wolbachia_hits.txt > best_wolbachia_hits_ids.txt
seqtk subseq ../wolbachia_trees/candidate_wolbachia_sequences.fasta best_wolbachia_hits_ids.txt > best_wolbachia_hits.fasta

#Get the cifA and cifB sequences from wCon
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/003/344/345/GCA_003344345.1_ASM334434v1/GCA_003344345.1_ASM334434v1_protein.faa.gz
gunzip GCA_003344345.1_ASM334434v1_protein.faa.gz

echo '>cifA_WP_138264912.1' > ref_cifAcifB.fasta
echo 'MPIETKRQAEVLKKLQDVIKHTDRDIAAGRKLAIKRWVETYIEYIKLFKDDKLEFLYNVFRDEGCWLGTR' >> ref_cifAcifB.fasta
echo 'LNNTVLGQKLTEEKIGEIDNPLPRYGMASRYCITGKIGDFFNKQFVLSRGQFTSEEVDSQGNPISDQYVR' >> ref_cifAcifB.fasta
echo 'NILLSSMKRNGPVFDFWIDRESGELKKYDAVEGFDSTVKLKWSEGVEYFYNQLEEKDKEKKLTEAIVALS' >> ref_cifAcifB.fasta
echo 'RPQSVKRDAPILDFCVRNIGDKDTLLQKLLQKDKGVYSLLAELIESCFFDTVHDLVQCWCYKGVSAGGDC' >> ref_cifAcifB.fasta
echo 'SDKIFSQQDYELFLYSLSNVMLKNPELSVQARSLIMEIWKCERFAEYRETSVNTSNYTVPIKSVLGGLII' >> ref_cifAcifB.fasta
echo 'NWKREDVCKPDREIEKEEILDMISFAKGCFPEKFDLFKEVMIENLRICGREGKRKGVDYGKFAEELFLQL' >> ref_cifAcifB.fasta
echo 'EKVTLPSVGDGPWNNLRSQSKVSLPLDGSGDGPQSEFEAPSVSGISGSHKKRRI' >> ref_cifAcifB.fasta
echo '>cifB_WP_010962722.1' >> ref_cifAcifB.fasta
echo 'MDGDLDGFRQEFESFLDQCPFFLYHVSTGRFLPVFFFSMFATAHDANILKANERVYFRFDNHGIDTGGRN' >> ref_cifAcifB.fasta
echo 'RNTGNLKVAVYHDGQQVVRCYSISDRLNSDGLRFSTRERNALVREIRGQNPNLREEDLNFEQYKVCMHGK' >> ref_cifAcifB.fasta
echo 'GKSQGEAIATVFEVIREKDSQGRDRFAKYSASEISLLRHIERNRLNGINAPAPRSLLTVKEIGSIRLNQD' >> ref_cifAcifB.fasta
echo 'QRVQLGHLVNFVQVAPGQQGIFSFMEVLASNQKINIERGINEGILPYITRIYRSYLGSLQNDIQNRSQKF' >> ref_cifAcifB.fasta
echo 'ESHGFFLGLLANFIHLYTIDIDLDLSPGNSYVAFLICHQAERENIPIVINVTRWRTSSDIALNRARADAK' >> ref_cifAcifB.fasta
echo 'RLHVSSFISIHTESRNAVCIGLNFNLNIDPFSIDTVEFLENRFPLVQRLFECLEDEGIRENIRDFLLQHL' >> ref_cifAcifB.fasta
echo 'PNEIPRNAENYNRIFDCITGFAFGNSILEEFRLVNAVQQRVRKYIFRYGDENHALTMVFHTQGSDIVILH' >> ref_cifAcifB.fasta
echo 'IRDNNAVQQGAINLQDLNVDGNNVHVREVSCTLNNQLGLNIHTDNLGLYHNYQNNNANNFLGGNLVQVPN' >> ref_cifAcifB.fasta
echo 'AGNVHNALNQVMNDGWQDRFQHQELFRNISAVLMPEDTHGNMIIDVNSKDKFRSILHGTFYASDNPYKVL' >> ref_cifAcifB.fasta
echo 'AMYKVGQTYSLKRWQEEEGERVILTRVTEQRLGLLLLRQPTADTHPIGYVLGFADNAEEVEQEQDEARYK' >> ref_cifAcifB.fasta
echo 'ITELMSKQRGYLPITSGNEVVLSYAVFNRGAQRAEDFISLPQQAVYVHRLDRRGHDSRPEVLVGPESVID' >> ref_cifAcifB.fasta
echo 'ENPPENLLSDQTRENFRRFYMEKRPGQNSIFLLDIDDNLHVPFSYLQGTRAQAIETLRSRIRGGGTSTAQ' >> ref_cifAcifB.fasta
echo 'GILQQINTILRRNNAREIEDVHNLLALDFATENQNFRYWLQTHDMFFAARQYTFHDDRSNPTNDRHDFAI' >> ref_cifAcifB.fasta
echo 'TSVGVDGNQNDPTGRDLLSSNIDNFKQKVDSGEKDRLTAIINVGNRHWVTLVIVHQNGNYYGYYADSLGP' >> ref_cifAcifB.fasta
echo 'DSRIDNNIRGALRECDISDDNVHDVSVHQQTDGHNCGIWAYENARDINQAIDQALQGNSNFGEKGEGIIG' >> ref_cifAcifB.fasta
echo 'YIRGLLSAGIGNDTRQPQRNEQYFRNRRRNISQLFQNDSLSSPRGRLIQGRPGIQHEIDPLLLQFLELQY' >> ref_cifAcifB.fasta
echo 'PQRGGGGALQLGGERVISIDFGPQSVLDEIDGVNRVYDHSNGRGSR' >> ref_cifAcifB.fasta

module load samtools/1.9
samtools faidx ref_cifAcifB.fasta cifA_WP_138264912.1 > ref_cifA.fasta
samtools faidx ref_cifAcifB.fasta cifB_WP_010962722.1 > ref_cifB.fasta


makeblastdb -in GCA_003344345.1_ASM334434v1_protein.faa -dbtype prot
blastp -query ref_cifAcifB.fasta \
       -db GCA_003344345.1_ASM334434v1_protein.faa \
       -evalue 1e-30 \
       -outfmt '6 qseqid sseqid evalue bitscore length pident qstart qend sstart send qlen slen' \
       -out ref_wCon_blastp_results.txt

grep 'cifA' ref_wCon_blastp_results.txt | cut -f 2 | sort | uniq > wCon_cifA_ids.txt
grep 'cifB' ref_wCon_blastp_results.txt | cut -f 2 | sort | uniq > wCon_cifB_ids.txt

seqtk subseq GCA_003344345.1_ASM334434v1_protein.faa wCon_cifA_ids.txt > wCon_cifA.fasta
seqtk subseq GCA_003344345.1_ASM334434v1_protein.faa wCon_cifB_ids.txt > wCon_cifB.fasta

makeblastdb -in best_wolbachia_hits.fasta -dbtype nucl

for X in cifA cifB
do
  #first pass search using only the wolbachia matching portions of the genome
  tblastn -query wCon_${X}.fasta \
          -db best_wolbachia_hits.fasta \
          -num_threads 4 \
          -evalue 1e-10 \
          -outfmt '6 qseqid sseqid evalue bitscore length qstart qend sstart send pident qlen slen' \
          -out tblastn_results_${X}.txt
  #second search using the full contigs
  cut -f 2 tblastn_results_${X}.txt | cut -f 1 -d ":" | sort | uniq > ${X}_candidate_full_contigs.txt
  seqtk subseq ${REF} ${X}_candidate_full_contigs.txt > ${X}_candidate_full_contigs.fasta
  makeblastdb -in ${X}_candidate_full_contigs.fasta -dbtype nucl
  tblastn -query wCon_${X}.fasta \
          -db ${X}_candidate_full_contigs.fasta \
          -num_threads 4 \
          -evalue 1e-10 \
          -outfmt '6 qseqid sseqid evalue bitscore length qstart qend sstart send pident qlen slen' \
          -out tblastn_results_full_${X}.txt
  #third search using the full contigs, but the reference sequences as contigs
  tblastn -query ref_${X}.fasta \
          -db ${X}_candidate_full_contigs.fasta \
          -num_threads 4 \
          -evalue 1e-3 \
          -outfmt '6 qseqid sseqid evalue bitscore length qstart qend sstart send pident qlen slen' \
          -out tblastn_results_full_ref_${X}.txt
done

#best way to present results?
#BLAST diagrams -- full contig on top
# plot a little bar below contig for each BLAST hit (use one color for cifA hits and another color for cifB hits)
# show amino acid numbers at borders, and put %identity inside
#like so
# contig_9992423 ========================================================================================
#                           ---------------                            ----------------------
#                          42    55% id  224                         110        48% id      331
#                                cifA                                           cifB

