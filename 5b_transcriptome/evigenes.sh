module load evigene/gnu/2013.07.27
export PATH=$PATH:/N/soft/rhel7/evigene/gnu/2013.07.27/scripts/rnaseq/

cd /N/dc2/scratch/chrichan/trachelipus_assembly/evigenes

# 0. collect input transcripts.tr,
# You supply input transcript sequences in .fasta, an over-assembly with redundant and variable quality transcripts, as one file. Please consider trformat.pl to regularize IDs, which are critical to tracking inputs. tr2aacds produces .cds, .aa sequences from .tr, working mostly on the CDS.

trformat.pl -output combined.fasta \
            -input translig_f.fasta \
                   translig_m.fasta \
                   trinity_f.fasta \
                   trinity_m.fasta
                   

tr2aacds.pl -mrnaseq combined.fasta \
  -MINCDS=90 -NCPU=8 -MAXMEM=60000 -logfile

# 1. perfect redundant removal: exonerate/fastanrdb input.cds > input_nr.cds,
# and protein qualities are used for choosing among cds identicals.



# 2. perfect fragment removal: cd-hit-est -c 1.0 -l $MINCDS ..
# 3. blastn, basic local align hi-ident subsequences for alternate tr.,
# with -perc_identity CDSBLAST_IDENT (98%), to find high-identity exon-sized alignments.
# 
# 4. classify main/alternate cds, okay & drop subsets, using evigene/rnaseq/asmrna_dupfilter2.pl
# .. merges alignment table, protein-quality and identity, to score okay-main, ok-alt, and drop sets.
# 
# 5. final output files from outclass: okay-main, okay-alts, drops
# okayset is for public consumption, drops for data-overload enthusiasts (may contain valids).
# evgmrna2tsa.pl is next step, to become part of tr2aacds2, for final publicset/

module load busco/3.0.2
export AUGUSTUS_CONFIG_PATH="/N/dc2/scratch/chrichan/augustus_config/"
export LINEAGES=/N/dc2/projects/ncgas/genomes/busco-lineage

TRANSCRIPTS=okayset/combined.okay.fasta
OUTNAME=busco_tr2aacds
run_BUSCO.py -i ${TRANSCRIPTS} \
               -o ${OUTNAME} \
               -l ${LINEAGES}/arthropoda_odb9 \
               -m transcriptome \
               -c 8 \
               -z \
               --blast_single_core


# INFO    Results:
# INFO    C:94.2%[S:86.3%,D:7.9%],F:1.0%,M:4.8%,n:1066
# INFO    1004 Complete BUSCOs (C)
# INFO    920 Complete and single-copy BUSCOs (S)
# INFO    84 Complete and duplicated BUSCOs (D)
# INFO    11 Fragmented BUSCOs (F)
# INFO    51 Missing BUSCOs (M)
# INFO    1066 Total BUSCO groups searched

#overall seems to have worked really well -- decreased the duplicated from mid-30s to
# about 8%, while only increasing missing from ~2% to ~4%