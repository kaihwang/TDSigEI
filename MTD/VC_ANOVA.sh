#!/bin/bash
# script for group analysis of VC connectivity

# visual coupling analysis
# two within subject factors: seedROI {FFA, PPA} or (RH LH) x attention conditions {T, P, D}
# note no between subject variables

for w in 5 7 9 11 13 15 17 19; do

	#for BC
	for dset in nusiance FIR; do
		echo "cd /home/despoB/kaihwang/TRSE/TDSigEI/Group 
		3dANOVA2 -type 3 \\
		-alevels 4 \\
		-blevels 28 \\
		-fa main_effect_condition \\
		-acontr 1 1 -1 -1 TD-P \\
		-acontr 0.5 0.5 0 0 TD \\
		-acontr 0 0 0.5 0.5 P \\" > /home/despoB/kaihwang/TRSE/TDSigEI/Group/ANOVA_BC_${dset}.sh

		cd /home/despoB/kaihwang/TRSE/TDSigEI/

		n=1
		for s in $(/bin/ls -d 5*); do
			
			for ROI in VC; do
				c=1
				for condition in FH HF Fp Hp; do
					cbrik=$(3dinfo -verb /home/despoB/TRSEPPI/TDSigEI/${s}/${dset}_w${w}_MTD_BC_stats_REML+tlrc | grep "BC_${condition}_${ROI}#0_Coef" | grep -o ' #[0-9]\{1,3\}' | grep -o '[0-9]\{1,3\}')
					echo "-dset ${c} ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/${dset}_w${w}_MTD_BC_stats_REML+tlrc[${cbrik}] \\" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/ANOVA_BC_${dset}.sh
					c=$(($c+1))
				done
			done
			n=$(($n+1))
		done

		echo "-bucket ANOVA_VC_w${w}_${dset}.nii.gz" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/ANOVA_BC_${dset}.sh

		. /home/despoB/kaihwang/TRSE/TDSigEI/Group/ANOVA_BC_${dset}.sh

	done
done

