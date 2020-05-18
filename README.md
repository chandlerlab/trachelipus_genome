This repository contains the code used in the preprint:

A Russell, S Borrelli, R Fontana, J Laricchiuta, J Pascar, T Becking, I Giraud, R Cordaux, and CH Chandler. 2020. Evolutionary transition to XY sex chromosomes associated with Y-linked duplication of a male hormone gene in a terrestrial isopod.

1_data_filtering: scripts for performing read trimming on the Illumina datasets

2_short_read_assembly: scripts for performing the initial assembly of the Illumina datasets using SparseAssembler, followed by evaluation with Quast and assembly filtering by redundans

3_error_correct_longreads: scripts to perform error correction on the PacBio and Oxford Nanopore data with the Illumina data, using FMLRC

4_dbg2olc_all: scripts to perform hybrid assembly using DBG2OLC, with a range of different parameter values, and then compile assembly statistics using QUAST

5_correct_and_eval_dbg2olc: scripts to perform hybrid error correction on a subset of the DBG2OLC assemblies using Pilon, and then evaluate the corrected assemblies using BUSCO
5b_transcriptome: scripts to assemble a previously published transcriptome dataset using a combination of TransLiG and Trinity, and then merge the assemblies using EvidentialGene

6_assembly_filtering: scripts to construct blobplots and filter likely contaminants from the corrected assembly

6b_genome_eval_with_transcripts: scripts to BLAST assembled transcripts against the assembled genome to see how many transcripts have nearly full-length matches in genome, as a second complementary assessment of genome assembly completeness

7_repeatmasking: scripts to construct a custom repeat library from the filtered assembly using RepeatModeler, and then mask repetitive elements from the assembly

8_genome_annotation: scripts to annotate the assembly using the Maker pipeline

9a_agh_phylogeny: scripts to identify all AGH-like sequences in the assembly and then construct a phylogeny (Figure 5)

9b_agh_structure: scripts to examine structure of AGH-like sequences in the assembly using the assembled expressed AGH transcript (Figure 4)

10a_wolbachia_trees: scripts to identify likely Wolbachia insertions in the Trachelipus nuclear genome and construct a phylogenetic tree showing their relationship to other Wolbachia isolates

10b_wolbachia_cifAcifB: scripts to look for homologs of the cytoplasmic incompatibility genes cifA and cifB in the likely Wolbachia insertions

10c_final_cov: scripts to look at sequencing depth across the assembly, including annotated single-copy genes from the BUSCO analysis and possible duplicates of AGH

Figure1_TEs: scripts to visualize distribution of transposable elements in the assembly
