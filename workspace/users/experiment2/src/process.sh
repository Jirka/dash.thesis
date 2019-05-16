#!/bin/bash
# 2019, Jiri Hynek

input_file=$1

if [ ! -f "$input_file" ]; then
  input_file="../../../../dataset/reviews/experiment2.zip"
fi

cd val
chmod +x val.sh 
echo "./val.sh ../$input_file ../../gen/val/"
./val.sh "../$input_file" "../../gen/val/"
cd ..

cd cmp
chmod +x cmp.sh 
echo "./cmp.sh ../$input_file ../../gen/cmp/"
./cmp.sh "../$input_file" "../../gen/cmp/"
cd ..
