#!/bin/bash
# 2019, Jiri Hynek

output_folder=$1

if [ ! -d "$output_folder" ]; then
  echo "err: unknown stats folder: $output_folder"
  echo "err: run \"./iis-val-all.sh folder_path\""
  exit
fi

act_path=`pwd`
cd $output_folder
output_subfolder_folder="avg"
mkdir -p $output_subfolder_folder

for f in *.txt # iterate over all files in current dir
do
	echo "$f"
	rm -rf $output_subfolder_folder/$f
	while IFS= read -r line; do
		#echo "$line"
		line=`echo $line | tr -d '[:space:]'`
		if [[ "$line" =~ ^[0-9][0-9][0-9](,[-]?[012345])*$ ]]
		then
			reg="\([0-9][0-9][0-9]\),\(.*\)";
			name=`echo "$line" | sed "s/$reg/\1/"`
			vals=`echo "$line" | sed "s/$reg/\2/"`
			#echo "$name $vals"
			IFS=',' read -r -a VALUES <<< "$vals"

			# mean
			sum=0
			i=0
			for VALUE in "${VALUES[@]}"
			do
				if [ "$VALUE" != "" ]; then
					sum=$(($sum+$VALUE))
					i=$(($i+1))
				fi
			done
			mean=`echo "scale=10; $sum/$i" | bc`

			# variance
			variance=0
			i=0
			for VALUE in "${VALUES[@]}"
			do
				if [ "$VALUE" != "" ]; then
					variance=`echo "scale=10; $variance+(($mean-($VALUE))*($mean-($VALUE)))" | bc`
					i=$(($i+1))
				fi
			done
			variance=`echo "scale=10; $variance/$i" | bc`

			# stdev
			stdev=`echo "scale=10; sqrt($variance)" | bc`

			# float number starting with dot
			if [[ "$mean" == \.* ]]; then
				mean="0"$mean
			elif [[ "$mean" == -\.* ]]; then
				mean=`echo "$mean" | sed 's/-//'` # absolute value
				mean="-0"$mean
			fi

			if [[ "$stdev" == \.* ]]; then
				stdev="0"$stdev
			elif [[ "$stdev" == -\.* ]]; then
				stdev=`echo "$stdev" | sed 's/-//'` # absolute value
				stdev="-0"$stdev
			fi

			printf "%s\t%s\t%s\n" "$name" "$mean" "$stdev" >> $output_subfolder_folder/$f
		else
			echo "$d: problem line - $line";
		fi
	done < "$f"
done

cd $act_path
