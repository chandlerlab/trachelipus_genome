#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=4,vmem=16gb,walltime=4:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N wolbachia_trees
#PBS -j oe 

#####################################################
#####################################################

cd /N/dc2/scratch/chrichan/trachelipus_assembly/
cd wolbachia_trees

#for now, keep only the hits that are at least XXX bp long
cat wolbachia_hits_filtered_sorted.txt | awk '{if (($5 >= 1000) && ($3 <= 1e-25)) {print $0}}' > best_wolbachia_hits.txt

#extract the sequences
cut -f 1 best_wolbachia_hits.txt > best_wolbachia_hits_ids.txt
seqtk subseq candidate_wolbachia_sequences.fasta best_wolbachia_hits_ids.txt > best_wolbachia_hits.fasta

#re-blast them against all the Wolbachia genomes, but this time including wVulC and wVul insertion
cat all_wolbachia_genomes.fasta ncbi-genomes-2019-08-08/wVul*.fasta > all_wolbachia_genomes_plus_wvul.fasta
makeblastdb -in all_wolbachia_genomes_plus_wvul.fasta -dbtype nucl
blastn -task blastn \
       -num_threads 2 \
       -query best_wolbachia_hits.fasta \
       -db all_wolbachia_genomes_plus_wvul.fasta \
       -evalue 1e-6 \
       -outfmt '6 qseqid sseqid evalue bitscore length pident qstart qend sstart send sstrand qlen qseq sseq' \
       -out best_wolbachia_allhits.txt

cat best_wolbachia_allhits.txt | awk '{if ($5 >= (0.80 * $12)) {print $0}}' > best_wolbachia_longhits.txt



 
 
#make dictionary for re-naming taxa
cd ncbi-genomes-2019-08-08/
ls -hl *.fna | awk '{print $9}' | awk -F "_" '{print $1 "_" $2}' > ../assemblies.txt
cd ..
rm wolbachia_table.txt
while read X
do
  grep ${X} assembly_summary.txt | head -1 | awk -F "\t" '{print $1 "," $8 "," $9}'
  #grep ${X} assembly_summary.txt | head -1
done < assemblies.txt
#manually cleaned that up to get the dictionary below
echo -e 'wVul_insertion\twVul_insertion.fasta' > dictionary.txt
echo -e 'wVulC\twVulC.fasta' >> dictionary.txt
echo -e 'wMel_GCF_000008025.1\tGCF_000008025.1_ASM802v1_genomic.fna' >> dictionary.txt
echo -e 'Brugia_malayi_GCF_000008385.1\tGCF_000008385.1_ASM838v1_genomic.fna' >> dictionary.txt
echo -e 'wRi_GCF_000022285.1\tGCF_000022285.1_ASM2228v1_genomic.fna' >> dictionary.txt
echo -e 'wPip_GCF_000073005.1\tGCF_000073005.1_ASM7300v1_genomic.fna' >> dictionary.txt
echo -e 'Culex_quinquefasciatus_GCF_000156735.1\tGCF_000156735.1_ASM15673v1_genomic.fna' >> dictionary.txt
echo -e 'D_ananassae_GCF_000167475.1\tGCF_000167475.1_ASM16747v1_genomic.fna' >> dictionary.txt
echo -e 'Muscidifurax_uniraptor_GCF_000174095.1\tGCF_000174095.1_wUni_1.0_genomic.fna' >> dictionary.txt
echo -e 'Nasonia_vitripennis_GCF_000204545.1\tGCF_000204545.1_WVB_1.0_genomic.fna' >> dictionary.txt
echo -e 'Culex_pipiens_molestus_GCF_000208785.1\tGCF_000208785.1_ASM20878v1_genomic.fna' >> dictionary.txt
echo -e 'wAlbB_GCF_000242415.2\tGCF_000242415.2_ASM24241v3_genomic.fna' >> dictionary.txt
echo -e 'wOo_GCF_000306885.1\tGCF_000306885.1_ASM30688v1_genomic.fna' >> dictionary.txt
echo -e 'Diaphorina_citri_GCF_000331595.1\tGCF_000331595.1_wACP3_genomic.fna' >> dictionary.txt
echo -e 'wBol1-b_GCF_000333775.1\tGCF_000333775.1_ASM33377v1_genomic.fna' >> dictionary.txt
echo -e 'valsugana_GCF_000333795.1\tGCF_000333795.1_ASM33379v2_genomic.fna' >> dictionary.txt
echo -e 'wNo_GCF_000376585.1\tGCF_000376585.1_ASM37658v1_genomic.fna' >> dictionary.txt
echo -e 'wHa_GCF_000376605.1\tGCF_000376605.1_ASM37660v1_genomic.fna' >> dictionary.txt
echo -e 'wMelPop_GCF_000475015.1\tGCF_000475015.1_wMelPop_genomic.fna' >> dictionary.txt
echo -e 'Cameroon_GCF_000530755.1\tGCF_000530755.1_W_O_volvulus_Cameroon_v3_genomic.fna' >> dictionary.txt
echo -e 'Glossina_morsitans_morsitans_GCF_000689175.1\tGCF_000689175.1_wGmm_version4_genomic.fna' >> dictionary.txt
echo -e 'wPip_Mol_GCF_000723225.2\tGCF_000723225.2_Wolbachia_endosymbiont_wPip_Mol_of_Culex_molestus_genomic.fna' >> dictionary.txt
echo -e 'wRec_GCF_000742435.1\tGCF_000742435.1_ASM74243v1_genomic.fna' >> dictionary.txt
echo -e 'wCle_GCF_000829315.1\tGCF_000829315.1_ASM82931v1_genomic.fna' >> dictionary.txt
echo -e 'wAu_GCF_000953315.1\tGCF_000953315.1_Wau001_genomic.fna' >> dictionary.txt
echo -e 'Ob_Wba_GCF_001266585.1\tGCF_001266585.1_ASM126658v1_genomic.fna' >> dictionary.txt
echo -e 'wTpre_GCF_001439985.1\tGCF_001439985.1_wTPRE_1.0_genomic.fna' >> dictionary.txt
echo -e 'wStri_GCF_001637495.1\tGCF_001637495.1_ASM163749v1_genomic.fna' >> dictionary.txt
echo -e 'wDacB_GCF_001648015.1\tGCF_001648015.1_ASM164801v1_genomic.fna' >> dictionary.txt
echo -e 'wDacA_GCF_001648025.1\tGCF_001648025.1_ASM164802v1_genomic.fna' >> dictionary.txt
echo -e 'wNfla_GCF_001675695.1\tGCF_001675695.1_ASM167569v1_genomic.fna' >> dictionary.txt
echo -e 'wNleu_GCF_001675715.1\tGCF_001675715.1_ASM167571v1_genomic.fna' >> dictionary.txt
echo -e 'wNpa_GCF_001675775.1\tGCF_001675775.1_ASM167577v1_genomic.fna' >> dictionary.txt
echo -e 'wNfe_GCF_001675785.1\tGCF_001675785.1_ASM167578v1_genomic.fna' >> dictionary.txt
echo -e 'wPpe_GCF_001752665.1\tGCF_001752665.1_ASM175266v1_genomic.fna' >> dictionary.txt
echo -e 'wInc_Cu_GCF_001758565.1\tGCF_001758565.1_ASM175856v1_genomic.fna' >> dictionary.txt
echo -e 'Berlin_GCF_001931755.2\tGCF_001931755.2_ASM193175v2_genomic.fna' >> dictionary.txt
echo -e 'wVitA_GCF_001983615.1\tGCF_001983615.1_ASM198361v1_genomic.fna' >> dictionary.txt
echo -e 'wUni_GCF_001983635.1\tGCF_001983635.1_ASM198363v1_genomic.fna' >> dictionary.txt
echo -e 'wWb_GCF_002204235.2\tGCF_002204235.2_ASM220423v2_genomic.fna' >> dictionary.txt
echo -e 'wSpc_GCF_002300525.1\tGCF_002300525.1_ASM230052v1_genomic.fna' >> dictionary.txt
echo -e 'wAus_GCF_002318985.1\tGCF_002318985.1_ASM231898v1_genomic.fna' >> dictionary.txt
echo -e 'wRi_GCF_002907405.1\tGCF_002907405.1_ASM290740v1_genomic.fna' >> dictionary.txt
echo -e 'wMel_AMD_GCF_002907445.1\tGCF_002907445.1_ASM290744v1_genomic.fna' >> dictionary.txt
echo -e 'wMel_KL_GCF_002907525.1\tGCF_002907525.1_ASM290752v1_genomic.fna' >> dictionary.txt
echo -e 'Wcon_GCF_003344345.1\tGCF_003344345.1_ASM334434v1_genomic.fna' >> dictionary.txt
echo -e 'wAna_India_GCF_003671365.1\tGCF_003671365.1_ASM367136v1_genomic.fna' >> dictionary.txt
echo -e 'wAna_Indonesia_GCF_003671375.1\tGCF_003671375.1_ASM367137v1_genomic.fna' >> dictionary.txt
echo -e 'wAna_Hawaii_GCF_003671405.1\tGCF_003671405.1_ASM367140v1_genomic.fna' >> dictionary.txt
echo -e 'China_1_GCF_003999585.1\tGCF_003999585.1_ASM399958v1_genomic.fna' >> dictionary.txt
echo -e 'wAlbB_GCF_004171285.1\tGCF_004171285.1_ASM417128v1_genomic.fna' >> dictionary.txt
echo -e 'Drosophila_mauritiana_GCF_004685025.1\tGCF_004685025.1_ASM468502v1_genomic.fna' >> dictionary.txt
echo -e 'Aedes_albopictus_GCF_004795415.1\tGCF_004795415.1_ASM479541v1_genomic.fna' >> dictionary.txt
echo -e 'Brugia_malayi_GCF_004795935.1\tGCF_004795935.1_ASM479593v1_genomic.fna' >> dictionary.txt
echo -e 'wMau_GCF_004795955.1\tGCF_004795955.1_ASM479595v1_genomic.fna' >> dictionary.txt
echo -e 'wMau_GCF_004795975.1\tGCF_004795975.1_ASM479597v1_genomic.fna' >> dictionary.txt
echo -e 'wSan_Quija630.39_GCF_005862095.1\tGCF_005862095.1_ASM586209v1_genomic.fna' >> dictionary.txt
echo -e 'wYak_CY17C_GCF_005862115.1\tGCF_005862115.1_ASM586211v1_genomic.fna' >> dictionary.txt
echo -e 'wTei_cascade_4_2_GCF_005862135.1\tGCF_005862135.1_ASM586213v1_genomic.fna' >> dictionary.txt
echo -e 'GBW_GCF_006334525.1\tGCF_006334525.1_ASM633452v1_genomic.fna' >> dictionary.txt
echo -e 'Carposina_sasakii_GCF_006542295.1\tGCF_006542295.1_ASM654229v1_genomic.fna' >> dictionary.txt
echo -e 'Bemisia_tabaci_GCF_900097055.1\tGCF_900097055.1_WBTv1_genomic.fna' >> dictionary.txt
rm full_dictionary.txt
while read L
do
  X=(${L})
  NAME=${X[0]}
  FILE=${X[1]}
  grep '^>' ncbi-genomes-2019-08-08/${FILE} | sed 's/>//' | awk -v transl=${NAME} '{print $1 "," transl}' >> full_dictionary.txt
done < dictionary.txt




#add the target genome information
module load r/3.6.0
Rscript --vanilla translate_wolbachia.R best_wolbachia_longhits.txt best_wolbachia_longhits_genome.txt

#keep only the best hit in each wolbachia genome
cat best_wolbachia_longhits_genome.txt | sort -k 1,1 -k 15,15 -k 4nr,4nr | awk 'BEGIN {last_q="XXX"; last_t="XXX"} {if (!((last_q == $1) && (last_t == $15))) {print $0} ; last_q=$1; last_t=$15}' > best_wolbachia_longhits_nodups.txt

#use only trachelipus wolbachia insertions that have hits in at least 4 wolbachia genomes
cat best_wolbachia_longhits_nodups.txt | awk 'BEGIN {last="X"; n=0} {if (last == $1) {n +=1} else {if (n >= 4) {print last; n=1} } last = $1} END {if (n>=4) {print last}} ' | sort | uniq > wolbachia_insertion_ids.txt


module load muscle/3.8.31
module load raxmlng

#using raxml-ng 0.9.0

COUNT=1
while read X
do
  echo "**********************************************************************"
  echo ${X}
  echo ${COUNT}

  mkdir -p tree_${COUNT}
  cd tree_${COUNT}
  
  grep ${X} ../best_wolbachia_longhits_nodups.txt > cur_hits.txt
  echo ${X} > cur_ref.txt
  seqtk subseq ../best_wolbachia_hits.fasta cur_ref.txt > cur_seqs.fasta
  
  cat cur_hits.txt | awk '{print ">" $2; print $14}' | sed '/[^>]/ s/-//g' > cur_hits.fasta  
  
  cat cur_hits.fasta >> cur_seqs.fasta
  
  
  python ../translate_wolbachia_fasta.py cur_seqs.fasta ../full_dictionary.txt > cur_seqs_renamed.fasta


  muscle -in cur_seqs_renamed.fasta \
         -out cur_hits_aligned.fasta
  trimal -in cur_hits_aligned.fasta \
         -strict \
         -out cur_hits_aligned_filtered.fasta

  #remove spaces from sequence names
  cat cur_hits_aligned_filtered.fasta | awk '{if ($0 ~ ">") {print $1} else {print $0}}' > cur_hits_aligned_filtered_renamed.fasta
  modeltest-ng -d nt \
               -i cur_hits_aligned_filtered_renamed.fasta \
               -o modeltest_ng_results.txt \
               -p 2 
  grep '  > raxml-ng' modeltest_ng_results.txt.out | tail -1 | sed 's/  > //' > command.txt
  #cat command.txt | awk '{print $0 " --all --tree pars{10} --bs-trees 100 --threads 2"}' > command_final.txt
  cat command.txt | awk '{print $0 " --all --tree pars{10} --bs-trees 100 --threads 1"}' > command_final.txt
  chmod a+x command_final.txt
  ./command_final.txt
  cp ../plot_tree.R .
  Rscript --vanilla plot_tree.R
  cp cur_tree.pdf ../tree_pdfs/tree_${COUNT}_${X}.pdf
  
  cd ..
  COUNT=`expr ${COUNT} + 1`
done < wolbachia_insertion_ids.txt

COUNT=`expr ${COUNT} - 1`

#Now make a concatenated tree
mkdir concatenated_tree
cd concatenated_tree

#generate the full concatenated dataset
#first, get the data from each individual tree
END=COUNT
for ((N=1;N<=END;N++))
do
    seqtk seq -l 0 ../tree_${N}/cur_hits_aligned_filtered_renamed.fasta | awk -F "|" '{if ($1 ~ ">") {if ($1 ~ ">contig") {contig="Trachelipus_insertion"} else {contig=$1; gsub(/>/, "", contig)}} else {print contig "\t" $1}}' | sort -k 1,1 > seq_table_${N}.txt
done

#now, get the list of all sequence IDs to be used in the concatenated dataset
cat seq_table_*.txt | cut -f 1 | sort | uniq > full_seq_id_list.txt

#for each individual wolbachia insertion, generate blank sequence data for the wolbachia genomes that don't have hits
for ((N=1;N<=END;N++))
do
  #fill in 
  join -j 1 -a 1 -e "*" -o 1.1 2.2 full_seq_id_list.txt seq_table_${N}.txt | awk '{print $1 "\t " $2 "\t" length($2)}' | sort -k 3nr,3nr | awk '{if (NR == 1) {blanks = ""; for (i=1; i <= length($2); i++) {blanks = blanks "-"}; print $1 "\t" $2} else {if ($2 ~"*") {print $1 "\t" blanks} else {print $1 "\t" $2}}}' | sort -k 1,1 > seq_table_${N}_full.txt
done

#put them all together to make the concatenated dataset
cp full_seq_id_list.txt TEMP
for ((N=1;N<=END;N++))
do
  join TEMP seq_table_${N}_full.txt > TEMP2
  mv TEMP2 TEMP
done
cat TEMP | awk '{dat = ""; for (i=2; i <= NF; i++) {dat = dat $i}; print $1 "\t" dat}' > concatenated_data.txt
cat concatenated_data.txt | awk '{print ">" $1; print $2}' > concatenated_data.fasta

#now make the tree
modeltest-ng -d nt \
             -i concatenated_data.fasta \
             -o modeltest_ng_results.txt \
             -p 4 
grep '  > raxml-ng' modeltest_ng_results.txt.out | tail -1 | sed 's/  > //' > command.txt
cat command.txt | awk '{print $0 " --all --tree pars{10} --bs-trees 100 --threads 4"}' > command_final.txt
chmod a+x command_final.txt
./command_final.txt
Rscript --vanilla plot_tree_concatenated.R
cp cur_tree.pdf ../tree_pdfs/concatenated_tree_full.pdf

cd ..

####################################################################################

#now for more targeted approach
mkdir concatenated_tree_targeted
cd concatenated_tree_targeted

#generate the full concatenated dataset
#first, get the data from each individual tree
for N in 7 10 18 20 22 25
do
    seqtk seq -l 0 ../tree_${N}/cur_hits_aligned_filtered_renamed.fasta | awk -F "|" '{if ($1 ~ ">") {if ($1 ~ ">contig") {contig="Trachelipus_insertion"} else {contig=$1; gsub(/>/, "", contig)}} else {print contig "\t" $1}}' | sort -k 1,1 > seq_table_${N}.txt
done

#now, get the list of all sequence IDs to be used in the concatenated dataset
cat seq_table_*.txt | cut -f 1 | sort | uniq > full_seq_id_list.txt

#for each individual wolbachia insertion, generate blank sequence data for the wolbachia genomes that don't have hits
for N in 7 10 18 20 22 25
do
  #fill in 
  join -j 1 -a 1 -e "*" -o 1.1 2.2 full_seq_id_list.txt seq_table_${N}.txt | awk '{print $1 "\t " $2 "\t" length($2)}' | sort -k 3nr,3nr | awk '{if (NR == 1) {blanks = ""; for (i=1; i <= length($2); i++) {blanks = blanks "-"}; print $1 "\t" $2} else {if ($2 ~"*") {print $1 "\t" blanks} else {print $1 "\t" $2}}}' | sort -k 1,1 > seq_table_${N}_full.txt
done

#put them all together to make the concatenated dataset
cp full_seq_id_list.txt TEMP
for N in 7 10 18 20 22 25
do
  join TEMP seq_table_${N}_full.txt > TEMP2
  mv TEMP2 TEMP
done
cat TEMP | awk '{dat = ""; for (i=2; i <= NF; i++) {dat = dat $i}; print $1 "\t" dat}' > concatenated_data.txt
cat concatenated_data.txt | awk '{print ">" $1; print $2}' > concatenated_data.fasta

#now make the tree
modeltest-ng -d nt \
             -i concatenated_data.fasta \
             -o modeltest_ng_results.txt \
             -p 4 
grep '  > raxml-ng' modeltest_ng_results.txt.out | tail -1 | sed 's/  > //' > command.txt
cat command.txt | awk '{print $0 " --all --tree pars{10} --bs-trees 100 --threads 4"}' > command_final.txt
chmod a+x command_final.txt
./command_final.txt
Rscript --vanilla plot_tree_concatenated.R



#** note that there are cifA and cifB homologs in the wolbachia-like sequences,
# so, T. rathkei would have had a cytoplasmic incompatibility strain!

#but they are not complete
#best way to present results?
#BLAST diagrams -- full contig on top
# plot a little bar below contig for each BLAST hit (use one color for cifA hits and another color for cifB hits)
# show amino acid numbers at borders, and put %identity inside
#like so
# contig_9992423 ========================================================================================
#                           ---------------                            ----------------------
#                          42    55% id  224                         110        48% id      331
#                                cifA                                           cifB

