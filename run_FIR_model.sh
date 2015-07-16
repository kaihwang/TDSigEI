#!/bin/bash
# script to run FIR model for each condition.

WD='/home/despoB/kaihwang/TRSE/TDSigEI'
SCRIPTS='/home/despoB/kaihwang/TRSE/TDSigEI/Scripts'
#503 505 508 509 511 512 513 516 517 518 519 523 527 529 530 532


for s in 505 508 509 511 512 513 516 517 518 519 523 527 529 530 532; do
	cd ${WD}/${s}


	#extract runs for each condition: FH, HF, Fo, Ho, Fp, Hp
	for condition in FH HF Fo Ho Fp Hp; do
		
		# create motor regressors
		echo -n "" > ${WD}/${s}/${condition}_RH.1D
		echo -n "" > ${WD}/${s}/${condition}_LH.1D
		echo -n "" > ${WD}/${s}/${condition}_stimtime.1D
		
		#create stimtime for each condition
		for run in $(cat ${SCRIPTS}/${s}_run_order | grep -n ${condition} | cut -f1 -d:); do
			
			if [ ! -e ${WD}/${s}/${condition}_run${run}.nii.gz ]; then
				ln -s ${WD}/${s}/run${run}/nswdktm_functional_6.nii.gz ${WD}/${s}/${condition}_run${run}.nii.gz
			fi
			
			if [ ! -e ${WD}/${s}/${condition}_run${run}_motpar.1D ]; then
				ln -s ${WD}/${s}/run${run}/motion.par ${WD}/${s}/${condition}_run${run}_motpar.1D
			fi

			sed -n "${run},${run}p" ${SCRIPTS}/${s}_RH_allruns_stimtime.1D >> ${WD}/${s}/${condition}_RH.1D
			sed -n "${run},${run}p" ${SCRIPTS}/${s}_LH_allruns_stimtime.1D >> ${WD}/${s}/${condition}_LH.1D
			sed -n "${run},${run}p" ${SCRIPTS}/${s}_${condition}_stimtime.1D >> ${WD}/${s}/${condition}_stimtime.1D
		done

		# concat motion regressors and create censor files
		cat $(ls ${WD}/${s}/${condition}_run*_motpar.1D | sort -V) > ${WD}/${s}/Motion_${condition}_runs.1D

		1d_tool.py -infile ${WD}/${s}/Motion_${condition}_runs.1D \
		-set_nruns 4 -show_censor_count -censor_motion 0.5 ${s}_${condition} -censor_prev_TR -overwrite

		#run FIR model
		3dDeconvolve -input $(ls ${WD}/${s}/${condition}_run*.nii.gz | sort -V) \
		-mask ${WD}/ROIs/overlap.nii.gz \
		-polort A \
		-num_stimts 9 \
		-censor ${WD}/${s}/${s}_${condition}_censor.1D \
		-stim_times 1 ${WD}/${s}/${condition}_stimtime.1D 'TENT(-1.5, 27, 19)' -stim_label 1 ${condition}_FIR \
		-stim_times 2 ${WD}/${s}/${condition}_RH.1D 'TENT(-1.5, 12, 9)' -stim_label 2 RH \
		-stim_times 3 ${WD}/${s}/${condition}_LH.1D 'TENT(-1.5, 12, 9)' -stim_label 3 LH \
		-stim_file 4 ${WD}/${s}/Motion_${condition}_runs.1D[0] -stim_label 4 motpar1 -stim_base 4 \
		-stim_file 5 ${WD}/${s}/Motion_${condition}_runs.1D[1] -stim_label 5 motpar2 -stim_base 5 \
		-stim_file 6 ${WD}/${s}/Motion_${condition}_runs.1D[2] -stim_label 6 motpar3 -stim_base 6 \
		-stim_file 7 ${WD}/${s}/Motion_${condition}_runs.1D[3] -stim_label 7 motpar4 -stim_base 7 \
		-stim_file 8 ${WD}/${s}/Motion_${condition}_runs.1D[4] -stim_label 8 motpar5 -stim_base 8 \
		-stim_file 9 ${WD}/${s}/Motion_${condition}_runs.1D[5] -stim_label 9 motpar6 -stim_base 9 \
		-iresp 1 ${condition}_FIR \
		-tshift \
		-errts ${s}_FIR_${condition}_errts.nii.gz \
		-rout \
		-bucket FIR_${condition}_stats \
		-x1D FIR_${condition}_design_mat \
		-GOFORIT 100\
		-noFDR \
		-allzero_OK 


	done


done