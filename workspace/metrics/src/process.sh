#!/bin/bash
# 2019, Jiri Hynek

cd img
chmod +x ./prepare_img.sh
./prepare_img.sh
cd ..

cd users
chmod +x ./prepare_users.sh
./prepare_users.sh
cd ..

cd ref
chmod +x ./copy.sh
./copy.sh
chmod +x ./copy_to_sort_folder.sh
./copy_to_sort_folder.sh
cd ..

cd ref-body
chmod +x ./copy.sh
./copy.sh
chmod +x ./copy_to_sort_folder.sh
./copy_to_sort_folder.sh
cd ..

cd separate
chmod +x ./separate.sh
./separate.sh
cd ..
