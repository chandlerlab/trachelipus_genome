cov.data <- read.table("compiled_cov_gc.txt", stringsAsFactors=F, col.names=c("gene", "gc", "cov.F", "cov.M"))
cov.data$cov.mean <- (cov.data$cov.F + cov.data$cov.M)/2


busco.data <- cov.data[grep(pattern="^[^agh]", cov.data$gene),]
agh.data <- cov.data[grep(pattern="^agh", cov.data$gene),]

plot(x=busco.data$gc, y=busco.data$cov.mean)

plot(x=busco.data$cov.F, y=busco.data$cov.M)

#my.points <- identify(x=busco.data$cov.F, y=busco.data$cov.M)
#busco.data[my.points,]

mean(busco.data$cov.F)
mean(busco.data$cov.M)

hist(busco.data$gc, breaks=25, col="#00000044", border="#00000000")

busco.data <- busco.data[order(busco.data$gc),]
num.rows <- nrow(busco.data)
percent <- 100
keep.start <- round((num.rows/2) - (num.rows * percent / 100 / 2)) + 1
keep.end <- round((num.rows/2) + (num.rows * percent / 100 / 2))
busco.data <- busco.data[keep.start:keep.end,]
#busco.data <- busco.data[(busco.data$gc >= 0.2) & (busco.data$gc < 0.3),]

#format gene names so text looks consistent with other figures
agh.data$gene <- toupper(agh.data$gene)
agh.data$gene <- sub(pattern="_", replacement="", x=agh.data$gene)

print(nrow(busco.data))

violin.data <- data.frame(	cov=c(busco.data$cov.F, busco.data$cov.M), 
                            sample=rep(c("F", "M"), each=nrow(busco.data))
                         )


violin.data.agh <- data.frame(	cov=c(agh.data$cov.F, agh.data$cov.M),
								sample=rep(c("F", "M"), each=nrow(agh.data)),
								label=rep(agh.data$gene, 2)
							)


library(ggplot2)
library(Hmisc)
library(ggrepel)

my.stat.summary <- function(x) {
	m <- mean(x)
	ymin <- m - sd(x)
	ymax <- m + sd(x)
	return(c(y=m, ymin=ymin, ymax=ymax))
}

p <- ggplot(violin.data, aes(x=sample, y=cov, color=sample, fill=sample)) +
     geom_violin(trim=F) +
     coord_flip() +
     geom_point(data=violin.data.agh, mapping=aes(x=sample, y=cov), color="black") +
     geom_label_repel(inherit.aes=F, mapping=aes(x=sample, y=cov, label=label), data=violin.data.agh, min.segment.length=0, force=22) +
     labs(x="Sample", y="Coverage") +
     scale_y_continuous(breaks=seq(from=0, to=100, by=20), limits=c(0,100)) +
     theme(legend.position="none", panel.background=element_rect(fill="#FFFFFF00"), panel.border=element_rect(fill=NA, linetype="solid"), panel.grid.major=element_line(size=0.5, color="grey90")) +
     scale_fill_manual(values=c("#FF000011", "#0000FF11")) +
     scale_color_manual(values=c("#FF0000", "#0000FF"))
     
hapcov <- 28

p + geom_hline(color="black", yintercept=hapcov, linetype="dotted") + geom_hline(mapping=aes(color="black"), yintercept=hapcov*2, linetype="dotted") + geom_dotplot(binaxis="y", stackdir="center", dotsize=0.5, color="#00000000", fill="#00000021")







hapcov <- 22

p2 <- ggplot(violin.data, aes(x=sample, y=cov, color=sample, fill=sample)) +
     #geom_hline(color="#00000099", yintercept=hapcov, linetype="dotted") + 
     geom_violin(trim=F) +
     coord_flip() +
     #geom_hline(mapping=aes(color="black"), yintercept=hapcov*2, linetype="dotted") +
     geom_dotplot(binaxis="y", stackdir="center", dotsize=0.5, color="#00000000", fill="#00000021", binwidth=2) +
     geom_point(data=violin.data.agh, mapping=aes(x=sample, y=cov), color="black") +
     geom_label_repel(inherit.aes=F, mapping=aes(x=sample, y=cov, label=label), data=violin.data.agh, min.segment.length=0, force=22) +
     labs(x="Sample", y="Coverage") +
     scale_y_continuous(breaks=seq(from=0, to=100, by=20), limits=c(0,100)) +
     theme(legend.position="none", panel.background=element_rect(fill="#FFFFFF00"), panel.border=element_rect(fill=NA, linetype="solid"), panel.grid.major=element_line(size=0.5, color="grey90")) +
     scale_fill_manual(values=c("#FF000011", "#0000FF11")) +
     scale_color_manual(values=c("#FF0000", "#0000FF"))
     
p2
