#!/bin/bash
# script to run FIR model for each condition.

WD='/home/despoB/kaihwang/TRSE/TDSigEI'
SCRIPTS='/home/despoB/kaihwang/TRSE/TDSigEI/Scripts'
#503 505 508 509 510 512 513 516 517 518 519 523 527 528 529 530 532 534 531
# 510

for s in 503; do
	cd ${WD}/${s}
	rm *FIR*
	rm *nusiance*
	
	# normalize tissue masks to extract nuisance signal
	fslreorient2std ${WD}/${s}/MPRAGE/mprage_bet_fast_seg_0.nii.gz ${WD}/${s}/MPRAGE/mprage_bet_fast_seg_0.nii.gz
	applywarp --ref=${WD}/${s}/MPRAGE/mprage_final.nii.gz \
	--rel \
	--interp=nn \
	--in=${WD}/${s}/MPRAGE/mprage_bet_fast_seg_0.nii.gz \
	--warp=${WD}/${s}/MPRAGE/mprage_warpcoef.nii.gz \
	-o ${WD}/${s}/CSF_orig.nii.gz
	rm ${WD}/${s}/CSF_erode.nii.gz
	3dmask_tool -prefix ${WD}/${s}/CSF_erode.nii.gz -quiet -input ${WD}/${s}/CSF_orig.nii.gz -dilate_result -1

	fslreorient2std ${WD}/${s}/MPRAGE/mprage_bet_fast_seg_2.nii.gz ${WD}/${s}/MPRAGE/mprage_bet_fast_seg_2.nii.gz
	applywarp --ref=${WD}/${s}/MPRAGE/mprage_final.nii.gz \
	--rel \
	--interp=nn \
	--in=${WD}/${s}/MPRAGE/mprage_bet_fast_seg_2.nii.gz \
	--warp=${WD}/${s}/MPRAGE/mprage_warpcoef.nii.gz \
	-o ${WD}/${s}/WM_orig.nii.gz	
	rm ${WD}/${s}/WM_erode.nii.gz
	3dmask_tool -prefix ${WD}/${s}/WM_erode.nii.gz -quiet -input ${WD}/${s}/WM_orig.nii.gz -dilate_result -1

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


			#nuisance tissue signal
			3dmaskave -quiet -mask ${WD}/${s}/CSF_erode.nii.gz ${WD}/${s}/${condition}_run${run}.nii.gz > ${WD}/${s}/CSF_TS_${condition}_run${run}.1D
			3dmaskave -quiet -mask ${WD}/${s}/WM_erode.nii.gz ${WD}/${s}/${condition}_run${run}.nii.gz > ${WD}/${s}/WM_TS_${condition}_run${run}.1D
			3dmaskave -quiet -mask ${WD}/${s}/subject_mask.nii.gz ${WD}/${s}/${condition}_run${run}.nii.gz > ${WD}/${s}/GS_TS_${condition}_run${run}.1D

		done

		# concat motion regressors and create censor files
		cat $(ls ${WD}/${s}/${condition}_run*_motpar.1D | sort -V) > ${WD}/${s}/Motion_${condition}_runs.1D

		1d_tool.py -infile ${WD}/${s}/Motion_${condition}_runs.1D \
		-set_nruns 4 -show_censor_count -censor_motion 0.3 ${s}_${condition} -censor_prev_TR -overwrite

		#tissue regressors
		cat $(ls ${WD}/${s}/CSF_TS_${condition}_run*.1D | sort -V) > ${WD}/${s}/RegCSF_${condition}_TS.1D
		cat $(ls ${WD}/${s}/WM_TS_${condition}_run*.1D | sort -V) > ${WD}/${s}/RegWM_${condition}_TS.1D
		cat $(ls ${WD}/${s}/GS_TS_${condition}_run*.1D | sort -V) > ${WD}/${s}/RegGS_${condition}_TS.1D

		#run "nuisance model"
		3dDeconvolve -input $(ls ${WD}/${s}/${condition}_run*.nii.gz | sort -V) \
		-mask ${WD}/ROIs/100overlap_mask+tlrc \
		-polort A \
		-num_stimts 8 \
		-stim_file 1 ${WD}/${s}/Motion_${condition}_runs.1D[0] -stim_label 1 motpar1 \
		-stim_file 2 ${WD}/${s}/Motion_${condition}_runs.1D[1] -stim_label 2 motpar2 \
		-stim_file 3 ${WD}/${s}/Motion_${condition}_runs.1D[2] -stim_label 3 motpar3 \
		-stim_file 4 ${WD}/${s}/Motion_${condition}_runs.1D[3] -stim_label 4 motpar4 \
		-stim_file 5 ${WD}/${s}/Motion_${condition}_runs.1D[4] -stim_label 5 motpar5 \
		-stim_file 6 ${WD}/${s}/Motion_${condition}_runs.1D[5] -stim_label 6 motpar6 \
		-stim_file 7 ${WD}/${s}/RegCSF_${condition}_TS.1D -stim_label 7 CSF \
		-stim_file 8 ${WD}/${s}/RegWM_${condition}_TS.1D -stim_label 8 WM \
		-nobucket \
		-GOFORIT 100 \
		-noFDR \
		-errts ${s}_nusiance_${condition}_errts.nii.gz \
		-allzero_OK


		#-stim_times 1 ${WD}/${s}/${condition}_stimtime.1D 'TENT(-1.5, 28.5, 20)' -stim_label 1 ${condition}_FIR \
		# -iresp 1 ${condition}_FIR \
		# -rout \
		# -bucket FIR_${condition}_stats \
		# -x1D FIR_${condition}_design_mat \
		# -GOFORIT 100\
		# -noFDR \
		# -allzero_OK

		# run FIR model
		3dDeconvolve -input ${s}_nusiance_${condition}_errts.nii.gz \
		-concat '1D: 0 102 204 306' \
		-mask ${WD}/ROIs/100overlap_mask+tlrc \
		-polort A \
		-num_stimts 1 \
		-stim_times 1 ${WD}/${s}/${condition}_stimtime.1D 'TENT(-1.5, 28.5, 20)' -stim_label 1 ${condition}_FIR \
		-iresp 1 ${condition}_FIR \
		-rout \
		-bucket FIR_${condition}_stats \
		-x1D FIR_${condition}_design_mat \
		-GOFORIT 100\
		-noFDR \
		-errts ${s}_FIR_${condition}_errts.nii.gz \
		-allzero_OK

	done


done
#
