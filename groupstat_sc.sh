#!/bin/bash
# script for group analysis of seed-based connecivity maps. 
# two within subject factors: seedROI {FFA, PPA} or (RH LH) x attention conditions {TD, To, P, D}
# note no between subject variables


#motor
echo "cd /home/despoB/kaihwang/TRSE/TDSigEI/Group 
3dANOVA3 -type 4 \\
-alevels 2 \\
-blevels 4 \\
-clevels 19 \\
-fa main_effect_roi \\
-fb main_effect_condition \\
-fab roi_x_condition \\
-bcontr 0 0 -1 1 D-P \\
-bcontr 1 0 0 -1 TD-D \\
-bcontr 1 -1 0 0 TD-To \\
-bcontr 1 0 -1 0 TD-P \\
-bcontr 0 1 -1 0 To-P \\
-bcontr 0 1 0 -1 To-D \\
-bcontr 1 0 0 0 TD \\
-bcontr 0 1 0 0 To \\
-bcontr 0 0 1 0 P \\
-bcontr 0 0 0 1 D \\" > /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_motor_seedcon.sh

cd /home/despoB/kaihwang/TRSE/TDSigEI/

n=1
for s in $(ls -d 5*); do
	r=1
	for ROI in RH LH; do
		c=1
		for condition in TD To P D; do
			echo "-dset ${r} ${c} ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/Corrcoef_seed${ROI}_${condition}+tlrc'[0]' \\" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_motor_seedcon.sh
			c=$(($c+1))
		done
		r=$(($r+1))
	done
	n=$(($n+1))
done

echo '-bucket GroupStats_motor_sc.nii.gz' >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_motor_seedcon.sh

. /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_motor_seedcon.sh 



#vis
echo "cd /home/despoB/kaihwang/TRSE/TDSigEI/Group 
3dANOVA3 -type 4 \\
-alevels 2 \\
-blevels 4 \\
-clevels 19 \\
-fa main_effect_roi \\
-fb main_effect_condition \\
-fab roi_x_condition \\
-bcontr 0 0 -1 1 D-P \\
-bcontr 1 0 0 -1 TD-D \\
-bcontr 1 -1 0 0 TD-To \\
-bcontr 1 0 -1 0 TD-P \\
-bcontr 0 1 -1 0 To-P \\
-bcontr 0 1 0 -1 To-D \\
-bcontr 1 0 0 0 TD \\
-bcontr 0 1 0 0 To \\
-bcontr 0 0 1 0 P \\
-bcontr 0 0 0 1 D \\" > /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_seedcon.sh

cd /home/despoB/kaihwang/TRSE/TDSigEI/

n=1
for s in $(ls -d 5*); do
	
	r=1
	for ROI in FFA; do
		c=1
		for condition in FH Fo Fp HF; do
			echo "-dset ${r} ${c} ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/Corrcoef_seed${ROI}_${condition}+tlrc'[0]' \\" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_seedcon.sh
			c=$(($c+1))
		done
	done

	r=2
	for ROI in PPA; do
		c=1
		for condition in HF Ho Hp FH; do
			echo "-dset ${r} ${c} ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/Corrcoef_seed${ROI}_${condition}+tlrc'[0]' \\" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_seedcon.sh
			c=$(($c+1))
		done
	done

	n=$(($n+1))
done

echo '-bucket GroupStats_sc.nii.gz' >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_seedcon.sh

. /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_seedcon.sh 



