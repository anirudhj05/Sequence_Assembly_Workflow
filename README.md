## nextflow_assignment1
This is the repository for the first nextflow assignment which involves trimming and assembling a fastqz file

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
 
 
