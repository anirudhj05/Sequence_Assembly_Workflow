#!/bin/bash -ue
trimmomatic PE -phred33 \
    SRR19965991_1.fastq.gz SRR19965991_2.fastq.gz \
    SRR19965991_R1.trimmed.fastq.gz SRR19965991_R1.unpaired.fastq.gz \
    SRR19965991_R2.trimmed.fastq.gz SRR19965991_R2.unpaired.fastq.gz \
    ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 SLIDINGWINDOW:4:30 MINLEN:36
