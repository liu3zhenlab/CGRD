
# produce a reference genome (40kb)
perl fasta.reorganiz.pl --fasta GCF_000005845.2_ASM584v2_genomic.fna --table ref.txt --header > ref.fasta

# simulate a query genome with 1 insertion and 1 deletion (40kb)
# insertion: 5001	10000
# deletion: 20001	25000
perl ~/scripts/fasta/fasta.reorganiz.pl --fasta GCF_000005845.2_ASM584v2_genomic.fna --table qry.txt --header > qry.fasta

