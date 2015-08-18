#!/bin/bash
# script for group analysis of seed-based connecivity maps. using AFNI's 3dMVM 
# two within subject factors: seedROI {FFA, PPA} x attention conditions {TD, To, P, D}
# note no between subject variables

#call 3dMVM

echo "cd /home/despoB/kaihwang/TRSE/TDSigEI/Group 
3dMVM -prefix /home/despoB/kaihwang/TRSE/TDSigEI/Group/GroupStats_seed_connectivity.nii.gz \\
-mask /home/despoB/kaihwang/TRSE/TDSigEI/ROIs/100overlap_mask+tlrc \\
-bsVars 1 \\
-cio \\
-wsVars 'SeedROI*Condition' \\
-num_glt 4 \\
-gltLabel 1 Target_with_Distractor-Passive -gltCode 1 'Condition : 1*TwD -1*P' \\
-gltLabel 2 Target-Passive -gltCode 2 'Condition : 1*To -1*P' \\
-gltLabel 3 Distractor-Passive -gltCode 3 'Condition : 1*D -1*P' \\
-gltLabel 4 Target-Distractor -gltCode 4 'Condition : 1*TwD -1*D' \\" > /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_seedcon.sh

echo 'Subj SeedROI Condition InputFile \' > /home/despoB/kaihwang/TRSE/TDSigEI/Group/anova_table.txt

cd /home/despoB/kaihwang/TRSE/TDSigEI/
for s in $(ls -d 5*); do

	echo "$s FFA TwD /home/despoB/kaihwang/TRSE/TDSigEI/${s}/Corrcoef_seedFFA_FH+tlrc.BRIK \\
$s FFA To /home/despoB/kaihwang/TRSE/TDSigEI/${s}/Corrcoef_seedFFA_Fo+tlrc.BRIK \\
$s FFA P /home/despoB/kaihwang/TRSE/TDSigEI/${s}/Corrcoef_seedFFA_Fp+tlrc.BRIK \\
$s FFA D /home/despoB/kaihwang/TRSE/TDSigEI/${s}/Corrcoef_seedFFA_HF+tlrc.BRIK \\ 
$s PPA TwD /home/despoB/kaihwang/TRSE/TDSigEI/${s}/Corrcoef_seedPPA_HF+tlrc.BRIK \\
$s PPA To /home/despoB/kaihwang/TRSE/TDSigEI/${s}/Corrcoef_seedPPA_Ho+tlrc.BRIK \\
$s PPA P /home/despoB/kaihwang/TRSE/TDSigEI/${s}/Corrcoef_seedPPA_Hp+tlrc.BRIK \\
$s PPA D /home/despoB/kaihwang/TRSE/TDSigEI/${s}/Corrcoef_seedPPA_FH+tlrc.BRIK \\ "  >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/anova_table.txt
	
done

echo '-dataTable @/home/despoB/kaihwang/TRSE/TDSigEI/Group/anova_table.txt' >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_seedcon.sh

. /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_seedcon.sh



