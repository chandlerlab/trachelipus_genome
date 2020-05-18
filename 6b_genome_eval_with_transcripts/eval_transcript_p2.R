
summary.results <- read.table("genome_blast_summary.txt", col.names=c("contig", "length", "covered", "pcov"), stringsAsFactors=F)

hist(summary.results$pcov, breaks=100, col="#000000")

nrow(summary.results)

#there are 15805 arthropod transcripts total that went into the original BLAST search



sum(summary.results$pcov >= 80)

#10813 total at 80% coverage

10813 / 15805 * 100




sum(summary.results$pcov >= 90)

#8422 total at 90% coverage

8422 / 15805 * 100




sum(summary.results$pcov >= 95)

#6897 total at 95% coverage

6897 / 15805 * 100

