#!/bin/sh
# 2019, Jiri Hynek

echo "copy ref to sort-id..."
folder="../../gen/ref"

cd $folder

for i in * # iterate over all files in current dir
do
  name=`echo "$i" | cut -c 1-3 `
  if [ -d ../sort-id/"$name" ]
  then
    cp $i ../sort-id/"$name"/
  fi
done
