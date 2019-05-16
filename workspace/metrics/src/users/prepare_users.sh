#!/bin/sh
# 2019, Jiri Hynek

echo "generating users-2016..."

dest_folder="../../gen"
src_folder="../../../../dataset/regions/"
wis_id="regions"
images="zip"
logins="logins.txt"

echo "unpacking wis archive..."
#rm -rf "$wis_id"
mkdir -p $dest_folder
unzip "$src_folder$wis_id.zip" -d "$dest_folder" >/dev/null
cd "$dest_folder"

echo "unpacking and analyzing student archives..."
for i in x* # iterate over all files in current dir
do
	if [ -d "$i" ] # if it's a directory
	then
		cd $i
		if [ -e "$i.zip" ]
		then
			unzip "$i.zip" >/dev/null
			if [ -d "$i" ]
			then
				for j in "$i"/*.xml
				do
					mv $j .
				done
			fi
			xmlCount=`ls | grep "^[0-9][0-9][0-9].xml$" | wc -l`
			if ! [ $xmlCount -eq "20" ]
			then
				echo "$i: does not contain 20 xml files but $xmlCount."
			fi
		else
			echo "$i: missing archive $i.zip"
		fi
		cd ..
		#group=`cat ../"$logins" | grep $i | sed 's/.*d\(.*\)\.zip/\1/'`
		#mkdir -p "$group"
		#mv $i $group/
		#cp hodnoceni-obhajoba "$i" # copy water.txt into it
	fi
done

echo "copying image files..."
for i in x* # iterate over all files in current dir
do
	if [ -d "$i" ] # if it's a directory
	then
		cd $i
		for j in *.xml
		do
			name=`echo "$j" | rev | cut -c 5- | rev`
			if [ -e ../../gen/all/color/$name* ]
			then
				cp ../../gen/all/color/$name* .
			fi
		done
		cd ..
		#cp hodnoceni-obhajoba "$i" # copy water.txt into it
	fi
done

mkdir sort-id
mkdir sort-login

echo "sorting image files..."
for i in x* # iterate over all files in current dir
do
	if [ -d "$i" ] # if it's a directory
	then
		cd $i
		for j in [0-9][0-9][0-9].*
		do
			#"^[0-9][0-9][0-9].xml$"
			#grep -q -E '^[0-9]+$'
			name=`echo "$j" | cut -c 1-3 `
			mkdir -p ../sort-id/"$name"
			cp "$j" ../sort-id/"$name"/"$i"_"$j"
		done
		rm $i.zip
		cd ..
		mv $i sort-login/
		#cp hodnoceni-obhajoba "$i" # copy water.txt into it
	fi
done

cd ..
