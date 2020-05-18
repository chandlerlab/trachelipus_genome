cifA.data <- read.table(file="tblastn_results_full_cifA.txt", col.names=c("qseqid", "sseqid", "evalue", "bitscore", "length", "qstart", "qend", "sstart", "send", "pident", "qlen", "slen"), stringsAsFactors=F)
cifB.data <- read.table(file="tblastn_results_full_cifB.txt", col.names=c("qseqid", "sseqid", "evalue", "bitscore", "length", "qstart", "qend", "sstart", "send", "pident", "qlen", "slen"), stringsAsFactors=F)

cifA.data$gene <- "cifA"
cifB.data$gene <- "cifB"

str(cifA.data)

all.data <- rbind(cifA.data, cifB.data)

all.data$strand <- ifelse(all.data$sstart < all.data$send, "+", "-")

all.data$leftcoord <- ifelse(all.data$sstart < all.data$send, all.data$sstart, all.data$send)
all.data$rightcoord <- ifelse(all.data$sstart < all.data$send, all.data$send, all.data$sstart)

matching.contigs <- unique(sort(all.data$sseqid))
n.matching.contigs <- length(matching.contigs)

contig.buffer <- 900
buffer <- 1700

contig.line <- "#00000000"
contig.fill <- "#000000FF"

diff.threshold <- 12

pdf(file="cifAcifBplots.pdf", width=8, height=8)

par(mfrow=c(3,2))
#############
for (n in 1:n.matching.contigs) {
#n <- 1

	cur.contig <- matching.contigs[n]
	cur.data <- all.data[all.data$sseqid == cur.contig,]
	contig.len <- cur.data$slen[1]
	
	cur.data <- cur.data[order(cur.data$leftcoord),]
	cur.data$keep <- F
	#get the best query for each of the genes (best one for cifA and best one for cifB)
	for (gene in c("cifA", "cifB")) {
		temp.data <- cur.data[cur.data$gene==gene,]
		temp.queries <- unique(sort(temp.data$qseqid))
		bitscore.sums <- rep(0, length(temp.queries))
		for (q in 1:length(temp.queries)) {
			cur.query <- temp.queries[q]
			bitscore.sums[q] <- sum(temp.data$bitscore[temp.data$qseqid==cur.query])
		}
		best.query <- temp.queries[which.max(bitscore.sums)[1]]
		cur.data$keep[cur.data$qseqid==best.query] <- T
	}
	cur.data <- cur.data[cur.data$keep,]
	
	#plot coordinates
	cur.data <- cur.data[cur.data$keep,]
	cur.data$plot.y <- 1
	if (nrow(cur.data) > 1) {
		for (r in 2:nrow(cur.data)) {
			if (cur.data$leftcoord[r] <= (cur.data$rightcoord[r-1] + buffer)) {
				cur.data$plot.y[r] <- cur.data$plot.y[r-1] + 1
			}
		}		
	}
	cur.data$plot.y <- cur.data$plot.y * -1
	box.width <- (1 - (min(cur.data$plot.y)))* 0.1
	
	cur.xlim <- c(min(cur.data$leftcoord) - contig.buffer, max(cur.data$rightcoord) + contig.buffer)

	if (n >= 7) {
		par(mar=c(4,1,1,1))
	} else {
		par(mar=c(3,1,1,1))
	}
	plot(x=NULL, y=NULL, xlim=cur.xlim, ylim=c(min(cur.data$plot.y), 1), xlab="Contig coordinates (bp)", yaxt="n")
	
	#draw the contig
	rect(xleft=0, xright=contig.len, ytop=0.5 + (box.width/2), ybottom=0.5 - (box.width/2), col=contig.fill, border=contig.line)
	text(x=mean(cur.xlim), y=0.5, cur.contig, col="#FFFFFF", cex=1)
		
	cur.data <- cur.data[order(cur.data$sstart),]
	print(cur.data[order(cur.data$qseqid),])
	
	for (r in 1:nrow(cur.data)) {
		lines(x=c(cur.data$leftcoord[r], cur.data$rightcoord[r]), y=rep(cur.data$plot.y[r] + 0.5, 2))
		
		#label the gene (cifA or cifB)
		text(cur.data$gene[r], x=mean(c(cur.data$rightcoord[r], cur.data$leftcoord[r])), y=cur.data$plot.y[r] + 0.5, adj=c(0.5, -0.5), cex=0.85)
		
		#label the gene with the exact accession number of the hit
		text(cur.data$qseqid[r], x=mean(c(cur.data$rightcoord[r], cur.data$leftcoord[r])), y=cur.data$plot.y[r] + 0.5, adj=c(0.5, 1.85), cex=0.5)
		
		adj.1 <- ifelse(cur.data$strand[r]=="+", c(1.2, 0), c(-0.2, 0))
		adj.2 <- ifelse(cur.data$strand[r]=="+", c(-0.2, 0), c(1.2, 0))
		#text(as.character(cur.data$qstart[r]), x=cur.data$sstart[r], y=cur.data$plot.y[r] + 0.5, adj=c(0.5, 1.5), cex=0.5)
		#text(as.character(cur.data$qend[r]), x=cur.data$send[r], y=cur.data$plot.y[r] + 0.5, adj=c(0.5, 1.5), cex=0.5)
		
		#label the amino acid start and end points
		text(as.character(cur.data$qstart[r]), x=cur.data$sstart[r], y=cur.data$plot.y[r] + 0.5, adj=adj.1, cex=0.65)
		text(as.character(cur.data$qend[r]), x=cur.data$send[r], y=cur.data$plot.y[r] + 0.5, adj=adj.2, cex=0.65)
	}
}





dev.off()





sorted.data <- cifA.data
sorted.data <- sorted.data[order(sorted.data$sstart),]
sorted.data <- sorted.data[order(sorted.data$sseqid),]


