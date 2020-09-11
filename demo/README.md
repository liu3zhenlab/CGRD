### Demo to run CGRD with sample data

#### step 1: data preparation
In this demo, 40 kb *E. coli* sequence was extracted from the Genbank accession NC_000913.3 as the reference genome \([ref](./genome/ref.fasta)\).  

A 50 kb insertion and a 50 kb deletion were introduced in a qrery genome \(qry\).  

Paired-end reads 2x100 bp were simulated from each genome, produing data:  
reads from the ref genome: [read1](./reads/ref.1.fastq) and [read2](reffq2=./reads/ref.2.fastq)  
reads from the qry genome: [read1](qryfq1=./reads/qry.1.fastq) and [read2](qryfq2=./reads/qry.2.fastq)

#### step 2: run CGRD

```
#!/bin/bash

ref=./genome/ref.fasta
reffq1=./reads/ref.1.fastq
reffq2=./reads/ref.2.fastq
qryfq1=./reads/qry.1.fastq
qryfq2=./reads/qry.2.fastq

perl cgrd --ref $ref \
	--subj ref --sfq1 $reffq1 --sfq2 $reffq2 \
	--qry qry -qfq1 $qryfq1 -qfq2 $qryfq2 \
	--threads 1
  ```
