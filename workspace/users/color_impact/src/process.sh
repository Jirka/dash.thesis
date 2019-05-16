#!/bin/bash
# 2019, Jiri Hynek

input_folder="../../../../dataset/reviews"
input_file=$input_folder"/color_impact.zip"
output_folder="../gen"
unzip_folder=$output_folder"/tmp"

declare -A files=(
		["balance_color"]="\([0-9]\{1,3\}\):\(-\{0,1\}[012345]\)\(:\(-\{0,1\}[012345]\)\)\{0,1\}"
		["symmetry_symmetry"]=".*-\([0-9]\{1,3\}\):\(-\{0,1\}[012345]\)\(:\(-\{0,1\}[012345]\)\)\{0,1\}"
)

echo "cleaning..."
rm -rf "$unzip_folder"
mkdir -p "$unzip_folder"
unzip $input_file -d "$unzip_folder" >/dev/null

echo "preparing..."
for f in "${!files[@]}"
do
	echo "processing $f"
	declare -A map
    declare -A map2
	for ff in $unzip_folder/$f* # iterate over all files in current dir
	do
		#echo "$d: OK"
		while IFS='' read -r line || [[ -n "$line" ]]; do
			line=`echo $line | tr -d '[:space:]'`
			#if [[ "$line" =~ ^[0-90-90-9](_[ab])?:-?[012]:-?[012]:[12345]$ ]];
			if [[ "$line" =~ ^.*[0-9][0-9]*(:[-]?[012345])?:[-]?[012345]$ ]]
			then
				reg=${files[$f]};
				name=`echo "$line" | sed "s/$reg/\1/"`
				val1=`echo "$line" | sed "s/$reg/\2/"`
				val2=`echo "$line" | sed "s/$reg/\4/"`
				if [[ "$name" =~ ^[0-9]$ ]]
				then
					name="0$name"
				fi;
				map[$name]=`echo "${map[$name]},$val1"`
				if [ "$val2" != "" ]; then
					map2[$name]=`echo "${map2[$name]},$val2"`
				fi;
			else
				if [[ "$line" =~ ^[0-9]*/[0-9]*/[0-9]*:[0-9]*:[0-9]*[a-z][a-z]$ ]]
				then
					echo "processing $ff - $line"
				else
					echo "$ff: problem line - $line";
				fi
			fi
		done < "$ff"
	done

	#while IFS= read -r line; do
	#  echo "$line${map[$line]}"
	#done < "variants.txt"
	#echo "$all"

	
    arr=($(
    for el in "${!map[@]}"
    do
        echo "$el"
    done | sort) )

	result=$(
    for item in "${arr[@]}" ; do
	    KEY=$item
		VALUE=${map[$KEY]}
        #IFS=',' read -r -a VALUES <<< "${map[$KEY]}"
		#for VALUE in "${VALUES[@]}"
		#do
		#	printf "%s\t%s\n" "$KEY" "$VALUE"
		#done
		#echo ""
	    printf "%s%s\n" "$KEY" "$VALUE"
	done)

    length=`echo "${#map2[@]}"`
    if [ "$length" != "0" ]; then
		arr=($(
		for el in "${!map[@]}"
		do
		    echo "$el"
		done | sort) )

		result2=$(
		for item in "${arr[@]}" ; do
			KEY=$item
			VALUE=${map2[$KEY]}
		    #IFS=',' read -r -a VALUES <<< "${map2[$KEY]}"
			#for VALUE in "${VALUES[@]}"
			#do
			#	printf "%s\t%s\n" "$KEY" "$VALUE"
			#done
			#echo ""
			printf "%s%s\n" "$KEY" "$VALUE"
		done)
	fi;

    printf '%s\n' "$result" > $output_folder"/$f.txt"
	if [ "$length" != "0" ]; then
		echo "ahoj";
		printf '%s\n' "$result2" > $output_folder"/"$f"_2.txt"
	fi;
	unset map
	unset map2
done;

rm -rf "$unzip_folder"
