#!/bin/bash

bismark_genome_preparation chr6

bismark --fastq chr6 -1 methylation_fastq/E4.0ICM_1.chr6.fastq -2 methylation_fastq/E4.0ICM_2.chr6.fastq 
bismark --fastq chr6 -1 methylation_fastq/E5.5Epi_1.chr6.fastq -2 methylation_fastq/E5.5Epi_2.chr6.fastq  

samtools sort E4.0ICM_1.chr6_bismark_bt2_pe.bam > E4sorted.bam 
samtools sort E5.5Epi_1.chr6_bismark_bt2_pe.bam > E5sorted.bam 

samtools index E4sorted.bam
samtools index E5sorted.bam

bismark_methylation_extractor --bedgraph --comprehensive E4sorted.bam
bismark_methylation_extractor --bedgraph --comprehensive E5sorted.bam 

IGV E4sorted.bedGraph.gz E5sorted.bedGraph.gz
