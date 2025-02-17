#!/usr/bin/env nextflow

nextflow.enable.dsl=2
//Default Parameters for the pipeline
params.fastqPath = "$baseDir/raw_data/*_{1,2}.fastq.gz" // // Default path to input FASTQ files, using a glob pattern to match paired-end reads
params.resultsPath = "$baseDir/results" // Default path where results will be saved
params.trimAdapters = 'TruSeq3-PE.fa' // Default path to the adapter sequences file used by Trimmomatic for trimming

// Define a channel for reading FASTQ file pairs
Channel.fromFilePairs(params.fastqPath, size: 2, flat: true)
       .set { readPairsCh }
//  Matches files into pairs based on pattern provided and assigns the matched pairs to the readPairsCh channel for use in the pipeline
process trimseq {
    tag "Trimming ${sample_name}"  // Tag each process instance with the sample name for easier log identification
    publishDir "${params.resultsPath}/trimmed_reads", mode: 'copy'  // Specify the directory to save output files, and copy files there upon completion

    input:
    tuple val(sample_name), path(fwd), path(rev) //inputs sample read, forward and reverse read

    output:
    tuple val(sample_name), path("*_trimmed_R1.fastq.gz"), path("*_trimmed_R2.fastq.gz") // outputs for sample, forward, and reverse reads
     // Run Trimmomatic for paired-end read trimming with specified parameters
    script:
    """
    trimmomatic PE -phred33 \\
        $fwd $rev \\
        ${sample_name}_trimmed_R1.fastq.gz ${sample_name}_trimmed_R1_unpaired.fastq.gz \\
        ${sample_name}_trimmed_R2.fastq.gz ${sample_name}_trimmed_R2_unpaired.fastq.gz \\
        ILLUMINACLIP:${params.trimAdapters}:2:30:10 SLIDINGWINDOW:4:30 MINLEN:36
    """
}

process assemblyseq {
    tag "Assembly ${sample_name}"
    publishDir "${params.resultsPath}/contig_assemblies", mode: 'copy'

    input:
    tuple val(sample_name), path(fwd_trimmed), path(rev_trimmed)

    output:
    path("${sample_name}_contigs.fasta")
    // Run SKESA for genome assembly using trimmed reads
    script:
    """
    skesa --fastq $fwd_trimmed $rev_trimmed --contigs_out ${sample_name}_contigs.fasta
    """
}

workflow {
    // Pipe readPairsCh through trimseq and assemblyseq
    readPairsCh
        | trimseq
        | assemblyseq
}    // Pipe read pairs through trimseq for trimming, then pass trimmed reads to assemblyseq
