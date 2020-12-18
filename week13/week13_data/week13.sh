#!/bin/bash

#Step 2: Deconvolute the assembled scaffolds into individual genomes (binning)

bwa index assembly.fasta 

bwa mem assembly.fasta READS/SRR492183_1.fastq READS/SRR492183_2.fastq > day0.sam

bwa mem assembly.fasta READS/SRR492186_1.fastq READS/SRR492186_2.fastq > day1.sam

bwa mem assembly.fasta READS/SRR492188_1.fastq READS/SRR492188_2.fastq > day2.sam

bwa mem assembly.fasta READS/SRR492189_1.fastq READS/SRR492189_2.fastq > day3.sam

bwa mem assembly.fasta READS/SRR492190_1.fastq READS/SRR492190_2.fastq > day4.sam

bwa mem assembly.fasta READS/SRR492193_1.fastq READS/SRR492193_2.fastq > day5.sam

bwa mem assembly.fasta READS/SRR492194_1.fastq READS/SRR492194_2.fastq > day6.sam

bwa mem assembly.fasta READS/SRR492197_1.fastq READS/SRR492197_2.fastq > day7.sam

for FILENAME in *.sam
do
	samtools sort -o ${FILENAME%.sam}.bam -O bam $FILENAME
done

conda activate metabat2
jgi_summarize_bam_contig_depths --outputDepth depth.txt *.bam

conda activate metabat
metabat2 -i assembly.fasta -a depth.txt -o bins_dir/bin

#STEP 3: Estimate the taxonomy of your putative genomes
for FILENAME in bins/*
do 
	line=$(head -n 1 $FILENAME);
	line="${line:1}"
	echo "$line"
	grep "$line" ./KRAKEN/assembly.kraken >>bin_identities.txt
done