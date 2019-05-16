#!/bin/bash
# 2019, Jiri Hynek

dashboard_samples="../../../../dataset/dashboards/dashboards.zip"
unzip_folder="../gen/tmp"
dash_folder="../../widget-based/gen/all/color"
overall_file="../gen/val/single_line/avg/overall_color.txt"
output_folder="../gen/overall_sort"
sort_file=$output_folder"/overall_sort.txt"

if [ ! -f $overall_file ]; then
  echo "err: missing file $overall_file"
  echo "err: run the src/process.sh script first"
  exit
fi

mkdir -p $output_folder
cat $overall_file | grep -v "^$" | sed 's/^\([0-9]\{3,3\}\) \(.*\)/\2 \1/g' | sort -r | sed 's/^.*\([0-9]\{3,3\}\)/\1/g' > $sort_file

mkdir -p $unzip_folder
unzip "$dashboard_samples" -d "$unzip_folder" >/dev/null

i=1 
while IFS= read -r line; do
	if [[ "$line" =~ ^[0-9][0-9][0-9]$ ]]
	then
		img=`ls $unzip_folder/$line*`
		file=$(basename "$img")
		#echo "$file $img"
		if [ -f $img ]; then
			extension="${file##*.}"
			filename="${file%.*}"
			if (( $i < 10 )); then
				prefix="00"
			elif (( $i < 100 )); then
				prefix="0"
			else
				prefix=""
			fi
			output_file=$prefix$i"_"$filename"."$extension
			#echo $output_file
			cp $img $output_folder/$output_file
			i=$((i+1)) 
		fi
	fi
done < "$sort_file"

rm -rf $unzip_folder
