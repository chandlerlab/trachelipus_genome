
plot.ymin <- 0
plot.height <- 4.5

contig.height <- 1.20
contig.border <- "#AAAAAA"
contig.color <- "#CCCCCC"

exon.height <- 1.35
exon.border <- "#AA3333"
exon.color <- "#CC5555"

intron.height <- 0.10
intron.lty <- 1
intron.color <- "#000000"

transcript.border <- "#33AA33"
transcript.color <- "#55CC55"

blast.border.f <- "#3333AA55"
blast.color.f <- "#5555CC55"
blast.border.r <- "#AA33AA55"
blast.color.r <- "#CC55CC55"

match.gap <- 0.2

#read the contig length data
contig.data <- read.csv(file="contiglens.csv", col.names=c("contig", "end"), stringsAsFactors=F, header=F)


#read the BLAST data
all.blast.data <- read.table("all_unmasked_comparison.txt", col.names=c("query", "target", "pident", "length", "mismatch", "gapopen", "qstart", "qend", "sstart", "send", "evalue", "bitscore"))

#read the annotation data
annotation.data <- read.table("agh_annotation_genes.gff", col.names=c("contig", "source", "type", "start", "end", "dot", "strand", "dot2", "notes"), stringsAsFactors=F)


#parameters
contig.y <- 1.25
transcript.y <- 3.75

plot.contig <- function(cur.contig, nickname="", window.plot.start=0, window.plot.width=4800, plot.scale=F) {

	
	#set up the plotting window
	par(mar=rep(0.5,4))
	plot(x=NULL, y=NULL, xlim=c(window.plot.start, window.plot.width), ylim=c(plot.ymin, plot.height), bty="n", xaxt="n", yaxt="n")
	
	#plot the contig with annotations
	cur.contig.len <- contig.data$end[contig.data$contig==cur.contig][1]
	cur.data <- all.blast.data[(all.blast.data$query=="expressed_cds") & (all.blast.data$target==cur.contig),]
	cur.annotations <- annotation.data[(annotation.data$contig==cur.contig) & (annotation.data$type=="exon"),]
	cur.annotations$transl.start <- seq(from=cur.contig.len, to=1, by=-1)[cur.annotations$end]
	cur.annotations$transl.end <- seq(from=cur.contig.len, to=1, by=-1)[cur.annotations$start]
	
	all.coords <- c(cur.annotations$transl.start, cur.annotations$transl.end, cur.data$sstart, cur.data$send)
	plot.start <- min(all.coords) - 100
	plot.end <- max(all.coords) + 100
	contig.offset <- ((plot.start + plot.end) / -2) + (window.plot.width / 2)
	
	contig.top <- contig.y + (contig.height/2)
	contig.bottom <- contig.y - (contig.height/2)
	rect(xleft=contig.offset, xright=contig.offset+cur.contig.len, ybottom=contig.bottom, ytop=contig.top, border=contig.border, col=contig.color)
	
	
	exon.top <- contig.y + (exon.height / 2)
	exon.bottom <- contig.y - (exon.height / 2)
	
	intron.bottom <- exon.top
	intron.top <- intron.bottom + intron.height
	
	
	
	if (nrow(cur.annotations) >= 2) {
	
	    rect(xleft=cur.annotations$transl.start[1]+contig.offset, xright=cur.annotations$transl.end[1]+contig.offset, ytop=exon.top, ybottom=exon.bottom, border=exon.border, col=exon.color)

		for (e in 2:nrow(cur.annotations)) {
			intron.left <- cur.annotations$transl.end[e-1] + contig.offset
			intron.right <- cur.annotations$transl.start[e] + contig.offset
			intron.mid <- ((intron.left + intron.right)/2)
			lines(x=c(intron.left, intron.mid, intron.right), y=c(intron.bottom, intron.top, intron.bottom), lty=intron.lty, col=intron.color)
			rect(xleft= cur.annotations$transl.start[e] + contig.offset, xright= cur.annotations$transl.end[e] + contig.offset, ytop=exon.top, ybottom=exon.bottom, border=exon.border, col=exon.color)
		}
	}
	
	#plot the transcript
	transcript.len <- contig.data$end[contig.data$contig=="expressed_cds"][1]
	
	transcript.offset <- ((transcript.len) / -2) + (window.plot.width / 2)
	
	transcript.top <- transcript.y + (contig.height/2)
	transcript.bottom <- transcript.y - (contig.height/2)
	rect(xleft=transcript.offset, xright=transcript.offset+transcript.len, ybottom=transcript.bottom, ytop=transcript.top, border=transcript.border, col=transcript.color)
	
	#plot matches to transcript
	for (r in 1:nrow(cur.data)) {
		match.t.left <- cur.data$qstart[r]
		match.t.right <- cur.data$qend[r]
		match.c.left <- cur.data$sstart[r]
		match.c.right <- cur.data$send[r]
		match.strand <- ifelse(match.c.left <= match.c.right, "plus", "minus")
		if (match.strand == "plus") {
			cur.match.border <- blast.border.f
			cur.match.color <- blast.color.f
		} else {
			cur.match.border <- blast.border.r
			cur.match.color <- blast.color.r	
		}
		polygon(	x=c(match.t.left + transcript.offset, match.t.right + transcript.offset, match.c.right + contig.offset, match.c.left + contig.offset),
					y=c(transcript.bottom - match.gap, transcript.bottom - match.gap, contig.top + match.gap, contig.top + match.gap), border=cur.match.border, col=cur.match.color)
	}
	
	
	#plot the contig name
	text(paste(nickname, cur.contig, sep=", "), x=(window.plot.start + window.plot.width)/2, y=contig.bottom, adj=c(0.5,1.75))
	
	#plot a scale
	if (plot.scale) {
		scale.left <- transcript.offset+transcript.len + 1000
		scale.right <- scale.left + 500
		scale.y <- (transcript.bottom + transcript.top) /2
		lines(x=c(scale.left, scale.right), y=c(scale.y, scale.y))
		text("500 bp", x=(scale.left+scale.right)/2, y=scale.y, adj=c(0.5, 1.5))
	}

}



par(mfcol=c(3,2))

plot.contig("contig113427", nickname="AGH1", plot.scale=T)
plot.contig("contig14679", nickname="AGH2")
plot.contig("contig67161", nickname="AGH3")
plot.contig("NODE_44048_length_535_cov_2.969828", nickname="AGHY1")
plot.contig("NODE_38289_length_618_cov_5.647166", nickname="AGHY2")
plot.contig("NODE_65428_length_363_cov_4.945205", nickname="AGHY3")