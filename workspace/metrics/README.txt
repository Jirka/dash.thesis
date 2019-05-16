# 2019, Jiri Hynek

## description of scripts
## important! run the scripts in the folder where the scripts are located (cd src/)

# ./src/process.sh
## analyses the description of regions (from the dataset) and prepare workspace for Dashboard Analyzer
## output: ./gen
## it executes the following scripts:


	# ./src/img/prepare_img.sh
	## unzips dashboard samples (from the dataset) into the gen folder


	# ./src/users/prepare_users.sh
	## unzips descriptions of regions (from the dataset) and link them with the dashboard samples:
	## output: ./gen/sort-id - sorted according to dashboard ID
	## output: ./gen/sort-login - sorted according to user ID


	# ./src/ref/copy.sh
	## unzips reference descriptions of regions (from the dataset) and link them with the dashboard samples
	## output: ./gen/ref


	# ./src/ref/copy_to_sort_folder.sh
	## copies the "./gen/ref" files into: ./gen/sort-id


	# ./src/ref-body/copy.sh
	## unzips reference descriptions of dashboard bodies (from the dataset) and link them with the dashboard samples
	## output: ./gen/ref-body


	# ./src/ref-body/copy_to_sort_folder.sh
	## copies the "./gen/ref-body" files into: ./gen/sort-id


	# ./src/separate/separate.sh
	## separates dashboards into two groups (well-designed, random)


# ./src/users/analyze.sh [optional]
## makes statistics of descriptions of regions 
## could be optionally executed only after of the execution of ./src/init.sh



