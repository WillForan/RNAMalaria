#!/usr/bin/env bash

#CHANGE HERE
#or use parameter/argument
recent='March_2011'
#where files go
base='/home/RNA/PlasmodiumFalciparum/genome/';

#do we have a param?
if [ "$1 x" != " x" ] ; then
  recent=$1
fi

#where sanger has the genome files
url="ftp://ftp.sanger.ac.uk/pub/pathogens/Plasmodium/falciparum/3D7/3D7.latest_version/$recent/"
#where to put the gff files
save="${base}features/$(date +%Y-%m)"
#where the db file should go
db="${base}features/features.sqlite3"
#db schema
schema="${base}features/featuresSchema.sql"

#make save dir if it doesn't exist
if [ ! -d $save ]; then mkdir -p $save; fi

#dir for chroms
if [ ! -d $base/bychrom ]; then mkdir -p $base/bychrom; fi

#dir for blast database
if [ ! -d $base/blastdb]; then mkdir -p $base/blastdb; fi

#Download for each chrom
for i in 0{1..9} {10..14}; do
 #get the gff file, could wrap this in ()& to execute all downloads at once .. they aren't that big
 
 #check to see if we already have the file
 if [ ! -f $save/${i}.gff ]; then
     #download and extract
     wget ${url}Pf3D7_${i}.gff.gz -O $save/${i}.gff.gz;
     gunzip $save/${i}.gff.gz;
 else
     echo " ** Already have gff for chrom ${i} **"
 fi
 
done

#create database
#mv $db $db.bak;		#mv current to back-up
#sqlite3 $db < $schema	#generare the schema of the new one


#parse each file and add to db
for i in 0{1..9} {10..14}; do
    #add each chrom feature to db
 #   echo "Parsing chr$i feature data"
 #   ./parse.pl $save/${i}.gff #|sqlite3 $db
    
    #extract fasta for each chrom
    echo "Parsing chr$1 sequence data"
    awk "(NR>=$(grep -n \>Pf3D7 $save/${i}.gff| sed s/:.*$//)){print}" $save/${i}.gff > ${base}/bychrom/${i}.fasta
done

#make one large genome file
cat ${base}/bychrom/*.fasta > ${base}/PF3D7_$recent.fasta

#make the database with this file
formatdb -i ${base}/PF3D7_$recent.fasta  -t pf5 -p F
mv ${base}/PF3D7_$recent.fasta.n* ${base}/blastdb


