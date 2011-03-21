#!/usr/bin/env perl
use strict; use warnings;

#get params (database, help?)
use Getopt::Std;
my %opt=('d'=>'/home/RNA/PlasmodiumFalciparum/genome/features/features.sqlite3');
getopts('d:h',\%opt);
&HELP_MESSAGE if(defined($opt{'h'}));
sub HELP_MESSAGE {
    print "$0 [-d sqlitedb] ##.gff\n";
    exit;   
}


#chrom number is given by the file as argument, and only one argument is given
&HELP_MESSAGE if($#ARGV!=0 || !($ARGV[0]=~m/0?(\d+)\.gff$/));
my $chrom=$1;

#open the database
use DBI;
my $dbh = DBI->connect("dbi:SQLite:dbname=$opt{'d'}","","") or die "Cannot open DB: $!\n"; 
$dbh->{RaiseError} = 0; #don't totally die on error, instead print messages
$dbh->{AutoCommit} = 0; 

use URI::Escape; #uri_unescape() to get back characters from %2D, etc 

#for intput
while(<>){
    next if !m/\t/;  #skip to next if there are no fields to read
    chomp;
    my $read=$_;

    s/([=\t])\./$1NULL/g;		#=. is the same as =NULL
    s/blastp%2Bgo_file/blastpgo_file/g;	#SQL can't handle the % in a key  (or rather I don't want to escape the key)

    #this is not given a value, lets say if it appears it is true
    s/stop_codon_redefined_as_selenocysteine.*?;/stop_codon_redefined_as_selenocysteine=true;/g;
    
    my @in  =  split/\t/; 
    my %keys=  split(/[=;]/, $in[8]);
    
    #add the other elements to the hash
    @keys{("source", "feature", "start", "end", "score", "strand", "frame","chrom")}=(@in[1..7],$chrom);
    
    #Uncomment to see just feilds (useful to pipe to |sort|uniq -c)
    #print join("\n",keys(%extra)),"\n"; next; #used to get counts of all the keys in the "group" gff position
    
    #Add to the database!
    my $atts= join(', ',keys %keys);
    my $vals= join(', ',map { $_=uri_unescape($_); $_=~s/'/''/g; qq/'$_'/ } values %keys);
    my $added = $dbh->do(qq{INSERT INTO features ($atts) VALUES ($vals)});
    if(!$added){
      print "$atts\n$vals\n$read\n\n";
    }
}
$dbh->commit();
$dbh->disconnect();


