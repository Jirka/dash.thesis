#!/bin/bash
# 2019, Jiri Hynek

input_file=$1

if [ ! -f "$input_file" ]; then
  echo "err: unknown input file: $input_file"
  echo "err: run \"./iis-cmp-all.sh file_path\""
  exit
fi

file=$(basename "$input_file")
extension="${file##*.}"
length=`echo "${#extension}"`
length=$(($length+2))

output_file=`echo $input_file | rev | cut -c $length- | rev`
echo $output_file"_sort.txt"

cat $input_file | sed -e 's/[0-9][0-9][0-9]\t//g' | sort > $output_file"_sort.txt"
