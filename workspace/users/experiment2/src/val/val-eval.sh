#!/bin/bash
# 2019, Jiri Hynek

# process arguments
input_file=$1
output_folder=$2
arg=$3 # -x for thorough output

if [ ! -f "$input_file" ]; then
  echo "err: unknown input file $input_file"
  echo "err: run \"./iis-val-eval.sh file_path output_folder [-x]\""
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

echo "cleaning..."

# prepare output folder
mkdir -p "$output_folder"
cd $output_folder
if [ -d $output_subfolder_folder ]; then
	rm -rf "$output_subfolder_folder"
fi
mkdir -p "$output_subfolder_folder"
cd $root_folder

# prepare temporary input folder
rm -rf $output_folder/$unzip_folder
unzip $input_file -d $output_folder/$unzip_folder >/dev/null
cd $output_folder/$unzip_folder

# unzip users archives
for d in x* # iterate over all files in current dir
do
  cd $d
  unzip -q -O utf8 "$d.zip" > /dev/null
  cd ..
done

echo "processing users files..."
for f in "${!files[@]}"
do
	declare -A map
	declare -A map2
	declare -A map12

	echo "processing $f.txt..."
	for d in x* # iterate over all files in current dir
	do
		if [ -d "$d" ] # if it's a directory
		then
			cd $d
			if [ -e "$f.txt" ]
			then
				c=`tail -c 1 "$f.txt"`
				if [ "$c" != "" ]; then
					echo "" >> "$f.txt" # append new line to read the last line properly
				fi;
				#echo "$d: OK"
				while IFS= read -r line; do
					#echo "$line"
					line=`echo $line | tr -d '[:space:]'`
					#if [[ "$line" =~ ^[0-90-90-9](_[ab])?:-?[012]:-?[012]:[12345]$ ]];
					if [[ "$line" =~ ^[0-9][0-9][0-9](:[-]?[012345])?:[-]?[012345]$ ]]
					then
						reg=${files[$f]};
						name=`echo "$line" | sed "s/$reg/\1/"`
						val1=`echo "$line" | sed "s/$reg/\2/"`
						val2=`echo "$line" | sed "s/$reg/\3/"`
						map[$name]=`echo "${map[$name]},$val1"`
						if [ "$val2" != "" ]; then
							map2[$name]=`echo "${map2[$name]},$val2"`
							val1=`echo "$val1" | sed 's/-//'` # absolute value
							val2=`echo "$val2" | sed 's/-//'` # absolute value
							# average converted to range 1-5 (similar range as density, etc.)
							#val12=`echo "scale=2; ((1-(($val1+$val2)/4.0))*4)+1" | bc | cut -c 1-1`
							val12=$(((4-($val1+$val2))+1)) # simplified
							map12[$name]=`echo "${map12[$name]},$val12"`
						fi;
				#		echo "$name $val1 $val2"
				#		name=`echo "$line" | sed 's/\([0-9][0-9][0-9]\(_[ab]\)\{0,1\}\):.*:.*:.*/\1/'`
				#		#value=`echo "$line" | sed 's/.*:.*:.*:\([1-5]\)/\1/'`
				#		valueV=`echo "$line" | sed 's/.*:\(.*\):.*:[1-5]/\1/'`
				#		valueH=`echo "$line" | sed 's/.*:.*:\(.*\):[1-5]/\1/'`
				#		valueV=`echo "$valueV" | sed 's/-//'`
				#		valueH=`echo "$valueH" | sed 's/-//'`
				#		value=`echo "scale=4; (1-(($valueV+$valueH)/6.0))*5" | bc`
				#		map[$name]=`echo "${map[$name]},$value"`
						#values=`echo "$line" | sed 's/.*:\(.*:.*:.*\)/\1/'`
						#all=`echo -e "$all\n$values"`
						#echo "${map[$name]}"
				#		continue;
					else
						echo "$d: problem line - $line";
					fi
				done < "$f.txt"
			else
				echo "$d: missing file $f.txt"
			fi
			cd ..
		fi
	done

	# results will be stored in global variable $result
	processValues "$(declare -p map)"
	length=`echo "${#map2[@]}"`
    if [ "$length" != "0" ]; then
		printf '%s\n' "$result" > $root_folder/$output_folder/$output_subfolder_folder/$f"_1.txt"
		processValues "$(declare -p map2)"
		printf '%s\n' "$result" > $root_folder/$output_folder/$output_subfolder_folder/$f"_2.txt"
		processValues "$(declare -p map12)"		
	fi
	printf '%s\n' "$result" > $root_folder/$output_folder/$output_subfolder_folder/$f.txt

	unset map
	unset map2
	unset map12
done;

cd $root_folder
rm -rf $output_folder/$unzip_folder
echo "done!"

