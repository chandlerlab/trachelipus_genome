cd /N/dc2/scratch/chrichan/trachelipus_assembly
mkdir -p fmlrc_corrected_longreads

cd fmlrc 

DEST=/N/dc2/scratch/chrichan/trachelipus_assembly/fmlrc_corrected_longreads

cp temp_ont_F/ont_F.corrected.fasta ${DEST}

SAMPLE=ont_M
cat temp_${SAMPLE}_001/${SAMPLE}.001.corrected.fasta > ${DEST}/${SAMPLE}.fasta
for N in 002 003 004 005 006 007 008
do
  cat temp_${SAMPLE}_${N}/${SAMPLE}.${N}.corrected.fasta >> ${DEST}/${SAMPLE}.fasta
done


SAMPLE=pb_M
cat temp_${SAMPLE}_001/${SAMPLE}.001.corrected.fasta > ${DEST}/${SAMPLE}.fasta
for N in 002 003 004
do
  cat temp_${SAMPLE}_${N}/${SAMPLE}.${N}.corrected.fasta >> ${DEST}/${SAMPLE}.fasta
done


SAMPLE=pb_F
cat temp_${SAMPLE}_001/${SAMPLE}.001.corrected.fasta > ${DEST}/${SAMPLE}.fasta
for N in 002 003 004 005 006 007 008 009 010 011 012 013 014 015 016 017 018 019 020 021 022 023 024
do
  cat temp_${SAMPLE}_${N}/${SAMPLE}.${N}.corrected.fasta >> ${DEST}/${SAMPLE}.fasta
done


LEN=1500
for SAMPLE in ont_M ont_F pb_M pb_F
do
  seqtk seq -L ${LEN} ${SAMPLE}.corrected.fasta > ${SAMPLE}.${LEN}.corrected.fasta
done