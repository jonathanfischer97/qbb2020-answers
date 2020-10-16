#!/bin/bash

#Part 1: ChIP-seq 
bowtie2-build chr19.fa chr19

for sample in g1e/*.fastq
do
	    #maps reads
	bowtie2 -x chr19 -U ${sample} -S ${sample%.fastq}.sam -p 6
	    #makes a bam file
	samtools view -bSo ${sample%.fastq}.bam ${sample%.fastq}.sam
	    #makes sorted file
	samtools sort ${sample%.fastq}.bam -o ${sample%.fastq}.sorted.bam
	    #indexes file
	samtools index ${sample%.fastq}.sorted.bam
done

macs2 callpeak -t CTCF_ER4.bam -c input_ER4.bam --format=BAM --name=CTCF_ER4 --gsize=61420004 

macs2 callpeak -t CTCF_G1E.bam -c input_G1E.bam --format=BAM --name=CTCF_G1E --gsize=61420004

bedtools subtract -a CTCF_ER4_peaks.narrowPeak -b CTCF_G1E_peaks.narrowPeak > gain_sites.bed

bedtools subtract -a CTCF_G1E_peaks.narrowPeak -b CTCF_ER4_peaks.narrowPeak > lost_sites.bed

grep 'promoter' Mus_musculus.GRCm38.94_features.bed.txt > promoter.bed
grep 'intron' Mus_musculus.GRCm38.94_features.bed.txt > intron.bed
grep 'exon' Mus_musculus.GRCm38.94_features.bed.txt > exon.bed

for ct in G1E ER4
do
	for feature in promoter intron exon
	do
		bedtools intersect -a CTCF_${ct}_peaks.narrowPeak -b ${feature}.bed  >${ct}_${feature}_overlap.bed
	done
done

#Part 2: Motif Discovery 
sort -rk 9 CTCF_ER4_peaks.narrowPeak | head -n 100 > top_motifs.txt 

bedtools getfasta -fi chr19.fa -bed  top_motifs.txt>top_motifs.fa

meme-chip  -meme-maxw 20 -oc meme_data top_motifs.fa

tomtom meme_data/combined.meme motif_databases/JASPAR/JASPAR_CORE_2016.meme

#opened tomtom_output.html to find the sequence logo of strongest motif