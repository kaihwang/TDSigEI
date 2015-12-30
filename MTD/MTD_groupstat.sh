#!/bin/bash
# script for group analysis of MTD regression. 

# visual coupling analysis
# two within subject factors: seedROI {FFA, PPA} or (RH LH) x attention conditions {T, P, D}
# note no between subject variables

for dset in nusianceReg FIRReg; do
	echo "cd /home/despoB/kaihwang/TRSE/TDSigEI/Group 
	3dANOVA3 -type 4 \\
	-alevels 2 \\
	-blevels 3 \\
	-clevels 28 \\
	-fa main_effect_roi \\
	-fb main_effect_condition \\
	-fab roi_x_condition \\
	-bcontr 0 -1 1 D-P \\
	-bcontr 1 0 -1 TD-D \\
	-bcontr 1 -1 0 TD-P \\
	-bcontr 1 0 0 TD \\
	-bcontr 0 1 0 P \\
	-bcontr 0 0 1 D \\" > /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_MTD_${dset}.sh

	cd /home/despoB/kaihwang/TRSE/TDSigEI/

	n=1
	for s in $(/bin/ls -d 5*); do
		
		r=1
		for ROI in FFA; do
			c=1
			for condition in FH Fp HF; do
				echo "-dset ${r} ${c} ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/MTD_${dset}_${condition}_${ROI}-VC_stats+tlrc'[2]' \\" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_MTD_${dset}.sh
				c=$(($c+1))
			done
		done

		r=2
		for ROI in PPA; do
			c=1
			for condition in HF Hp FH; do
				echo "-dset ${r} ${c} ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/MTD_${dset}_${condition}_${ROI}-VC_stats+tlrc'[2]' \\" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_MTD_${dset}.sh
				c=$(($c+1))
			done
		done

		n=$(($n+1))
	done

	echo "-bucket GroupStats_MTD_${dset}.nii.gz" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_MTD_${dset}.sh

	. /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_MTD_${dset}.sh

done

