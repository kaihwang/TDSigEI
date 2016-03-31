#!/bin/bash
# script for group analysis of MTD regression. 

# visual coupling analysis
# two within subject factors: seedROI {FFA, PPA} or (RH LH) x attention conditions {T, P, D}
# note no between subject variables

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
	-bcontr 0 0 1 D \\" > /home/despoB/kaihwang/TRSE/TDSigEI/Group/ANOVA_MTD_b${dset}.sh

	cd /home/despoB/kaihwang/TRSE/TDSigEI/

	n=1
	for s in $(/bin/ls -d 5*); do
		
		r=1
		for ROI in FFA; do
			c=1
			for condition in FH Fp HF; do
				cbrik=$(3dinfo -verb /home/despoB/TRSEPPI/TDSigEI/${s}/${dset}_MTD_BC_stats+tlrc | grep "MTD_${condition}_${ROI}-VC#0_Coef" | grep -o ' #[0-9]\{1,3\}' | grep -o '[0-9]\{1,3\}')
				echo "-dset ${r} ${c} ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/${dset}_MTD_BC_stats+tlrc[${cbrik}] \\" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/ANOVA_MTD_b${dset}.sh
				c=$(($c+1))
			done
		done

		r=2
		for ROI in PPA; do
			c=1
			for condition in HF Hp FH; do
				cbrik=$(3dinfo -verb /home/despoB/TRSEPPI/TDSigEI/${s}/${dset}_MTD_BC_stats+tlrc | grep "MTD_${condition}_${ROI}-VC#0_Coef" | grep -o ' #[0-9]\{1,3\}' | grep -o '[0-9]\{1,3\}')
				echo "-dset ${r} ${c} ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/${dset}_MTD_BC_stats+tlrc[${cbrik}] \\" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/ANOVA_MTD_b${dset}.sh
				c=$(($c+1))
			done
		done

		n=$(($n+1))
	done

	echo "-bucket bANOVA_MTD_${dset}.nii.gz" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/ANOVA_MTD_b${dset}.sh

	. /home/despoB/kaihwang/TRSE/TDSigEI/Group/ANOVA_MTD_b${dset}.sh

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
	-bcontr 0 0 1 D \\" > /home/despoB/kaihwang/TRSE/TDSigEI/Group/ANOVA_BC_b${dset}.sh

	cd /home/despoB/kaihwang/TRSE/TDSigEI/

	n=1
	for s in $(/bin/ls -d 5*); do
		
		r=1
		for ROI in FFA; do
			c=1
			for condition in FH Fp HF; do
				cbrik=$(3dinfo -verb /home/despoB/TRSEPPI/TDSigEI/${s}/${dset}_MTD_BC_stats+tlrc | grep "BC_${condition}_${ROI}#0_Coef" | grep -o ' #[0-9]\{1,3\}' | grep -o '[0-9]\{1,3\}')
				echo "-dset ${r} ${c} ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/${dset}_MTD_BC_stats+tlrc[${cbrik}] \\" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/ANOVA_BC_b${dset}.sh
				c=$(($c+1))
			done
		done

		r=2
		for ROI in PPA; do
			c=1
			for condition in HF Hp FH; do
				cbrik=$(3dinfo -verb /home/despoB/TRSEPPI/TDSigEI/${s}/${dset}_MTD_BC_stats+tlrc | grep "BC_${condition}_${ROI}#0_Coef" | grep -o ' #[0-9]\{1,3\}' | grep -o '[0-9]\{1,3\}')
				echo "-dset ${r} ${c} ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/${dset}_MTD_BC_stats+tlrc[${cbrik}] \\" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/ANOVA_BC_b${dset}.sh
				c=$(($c+1))
			done
		done

		n=$(($n+1))
	done

	echo "-bucket bANOVA_BC_${dset}.nii.gz" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/ANOVA_BC_b${dset}.sh

	. /home/despoB/kaihwang/TRSE/TDSigEI/Group/ANOVA_BC_b${dset}.sh

done

# #do vis-m coupling
# for dset in nusianceReg FIRReg; do
# 	echo "cd /home/despoB/kaihwang/TRSE/TDSigEI/Group 
# 	3dANOVA3 -type 4 \\
# 	-alevels 2 \\
# 	-blevels 3 \\
# 	-clevels 28 \\
# 	-fa main_effect_roi \\
# 	-fb main_effect_condition \\
# 	-fab roi_x_condition \\
# 	-bcontr 0 -1 1 D-P \\
# 	-bcontr 1 0 -1 TD-D \\
# 	-bcontr 1 -1 0 TD-P \\
# 	-bcontr 1 0 0 TD \\
# 	-bcontr 0 1 0 P \\
# 	-bcontr 0 0 1 D \\" > /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_MTD_vis-M_${dset}.sh

# 	cd /home/despoB/kaihwang/TRSE/TDSigEI/

# 	n=1
# 	for s in $(/bin/ls -d 5*); do
		
# 		r=1
# 		for ROI in FFA; do
# 			c=1
# 			for condition in FH Fp HF; do
# 				echo "-dset ${r} ${c} ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/MTD_${dset}_${condition}_${ROI}-M_stats+tlrc'[2]' \\" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_MTD_vis-M_${dset}.sh
# 				c=$(($c+1))
# 			done
# 		done

# 		r=2
# 		for ROI in PPA; do
# 			c=1
# 			for condition in HF Hp FH; do
# 				echo "-dset ${r} ${c} ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/MTD_${dset}_${condition}_${ROI}-M_stats+tlrc'[2]' \\" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_MTD_vis-M_${dset}.sh
# 				c=$(($c+1))
# 			done
# 		done

# 		n=$(($n+1))
# 	done

# 	echo "-bucket GroupStats_MTD_${dset}_vis-M.nii.gz" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_MTD_vis-M_${dset}.sh

# 	. /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_MTD_vis-M_${dset}.sh

# done


# #do vis-m coupling but contrast m v nm for TD
# for dset in nusianceReg FIRReg; do
# 	echo "cd /home/despoB/kaihwang/TRSE/TDSigEI/Group 
# 	3dANOVA3 -type 4 \\
# 	-alevels 2 \\
# 	-blevels 3 \\
# 	-clevels 28 \\
# 	-fa main_effect_roi \\
# 	-fb main_effect_condition \\
# 	-fab roi_x_condition \\
# 	-bcontr -1 1 M-NM \\" > /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_MTD_TD_vis-MvNM_${dset}.sh

# 	cd /home/despoB/kaihwang/TRSE/TDSigEI/

# 	n=1
# 	for s in $(/bin/ls -d 5*); do
		
# 		r=1
# 		for ROI in FFA; do
# 			c=1
# 			for condition in M NM; do
# 				echo "-dset ${r} ${c} ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/MTD_${dset}_FH_${ROI}-${condition}_stats+tlrc'[2]' \\" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_MTD_TD_vis-MvNM_${dset}.sh
# 				c=$(($c+1))
# 			done
# 		done

# 		r=2
# 		for ROI in PPA; do
# 			c=1
# 			for condition in M NM; do
# 				echo "-dset ${r} ${c} ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/MTD_${dset}_HF_${ROI}-${condition}_stats+tlrc'[2]' \\" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_MTD_TD_vis-MvNM_${dset}.sh
# 				c=$(($c+1))
# 			done
# 		done

# 		n=$(($n+1))
# 	done

# 	echo "-bucket GroupStats_MTD_${dset}_TD_vis-MvNM.nii.gz" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_MTD_TD_vis-MvNM_${dset}.sh

# 	. /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_MTD_TD_vis-MvNM_${dset}.sh

# done

# #do vis-m coupling but contrast m v nm for D
# for dset in nusianceReg FIRReg; do
# 	echo "cd /home/despoB/kaihwang/TRSE/TDSigEI/Group 
# 	3dANOVA3 -type 4 \\
# 	-alevels 2 \\
# 	-blevels 3 \\
# 	-clevels 28 \\
# 	-fa main_effect_roi \\
# 	-fb main_effect_condition \\
# 	-fab roi_x_condition \\
# 	-bcontr -1 1 M-NM \\" > /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_MTD_D_vis-MvNM_${dset}.sh

# 	cd /home/despoB/kaihwang/TRSE/TDSigEI/

# 	n=1
# 	for s in $(/bin/ls -d 5*); do
		
# 		r=1
# 		for ROI in FFA; do
# 			c=1
# 			for condition in M NM; do
# 				echo "-dset ${r} ${c} ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/MTD_${dset}_HF_${ROI}-${condition}_stats+tlrc'[2]' \\" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_MTD_D_vis-MvNM_${dset}.sh
# 				c=$(($c+1))
# 			done
# 		done

# 		r=2
# 		for ROI in PPA; do
# 			c=1
# 			for condition in M NM; do
# 				echo "-dset ${r} ${c} ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/MTD_${dset}_FH_${ROI}-${condition}_stats+tlrc'[2]' \\" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_MTD_D_vis-MvNM_${dset}.sh
# 				c=$(($c+1))
# 			done
# 		done

# 		n=$(($n+1))
# 	done

# 	echo "-bucket GroupStats_MTD_${dset}_D_vis-MvNM.nii.gz" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_MTD_D_vis-MvNM_${dset}.sh

# 	. /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_MTD_D_vis-MvNM_${dset}.sh

# done
