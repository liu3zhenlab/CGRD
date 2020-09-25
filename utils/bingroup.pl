#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Long;

# default:
my $loquantile = 0.001;
my $hiquantile = 0.999;
my $min = 20;
my $maxdist = 5000;
my $minbin = 5;
my $newgrouplab = "_TMPNEWGROUP";

sub prompt {
    print <<EOF;
    Usage: perl bingroup.pl [optioons]
    [Options]
    --bc <file>          read counts per bin; required
                         6 columns with no head; 5th column is used for bin filtering;
                         e.g., chr1(chr)	165 (start)	2932(end)	1(binID)	59(count1)	0(count2)
    --loquantile <num>   bins at the percentile from 0-$loquantile will be excluded ($loquantile)
    --hiquantile <num>   bins at the percnetile from $hiquantile-1 will be excluded ($hiquantile)
    --min <num>          bins with counts lower than $min will be excluded ($min)
    --maxdist <num>      bp distance between neighbor bins after exclusion of disqualified bins ($maxdist)
                         if the distance of two neighbor bins is larger than $maxdist, these neighbor
                         will be separated to different groups.
    --minbin <num>       minimal number of bins per group ($minbin)
                         groups with fewer bins than $minbin will be removed in the output
    --newgrouplab <str>  label suffix for new defined groups ($newgrouplab)
    --help|h             help information
EOF
exit;
}

#############
# parameters
#############
my ($bc, $help);
my %opts = ();
&GetOptions(\%opts, "bc=s", "loquantile=f", "hiquantile=f",
                    "min=i", "maxdist=i", "minbin=i", "newgrouplab", "help");

&prompt if exists $opts{help} or !%opts;
$bc = $opts{bc} if exists $opts{bc};
$loquantile = $opts{loquantile} if exists $opts{loquantile};
$hiquantile = $opts{hiquantile} if exists $opts{hiquantile};
$min = $opts{min} if exists $opts{min};
$maxdist = $opts{maxdist} if exists $opts{maxdist};
$minbin = $opts{minbin} if exists $opts{minbin};
$newgrouplab = $opts{newgrouplab} if exists $opts{newgrouplab};

############# 
# obtain counts of all bins
############# 
my $nbin = 0;
my @allcounts;
open(IN, $bc) || die;
while(<IN>) {
	chomp;
	$nbin++;
	my ($chr, $start, $end, $id, $count, $count2) = split(/\t/, $_);
	push(@allcounts, $count);
}
close IN;

############# 
# determine low and high quantile counts:
############# 
my $ccount = 0;
my ($loquantile_val, $hiquantile_val);
foreach my $ecount (sort {$a <=> $b} (@allcounts)) {
	$ccount++;
	if (!defined $loquantile_val and $ccount >= $loquantile * $nbin) {
		$loquantile_val = $ecount;
	}
	
	if (!defined $hiquantile_val and $ccount >= $hiquantile * $nbin) {
		$hiquantile_val = $ecount;
	}
}

# adjust min counts for bins
if ($loquantile_val > $min) {
	$min = $loquantile_val;
}

@allcounts = (); # cleanup

############# 
#
############# 
my $newchr;
my $prechr = "";
my $prepos = 1000000000000000;
my $newgroupID = 0;
open(IN, $bc) || die;
while(<IN>) {
	chomp;
	my ($chr, $start, $end, $id, $count, $count2) = split(/\t/, $_);
	if ($count >= $min and $count <= $hiquantile_val) { # qualified bins
		if ($chr eq $prechr) {
			if (($start - $prepos > $maxdist)) { # start from previous ends
				$newgroupID++;
				$newchr = $chr.$newgrouplab.$newgroupID;
			}
		} else {
			$newchr = $chr;
		}
		print "$newchr\t$start\t$end\t$id\t$count\t$count2\n";
		$prechr = $chr;
		$prepos = $end;
	}
}
close IN;

