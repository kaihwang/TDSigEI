#!/bin/bash
# script for group analysis on gPPI 

#call 3dANOVA

echo "cd /home/despoB/kaihwang/TRSE/TDSigEI/Group \\
3dANOVA3 -type 4 -bucket GroupStats_gPPI.nii.gz \\
-alevels 2 \\
-blevels 2 \\
-clevels 19 \\
-fa main_effect_roi \\
-fb main_effect_condition \\
-fab roi_x_condition \\
-bcontr 1 -1 T-D \\
-Abcontr 2 : 1 -1 PPA_T-D \\
-Abcontr 1 : 1 -1 FFA_T-D \\" > /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_gPPI.sh


cd /home/despoB/kaihwang/TRSE/TDSigEI/
n=1

for s in $(ls -d 5*); do

	echo "-dset 1 1 ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/gPPI_FFA_Full_model_stats_REML+tlrc'[2]' \\
-dset 1 2 ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/gPPI_FFA_Full_model_stats_REML+tlrc'[6]' \\
-dset 2 1 ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/gPPI_PPA_Full_model_stats_REML+tlrc'[2]' \\
-dset 2 2 ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/gPPI_PPA_Full_model_stats_REML+tlrc'[6]' \\"  >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_gPPI.sh
	n=$((n=n+1))
done

#echo '-dataTable @/home/despoB/kaihwang/TRSE/TDSigEI/Group/anova_table.txt' >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_gPPI.sh

#. /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_gPPI.sh



