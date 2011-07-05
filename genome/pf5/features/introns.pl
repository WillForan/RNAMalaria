#!/usr/bin/env perl
use strict; use warnings;

####
# Introns -- get introns from gene/exon positions
####

open my $pipeFH, "sqlite3 features.db 'select * from features 				\
	where supercontig like \"chr%\" and (type like \"exon\" or type like \"gene\") 	\
	order by strand,supercontig,start asc,end desc					\
	' |" or die "cannot open pipeFH: $!\n";

my @gene=();
my @introns=();
my @intron=();
my $DEBUG=0;
while (<$pipeFH>) {
    my ($supercontig, $type, $strand, $start,$end,$description)= split /\|/;

    if($type eq 'gene') {

	#take care of previous
	if($#intron>-1){
	    #intron end is gene end
	    $intron[1]=$gene[2];
	    push @introns, [@intron];
	    print "at new gene, but have leftover intron data; added:", join("|",@intron), "\n" if $DEBUG;
	}

	if($#introns>-1){
	    print(join("\t",$supercontig, @{$_}),"\n") for @introns;
	    print "\n\n" if $DEBUG;
	}

	#move on to new
	@gene=($supercontig,$start,$end);
	print "new gene:", join("|",@gene), "\n" if $DEBUG;
	@introns=();
	@intron=();
    }
    else{ #exon

	#g:  1----------2
	#a:  s----------e
	#b:  s----exxxxxx
	#c:  xxs------exx
	#d   xxxxxxxs---e
	if($gene[1] == $start){
	    print "exon($start|$end) is at start of gene\t" if $DEBUG;
	    if($gene[2] == $end){
		print "exon is gene; skip\n" if $DEBUG;
		next; #a -- exon is gene
	    }

	    #b: exon ends before, gene. start intron. 
	    push @intron, $end+1;
	    print "found intron start: $end+1\n" if $DEBUG;
	}
	else{ 
	    print "exon($start|$end) is after start\t" if $DEBUG;

	    #if this exon is not the first, use it's start as the end of prev intron
	    if($#intron>-1) { 
		$intron[1]=$start-1;
		push @introns, [@intron];
		print "start of intron exists, finished off\t", join("|",@intron),"\n" if $DEBUG;
		@intron=();
	    }

	    #c
	    if($gene[2] != $end ){
		push @intron, $end+1;
		print "exon is not at the end, pushing exon end ($end+1) to intron\n" if $DEBUG; 
	    }
	    #if it si the end nothing needs to be done!
	    #else{
	    #	#d
	    #	push @introns, [$gene[1],$start-1];
	    #	print "exon is last, pushing from gene start to exon start ($gene[1]|$start-1)\n" if $DEBUG;
	    #}
	}
    }

}




