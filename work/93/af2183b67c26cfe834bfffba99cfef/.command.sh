#!/bin/bash -ue
trimmomatic PE -phred33 \
    SRR19965991_1.fastq.gz SRR19965991_2.fastq.gz \
    SRR19965991_trimmed_R1.fastq.gz SRR19965991_trimmed_R1_unpaired.fastq.gz \
    SRR19965991_trimmed_R2.fastq.gz SRR19965991_trimmed_R2_unpaired.fastq.gz \
    ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 SLIDINGWINDOW:4:30 MINLEN:36
