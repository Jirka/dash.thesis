#!/bin/bash
# 2019, Jiri Hynek

input_file=$1
output_folder=$2

if [ ! -f "$input_file" ]; then
  echo "err: unknown input file: $input_file"
  echo "err: run \"./cmp.sh folder_file\""
  exit
fi

containsSlash=`echo "$output_folder" | grep '/$'`
if [ $containsSlash != "" ]; then
  output_folder=`echo "$output_folder" | rev | cut -c 2- | rev`
fi

chmod +x cmp-eval.sh 
chmod +x cmp-sort.sh 

#echo "balance"
echo "./cmp-eval.sh $input_file $output_folder balance_color balance_black -x"
./cmp-eval.sh $input_file $output_folder balance_color balance_black -x
echo "./cmp-eval.sh $input_file balance_color balance_gray -x"
./cmp-eval.sh $input_file $output_folder balance_color balance_gray -x
echo "./cmp-eval.sh $input_file $output_folder balance_gray balance_black -x"
./cmp-eval.sh $input_file $output_folder balance_gray balance_black -x

#echo "density"
echo "./cmp-eval.sh $input_file $output_folder density_color density_black -x"
./cmp-eval.sh $input_file $output_folder density_color density_black -x
echo "./cmp-eval.sh $input_file $output_folder density_color density_gray -x"
./cmp-eval.sh $input_file $output_folder density_color density_gray -x
echo "./cmp-eval.sh $input_file $output_folder density_gray density_black -x"
./cmp-eval.sh $input_file $output_folder density_gray density_black -x

echo "./cmp-eval.sh $input_file $output_folder balance_color overall_color -x"
./cmp-eval.sh $input_file $output_folder balance_color overall_color -x
echo "./cmp-eval.sh $input_file $output_folder balance_black overall_color -x"
./cmp-eval.sh $input_file $output_folder balance_black overall_color -x
echo "./cmp-eval.sh $input_file $output_folder balance_gray overall_color -x"
./cmp-eval.sh $input_file $output_folder balance_gray overall_color -x
echo "./cmp-sort.sh $output_folder/mult_line/balance_color_overall_color.txt"
./cmp-sort.sh $output_folder/mult_line/balance_color_overall_color.txt

echo "./cmp-eval.sh $input_file $output_folder density_color overall_color -x"
./cmp-eval.sh $input_file $output_folder density_color overall_color -x
echo "./cmp-eval.sh $input_file $output_folder density_black overall_color -x"
./cmp-eval.sh $input_file $output_folder density_black overall_color -x
echo "./cmp-eval.sh $input_file $output_folder density_gray overall_color -x"
./cmp-eval.sh $input_file $output_folder density_gray overall_color -x
echo "./cmp-sort.sh $output_folder/mult_line/density_color_overall_color.txt"
./cmp-sort.sh $output_folder/mult_line/density_color_overall_color.txt

echo "./cmp-eval.sh $input_file $output_folder colorfulness_color overall_color -x"
./cmp-eval.sh $input_file $output_folder colorfulness_color overall_color -x
echo "./cmp-sort.sh $output_folder/mult_line/colorfulness_color_overall_color.txt"
./cmp-sort.sh $output_folder/mult_line/colorfulness_color_overall_color.txt
