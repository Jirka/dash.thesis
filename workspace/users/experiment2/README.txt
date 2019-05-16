# 2019, Jiri Hynek

## description of scripts
## important! run the scripts in the folder where the scripts are located (cd src/)

# ./src/process.sh
## analyses the user reviews regarding the experiment 2 (from the dataset)
## output: ./gen
## it executes the following scripts:


	# ./src/val/val.sh
	## process values of ratings
	## output: .gen/val
	## executes following 3 scripts:


		# ./src/val/val-eval.sh
		# ./src/val/val-eval.sh -x
		## unzips the user reviews and link them with the dashboard samples
		## output: ./gen/val/single_line (values are on line for one dashboard)
		## output: ./gen/val/multiline_line (-x; every value is on a single line, but linked to dashboard)


		# ./src/val/val-stats.sh
		## calculates average and standard deviation of the "./gen/val/single_line" files
		## output: ./gen/val/single_line/avg


		# ./src/cmp/val-separate.sh
		## separates dashboards into two groups (well-designed, random)


	# ./src/cmp/cmp.sh
	## compares ratings of different characteristics for every users
	## output: ./gen/cmp/multiline_line
	## executes following 2 scripts:


		# ./src/cmp/cmp-eval.sh
		## unzips the user reviews and performs comparisons
		## output: ./gen/cmp/multiline_line


		# ./src/cmp/cmp-sort.sh
		## sorts comparisons according to IDs


# ./src/overall-sort.sh [optional]
## sort dashboards according to overall rating of users
## output: ./gen/sort-overall
## important! could be optionally executed only after of the execution of ./src/process.sh




