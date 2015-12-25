#!/bin/bash
# script for group analysis of seed-based connecivity maps. using AFNI's 3dMVM 
# two within subject factors: seedROI {FFA, PPA} x attention conditions {TD, To, P, D}
# note no between subject variables

#motor
for condition in TD D; do
	echo "cd /home/despoB/kaihwang/TRSE/TDSigEI/Group 
3dANOVA3 -type 4 \\
-alevels 2 \\
-blevels 2 \\
-clevels 19 \\
-fa main_effect_roi \\
-fb main_effect_thareg \\
-fab roi_x_thareg \\
-bcontr 1 -1 noTha-Tha \\" > /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_seedcon_motor${condition}_thareg.sh

	cd /home/despoB/kaihwang/TRSE/TDSigEI/

	n=1
	for s in $(ls -d 5*); do

		echo "-dset 1 1 ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/Corrcoef_seedRH_${condition}+tlrc'[0]' \\
-dset 2 1 ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/Corrcoef_seedLH_${condition}+tlrc'[0]' \\
-dset 1 2 ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/Corrcoef_seedRH_${condition}_thareg+tlrc'[0]' \\
-dset 2 2 ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/Corrcoef_seedLH_${condition}_thareg+tlrc'[0]' \\" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_seedcon_motor${condition}_thareg.sh

		n=$(($n+1))
	done
	echo "-bucket GroupStat_sc_motor${condition}_tha.nii.gz" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_seedcon_motor${condition}_thareg.sh

	if [ ! -e //home/despoB/kaihwang/TRSE/TDSigEI/Group/GroupStat_sc_motor${condition}_tha.nii.gz ]; then
		. /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_seedcon_motor${condition}_thareg.sh
	fi
done




#vis

for condition in TD D To P; do

	if [ "$condition" == "TD" ]; then
		cond1=FH
		cond2=HF
	fi

	if [ "$condition" == "D" ]; then
		cond1=HF
		cond2=FH
	fi

	if [ "$condition" == "To" ]; then
		cond1=Fo
		cond2=Ho
	fi

	if [ "$condition" == "P" ]; then
		cond1=Fp
		cond2=Hp
	fi

	echo "cd /home/despoB/kaihwang/TRSE/TDSigEI/Group 
3dANOVA3 -type 4 \\
-alevels 2 \\
-blevels 2 \\
-clevels 19 \\
-fa main_effect_roi \\
-fb main_effect_thareg \\
-fab roi_x_thareg \\
-bcontr 1 -1 noTha-Tha \\" > /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_seedcon_${condition}_thareg.sh

	cd /home/despoB/kaihwang/TRSE/TDSigEI/

	n=1
	for s in $(ls -d 5*); do

		echo "-dset 1 1 ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/Corrcoef_seedFFA_${cond1}+tlrc'[0]' \\
-dset 2 1 ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/Corrcoef_seedPPA_${cond2}+tlrc'[0]' \\
-dset 1 2 ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/Corrcoef_seedFFA_${cond1}_thareg+tlrc'[0]' \\
-dset 2 2 ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/Corrcoef_seedPPA_${cond2}_thareg+tlrc'[0]' \\" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_seedcon_${condition}_thareg.sh

		n=$(($n+1))
	done
	echo "-bucket GroupStat_sc_${condition}_tha.nii.gz" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_seedcon_${condition}_thareg.sh

	if [ ! -e //home/despoB/kaihwang/TRSE/TDSigEI/Group/GroupStat_sc_${condition}_tha.nii.gz ]; then
		. /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_seedcon_${condition}_thareg.sh
	fi
done 



#for thareg contrast between conditions
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
-bcontr 0 0 0 1 D \\"> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_seedcon_motor_thareg.sh

cd /home/despoB/kaihwang/TRSE/TDSigEI/

n=1
for s in $(ls -d 5*); do
	r=1
	for ROI in RH LH; do
		c=1
		for condition in TD To P D; do
			echo "-dset ${r} ${c} ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/Corrcoef_seed${ROI}_${condition}_thareg+tlrc'[0]' \\" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_seedcon_motor_thareg.sh
			c=$(($c+1))
		done
		r=$(($r+1))
	done
	n=$(($n+1))
done
echo "-bucket GroupStat_sc_motor_tha.nii.gz" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_seedcon_motor_thareg.sh

. /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_seedcon_motor_thareg.sh


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
-bcontr 0 0 0 1 D \\" > /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_seedcon_thareg.sh

cd /home/despoB/kaihwang/TRSE/TDSigEI/

n=1
for s in $(ls -d 5*); do
	
	r=1
	for ROI in FFA; do
		c=1
		for condition in FH Fo Fp HF; do
			echo "-dset ${r} ${c} ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/Corrcoef_seed${ROI}_${condition}_thareg+tlrc'[0]' \\" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_seedcon_thareg.sh
			c=$(($c+1))
		done
	done

	r=2
	for ROI in PPA; do
		c=1
		for condition in HF Ho Hp FH; do
			echo "-dset ${r} ${c} ${n} /home/despoB/TRSEPPI/TDSigEI/${s}/Corrcoef_seed${ROI}_${condition}_thareg+tlrc'[0]' \\" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_seedcon_thareg.sh
			c=$(($c+1))
		done
	done

	n=$(($n+1))
done

echo '-bucket GroupStats_sc_tha.nii.gz' >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_seedcon_thareg.sh

. /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_seedcon_thareg.sh 

