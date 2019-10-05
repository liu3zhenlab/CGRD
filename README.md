# CGRD
Comparative Genomics Read Depth

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
jellyfish-2.2.10
bowtie-1.2.3
bwa-0.7.17
samtools-1.9
bedtools-2.29.0
pandoc-2.2.3.2-0
r-base-3.6.1
r-knitr-1.22
dnacopy-1.58.0


