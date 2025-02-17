# Nextflow Pipeline for bacterial genome read cleaning and gene assembly

This Nextflow pipeline automates the process of trimming sequencing reads and assembling them into contigs. It utilizes Trimmomatic for read trimming and SKESA for genome assembly. The pipeline is designed to handle paired-end sequencing reads and is structured to be modular and easy to configure with user-defined parameters.

## Prerequisites
- **Nextflow**: Ensure Nextflow is installed on your system. You can install it by running `curl -s https://get.nextflow.io | bash` and then moving the Nextflow binary to a directory in your `$PATH`.
- Conda: A Conda environment is recommended for managing the software dependencies. Install Miniconda from Miniconda's site if it is not already installed.

## Setup
- Clone the repository:
  ```bash
  


I have downloaded SRR19965991 from NCBI using fasterq-dump \
 SRR19965991 
 --threads 1 \
 --outdir raw_data \
 --split-files \
 --skip-technical
 
pigz -9f *.fastq was used to compress the file

Trimming:
Trimmomatic was used in the nextflow pipeline for trimming the fastq file

trimmomatic PE -phred33 \\
        $fwd $rev \\
        ${sample_name}_trimmed_R1.fastq.gz ${sample_name}_trimmed_R1_unpaired.fastq.gz \\
        ${sample_name}_trimmed_R2.fastq.gz ${sample_name}_trimmed_R2_unpaired.fastq.gz \\
        ILLUMINACLIP:${params.trimAdapters}:2:30:10 SLIDINGWINDOW:4:30 MINLEN:36

Assembly:
Skesa was used to assemble the trimmed reads 
skesa --fastq $fwd_trimmed $rev_trimmed --contigs_out ${sample_name}_contigs.fasta

Running the pipeline:
 nextflow run main.nf --fastqPath 'raw_data/*_{1,2}.fastq.gz'
 This command runs the main.nf file from the terminal
 
 grep -c '>' *.fasta The grep command was used to find out how many contigs were there
 
 
