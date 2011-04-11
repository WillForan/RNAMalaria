#!/usr/bin/env bash

wget 'http://www.ebi.ac.uk/ena/data/view/reports/sra/fastq_files/internal/ERA000119'
echo -n "Size(MB): "
cut -d'	' -f15 ERA000119|tr [MbFileSize] ' '|awk 'BEGIN{ summ=0 } {summ+=$1} END{print summ}'

cut -d'	' -f8-9,14,17 ERA000119 |grep hr|  sed -e "s/hr.*	\(P\|S\)/hr_\1/" -e 's/^8/08/' -e 's/zero/00/' | 
while read dir file dl;  do
  echo $file
  if [ ! -d $dir ]; then
     mkdir -p reads/$dir
  fi
  wget $dl -O reads/$dir/$file;
  gunzip reads/$dir/$file;
done

