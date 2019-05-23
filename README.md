# Impact of Subjective Visual Perception<br> on Automatic Evaluation of Dashboard Design

This repository contains all data related to the reults of research presented in my PhD thesis; created at Brno University of Technology, Faculty of Information Technology, Department of Information Systems.

The repository consints of **dataset**, **results**, and **workspaces**.

**Note:** Read the thesis first to understand the meaning of all files.

## Dataset

The dataset used in the research.

- ``dataset/dashboards/`` - dashboard samples used for analyses of metrics and approaches
  - ``dashboards.zip`` - screenshots dashhboards found on the Internet (*D*<sub>all</sub>)
  - ``heatmaps.zip`` - average descriptions of regions calculated from description of regions provided by users (*D*<sub>gray</sub>)
  - ``heatmaps_threshold.zip`` - thresholded average descriptions of regions (*D*<sub>BW</sub>)
- ``dataset/regions/`` - subjective descriptions of dashboards' regions provided by users using [Dashboard Analyzer](https://github.com/Jirka/dash)
  - ``ref-body.zip`` - descriptions of dashboards' body areas (provided by the author of the thesis)
	- ``ref-regions.zip`` -  descriptions of dashboards' regions (provided by the author of the thesis)
	- ``regions.zip`` - descriptions of dashboards' regions (provided by 251 users)
- ``dataset/reviews/`` - ratings of dashboards' characteritics provided by users using [Interactive Survey Tool](https://github.com/Jirka/survey-tool)
 	- ``color_impact.zip`` - data of the study of color impact on object-based metrics (Chapter 8.2)
	- ``experiment1.zip`` - data gathered for the comparison of metrics with
reviews of users: Experiment 1 (Chap. 10.1)
	- ``experiment2.zip`` - data gathered  for the comparison of metrics with
reviews of users: Experiment 2 (Chap. 10.2)

## Results

The results of the research.

- ``results/06-pixel-based/`` - results of the analysis of pixel-based metrics (Chapter 6)
  - ``06-metrics.ods`` - the values measured by the pixel-based metrics
- ``results/07-object-based/`` - results of the analysis of object-based metrics (Chapter 7)
  - ``07-01-study.ods`` - the results of the study of visual perception of objects (Chapter 7.1)
  - ``07-03-metrics.ods`` - the average values of UI characteristics measured by the Ngo's metrics, including the values of the metrics' *objectivity* and *decisiveness* (Chapter 7.3)
- ``results/08-improvement/`` - results of the process of design and improvement of metrics (Chapter 8)
  - ``08-02-study.ods`` - the results of the study of the impact of color on object-based metrics (Chapter 8.2)
  - ``08-03-improvement.ods`` - the average values measured by the modified versions of the Balance metrics,
including the values of the metrics' *objectivity* and *decisiveness* (Chapter 8.3)
- ``results/09-segmentation/`` - results of the automatic segmentation of dashboards (Chapter 9)
  - ``09-03-02-regions.ods`` - the results of the quantitative comparison of the user descriptions with the generated descriptions (Chapter 9.3.2)
  - ``09-03-03-balance.ods`` - the results of measuring Balance using the user and generated descriptions and
comparison of the results (Chapter 9.3.3)
- ``results/10-comparison/`` - results of the comparison of metrics with reviews of users (Chapter 10)
  - ``10-01-experiment-1/`` - (Chapter 10.1)
    - ``10-01-all_vals.ods`` - statistics of all single values provided by users
    - ``10-01-cmp-balance-color.ods`` - comparison of average calculated and perceived balance
  - ``10-02-experiment-2/`` - (Chapter 10.2)
    - ``10-02-all_vals.ods`` - statistics of all single values provided by users
    - ``10-02-cmp-balance-color.ods`` - comparison of average calculated and perceived balance
    - ``10-02-cmp-colorfulness.ods`` - comparison of average calculated and perceived colorfulness

# Workspace

Workspaces which prepares the dataset for the analyses which produce the results. It requires to run bash scripts.

- ``workspace/metrics/`` - scripts for preparation of the workspace used by Dashboard Analyzer for analysis of dashboards, metrics, and method for segmentation of dashboards
- ``workspace/users/`` - scripts for analysis of the user reviews
  - ``color_impact/`` - study of color impact on object-based metrics (Chapter 8.2)
  - ``experiment1/`` - comparison of metrics with reviews of users (Chapter 10.1)
  - ``experiment2/`` - comparison of metrics with reviews of users (Chapter 10.2)
  
### ``metrics`` workspace

1. Follow the instructions described in [``metrics/README.txt``](https://github.com/Jirka/dash.thesis/tree/devel/workspace/metrics):
   - ``cd metrics/src/``
   - run: ``./process.sh`` - it preprocess the ``dataset/dashboards/dashboards.zip`` and ``dataset/regions/*``
   - wait until ``../gen/`` folder is generated - it contains:
     - ``gen/all/color`` - all dashboard samples without description of regions 
     - ``gen/sort-id`` - dashboards and description of regions sorted according to dashboard ID
     - ``gen/sort-login`` - dashboards + description of regions sorted according to user ID
     - ``gen/ref`` - dashboards + description of regions provided by the author
     - ``gen/ref-body`` - dashboards + description of dashboard bodies provided by the author

2. Checkout the [``dash``](https://github.com/Jirka/dash) and [``web-download-tool``](https://github.com/Jirka/web-download-tool) (optional) projects into the same folder as the ``dash.thesis`` repository:
   - \[required\] Follow the instructions of [``dash/README.md``](https://github.com/Jirka/dash/blob/master/README.md) to checkout the ``dash`` repository:
     - switch to the feature-22-thesis branch or the rel-0.9-thesis release
     - run the ``DashApp.java`` file located in the ``dashapp.rel.thesis`` project (intead of the dashapp.rel.thesis project)
   - \[optional\] Follow the instructions of [``web-download-tool/README.md``](https://github.com/Jirka/web-download-tool/blob/master/README.md) to checkout the ``dash`` repository:
     - run ``./prepare.sh`` which downloads 3rd party dependecies
     - the tool provides the support for downloading new samples from URL

3. Perform analyses according to the instruction described in ``dash`` [wiki](https://github.com/Jirka/dash/wiki).

### ``users/color_impact`` workspace

Follow the instructions described in [``users/color_impact/README.txt``](https://github.com/Jirka/dash.thesis/tree/devel/workspace/users/color_impact/README.txt):
   - ``cd users/color_impact/src/``
   - run: ``./process.sh`` - it preprocess the ``dataset/reviews/color_impact.zip``
   - wait until ``../gen/`` folder is generated - it contains:
     - ``balance_color.txt`` - the ratings of the horizontal balance
     - ``balance_color_2.txt`` - the rating of the vertical balance
     - ``symmetry_symmetry.txt`` - the ratings of the overall symmetry

### ``users/experiment1`` workspace

Follow the instructions described in [``users/experiment1/README.txt``](https://github.com/Jirka/dash.thesis/tree/devel/workspace/users/experiment1/README.txt):
   - ``cd users/experiment1/src/``
   - run: ``./process.sh`` - it preprocess the ``dataset/reviews/experiment1.zip``
   - wait until ``../gen/`` folder is generated - it contains:
      - ``all_values.txt`` - list of all ratings
      - ``balance/stats.txt`` - ratings of the overall of balance
      - ``balanceVH/stats_H.txt`` - ratings of the vertical balance
      - ``balanceVH/stats_V.txt`` - ratings of the horizontal balance
      - ``balanceVH/stats_VH.txt`` - values of the overall balance calculated from the ratings of the vertical and horizontal balance

### ``users/experiment2`` workspace

Follow the instructions described in [``users/experiment2/README.txt``](https://github.com/Jirka/dash.thesis/tree/devel/workspace/users/experiment2/README.txt):
   - ``cd users/experiment2/src/``
   - run: ``./process.sh`` - it preprocess the ``dataset/reviews/experiment2.zip``
   - wait until ``../gen/`` folder is generated - it contains:
     - ``val/`` - values of characteristics provided by ratings
       - ``single_line/`` - the values are on line for one dashboard
       - ``single_line/avg/`` - the average values and standard deviation of the "single_line/" files
       - ``multiline/`` - every value is on a single line, but linked to dashboard
     - ``cmp/`` - comparisons of characteristics
       - ``multiline/`` - every line of the files contains a comparison of two characteristics rated by one user
   - [optional] run: ``./overall-sort.sh`` - it sorts dashboards according to average ratings of users
     - see ``gen/sort-overall/`` - it contains sorted dashboard, named as ``images X_Y``
       - X: ``[0-9][0-9][0-9]`` - ID representing the new order of dashboards
       - Y: ``[0-9][0-9][0-9]`` - original ID
