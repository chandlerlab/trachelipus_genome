library(GenomicRanges)

all.data <- read.table(file="transcript_blast.txt", stringsAsFactors=F, col.names=c("query", "hit", "evalue", "bitscore", "length", "pident", "qlen", "qstart", "qend", "qcovs"))

all.data$start <- ifelse(all.data$qstart < all.data$qend, all.data$qstart, all.data$qend)
all.data$end <- ifelse(all.data$qstart < all.data$qend, all.data$qend, all.data$qstart)

all.data <- all.data[all.data$pident >= 90,]

raw.ranges <- GRanges(
    seqnames = all.data$query,
    ranges = IRanges(start=all.data$start, end=all.data$end),
)

reduced.ranges <- reduce(raw.ranges)

summary.results <- data.frame(	transcript=unique(sort(all.data$query)),
								seqlen=NA,
								covered=NA,
								perc.cov=NA)
								
for (i in 1:nrow(summary.results)) {
	cur.seq <- summary.results$transcript[i]
	cur.len <- all.data[all.data$query==cur.seq,]$qlen[1]
	summary.results$seqlen[i] <- cur.len
	cur.ranges <- reduced.ranges[reduced.ranges@seqnames==cur.seq]
	cur.cov <- sum(cur.ranges@ranges@width)
	summary.results$covered[i] <- cur.cov
}

summary.results$perc.cov <- summary.results$covered / summary.results$seqlen * 100

write.table(summary.results, file="genome_blast_summary.txt", quote=F, sep="\t", row.names=F, col.names=F)


######

