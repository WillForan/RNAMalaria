#!/usr/bin/env perl
use strict; use warnings;

use POSIX;
#use Data::Dumper;

#where the bychrom fasta files are
#TODO this should work outside of wfo../pf5
my $BASE='/home/wforan1/seq/pf5/';
my $rev=0;

#get what to do
use Getopt::Std;
my %opt=();
getopts('c:s:e');
my ($chrm, $start,$end);
if(defined($opt{'c'}) && defined($opt{'s'}) && defined($opt{'e'}) ) {
    $chrm=$opt{'c'}; $start=$opt{'s'}; $end=$opt{'e'};
}
elsif($#ARGV==0 && ($ARGV[0]=~m/(.*):(.*)-(.*)/) ) {
     $chrm=lc($1);  $start=$2;  $end=$3;
}
else { 
    print "USAGE: $0 chr1:100-400 OR $0 -c chr1 -s 100 -e 400\n";
    exit;
}

#if is reverse
if($start>$end){
    $start=$3;
    $end=$2;
    $rev=1;
}
open my $cFILE, "$BASE$chrm.fa" or die "Cannot open $chrm.fa file: $!\n";

my $offset=length(<$cFILE>);

#extra byte(newline) ever 50 chars + start  + $offset - starts at 1 not 0
my $pos=floor($start/50) + $start + $offset - 1;

#difference in positions
my $diff=$end-$start;

#extra byte every 50 + actual diff
my $len=floor($diff/50)+$diff;

#add one if there is an extra newline to overcome (ie. compansate for not starting at beg. of line)
$len+=1 if ($end%50<$start%50);

#get the file to the start
seek($cFILE,$pos,SEEK_SET);

#read the length
read($cFILE,my $seq, $len+1,0);
#done with file
close($cFILE);

#make presenentable
$seq=uc($seq);
$seq=~s/\n//g;

#tr and rev if is antisense
if($rev) {
    $seq=~tr/ATGC/TACG/;
    $seq=reverse $seq;
}

print $seq,"\n";