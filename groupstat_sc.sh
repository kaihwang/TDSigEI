#!/bin/bash
# script for group analysis of seed-based connecivity maps. using AFNI's 3dMVM 
# two within subject factors: seedROI {FFA, PPA} x attention conditions {TD, To, P, D}
# note no between subject variables

#call 3dMVM

echo "cd /home/despoB/kaihwang/TRSE/TDSigEI/Group 
3dMVM -prefix /home/despoB/TRSEPPI/TDSigEI/Group/GroupStats_seed_connectivity.nii.gz \\
-mask /home/despoB/TRSEPPI/TDSigEI/ROIs/100overlap_mask+tlrc \\
-bsVars 1 \\
-cio \\
-model 'SeedROI*Condition' \\" > /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_seedcon.sh

echo 'Subj SeedROI Condition InputFile \' > /home/despoB/kaihwang/TRSE/TDSigEI/Group/anova_table.txt

cd /home/despoB/kaihwang/TRSE/TDSigEI/
for s in $(ls -d 5*); do

	echo "$s FFA TwD /home/despoB/TRSEPPI/TDSigEI/${s}/Corrcoef_seedFFA_FH+tlrc.BRIK \\
$s FFA To /home/despoB/TRSEPPI/TDSigEI/${s}/Corrcoef_seedFFA_Fo+tlrc.BRIK \\
$s FFA P /home/despoB/TRSEPPI/TDSigEI/${s}/Corrcoef_seedFFA_Fp+tlrc.BRIK \\
$s FFA D /home/despoB/TRSEPPI/TDSigEI/${s}/Corrcoef_seedFFA_HF+tlrc.BRIK \\ 
$s PPA TwD /home/despoB/TRSEPPI/TDSigEI/${s}/Corrcoef_seedPPA_HF+tlrc.BRIK \\
$s PPA To /home/despoB/TRSEPPI/TDSigEI/${s}/Corrcoef_seedPPA_Ho+tlrc.BRIK \\
$s PPA P /home/despoB/TRSEPPI/TDSigEI/${s}/Corrcoef_seedPPA_Hp+tlrc.BRIK \\
$s PPA D /home/despoB/TRSEPPI/TDSigEI/${s}/Corrcoef_seedPPA_FH+tlrc.BRIK \\ "  >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/anova_table.txt
	
done

echo '-dataTable @/home/despoB/kaihwang/TRSE/TDSigEI/Group/anova_table.txt' >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_seedcon.sh

. /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_seedcon.sh



