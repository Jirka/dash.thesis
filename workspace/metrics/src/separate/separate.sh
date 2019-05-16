#!/bin/bash
# 2019, Jiri Hynek

folder="../../gen/sort-id"

declare -A name_map=(
  ["001"]="b"
  ["002"]="b"
  ["003"]="b"
  ["004"]="b"
  ["005"]="b"
  ["006"]="b"
  ["007"]="b"
  ["008"]="b"
  ["009"]="b"
  ["010"]="b"
  ["011"]="b"
  ["012"]="b"
  ["013"]="b"
  ["014"]="b"
  ["015"]="a"
  ["016"]="b"
  ["017"]="b"
  ["018"]="b"
  ["019"]="b"
  ["020"]="b"
  ["021"]="b"
  ["022"]="b"
  ["023"]="b"
  ["024"]="b"
  ["025"]="a"
  ["026"]="b"
  ["027"]="b"
  ["028"]="b"
  ["029"]="b"
  ["030"]="b"
  ["031"]="b"
  ["032"]="b"
  ["033"]="b"
  ["034"]="b"
  ["035"]="a"
  ["036"]="b"
  ["037"]="b"
  ["038"]="b"
  ["039"]="b"
  ["040"]="b"
  ["041"]="b"
  ["042"]="b"
  ["043"]="b"
  ["044"]="b"
  ["045"]="a"
  ["046"]="b"
  ["047"]="b"
  ["048"]="b"
  ["049"]="b"
  ["050"]="b"
  ["051"]="b"
  ["052"]="b"
  ["053"]="b"
  ["054"]="b"
  ["055"]="a"
  ["056"]="b"
  ["057"]="b"
  ["058"]="b"
  ["059"]="b"
  ["060"]="b"
  ["061"]="b"
  ["062"]="b"
  ["063"]="b"
  ["064"]="b"
  ["065"]="a"
  ["066"]="b"
  ["067"]="b"
  ["068"]="b"
  ["069"]="b"
  ["070"]="b"
  ["071"]="b"
  ["072"]="b"
  ["073"]="b"
  ["074"]="b"
  ["075"]="b"
  ["076"]="b"
  ["077"]="b"
  ["078"]="b"
  ["079"]="b"
  ["080"]="b"
  ["081"]="b"
  ["082"]="b"
  ["083"]="b"
  ["084"]="b"
  ["085"]="a"
  ["086"]="b"
  ["087"]="b"
  ["088"]="b"
  ["089"]="b"
  ["090"]="b"
  ["091"]="b"
  ["092"]="b"
  ["093"]="b"
  ["094"]="b"
  ["095"]="b"
  ["096"]="b"
  ["097"]="b"
  ["098"]="b"
  ["099"]="b"
  ["100"]="b"
  ["101"]="b"
  ["102"]="b"
  ["103"]="b"
  ["104"]="b"
  ["105"]="a"
  ["106"]="b"
  ["107"]="b"
  ["108"]="b"
  ["109"]="b"
  ["110"]="b"
  ["111"]="b"
  ["112"]="b"
  ["113"]="b"
  ["114"]="b"
  ["115"]="a"
  ["116"]="b"
  ["117"]="b"
  ["118"]="b"
  ["119"]="b"
  ["120"]="b"
  ["121"]="b"
  ["122"]="b"
  ["123"]="b"
  ["124"]="b"
  ["125"]="b"
  ["126"]="b"
  ["127"]="b"
  ["128"]="b"
  ["129"]="b"
  ["130"]="b"
)

function rename() {
  file=$1
  file_name=$(basename "$file")
  number=`expr "$file_name" : '^.*\([0-9][0-9][0-9]\).*$'`
  prefix="${name_map[$number]}"
  file_name2="${file_name/$number/$prefix$number}"
  #echo "$file_name -> $file_name2"
  mv "$file_name" "$file_name2"
}

echo "separate well-designed in sort-id folder..."
cd "$folder"
for dashboard_group in *
do
  cd "$dashboard_group"
  for f in *
  do
    rename "$f"
  done;
  cd ..
  file=$(basename "$dashboard_group")
  rename "$file"
done;
