#!/bin/bash

ref=../genome/ref.fasta
reffq1=../reads/ref.1.fastq
reffq2=../reads/ref.2.fastq
qryfq1=../reads/qry.1.fastq
qryfq2=../reads/qry.2.fastq

perl cgrd --ref $ref \
	--subj ref --sfq1 $reffq1 --sfq2 $reffq2 \
	--qry qry -qfq1 $qryfq1 -qfq2 $qryfq2 \
	--threads 1

