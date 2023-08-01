#!/bin/bash

## 1.midpoint +-1kB
cat ./data/monocyte.ATACs.bed | awk 'OFS="\t" {print $1, int(($2+$3)/2)-1000, int(($2+$3)/2)+1000, $4}' > ./data/monocyte.ATACs_midpoint.1kb.bed

## 2.10bp bins for each peak

 awk ' \
    { \
         regionChromosome = $1; \
         regionStart = $2; \
         regionStop = $3; \
         regionID = $4; \
         baseIdx = 0; \
         for (baseStart = regionStart; baseStart < regionStop; baseStart+=10) { \
             baseStop = baseStart + 10; \
             print regionChromosome"\t"baseStart"\t"baseStop"\t"regionID"-"baseIdx; \
             baseIdx++; \
         } \
    }' ./data/monocyte.ATACs_midpoint.1kb.bed > ./data/monocyte.ATACs_midpoint.1kb_per10Base.bed


## 3.calculate phyloP scores
chmod +x ./scripts/bigWigAverageOverBed 
#
./scripts/bigWigAverageOverBed \
${hg38.phyloP100way.bw} \
./data/monocyte.ATACs_midpoint.1kb_per10Base.bed \
./output/monocyte_phyloP.tab
