cd /N/dc2/scratch/chrichan/trachelipus_assembly
cd all_dbg2olc
mkdir -p scripts
cd scripts

N=1
for CORRECTOR in lordec fmlrc
do
  for K in 17 19
  do
    for KMERCOVTHRESH in 2 5
    do
      for MINOVERLAP in 10 30
      do
        for MINLEN in 100 200
        do
          echo $N
          sed "s/AAA/${CORRECTOR}/g" dbg2olc_template.sh | \
            sed "s/BBB/${K}/g" | \
            sed "s/CCC/${KMERCOVTHRESH}/g" | \
            sed "s/DDD/${MINOVERLAP}/g" | \
            sed "s/EEE/${MINLEN}/g" | \
            sed "s/NNN/${N}/g" \
            > dbg2olc_${N}.sh
          qsub dbg2olc_${N}.sh
          ((N+=1))
        done
      done
    done
  done
done


#####################################################
#####################################################

CORRECTOR=AAA
# lordec fmlrc

K=BBB
# 17 19

KMERCOVTHRESH=CCC
# 2 5 

MINOVERLAP=DDD
# 10 30

MINLEN=EEE
# 100 200

