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

declare -a well=(
	"015" "025" "035" "045" "055" "065" "085" "105" "115"
	"215" "225" "235" "245" "255" "265" "285" "305" "315"
	"415" "425" "435" "445" "455" "465" "485" "505" "515"
)

#declare -a skip=("076" "276" "476")
declare -a skip=("999")

for f in *.txt # iterate over all files in current dir
do
	echo "$f"

	first=""
	second=""
	while IFS= read -r line; do
		#echo "$line"
		#line=`echo $line | tr -d '[:space:]'`
		if [[ "$line" =~ ^[0-9][0-9][0-9](.)*$ ]]
		then
			reg="\([0-9][0-9][0-9]\).*";
			name=`echo "$line" | sed "s/$reg/\1/"`
			#echo "$name $vals"
			
			contains=false
			for el in "${skip[@]}"
			do
				if [ "$name" == "$el" ]; then
					contains=true
					break;
				fi
			done

			# ignore values of skip array
			if [ $contains == false ]; then
				for el in "${well[@]}"
				do
					if [ "$name" == "$el" ]; then
						contains=true
						break;
					fi
				done

				if [ $contains == true ]; then
					if [ "$first" == "" ]; then
						first="$line"
					else
						first="$first\n$line"
					fi
				else
					if [ "$second" == "" ]; then
						second="$line"
					else
						second="$second\n$line"
					fi
				fi
			fi
		else
			echo "$d: problem line - $line";
		fi
	done < "$f"

    #printf "ahoj\nahoj"
	echo -e $first > $f
	echo "" >> $f
	echo -e $second >> $f
done

cd $act_path
