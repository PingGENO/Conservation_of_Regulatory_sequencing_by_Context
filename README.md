# Conservation of Regulatory DNA sequencing x Context

## Introduction

Cis-regulatory DNA elements have significantly higher conservation than randomly selected DNA sequences, and distal cis-regulatory regions such as enhancers are less conserved and evolve rapidly relative to promoters. This demo shows the stimulation-specific open chromatin regions determined by ATAC-seq for human immune cells are more likely to be distal enhancers and have faster functional evolution (lower averaged phyloP scores) than non-differential ATACs.


## Source of data:
- human primary [monocytes](https://zenodo.org/record/8158923) treated with lipopolysaccharide or interferon-γ.
- monocyte derived [macrophages](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE172116) treated with lipopolysaccharide for acute response and tolerance.
- the phyloP score85, the -log(p value) under a null hypothesis of neutral evolution, derived from the alignment of 100 vertebrate genomes per base from the [UCSC browser](http://hgdownload.cse.ucsc.edu/goldenpath/hg38/phyloP100way/). 


## Script

```
awk 'OFS="\t" {print $1":"$2"-"$3, $1, $4, $5, "."}' test.data/distal.ATAC.regions.Chr7.txt > peak.saf

/apps/htseq/subread-1.6.4-Linux-x86_64/bin/featureCounts -T 12 \
-p \
-F SAF \
-a peak.saf \
-o eRNA_featureCounts.txt \
Mapping/mapped.hisat2/*_chr.uniq.mapped.bam

```

## Output & visualisation
<img src="man/figures/logo30.png" align="right" />



Average PhyloP conservation scores of the ±1Kb genomic regions centered on differential ATAC peaks (orange) and non-differential peaks (grey). The PhyloP scores for each region were calculated in 10-bp bins using bigWigAverageOverBed (see Methods).  

