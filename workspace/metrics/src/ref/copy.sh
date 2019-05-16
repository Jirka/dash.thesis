#!/bin/sh
# 2019, Jiri Hynek

dest_folder="../../gen/ref"
src_folder="../../../../dataset/regions/ref-regions.zip"

echo "generating ref..."
mkdir -p $dest_folder
unzip $src_folder -d "$dest_folder" >/dev/null
cd $dest_folder

for i in * # iterate over all files in current dir
do
  name=`echo "$i" | cut -c 1-3 `
  if [ -e ../../gen/all/color/$name* ]
  then
    cp ../../gen/all/color/$name* .
  fi
done
