#!/usr/bin/perl -w
# split.fasta.pl
# author: Sanzhen Liu
# date: 6/29/2021

use strict;
use warnings;
use Getopt::Long;

my ($length, $min, $help);
my $result = &GetOptions("length|l=i" => \$length,
                         "min|m=i" => \$min,
			             "help|h" => \$help
);

if (@ARGV<1) {
	&errINF;
	exit;
}

# print help information if errors occur:
if ($help) {
	&errINF;
	exit;
}

$length = 10000 if (!defined $length or (defined $length and $length==0));
$min = 100 if (!defined $min);

### count the total sequences:
my $len;
my ($seqname, $seq, %seqsize, %seq);
my $raw_read_num=0;
my $split_read_num=0;
my $discard_bps=0;

open(IN, $ARGV[0]) || die;
while (<IN>) {
	chomp;
	if (/^>(\S+)/) {
		$raw_read_num++;
		if (defined $seqname) {
			my $split_out_nums = &seqsplit($seqname, $seq, $length, $min);
			my @split_out_nums = @{$split_out_nums};
			print join("\t", @split_out_nums);
			print "\n";
			$split_read_num += $split_out_nums[0];
			$discard_bps += $split_out_nums[1];
		}
		$seqname = $1;
		$seq = '';
	} else {
		$seq .= $_;
	}
}

### last seq
my $split_out_nums = &seqsplit($seqname, $seq, $length, $min);
my @split_out_nums = @{$split_out_nums};
print join("\t", @split_out_nums);
print "\n";
$split_read_num += $split_out_nums[0];
$discard_bps += $split_out_nums[1];

close IN;

print STDERR "raw_reads\t$raw_read_num\n";
print STDERR "split_reads\t$split_read_num\n";
print STDERR "discard_bps\t$discard_bps\n";

##########################################################
# module: sequence split
##########################################################
sub seqsplit {
# 
# Inputs:
# seqname, sequence, length of each sequence, minimum length
# Output:
# print split sequences
# output two numbers:
# valid split read number and discarded split read number
#
	my ($in_seqname, $in_seq, $in_tolen, $in_min) = @_;
	my $cur_seqsize = length($in_seq);
	my $part = 0;
	my $bps_discarded = 0;
	if (($cur_seqsize >= $in_min) and ($cur_seqsize <= $length)) {
		$part++;
		print ">$in_seqname\n";
		&format_print($in_seq, 80);
	} elsif ($cur_seqsize < $in_min) {
		$bps_discarded += $cur_seqsize;
	} else {
		until (length($in_seq) < $in_min) {
			my $extract = substr($in_seq, 0, $in_tolen, "");
			$part++;
			printf(">%s_%s\n", $in_seqname, $part);
			&format_print($extract, 80);
			$bps_discarded = length($in_seq);
		}
	}
	
	my $num_valid_splitreads = $part;
	my @output = ($num_valid_splitreads, $bps_discarded);
	return \@output;
}

### helping information
sub errINF {
	print <<EOF;
Usage: perl split.fasta.pl <input> [Options]
	Options
	--length|l: max size of an original seq;
	               if >length, split into multiple sequences with length bp plus a sequence with the remainder
				   if the remainder is <=min, add it to the last sequence; default = 10,000 bp 
	--min|m   : min size of a split seq; default = 100 bp
	--help|h  : help information
EOF
	exit;
}

### module for formatted output:
sub format_print {
	my ($inseq, $formatlen) = @_; 
	while (my $chunk = substr($inseq, 0, $formatlen, "")) {
		print "$chunk\n";
	}   
}

