#Read in the data
te.data <- read.csv(file="te_data.csv", header=T)

genome.size <- 5181251014 
fraction.sampled <- 0.010


#Create a length column so that we can plot histograms of cumulative sequence length, not # of elements
te.data$length <- abs(te.data$qend - te.data$qstart)

#And calculate cumulative proportions rather than total length
te.data$proportion <- (te.data$length / (genome.size * fraction.sampled))


#Exclude simple repeats -- there are lots of these but they are not of interest in this plot
te.data <- te.data[te.data$family != "Simple_repeat",]

#Create a family column without subfamilies for less messy plotting
te.data$family.broad <- as.character(te.data$family)

library(ggplot2)
#library(RColorBrewer)

#Create a custom color palette so that we can distinguish different classes of TEs
all.levels <- levels(te.data$family)

all.colors <- rep("#000000", length(all.levels))

#DON'T CHANGE THIS STUFF

cur.tes <- "DNA"
cur.levels <- grep(pattern=cur.tes, x=all.levels)
all.colors[cur.levels] <- colorRampPalette(c(rgb(255,0,0, alpha=220, maxColorValue=255), rgb(230,50,50, alpha=220, maxColorValue=255)), alpha=T)(length(cur.levels))
cur.rows <- grep(pattern=cur.tes, x=te.data$family)
te.data$family.broad[cur.rows] <- cur.tes

cur.tes <- "LINE"
cur.levels <- grep(pattern=cur.tes, x=all.levels)
all.colors[cur.levels] <- colorRampPalette(c(rgb(0,200,0, alpha=220, maxColorValue=255), rgb(20,150,20, alpha=220, maxColorValue=255)), alpha=T)(length(cur.levels))
cur.rows <- grep(pattern=cur.tes, x=te.data$family)
te.data$family.broad[cur.rows] <- cur.tes


cur.tes <- "LTR"
cur.levels <- grep(pattern=cur.tes, x=all.levels)
all.colors[cur.levels] <- colorRampPalette(c(rgb(0,0,255, alpha=220, maxColorValue=255), rgb(50,50,255, alpha=220, maxColorValue=255)), alpha=T)(length(cur.levels))
cur.rows <- grep(pattern=cur.tes, x=te.data$family)
te.data$family.broad[cur.rows] <- cur.tes

cur.tes <- "nonLTR"
cur.levels <- grep(pattern=cur.tes, x=all.levels)
all.colors[cur.levels] <- colorRampPalette(c(rgb(200,100,100, alpha=220, maxColorValue=255), rgb(250,100,100, alpha=220, maxColorValue=255)), alpha=T)(length(cur.levels))
cur.rows <- grep(pattern=cur.tes, x=te.data$family)
te.data$family.broad[cur.rows] <- cur.tes


cur.tes <- "Simple_repeat"
cur.levels <- grep(pattern=cur.tes, x=all.levels)
all.colors[cur.levels] <- colorRampPalette(c(rgb(255,0,255, alpha=220, maxColorValue=255), rgb(250,50,255, alpha=220, maxColorValue=255)), alpha=T)(length(cur.levels))
cur.rows <- grep(pattern=cur.tes, x=te.data$family)
te.data$family.broad[cur.rows] <- cur.tes


cur.tes <- "Low_complexity"
cur.levels <- grep(pattern=cur.tes, x=all.levels)
all.colors[cur.levels] <- colorRampPalette(c(rgb(0,255,255, alpha=220, maxColorValue=255), rgb(20,230,230, alpha=220, maxColorValue=255)), alpha=T)(length(cur.levels))
cur.rows <- grep(pattern=cur.tes, x=te.data$family)
te.data$family.broad[cur.rows] <- cur.tes


cur.tes <- "RC"
cur.levels <- grep(pattern=cur.tes, x=all.levels)
all.colors[cur.levels] <- colorRampPalette(c(rgb(75,75,75, alpha=220, maxColorValue=255), rgb(75,75,75, alpha=220, maxColorValue=255)), alpha=T)(length(cur.levels))
cur.rows <- grep(pattern=cur.tes, x=te.data$family)
te.data$family.broad[cur.rows] <- cur.tes

cur.tes <- "Retro"
cur.levels <- grep(pattern=cur.tes, x=all.levels)
all.colors[cur.levels] <- colorRampPalette(c(rgb(220,90,220, alpha=220, maxColorValue=255), rgb(250, 80, 250, alpha=220, maxColorValue=255)), alpha=T)(length(cur.levels))
cur.rows <- grep(pattern=cur.tes, x=te.data$family)
te.data$family.broad[cur.rows] <- cur.tes

cur.tes <- "rRNA"
cur.levels <- grep(pattern=cur.tes, x=all.levels)
all.colors[cur.levels] <- colorRampPalette(c(rgb(90,90,170, alpha=220, maxColorValue=255), rgb(100,100,150, alpha=220, maxColorValue=255)), alpha=T)(length(cur.levels))
cur.rows <- grep(pattern=cur.tes, x=te.data$family)
te.data$family.broad[cur.rows] <- cur.tes


cur.tes <- "Satellite"
cur.levels <- grep(pattern=cur.tes, x=all.levels)
all.colors[cur.levels] <- colorRampPalette(c(rgb(90,250,170, alpha=220, maxColorValue=255), rgb(100,100,150, alpha=220, maxColorValue=255)), alpha=T)(length(cur.levels))
cur.rows <- grep(pattern=cur.tes, x=te.data$family)
te.data$family.broad[cur.rows] <- cur.tes

cur.tes <- "SINE"
cur.levels <- grep(pattern=cur.tes, x=all.levels)
all.colors[cur.levels] <- colorRampPalette(c(rgb(180,100,50, alpha=220, maxColorValue=255), rgb(200,120,20, alpha=220, maxColorValue=255)), alpha=T)(length(cur.levels))
cur.rows <- grep(pattern=cur.tes, x=te.data$family)
te.data$family.broad[cur.rows] <- cur.tes

cur.tes <- "Unknown"
cur.levels <- grep(pattern=cur.tes, x=all.levels)
all.colors[cur.levels] <- colorRampPalette(c(rgb(10,10,10, alpha=220, maxColorValue=255), rgb(10,10,10, alpha=220, maxColorValue=255)), alpha=T)(length(cur.levels))
cur.rows <- grep(pattern=cur.tes, x=te.data$family)
te.data$family.broad[cur.rows] <- cur.tes


#Plot stacked histogram
#ggplot(te.data, aes(pdiv)) +
# geom_histogram(binwidth=0.5, aes(weight=length, fill=family)) +
# scale_fill_manual(values=all.colors)






#########################################################

#HERE IS THE PART TO EDIT!

te.data$family.broad <- factor(te.data$family.broad)

all.levels <- levels(te.data$family.broad)

all.colors <- rep("#000000", length(all.levels))



all.colors <- rep("#000000", length(all.levels))

cur.tes <- "DNA"
cur.levels <- grep(pattern=cur.tes, x=all.levels)
all.colors[cur.levels] <- colorRampPalette(c(rgb(255,0,0, alpha=220, maxColorValue=255), rgb(230,50,50, alpha=220, maxColorValue=255)), alpha=T)(length(cur.levels))


cur.tes <- "LINE"
cur.levels <- grep(pattern=cur.tes, x=all.levels)
all.colors[cur.levels] <- colorRampPalette(c(rgb(0,200,0, alpha=220, maxColorValue=255), rgb(20,150,20, alpha=220, maxColorValue=255)), alpha=T)(length(cur.levels))


cur.tes <- "LTR"
cur.levels <- grep(pattern=cur.tes, x=all.levels)
all.colors[cur.levels] <- colorRampPalette(c(rgb(0,0,255, alpha=220, maxColorValue=255), rgb(50,50,255, alpha=220, maxColorValue=255)), alpha=T)(length(cur.levels))

cur.tes <- "nonLTR"
cur.levels <- grep(pattern=cur.tes, x=all.levels)
all.colors[cur.levels] <- colorRampPalette(c(rgb(200,100,100, alpha=220, maxColorValue=255), rgb(250,100,100, alpha=220, maxColorValue=255)), alpha=T)(length(cur.levels))

cur.tes <- "Simple_repeat"
cur.levels <- grep(pattern=cur.tes, x=all.levels)
all.colors[cur.levels] <- colorRampPalette(c(rgb(255,0,255, alpha=220, maxColorValue=255), rgb(250,50,255, alpha=220, maxColorValue=255)), alpha=T)(length(cur.levels))

cur.tes <- "Low_complexity"
cur.levels <- grep(pattern=cur.tes, x=all.levels)
all.colors[cur.levels] <- colorRampPalette(c(rgb(0,255,255, alpha=220, maxColorValue=255), rgb(20,230,230, alpha=220, maxColorValue=255)), alpha=T)(length(cur.levels))


cur.tes <- "RC"
cur.levels <- grep(pattern=cur.tes, x=all.levels)
all.colors[cur.levels] <- colorRampPalette(c(rgb(75,75,75, alpha=220, maxColorValue=255), rgb(75,75,75, alpha=220, maxColorValue=255)), alpha=T)(length(cur.levels))

cur.tes <- "Retro"
cur.levels <- grep(pattern=cur.tes, x=all.levels)
all.colors[cur.levels] <- colorRampPalette(c(rgb(220,90,220, alpha=220, maxColorValue=255), rgb(250, 80, 250, alpha=220, maxColorValue=255)), alpha=T)(length(cur.levels))

cur.tes <- "rRNA"
cur.levels <- grep(pattern=cur.tes, x=all.levels)
all.colors[cur.levels] <- colorRampPalette(c(rgb(90,90,170, alpha=220, maxColorValue=255), rgb(100,100,150, alpha=220, maxColorValue=255)), alpha=T)(length(cur.levels))


cur.tes <- "Satellite"
cur.levels <- grep(pattern=cur.tes, x=all.levels)
all.colors[cur.levels] <- colorRampPalette(c(rgb(90,250,170, alpha=220, maxColorValue=255), rgb(100,100,150, alpha=220, maxColorValue=255)), alpha=T)(length(cur.levels))

cur.tes <- "SINE"
cur.levels <- grep(pattern=cur.tes, x=all.levels)
all.colors[cur.levels] <- colorRampPalette(c(rgb(180,100,50, alpha=220, maxColorValue=255), rgb(200,120,20, alpha=220, maxColorValue=255)), alpha=T)(length(cur.levels))

cur.tes <- "Unknown"
cur.levels <- grep(pattern=cur.tes, x=all.levels)
all.colors[cur.levels] <- colorRampPalette(c(rgb(10,10,10, alpha=220, maxColorValue=255), rgb(10,10,10, alpha=220, maxColorValue=255)), alpha=T)(length(cur.levels))


#Plot stacked histogram

pdf(file="TE_histo.pdf", width=8, height=5)

ggplot(te.data, aes(pdiv)) +
 geom_histogram(binwidth=1, aes(weight=proportion, fill=family.broad)) +
 scale_fill_manual(values=all.colors) +
 labs(fill="Family", x="Percent divergence", y="Fraction of genome")

dev.off()

#########################################################




