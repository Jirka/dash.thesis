#!/bin/sh
# 2019, Jiri Hynek

folder="../../gen"

cd $folder/sort-id

min=0
max=100
two=2

for i in * # iterate over all files in current dir
do
  if [ -d "$i" ] # if it's a directory
  then
    prefix=`echo "$i" | cut -c 1-1 `
    if [ "$prefix" != "_" ]
    then
        count=`ls -1 $i | grep ^x.* | wc -l`
        count=$((count / two))
        echo "$i $count"
    fi
  fi
done
