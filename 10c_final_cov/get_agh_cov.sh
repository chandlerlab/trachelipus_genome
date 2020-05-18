#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=4,vmem=64gb,walltime=24:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N get_busco_cov
#PBS -j oe 

#####################################################
#####################################################

CONTIGS=/N/dc2/scratch/chrichan/trachelipus_assembly/final_cov/trachelipus_v1_unmasked_plus_malespecific.fasta


cd /N/dc2/scratch/chrichan/trachelipus_assembly/final_cov

mkdir -p agh_cov
cd agh_cov

cp /N/dc2/scratch/chrichan/trachelipus_assembly/agh_phylogeny/aa_blast.txt .

grep 'contig113427' aa_blast.txt | awk '{if ($9 < $10) {print $2 "\t" $9 "\t" $10} else {{print $2 "\t" $10 "\t" $9}}}' > agh_1.txt
grep 'contig14679' aa_blast.txt | awk '{if ($9 < $10) {print $2 "\t" $9 "\t" $10} else {{print $2 "\t" $10 "\t" $9}}}' > agh_2.txt
grep 'contig67161' aa_blast.txt | awk '{if ($9 < $10) {print $2 "\t" $9 "\t" $10} else {{print $2 "\t" $10 "\t" $9}}}' > agh_3.txt
grep 'NODE_44048_length_535_cov_2' aa_blast.txt | awk '{if ($9 < $10) {print $2 "\t" $9 "\t" $10} else {{print $2 "\t" $10 "\t" $9}}}' > agh_Y1.txt
grep 'NODE_38289_length_618_cov_5' aa_blast.txt | awk '{if ($9 < $10) {print $2 "\t" $9 "\t" $10} else {{print $2 "\t" $10 "\t" $9}}}' > agh_Y2.txt
grep 'NODE_65428_length_363_cov_4' aa_blast.txt | awk '{if ($9 < $10) {print $2 "\t" $9 "\t" $10} else {{print $2 "\t" $10 "\t" $9}}}' > agh_Y3.txt

#results should be:
# contig113427    13093   13278
# contig113427    11776   11868
# contig113427    14242   14334
# contig113427    14488   14562
# contig14679     335     421
# contig67161     25498   25629
# contig67161     24241   24336
# NODE_44048_length_535_cov_2.969828      130     366
# NODE_38289_length_618_cov_5.647166      219     503
# NODE_65428_length_363_cov_4.945205      71      163

for COPY in 1 2 3 Y1 Y2 Y3
do
  for SAMPLE in Fpool Mpool
  do
    sambamba depth region -L agh_${COPY}.txt -t 4 \
      -o cur_depth_agh_${COPY}.txt \
      -F '(mapping_quality > 0) and (not duplicate) and (not failed_quality_control) and (not supplementary) and (proper_pair)' \
      ../${SAMPLE}_bwa.bam
    grep -v '^#' cur_depth_agh_${COPY}.txt | awk -v contig="agh"_${COPY} 'BEGIN {len=0; cov=0} {curlen = $3 - $2 + 1; len += curlen; cov += (curlen * $5)} END {print contig "\t" (cov/len)}' > agh_${COPY}_cov_${SAMPLE}.txt
  done
done


module load bedtools/gnu/2.26.0
module load samtools/1.9

#now try to get GC content for the associated regions so we can see if there is a correlation between GC content and sequencing depth (because there is a lot of variation in sequencing depth)

#remove the GC file if it's there from a previous run
touch gc_agh.txt
rm gc_agh.txt

for COPY in 1 2 3 Y1 Y2 Y3
do
  grep -v '^#' agh_${COPY}.txt | awk '{if ($2 > 100) {print $1 "\t" $2 - 100 "\t" $3 + 100} else {print $1 "\t" 1 "\t" $3 + 100}}' | sort -k 2n,2n > agh_${COPY}_exons_expanded.bed
  bedtools merge -i agh_${COPY}_exons_expanded.bed > agh_${COPY}_exons_expanded_merged.bed
  CONTIG=`cut -f 1 agh_${COPY}_exons_expanded_merged.bed | sort | uniq`
  samtools faidx ${CONTIGS} ${CONTIG} > cur_contig.fasta
  seqtk comp -r agh_${COPY}_exons_expanded_merged.bed cur_contig.fasta | awk -v contig="agh_"${COPY} 'BEGIN {gc=0; at=0} {gc += ($5 + $6); at += ($4 + $7)} END {print contig "\t" (gc/(gc+at))}' >> gc_agh.txt
done

cd ../
mkdir -p busco_gc
cd busco_gc
cp -r ../busco_cov/gffs .
cp ../busco_cov/complete_singlecopy_buscos.txt .
touch gc_busco.txt
rm gc_busco.txt
while read X
do
  grep 'exon' gffs/${X}.gff | awk '{print $1 "\t" $4 "\t" $5}' > cur_regions.txt 
  N=`wc -l cur_regions.txt | awk '{print $1}'`
  #some of the complete single-copy buscos seem to be missing GFFs, for some reason
  if [ $N -lt 1 ]
  then
    echo 'Missing ' $X
  else
    echo 'Doing ' $X
    grep -v '^#' cur_regions.txt | awk '{print $1 "\t" $2 - 100 "\t" $3 + 100}' | sort -k 2n,2n > cur_regions_expanded.bed
    CONTIG=`cut -f 1 cur_regions_expanded.bed | sort | uniq`
    samtools faidx ${CONTIGS} ${CONTIG} > cur_contig.fasta
    seqtk comp cur_contig.fasta > cur_comp.txt
    CONTIGLEN=`cut -f 2 cur_comp.txt`
    cat cur_regions_expanded.bed | awk -v contiglen=${CONTIGLEN} '{if ($2 < 1) {$2 = 1}; if ($3 > contiglen) {$3 = contiglen}; print $1 "\t" $2 "\t" $3}' > cur_regions_expanded_fixed.bed
    bedtools merge -i cur_regions_expanded_fixed.bed > cur_regions_expanded_merged.bed
    seqtk comp -r cur_regions_expanded_merged.bed cur_contig.fasta | awk -v contig=${X} 'BEGIN {gc=0; at=0} {gc += ($5 + $6); at += ($4 + $7)} END {print contig "\t" (gc/(gc+at))}' >> gc_busco.txt
  fi
done < complete_singlecopy_buscos.txt

cd ..
mkdir -p compiled
cd compiled

cp ../agh_cov/gc_agh.txt .
cat ../agh_cov/*cov_Fpool.txt > agh_cov_Fpool.txt
cat ../agh_cov/*cov_Mpool.txt > agh_cov_Mpool.txt

cp ../busco_gc/gc_busco.txt .
cp ../busco_cov/busco_cov_Fpool.txt .
cp ../busco_cov/busco_cov_Mpool.txt .

cat gc_busco.txt gc_agh.txt | sort -k 1,1 > gc_combined.txt
cat busco_cov_Fpool.txt agh_cov_Fpool.txt | sort -k 1,1 > cov_Fpool.txt
cat busco_cov_Mpool.txt agh_cov_Mpool.txt | sort -k 1,1 > cov_Mpool.txt


join -a 1 -a 2 -e 0 gc_combined.txt cov_Fpool.txt > TEMP

join -a 1 -a 2 -o 1.1 1.2 2.2 -e 0 gc_combined.txt cov_Fpool.txt > TEMP
join -a 1 -a 2 -o 1.1 1.2 1.3 2.2 -e 0 TEMP cov_Mpool.txt > compiled_cov_gc.txt

rm TEMP





#agh2 seems to have 0 coverage in both samples, but it's near the end of the contig
#get coverage of rest of contig and only ~85 bp total, whereas agh1 and 2 are ~440 and ~225
#even the y-linked ones are bigger
#33268 
rm agh2_fullcontig.bed
for ((S=300; S<=32500; S+=500))
do
  E=`expr $S + 500`
  echo -e "contig14679\t"$S"\t"$E >> agh2_fullcontig.bed
done

for SAMPLE in Mpool Fpool
do
  sambamba depth region -L agh2_fullcontig.bed -t 4 \
    -o agh2_fullcontig_cov_${SAMPLE}.txt \
    -F '(mapping_quality > 0) and (not duplicate) and (not failed_quality_control) and (not supplementary) and (proper_pair)' \
    ../${SAMPLE}_bwa.bam
done

#3800 - 9800
samtools faidx ${CONTIGS} contig14679:3800-9800