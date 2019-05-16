#!/bin/bash
# 2019, Jiri Hynek

# process arguments
input_file=$1
output_folder=$2
file1=$3
file2=$4
arg=$5

if [ ! -f "$input_file" ]; then
  echo "err: unknown input file: $input_file"
  echo "err: run \"./iis-cmp-eval.sh input_file_path file1 file2 [-xs]\""
  exit
fi

if [ "$arg" == "-x" ]; then
	arg_x=true
else
	arg_x=false
fi

if [ "$arg_x" == true ]; then
  output_subfolder_folder="mult_line"
else
  output_subfolder_folder="single_line"
fi

root_folder=`pwd`
unzip_folder="tmp"

regex="\([0-9][0-9][0-9]\):\(-\{0,1\}[012345]\)\(:\(-\{0,1\}[012345]\)\)\{0,1\}"

declare -a arr=("balance_black" "balance_color" "balance_gray" "colorfulness_color" "density_black" "density_color" "density_gray" "overall_color")

declare -A files=(
		["balance_black"]="\([0-9][0-9][0-9]\):\(-\{0,1\}[0123]\):\(-\{0,1\}[0123]\)"
		["balance_color"]="\([0-9][0-9][0-9]\):\(-\{0,1\}[0123]\):\(-\{0,1\}[0123]\)"
		["balance_gray"]="\([0-9][0-9][0-9]\):\(-\{0,1\}[0123]\):\(-\{0,1\}[0123]\)"
		["colorfulness_color"]="\([0-9][0-9][0-9]\):\([12345]\)\(\)"
		["density_black"]="\([0-9][0-9][0-9]\):\([12345]\)\(\)"
		["density_color"]="\([0-9][0-9][0-9]\):\([12345]\)\(\)"
		["density_gray"]="\([0-9][0-9][0-9]\):\([12345]\)\(\)"
		["overall_color"]="\([0-9][0-9][0-9]\):\([12345]\)\(\)"
)

if [ "${files[$file1]}" == "" ] || [ "${files[$file2]}" == "" ]
then
	echo "err: unknown input file"
	exit
fi

declare -A map

function appendNewLine {
	f=$1
	c=`tail -c 1 "$f"`
	if [ "$c" != "" ]; then
		echo "" >> "$f" # append new line to read the last line properly
	fi;
}

echo "cleaning..."

# prepare output folder
mkdir -p $output_folder
cd $output_folder
# don't delete folder, append results to existing folder
#if [ -d $output_subfolder_folder ]; then
#	rm -rf "$output_subfolder_folder"
#fi
mkdir -p $output_subfolder_folder
cd $root_folder

# prepare temporary input folder
cd $output_folder
rm -rf $unzip_folder
unzip $input_file -d $unzip_folder >/dev/null
cd $unzip_folder

result=""

function processValues {
    eval "declare -A m"=${1#*=}
    #declare -p m
	#echo "${m[@]}"

	arr=($(
    for el in "${!m[@]}"
    do
        echo "$el"
    done | sort) )

	result=$(
    for item in "${arr[@]}" ; do
	    KEY=$item
		if [ $arg_x == true ]
		then
			IFS=',' read -r -a VALUES <<< "${m[$KEY]}"
			for VALUE in "${VALUES[@]}"
			do
				if [ "$VALUE" != "" ]; then
					printf "%s\t%s\n" "$KEY" "$VALUE"
				fi
			done
			#echo ""
		else
			VALUE=${m[$KEY]}
			printf "%s%s\n" "$KEY" "$VALUE"
        fi;
	done)
}

declare -A map
declare -A map2
declare -A map12

echo "processing wis files..."
for d in x* # iterate over all files in current dir
do
	#echo "$d"
	if [ -d "$d" ] # if it's a directory
	then
		cd $d
		# unzip users archives
		unzip -q -O utf8 "$d.zip" > /dev/null
		if [ -e "$file1.txt" ] && [ -e "$file2.txt" ]
		then
			#echo "$d: OK"
			appendNewLine "$file1.txt"
			appendNewLine "$file2.txt"

			# process lines of the first file
			i=1
			while IFS= read -r f1_line; do
				#echo "$line"
				f1_line=`echo $f1_line | tr -d '[:space:]'`
				if [[ "$f1_line" =~ ^[0-9][0-9][0-9](:[-]?[012345])?:[-]?[012345]$ ]]
				then
					# parse line
					f1_reg=${files[$file1]};
					f1_name=`echo "$f1_line" | sed "s/$f1_reg/\1/"`
					f1_val1=`echo "$f1_line" | sed "s/$f1_reg/\2/"`
					f1_val2=`echo "$f1_line" | sed "s/$f1_reg/\3/"`
					
					# get appropriate second line
					#line_f2=`cat $file2.txt | grep "^$name:"`
					f2_line=`cat $file2.txt | head -$i | tail -1` # names can differ between the color, black and gray groups
					#echo "$line_f2"
					if [[ "$f2_line" =~ ^[0-9][0-9][0-9](:[-]?[012345])?:[-]?[012345]$ ]]
					then
						# parse the second line (only the first value is important)
						f2_reg=${files[$file2]};
						f2_val1=`echo "$f2_line" | sed "s/$f2_reg/\2/"`
						f2_val2=`echo "$f2_line" | sed "s/$f2_reg/\3/"`

						# create first relation between values of two files and store it in map
						map[$f1_name]=`echo "${map[$f1_name]},$f1_val1:$f2_val1"`

						f1_val12=""
						if [ "$f1_val2" != "" ]; then
							val1_abs=`echo "$f1_val1" | sed 's/-//'` # absolute value
							val2_abs=`echo "$f1_val2" | sed 's/-//'` # absolute value
							# average converted to range 1-5 (similar range as density, etc.)
							f1_val12=$(((4-($val1_abs+$val2_abs))+1)) # simplified
						fi

						f2_val12=""
						if [ "$f2_val2" != "" ]; then
							val1_abs=`echo "$f2_val1" | sed 's/-//'` # absolute value
							val2_abs=`echo "$f2_val2" | sed 's/-//'` # absolute value
							f2_val12=$(((4-($val1_abs+$val2_abs))+1)) # simplified
						fi

						# create remaining relations between values of two files and store it in map
						if [ "$f1_val12" != "" ] && [ "$f2_val12" != "" ]; then
							map2[$f1_name]=`echo "${map2[$f1_name]},$f1_val2:$f2_val2"`
							map12[$f1_name]=`echo "${map12[$f1_name]},$f1_val12:$f2_val12"`
						elif [ "$f1_val12" != "" ]; then
							map2[$f1_name]=`echo "${map2[$f1_name]},$f1_val2:$f2_val1"`
							map12[$f1_name]=`echo "${map12[$f1_name]},$f1_val12:$f2_val1"`
						elif [ "$f2_val12" != "" ]; then
							map2[$f1_name]=`echo "${map2[$f1_name]},$f1_val1:$f2_val2"`
							map12[$f1_name]=`echo "${map12[$f1_name]},$f1_val1:$f2_val12"`
						fi
					fi
				fi
			i=$(($i+1))
			done < $file1.txt
		else
			echo "$d: missing file $file1.txt or $file2.txt"
		fi
		cd ..
	fi
done

echo "making results..."
processValues "$(declare -p map)"
length=`echo "${#map2[@]}"`
if [ "$length" != "0" ]; then
	printf '%s\n' "$result" > $root_folder/$output_folder/$output_subfolder_folder/$file1"_"$file2"_1.txt"
	processValues "$(declare -p map2)"
	printf '%s\n' "$result" > $root_folder/$output_folder/$output_subfolder_folder/$file1"_"$file2"_2.txt"
	processValues "$(declare -p map12)"		
fi
printf '%s\n' "$result" > $root_folder/$output_folder/$output_subfolder_folder/$file1"_"$file2.txt

unset map
unset map2
unset map12

cd $root_folder
rm -rf $output_folder/$unzip_folder
echo "done!"

