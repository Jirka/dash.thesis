#!/bin/bash
# 2019, Jiri Hynek

samples="../../../../dataset/dashboards/dashboards.zip"
folder="../../gen/all/color"

mkdir -p $folder

echo "preparing images..."
unzip $samples -d "$folder" >/dev/null
