# Nextflow Pipeline for bacterial genome read cleaning and gene assembly

This Nextflow pipeline automates the process of trimming sequencing reads and assembling them into contigs. It utilizes Trimmomatic for read trimming and SKESA for genome assembly. The pipeline is designed to handle paired-end sequencing reads and is structured to be modular and easy to configure with user-defined parameters.

## Prerequisites
- **Nextflow**: Ensure Nextflow is installed on your system. You can install it by running `curl -s https://get.nextflow.io | bash` and then moving the Nextflow binary to a directory in your `$PATH`.
- Conda: A Conda environment is recommended for managing the software dependencies. Install Miniconda from Miniconda's site if it is not already installed.

## Setup
- Clone the repository:
```bash
https://github.com/anirudhj05/Sequence_Assembly_Workflow.git
cd Sequence_Assembly_Workflow
```
- Environment Setup: The repository contains an environment.yml file which can be used to install the dependencies needed to run this pipeline. Use this file and create a conda environment.
```bash
conda env create -f environment.yml
conda activate environmentname
```

- Prepare Input Data: Organize your paired-end FASTQ files in a specified directory. The default expectation is for files to be named in the pattern *_1.fastq.gz and *_2.fastq.gz. The directory `raw_data` has a sample FASTQ file SRR19965991 downloaded from NCBI.
```bash
fasterq-dump \
SRR19965991 \
--threads 1 \
--outdir raw_data \
--split-files \
--skip-technical
```
 ```bash
pigz -9f *.fastq # Compress the file
```
## Pipeline

- Trimming: Trimmomatic was used in the nextflow pipeline for trimming the fastq file
```bash
trimmomatic PE -phred33 \\
        $fwd $rev \\
        ${sample_name}_trimmed_R1.fastq.gz ${sample_name}_trimmed_R1_unpaired.fastq.gz \\
        ${sample_name}_trimmed_R2.fastq.gz ${sample_name}_trimmed_R2_unpaired.fastq.gz \\
        ILLUMINACLIP:${params.trimAdapters}:2:30:10 SLIDINGWINDOW:4:30 MINLEN:36
```

- Assembly: Skesa was used to assemble the trimmed reads
```bash
skesa --fastq $fwd_trimmed $rev_trimmed --contigs_out ${sample_name}_contigs.fasta
```
- Running the pipeline: To run the pipeline, use the following command:
```bash
 nextflow run main.nf --fastqPath 'raw_data/*_{1,2}.fastq.gz'
 ```
This command runs the main.nf file from the terminal
```bash
 grep -c '>' *.fasta # The grep command was used to find out how many contigs were there
 ```
 
