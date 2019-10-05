## CGRD
*Comparative Genomics Read Depth*

CGRD is a pipeline to compare sequencing read depths from two samples along a reference genome. Three major steps are involved: 1. define effective genomic bins each of which habors certain non-repetitive sequences 2. align reads and count read depths per bin for both samples 3. segmentation to combine neighbor bins with similar fold changes in read depth between the two samples. From the result, genomic segments with similar and differential (higher or lower) read depths are obtained. Therefore, genomic copy number variation (CNV) based on read depths can be extracted from the result and visualized on the genome map.

### INSTALLATION
The following packages are required:
1. jellyfish: to generate k-mers from a FASTA file
2. Bowtie: to align and determine k-mer positions on the genome
3. BWA: to align reads to the reference genome
4. samtoos: to convert SAM to BAM
5. bedtools: to determine read counts per genomic bin
6. pandoc: to create a html report
7. R: to perform CNV analysis and create a report
8. R pakages: knitr, DNAcopy

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
conda install r-base r-knitr
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
8. r-knitr-1.22
9. dnacopy-1.58.0


