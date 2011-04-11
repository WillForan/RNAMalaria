#!/usr/bin/env bash


BOWTIE="/home/RNA/Packages/Bowtie/bowtie-0.12.6/bowtie"
REF="/home/RNA/PlasmodiumFalciparum/genome/pf5/bowtie-index/pf5"
BASE="/home/RNA/PlasmodiumFalciparum/Llinas"


#inside base:
# use bowtie with refrence genome
# use ERR---._{1,2}.fastq paired reads from reads/##_hr_PAIRED
# align and put in alignments/##_hr_PAIRED/ERR---.txt

#
# This is mRNA not sRNA so it doesn't need to be trimmed?!
# Paired End DNA oligonucleotide sequences
#PE Adapters
#5' /Phos/-GATCGGAAGAGCGGTTCAGCAGGAATGCCGAG
#5' ACACTCTTTCCCTACACGACGCTCTTCCGATCT
#
#

#for each time stage (as directory reads/##_hr_PAIRED)
for dir in $(ls -d $BASE/reads/*hr_P*/); do 

 #get a good format for the state
 algdir=$(echo $dir | sed -e "s:$BASE/reads/\(.*\)/:\1:")
 echo $algdir

 #and make the dir
 mkdir -p alignments/$algdir;

 #for each 1/2 pair in time stage (usually two)
 for pair in $(ls $dir|sed -e 's/_\(1\|2\).*//'|uniq); do
     echo -e "\t$pair";

     #align!
     $BOWTIE $REF \
     --chunkmbs 128 \
     -1 ${dir}${pair}_1.fastq \
     -2 ${dir}${pair}_2.fastq \
     > $BASE/alignments/$algdir/$pair.txt

 done;
done;
