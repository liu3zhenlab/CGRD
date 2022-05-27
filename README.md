## CGRD
*Comparative Genomic Read Depth*

CGRD is a pipeline to compare sequencing read depths from two samples along a reference genome. Three major steps are involved:  
1. define effective genomic bins each of which harbors certain non-repetitive sequences  
2. align reads and count read depths per bin for both samples  
3. combine neighboring bins with similar fold changes in read depth between the two samples (segmentation)  

From the result, genomic segments with similar and differential (higher or lower) read depths are obtained. Therefore, genomic copy number variation (CNV) based on read depths can be extracted from the result and visualized on the genome map.

### CITATION
G Lin, C He, J Zheng, DH Koo, H Le, H Zheng, D Koo, H Le, H Zheng, TM Tamang, J Lin, Y Liu, M Zhao, Y Hao, F McFarland, B Wang, Y Qin, H Tang, DR McCarty, H Wei, MJ Cho, S Park, H Kaeppler, S Kaeppler, Y Liu, NM Springer, PS Schnable, G Wang, FF White, S Liu. (2021). Chromosome-level genome assembly of a regenerable maize inbred line A188, Genome Biology, 22:175

### VERSIONS
v0.3.5: add the parameter of --adj0 to allow a further adjustment of the logRD mode to 0  
v0.3.4: added the step to check required software packages and fixed the issue associated with --knum  

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
  --subj ref --sfq1 <subject fq1> --sfq2 <subject fq2> \
  --qry qry --qfq1 <query fq1> --qfq2 <query fq2>
```

If BAM alignments are ready, run:
```
perl <path-to-cgrd>/cgrd --ref <fas> \
  --subj ref --sbam <subject bam> \
  --qry qry --qbam <query bam>
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
conda install -c bioconda jellyfish bowtie bwa bedtools pandoc samtools=1.9 minimap2
conda install -c r r-base r-knitr r-rmarkdown
conda install -c bioconda bioconductor-DNAcopy

# after all the installation:
git clone https://github.com/liu3zhenlab/CGRD.git
cd CGRD
perl cgrd
```

#### tested package versions
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

**Note**: the installation may take 1-2 hours.

### to-do
Here is a warning message during the report generation, which does not affect the result but needs to be solved.
"'mode(width)' and 'mode(height)' differ between new and previous"

### BUG REPORT
Please report any bugs or suggestion on github or by email to Sanzhen Liu (liu3zhen@ksu.edu).

### LICENSE
CGRD is distributed under MIT licence.

### CONTRIBUTIONS
The idea was developed by Sanzhen Liu when he was in Schnable lab at Iowa State University. Guifang Lin tested the scripts. Thanks suggestions from Ha Le.
