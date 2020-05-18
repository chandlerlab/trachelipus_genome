#generate files

LONG_SAMPLE=ont_M
SHORT_SAMPLE=Mpool
for CHUNK in 001 002 003 004 005 006 007 008
do
  sed "s/XXX/${CHUNK}/g" fmlrc_template.sh | sed "s/YYY/${LONG_SAMPLE}/g" | sed "s/ZZZ/${SHORT_SAMPLE}/g" > fmlrc_${LONG_SAMPLE}_${CHUNK}.sh
done


LONG_SAMPLE=pb_M
SHORT_SAMPLE=Mpool
for CHUNK in 002 003 004
do
  sed "s/XXX/${CHUNK}/g" fmlrc_template.sh | sed "s/YYY/${LONG_SAMPLE}/g" | sed "s/ZZZ/${SHORT_SAMPLE}/g" > fmlrc_${LONG_SAMPLE}_${CHUNK}.sh
done


LONG_SAMPLE=pb_F
SHORT_SAMPLE=Fpool
for CHUNK in 001 002 003 004 005 006 007 008 009 010 011 012 013 014 015 016 017 018 019 020 021 022 023 024
do
  sed "s/XXX/${CHUNK}/g" fmlrc_template.sh | sed "s/YYY/${LONG_SAMPLE}/g" | sed "s/ZZZ/${SHORT_SAMPLE}/g" > fmlrc_${LONG_SAMPLE}_${CHUNK}.sh
done


#submit

LONG_SAMPLE=ont_M
SHORT_SAMPLE=Mpool
for CHUNK in 002 003 004 005 006 007 008
do
  qsub fmlrc_${LONG_SAMPLE}_${CHUNK}.sh
done


LONG_SAMPLE=pb_M
SHORT_SAMPLE=Mpool
for CHUNK in 002 003 004
do
  qsub fmlrc_${LONG_SAMPLE}_${CHUNK}.sh
done


LONG_SAMPLE=pb_F
SHORT_SAMPLE=Fpool
for CHUNK in 001 002 003 004 005 006 007 008 009 010 011 012 013 014 015 016 017 018 019 020 021 022 023 024
do
  qsub fmlrc_${LONG_SAMPLE}_${CHUNK}.sh
done
