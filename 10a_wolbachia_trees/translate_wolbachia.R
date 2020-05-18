args <- commandArgs(trailingOnly=T)

blast.file <- args[1]
#blast.file <- "best_wolbachia_longhits.txt"

rename.dict <- read.csv("full_dictionary.txt", stringsAsFactors=F, header=F, col.names=c("contig", "translated.name"))

blast.data <- read.table(file=blast.file, stringsAsFactors=F, col.names=c("qseqid", "sseqid", "evalue", "bitscore", "length", "pident", "qstart", "qend", "sstart", "send", "sstrand", "qlen", "qseq", "sseq"), header=F)

matching.index <- match(blast.data$sseqid, rename.dict$contig)

blast.data$genome <- rename.dict$translated.name[matching.index]

write.table(x=blast.data, file=args[2], quote=F, sep="\t", row.names=F, col.names=F)