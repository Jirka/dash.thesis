#!/bin/sh
# 2019, Jiri Hynek

echo "copy ref-body to sort-id..."
folder="../../gen/ref-body"

cd $folder

for i in * # iterate over all files in current dir
do
  name=`echo "$i" | cut -c 1-3 `
  suffix=`echo "$i" | cut -c 4- `
  if [ -d ../sort-id/"$name" ]
  then
    cp $i ../sort-id/"$name"/$name"_body"$suffix
  fi
done
