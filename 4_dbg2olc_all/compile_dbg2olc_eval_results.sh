#!/bin/bash
#PBS -k o 
#PBS -l nodes=1:ppn=4,vmem=64gb,walltime=80:00:00
#PBS -M cholden23@gmail.com
#PBS -m abe 
#PBS -N dbg2olc_NNN
#PBS -j oe 

#####################################################
#####################################################


cd /N/dc2/scratch/chrichan/trachelipus_assembly
cd all_dbg2olc
mkdir -p compiled
cd compiled

touch compiled_stats.txt
rm compiled_stats.txt

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
          DIRNAME=${CORRECTOR}_k${K}_kct${KMERCOVTHRESH}_mo${MINOVERLAP}_l${MINLEN}
          
          REPORTFILE=../${DIRNAME}/quast_results/report.tsv
          if test -f "${REPORTFILE}"
          then
                    
            #total size
            TOTSIZE=`grep "Total\ length" ../${DIRNAME}/quast_results/report.tsv | cut -f 2 | head -1`
            
            #n50
            N50=`grep "N50" ../${DIRNAME}/quast_results/report.tsv | cut -f 2 | head -1`
            
            #number of contigs
            NCONTIGS=`grep "^\# contigs" ../${DIRNAME}/quast_results/report.tsv | cut -f 2 | head -1`
            
            #longest contig
            LARGESTCONTIG=`grep "Largest\ contig" ../${DIRNAME}/quast_results/report.tsv | cut -f 2 | head -1`
            
            echo -e ${N}"\t"${DIRNAME}"\t"${TOTSIZE}"\t"${N50}"\t"${NCONTIGS}"\t"${LARGESTCONTIG} >> compiled_stats.txt
            
          fi
          ((N+=1))
        done
      done
    done
  done
done

sort -k 3nr,3nr compiled_stats.txt 