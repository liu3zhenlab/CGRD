#!/usr/bin/perl -w
# ====================================================================================================
# File: fq.size.filter.pl
# Author: Sanzhen Liu
# Date: 12/29/2020
# ====================================================================================================

use strict;
use warnings;
use Getopt::Long;

my ($seq,$seq_name,$seq_bp);
my ($min,$max,$help);

sub prompt {
	print <<EOF;
	Usage: perl $0 <fastq> [options]
	Count the size for each fasta sequence and filter sequences based on the specified criteria.
	--min: minimum length (0)
	--max: maximum length (infinite)
	--help 
EOF
exit;
}
# read the parameters:
&GetOptions("min=i" => \$min, "max=i" => \$max, "help" => \$help) || &prompt;

if ($help) { &prompt; }
$min = defined $min ? $min : 0;
my $inf = (~0)**(~0);
$max = defined $max ? $max : $inf;
#print $max;

# Read all sequence (name and size) into hash;
my $num_row = 0; # number of rows
my $total_valid_read_num = 0;
my $total_len_valid_reads = 0;
my $total_discard_read_num = 0;
my $total_len_discard_reads = 0;

open(IN, $ARGV[0]) || die;
while (<IN>) {
	if (!/^$/) {
		$num_row++;
		$_ =~ s/\R//g; # \R is Linebreak
		chomp;
		if ($num_row % 4 == 1) {
			$seq_name = $_;
			$_ = <IN>; $_ =~ s/\R//g; chomp; $num_row++;
			$seq = $_;
			$seq_bp = length($seq);
			if ($seq_bp >= $min and $seq_bp <= $max) {
				$total_valid_read_num++;
				$total_len_valid_reads += $seq_bp;
				print "$seq_name\n$seq\n";
				$_ = <IN>; $num_row++; $_ =~ s/\R//g; chomp; print "$_\n";
				$_ = <IN>; $num_row++; $_ =~ s/\R//g; chomp; print "$_\n";
			} else {
				$total_discard_read_num++;
				$total_len_discard_reads += $seq_bp;
			}
		}
	}
}
close IN;

print STDERR "valid_reads\t$total_valid_read_num\n";
print STDERR "valid_bps\t$total_len_valid_reads\n";
print STDERR "discard_reads\t$total_discard_read_num\n";
print STDERR "discard_bps\t$total_len_discard_reads\n";


