#!/bin/bash
# script for group analysis on gPPI 
# note no between subject variables

#call 3dMVM

echo "cd /home/despoB/kaihwang/TRSE/TDSigEI/Group 
3dMVM -prefix /home/despoB/kaihwang/TRSE/TDSigEI/Group/GroupStats_seed_connectivity.nii.gz \\
-mask /home/despoB/kaihwang/TRSE/TDSigEI/ROIs/100overlap_mask+tlrc \\
-bsVars 1 \\
-wsMVT \\
-wsVars 'SeedROI*Condition' \\
-num_glt 3 \\
-gltLabel 1 Target -gltCode 1 'Condition : 1*Target' \\
-gltLabel 2 Distractor -gltCode 2 'Condition : 1*Distractor' \\
-gltLabel 3 Target-Distractor -gltCode 3 'Condition : 1*Target -1*Distractor' \\" > /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_gPPI.sh

echo 'Subj SeedROI Condition InputFile \' > /home/despoB/kaihwang/TRSE/TDSigEI/Group/anova_table.txt

cd /home/despoB/kaihwang/TRSE/TDSigEI/
for s in $(ls -d 5*); do

	echo "${s} FFA Target gPPI_FFA_Full_model_stats_REML+tlrc[2] \\
${s} FFA Distractor gPPI_FFA_Full_model_stats_REML+tlrc[6] \\
${s} PPA Target gPPI_PPA_Full_model_stats_REML+tlrc[2] \\
${s} PPA Distractor gPPI_PPA_Full_model_stats_REML+tlrc[6] \\"  >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/anova_table.txt
	
done

echo '-dataTable @/home/despoB/kaihwang/TRSE/TDSigEI/Group/anova_table.txt' >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_gPPI.sh

. /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_gPPI.sh



