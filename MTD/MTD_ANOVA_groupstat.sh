#!/bin/bash
# script for group analysis of MTD regression. 

# visual coupling analysis
# two within subject factors: seedROI {FFA, PPA} or (RH LH) x attention conditions {T, P, D}
# note no between subject variables

for w in 5 7 9 11 13 15 17 19; do
	for dset in nusiance FIR; do
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
		-bcontr 0 0 1 D \\" > /home/despoB/kaihwang/TRSE/TDSigEI/Group/ANOVA_MTD_${dset}.sh

		cd /home/despoB/kaihwang/TRSE/TDSigEI/

		n=1
		for s in $(/bin/ls -d 5*); do
			
			r=1
			for ROI in FFA; do
				c=1
				for condition in FH Fp HF; do
					cbrik=$(3dinfo -verb /home/despoB/TRSEPPI/TDSigEI/${s}/${dset}_w${w}_MTD_BC_stats_REML+tlrc | grep "MTD_${condition}_${ROI}-VC#0_Coef" | grep -o ' #[0-9]\{1,3\}' | grep -o '[0-9]\{1,3\}')
					echo "-dset ${r} ${c} ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/${dset}_w${w}_MTD_BC_stats_REML+tlrc[${cbrik}] \\" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/ANOVA_MTD_${dset}.sh
					c=$(($c+1))
				done
			done

			r=2
			for ROI in PPA; do
				c=1
				for condition in HF Hp FH; do
					cbrik=$(3dinfo -verb /home/despoB/TRSEPPI/TDSigEI/${s}/${dset}_w${w}_MTD_BC_stats_REML+tlrc | grep "MTD_${condition}_${ROI}-VC#0_Coef" | grep -o ' #[0-9]\{1,3\}' | grep -o '[0-9]\{1,3\}')
					echo "-dset ${r} ${c} ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/${dset}_w${w}_MTD_BC_stats_REML+tlrc[${cbrik}] \\" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/ANOVA_MTD_${dset}.sh
					c=$(($c+1))
				done
			done

			n=$(($n+1))
		done

		echo "-bucket ANOVA_MTD_w${w}_${dset}.nii.gz" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/ANOVA_MTD_${dset}.sh

		#. /home/despoB/kaihwang/TRSE/TDSigEI/Group/ANOVA_MTD_${dset}.sh

	done

	#for BC
	for dset in nusiance FIR; do
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
		-bcontr 0 0 1 D \\" > /home/despoB/kaihwang/TRSE/TDSigEI/Group/ANOVA_BC_${dset}.sh

		cd /home/despoB/kaihwang/TRSE/TDSigEI/

		n=1
		for s in $(/bin/ls -d 5*); do
			
			r=1
			for ROI in FFA; do
				c=1
				for condition in FH Fp HF; do
					cbrik=$(3dinfo -verb /home/despoB/TRSEPPI/TDSigEI/${s}/${dset}_w${w}_MTD_BC_stats_REML+tlrc | grep "BC_${condition}_${ROI}#0_Coef" | grep -o ' #[0-9]\{1,3\}' | grep -o '[0-9]\{1,3\}')
					echo "-dset ${r} ${c} ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/${dset}_w${w}_MTD_BC_stats_REML+tlrc[${cbrik}] \\" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/ANOVA_BC_${dset}.sh
					c=$(($c+1))
				done
			done

			r=2
			for ROI in PPA; do
				c=1
				for condition in HF Hp FH; do
					cbrik=$(3dinfo -verb /home/despoB/TRSEPPI/TDSigEI/${s}/${dset}_w${w}_MTD_BC_stats_REML+tlrc | grep "BC_${condition}_${ROI}#0_Coef" | grep -o ' #[0-9]\{1,3\}' | grep -o '[0-9]\{1,3\}')
					echo "-dset ${r} ${c} ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/${dset}_w${w}_MTD_BC_stats_REML+tlrc[${cbrik}] \\" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/ANOVA_BC_${dset}.sh
					c=$(($c+1))
				done
			done

			n=$(($n+1))
		done

		echo "-bucket ANOVA_BC_w${w}_${dset}.nii.gz" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/ANOVA_BC_${dset}.sh

		. /home/despoB/kaihwang/TRSE/TDSigEI/Group/ANOVA_BC_${dset}.sh

	done
done

