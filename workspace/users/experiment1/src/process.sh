#!/bin/bash
# 2019, Jiri Hynek

output_folder="../gen/"
output_folder_balance=$output_folder"balance/"
output_folder_balance_VH=$output_folder"balance_VH/"
output_file=$output_folder_balance"stats.txt"
output_file_VH=$output_folder_balance_VH"stats_VH.txt"
output_file_all=$output_folder"all_values.txt"
output_file_V=$output_folder_balance_VH"stats_V.txt"
output_file_H=$output_folder_balance_VH"stats_H.txt"
input_folder="../../../../dataset/reviews/"
unpack_folder=$output_folder"tmp"
#input_file="63187.zip"
input_file="experiment1.zip"
samples_list_file="./samples.txt"

declare -A map
declare -A mapVH
declare -A mapV
declare -A mapH

echo "cleaning..."
rm -rf "$unpack_folder"
mkdir -p "$unpack_folder"
unzip "$input_folder/$input_file" -d "$unpack_folder" >/dev/null

echo "preparing..."
for i in $unpack_folder/x* # iterate over all files in current dir
do
	if [ -d "$i" ] # if it's a directory
	then
		login="${i/$unpack_folder\//}"
		if [ -e "$i/balance.txt" ]
		then
			echo "$login: OK"
			c=`tail -c 1 "$i/balance.txt"`
			if [ "$c" != "" ]; then
				echo "" >> "$i/balance.txt" # append new line to read the last line properly
			fi;
			while IFS= read -r line; do
				line=`echo $line | tr -d '[:space:]'`
				#if [[ "$line" =~ ^[0-90-90-9](_[ab])?:-?[012]:-?[012]:[12345]$ ]];
				if [[ "$line" =~ ^[0-9][0-9][0-9](_[ab])?:[-]?[012]:[-]?[012]:[1-5]$ ]]
				then
					name=`echo "$line" | sed 's/\([0-9][0-9][0-9]\(_[ab]\)\{0,1\}\):.*:.*:.*/\1/'`
					value=`echo "$line" | sed 's/.*:.*:.*:\([1-5]\)/\1/'`
					valueV=`echo "$line" | sed 's/.*:\(.*\):.*:[1-5]/\1/'`
					valueH=`echo "$line" | sed 's/.*:.*:\(.*\):[1-5]/\1/'`
					valueVabs=`echo "$valueV" | sed 's/-//'` # absolute value
					valueHabs=`echo "$valueH" | sed 's/-//'` # absolute value`
					valueVH=$(((4-($valueVabs+$valueHabs))+1)) # simplified
					map[$name]=`echo "${map[$name]},$value"`
					mapVH[$name]=`echo "${mapVH[$name]},$valueVH"`
					mapV[$name]=`echo "${mapV[$name]},$valueV"`
					mapH[$name]=`echo "${mapH[$name]},$valueH"`
					values=`echo "$line" | sed 's/.*:\(.*:.*:.*\)/\1/'`
					all=`echo -e "$all\n$values"`
					#echo "${map[$name]}"
					continue;
				else
					echo "$login: problem line - $line";
				fi
			done < "$i/balance.txt"
		else
			echo "$login: missing archive balance.txt"
		fi
	fi
done

echo "generating output..."

rm -rf $output_file $output_file_VH $output_file_V $output_file_H

mkdir -p $output_folder
mkdir -p $output_folder_balance
mkdir -p $output_folder_balance_VH

#sorted output
while IFS= read -r line; do
  echo "$line${map[$line]}" >> $output_file
  echo "$line${mapVH[$line]}" >> $output_file_VH
  echo "$line${mapV[$line]}" >> $output_file_V
  echo "$line${mapH[$line]}" >> $output_file_H
done < "$samples_list_file"
echo "$all" > $output_file_all

#unsorted output
#for item in "${!map[@]}" ; do
#    KEY=$item
#    VALUE=${map[$KEY]}
#    printf "%s%s\n" "$KEY" "$VALUE"
#done

rm -rf "$unpack_folder"
