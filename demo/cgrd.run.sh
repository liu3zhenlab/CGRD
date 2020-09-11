#!/bin/bash

ref=../data/simulated/genome/ref.fasta
reffq1=../data/simulated/reads/ref.1.fastq
reffq2=../data/simulated/reads/ref.q.fastq
qryfq1=../data/simulated/reads/qry.1.fastq
qryfq2=../data/simulated/reads/qry.2.fastq

perl ~/scripts2/CGRD/cgrd --ref $ref \
	--subj ref --sfq1 $reffq1 --sfq2 $reffq2 \
	--qry qry -qfq1 $qryfq1 -qfq2 $qryfq2 \
	--threads 1

