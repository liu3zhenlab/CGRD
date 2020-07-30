## CGRD
*Comparative Genomic Read Depth*

CGRD is a pipeline to compare sequencing read depths from two samples along a reference genome. Three major steps are involved:  
1. define effective genomic bins each of which habors certain non-repetitive sequences  
2. align reads and count read depths per bin for both samples  
3. combine neighbor bins with similar fold changes in read depth between the two samples (segmentation)  

From the result, genomic segments with similar and differential (higher or lower) read depths are obtained. Therefore, genomic copy number variation (CNV) based on read depths can be extracted from the result and visualized on the genome map.

### DATA REQUIREMENT
1. reference genome (FASTA format)
2. FASTQ reads or an sorted BAM file of sample 1
3. FASTQ reads or an sorted BAM file of sample 2  
**Note**:  
- If BAM files were provided, BAM index files are located at the same directory as BAM files.
- FASTQ data are whole genome sequencing data. The higher sequencing depth is, the smaller the bin size could be.

### GET STARTED
Running is easy but might takes days if the genome is large and high-depth sequencing data are produced.

If no BAM alignments are ready, run:
```
perl <path-to-cgrd>/cgrd --ref <fas> \
  --sfq1 <subject fq1> --sfq2 <subject fq2> \
  --qfq1 <query fq1> --qfq2 <query fq2>
```

If BAM alignments are ready, run:
```
perl <path-to-cgrd>/cgrd --ref <fas> \
  --sbam <subject bam> --qbam <query bam>
```

### INSTALLATION
The following packages are required:
1. jellyfish: to generate k-mers from a FASTA file
2. Bowtie: to align and determine k-mer positions on the genome
3. BWA: to align reads to the reference genome
4. samtoos: to convert SAM to BAM
5. bedtools: to determine read counts per genomic bin
6. pandoc: to create a html report
7. R: to perform CNV analysis and create a report
8. R pakages: rmarkdown, knitr, DNAcopy

If all the packages are installed and commands are in the paths. You can directly copy CGRD for your uses.

```
git clone https://github.com/liu3zhenlab/CGRD.git
cd CGRD
perl cgrd
```

#### conda installation
```
conda create -n cgrd
conda activate cgrd
conda install -c bioconda jellyfish bowtie bwa samtools bedtools pandoc
conda install -c r r-base r-knitr r-rmarkdown
conda install -c bioconda bioconductor-DNAcopy

# after all the installation:
git clone https://github.com/liu3zhenlab/CGRD.git
cd CGRD
perl cgrd
```

#### tested package versions:
1. jellyfish-2.2.10
2. bowtie-1.2.3
3. bwa-0.7.17
4. samtools-1.9
5. bedtools-2.29.0
6. pandoc-2.2.3.2-0
7. r-base-3.6.1
8. r-rmarkdown-1.12
9. r-knitr-1.22
10. dnacopy-1.58.0
