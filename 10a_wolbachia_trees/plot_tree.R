library("treeio")
library("ggtree")
library("ggrepel")
library("tibble")

tree <- read.newick("cur_hits_aligned_filtered_renamed.fasta.raxml.support", node.label="support")

ggtree(tree) + geom_tiplab(size=5) + geom_text(aes(label=support), size=2.0, nudge_x=0.015) + xlim(0,1.5)

root.node <- length(tree@phylo$tip.label) + 1
all.branch.lens <- as.data.frame(as.tibble(tree))$branch.length
tot.len <- 0
for (x in 1:(root.node-1)) {
	cur.path <- get.path(tree@phylo, root.node, x)
	branch.lens <- all.branch.lens[cur.path]
	if (sum(branch.lens) > tot.len) {
		tot.len <- sum(branch.lens)
	}
}
cur.width <- tot.len + 5
cur.height <- length(tree@phylo$tip.label)/3

ggsave(file="cur_tree.pdf", width=cur.width, height=cur.height)
