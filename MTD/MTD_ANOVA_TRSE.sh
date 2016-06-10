#!/bin/bash
# script for group analysis of MTD regression. 

# visual coupling analysis
# two within subject factors: seedROI {FFA, PPA} or (RH LH) x attention conditions {T, P, D}
# note no between subject variables

for w in 8 10 12 14 16 18 20 22 24 26 28 30; do
	echo "cd /home/despoB/kaihwang/TRSE/TRSEPPI/Group
	3dANOVA3 -type 4 \\
	-alevels 2 \\
	-blevels 3 \\
	-clevels 54 \\
	-fa main_effect_roi \\
	-fb main_effect_condition \\
	-fab roi_x_condition \\
	-bcontr 0 -1 1 D-P \\
	-bcontr 1 0 -1 TD-D \\
	-bcontr 1 -1 0 TD-P \\
	-bcontr 1 0 0 TD \\
	-bcontr 0 1 0 P \\
	-bcontr 0 0 1 D \\" > /home/despoB/kaihwang/TRSE/TRSEPPI/Group/ANOVA_MTD.sh

	cd /home/despoB/kaihwang/TRSE/TDSigEI/

	n=1
	for s in 1106 1107 1109 1110 1111 1112 1113 1114 1116 1401 1403 1404 1405 1406 1407 1408 1409 1411 1412 1413 1414 1415 1416 1417 1418 1419 1422 1423 1426 1427 1429 1430 1431 620 623 627 628 629 630 631 632 633 634 636 637 638 640 7601 7604 7611 7613 7616 7620 7621; do
		
		r=1
		for ROI in FFA; do
			c=1
			for condition in FH CAT HF; do
				cbrik=$(3dinfo -verb /home/despoB/kaihwang/TRSE/TRSEPPI/AllSubjs/${s}/MTD_w${w}_BC_stats_REML+tlrc | grep "MTD_${condition}_${ROI}-VC#0_Coef" | grep -o ' #[0-9]\{1,3\}' | grep -o '[0-9]\{1,3\}')
				echo "-dset ${r} ${c} ${n} /home/despoB/kaihwang/TRSE/TRSEPPI/AllSubjs/${s}/MTD_w${w}_BC_stats_REML+tlrc[${cbrik}] \\" >> /home/despoB/kaihwang/TRSE/TRSEPPI/Group/ANOVA_MTD.sh
				c=$(($c+1))
			done
		done

		r=2
		for ROI in PPA; do
			c=1
			for condition in HF CAT FH; do
				cbrik=$(3dinfo -verb /home/despoB/kaihwang/TRSE/TRSEPPI/AllSubjs/${s}/MTD_w${w}_BC_stats_REML+tlrc | grep "MTD_${condition}_${ROI}-VC#0_Coef" | grep -o ' #[0-9]\{1,3\}' | grep -o '[0-9]\{1,3\}')
				echo "-dset ${r} ${c} ${n} /home/despoB/kaihwang/TRSE/TRSEPPI/AllSubjs/${s}/MTD_w${w}_BC_stats_REML+tlrc[${cbrik}] \\" >> /home/despoB/kaihwang/TRSE/TRSEPPI/Group/ANOVA_MTD.sh
				c=$(($c+1))
			done
		done

		n=$(($n+1))
	done

	echo "-bucket ANOVA_MTD_w${w}.nii.gz" >> /home/despoB/kaihwang/TRSE/TRSEPPI/Group/ANOVA_MTD.sh

	. /home/despoB/kaihwang/TRSE/TRSEPPI/Group/ANOVA_MTD.sh

	#for BC
	echo "cd /home/despoB/kaihwang/TRSE/TRSEPPI/Group 
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
	-bcontr 0 0 1 D \\" > /home/despoB/kaihwang/TRSE/TRSEPPI/Group/ANOVA_BC.sh

	cd /home/despoB/kaihwang/TRSE/TDSigEI/

	n=1
	for s in 1106 1107 1109 1110 1111 1112 1113 1114 1116 1401 1403 1404 1405 1406 1407 1408 1409 1411 1412 1413 1414 1415 1416 1417 1418 1419 1422 1423 1426 1427 1429 1430 1431 620 623 627 628 629 630 631 632 633 634 636 637 638 640 7601 7604 7611 7613 7616 7620 7621; do
		
		r=1
		for ROI in FFA; do
			c=1
			for condition in FH CAT HF; do
				cbrik=$(3dinfo -verb /home/despoB/kaihwang/TRSE/TRSEPPI/AllSubjs/${s}/MTD_w${w}_BC_stats_REML+tlrc | grep "BC_${condition}_${ROI}#0_Coef" | grep -o ' #[0-9]\{1,3\}' | grep -o '[0-9]\{1,3\}')
				echo "-dset ${r} ${c} ${n} /home/despoB/kaihwang/TRSE/TRSEPPI/AllSubjs/${s}/MTD_w${w}_BC_stats_REML+tlrc[${cbrik}] \\" >> /home/despoB/kaihwang/TRSE/TRSEPPI/Group/ANOVA_BC.sh
				c=$(($c+1))
			done
		done

		r=2
		for ROI in PPA; do
			c=1
			for condition in HF CAT FH; do
				cbrik=$(3dinfo -verb /home/despoB/kaihwang/TRSE/TRSEPPI/AllSubjs/${s}/MTD_w${w}_BC_stats_REML+tlrc | grep "BC_${condition}_${ROI}#0_Coef" | grep -o ' #[0-9]\{1,3\}' | grep -o '[0-9]\{1,3\}')
				echo "-dset ${r} ${c} ${n} /home/despoB/kaihwang/TRSE/TRSEPPI/AllSubjs/${s}/MTD_w${w}_BC_stats_REML+tlrc[${cbrik}] \\" >> /home/despoB/kaihwang/TRSE/TRSEPPI/Group/ANOVA_BC.sh
				c=$(($c+1))
			done
		done

		n=$(($n+1))
	done

	echo "-bucket ANOVA_w${w}_BC.nii.gz" >> /home/despoB/kaihwang/TRSE/TRSEPPI/Group/ANOVA_BC.sh

	. /home/despoB/kaihwang/TRSE/TRSEPPI/Group/ANOVA_BC.sh

done
