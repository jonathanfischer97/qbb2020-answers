#!/bin/bash 

#create partitioned file
hifive fends partition.txt --binned 100000 -L genome/mm9.len

#count interaction reads
hifive hic-data -X data/WT_100kb/raw_\*.mat partition.txt counts.txt

#create project file
hifive hic-project -f 25 -n 25 -j 100000 counts.txt project.txt

#data normalization
hifive hic-normalize express project.txt

#subset negative value compartments
grep - hic_comp.bed > compA.bed

#subset positive value compartments 
grep -v - hic_comp.bed > compB.bed

#find intersection of genes and compartments 
bedtools intersect -a data/WT_fpkm.bed -b compA.bed -wb > compA_intersect.bed
bedtools intersect -a data/WT_fpkm.bed -b compB.bed -wb > compB_intersect.bed