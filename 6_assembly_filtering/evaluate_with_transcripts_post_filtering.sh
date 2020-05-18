
#blast all transcripts against the assembly
blastn -num_threads 2 -task blastn -evalue 0.01 -query test.fasta -db corrected.fasta -outfmt '6 qseqid sseqid evalue bitscore length pident qlen qstart qend qcovs' > test_blast.txt

#get best coverage per subject for each transcript, along with percent identity
cat test_blast.txt | sort -k 1,1 -k 10nr,10nr | awk 'BEGIN {last="X"} {if (($1 != last) && last != "X") {print $0}; last = $1}' | cut -f 1,2,6,10 | less

cat test_blast.txt | sort -k 1,1 -k 10nr,10nr | awk 'BEGIN {last="X"} {if (($1 != last) && last != "X") {print $0}; last = $1}' | cut -f 1,2,6,10 | awk '{if (($3 >= 80) && ($4 >= 80)) {print $0}}' | wc -l


#probably not reasonable to expect transcripts to be ALL on one contig (subject)
#re-write script to retain all BLAST hits above a certain % id thresh
#then an R script to analyze (using qstart qend) breadth of coverage across ALL
# blast hits