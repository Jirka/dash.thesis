#!/bin/bash
# 2019, Jiri Hynek

input_file=$1
output_folder=$2

if [ ! -f "$input_file" ]; then
  echo "err: unknown input file: $input_file"
  echo "err: run \"./val.sh file_path output_folder\""
  exit
fi

containsSlash=`echo "$output_folder" | grep '/$'`
if [ $containsSlash != "" ]; then
  output_folder=`echo "$output_folder" | rev | cut -c 2- | rev`
fi

chmod +x val-eval.sh 
chmod +x val-stats.sh 
chmod +x val-separate.sh 

echo "./val-eval.sh $input_file $output_folder"
./val-eval.sh $input_file $output_folder
echo "./val-eval.sh $input_file $output_folder -x"
./val-eval.sh $input_file $output_folder -x
echo "./val-stats.sh $output_folder/single_line/"
./val-stats.sh "$output_folder/single_line/"
echo "./val-separate.sh $output_folder/single_line/avg/"
./val-separate.sh "$output_folder/single_line/avg/"

# s help script which uses final stats
#./overall-sort.sh
