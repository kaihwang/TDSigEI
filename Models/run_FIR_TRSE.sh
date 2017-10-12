# script to run FIR model on the old TRSE dataset

WD='/home/despoB/kaihwang/TRSE/TRSEPPI/AllSubjs'
SCRIPT='/home/despoB/kaihwang/TRSE/TRSEPPI/TRSE_scripts'
MTD='/home/despoB/kaihwang/bin/TDSigEI/MTD'


for s in 1106; do
	
	cd $WD/${s}

	###creat sym links for preproc data
	#FH
	i=1
	for run in 1 8 11 14 17; do
		ln -s $WD/${s}/preproced_run${run}.nii.gz $WD/${s}/${s}_FH_run${i}.nii.gz
		ln -s $WD/${s}/run${run}/motion.1D $WD/${s}/${s}_FH_motion_run${i}.1D
		i=$(($i+1))
	done
	
	#HF
	i=1
	for run in 2 5 12 15 18; do
		ln -s $WD/${s}/preproced_run${run}.nii.gz $WD/${s}/${s}_HF_run${i}.nii.gz
		ln -s $WD/${s}/run${run}/motion.1D $WD/${s}/${s}_HF_motion_run${i}.1D
		i=$(($i+1))
	done

	#CAT
	i=1
	for run in 3 6 9 16 19; do
		ln -s $WD/${s}/preproced_run${run}.nii.gz $WD/${s}/${s}_CAT_run${i}.nii.gz
		ln -s $WD/${s}/run${run}/motion.1D $WD/${s}/${s}_CAT_motion_run${i}.1D
		i=$(($i+1))
	done

	#BO
	i=1
	for run in 4 7 10 13 17 20; do
		ln -s $WD/${s}/preproced_run${run}.nii.gz $WD/${s}/${s}_BO_run${i}.nii.gz
		ln -s $WD/${s}/run${run}/motion.1D $WD/${s}/${s}_BO_motion_run${i}.1D
		i=$(($i+1))
	done


	### get nuisance regressors
	if [ ! -e ${WD}/${s}/CSF_erode.nii.gz ]; then
		fslreorient2std ${WD}/${s}/MPRAGE/mprage_bet_fast_seg_0.nii.gz ${WD}/${s}/MPRAGE/mprage_bet_fast_seg_0.nii.gz
		applywarp --ref=${WD}/${s}/MPRAGE/template_brain.nii \
		--rel \
		--interp=nn \
		--in=${WD}/${s}/MPRAGE/mprage_bet_fast_seg_0.nii.gz \
		--warp=${WD}/${s}/MPRAGE/mprage_warpcoef.nii.gz \
		-o ${WD}/${s}/CSF_orig.nii.gz
	
		3dmask_tool -prefix ${WD}/${s}/CSF_erode.nii.gz -quiet -input ${WD}/${s}/CSF_orig.nii.gz -dilate_result -1
	fi

	if [ ! -e ${WD}/${s}/WM_erode.nii.gz ]; then
		fslreorient2std ${WD}/${s}/MPRAGE/mprage_bet_fast_seg_2.nii.gz ${WD}/${s}/MPRAGE/mprage_bet_fast_seg_2.nii.gz
		applywarp --ref=${WD}/${s}/MPRAGE/template_brain.nii \
		--rel \
		--interp=nn \
		--in=${WD}/${s}/MPRAGE/mprage_bet_fast_seg_2.nii.gz \
		--warp=${WD}/${s}/MPRAGE/mprage_warpcoef.nii.gz \
		-o ${WD}/${s}/WM_orig.nii.gz	
	
		3dmask_tool -prefix ${WD}/${s}/WM_erode.nii.gz -quiet -input ${WD}/${s}/WM_orig.nii.gz -dilate_result -1
	fi

	for condition in FH HF CAT BO; do
		
		for run in 1 2 3 4 5; do

			3dmaskave -quiet -mask ${WD}/${s}/CSF_erode.nii.gz ${WD}/${s}/${s}_${condition}_run${run}.nii.gz > ${WD}/${s}/${condition}_CSF_TS_run${run}.1D
			3dmaskave -quiet -mask ${WD}/${s}/WM_erode.nii.gz ${WD}/${s}/${s}_${condition}_run${run}.nii.gz > ${WD}/${s}/${condition}_WM_TS_run${run}.1D
			3dmaskave -quiet -mask $WD/${s}/${s}_${condition}_run${run}.nii.gz[0] ${WD}/${s}/${s}_${condition}_run${run}.nii.gz > ${WD}/${s}/${condition}_GS_TS_run${run}.1D
		done

		cat $(/bin/ls ${WD}/${s}/${condition}_CSF_TS_run*.1D | sort -V) > ${WD}/${s}/${condition}_RegCSF_TS.1D
		cat $(/bin/ls ${WD}/${s}/${condition}_WM_TS_run*.1D | sort -V) > ${WD}/${s}/${condition}_RegWM_TS.1D
		cat $(/bin/ls ${WD}/${s}/${condition}_GS_TS_run*.1D | sort -V) > ${WD}/${s}/${condition}_RegGS_TS.1D
		cat $(/bin/ls ${WD}/${s}/${s}_${condition}_motion_run*.1D | sort -V) > ${WD}/${s}/${condition}_motionRuns.1D
	
	done

	#extract timings
	cat ${SCRIPT}/${s}_relevant_face.txt | grep [0-9] > ${WD}/${s}/FH_stim1.1D
	cat ${SCRIPT}/${s}_irrelevant_scene.txt | grep [0-9] > ${WD}/${s}/FH_stim2.1D
	cat ${SCRIPT}/${s}_relevant_scene.txt | grep [0-9] > ${WD}/${s}/HF_stim1.1D
	cat ${SCRIPT}/${s}_irrelevant_face.txt | grep [0-9] > ${WD}/${s}/HF_stim2.1D
	cat ${SCRIPT}/${s}_categorize_face.txt | grep [0-9] > ${WD}/${s}/CAT_stim1.1D
	cat ${SCRIPT}/${s}_categorize_scene.txt | grep [0-9] > ${WD}/${s}/CAT_stim2.1D
	cat ${SCRIPT}/${s}_both_face.txt | grep [0-9] > ${WD}/${s}/BO_stim1.1D
	cat ${SCRIPT}/${s}_both_scene.txt | grep [0-9] > ${WD}/${s}/BO_stim2.1D

	for condition in FH HF CAT BO; do
		
		3dDeconvolve -input $(/bin/ls ${WD}/${s}/${s}_${condition}_run*.nii.gz | sort -V) \
		-mask /home/despoB/TRSEPPI/TRSEPPI/overlap_mask/TRSE_80perOverlap_mask.nii.gz \
		-polort A \
		-num_stimts 11 \
		-stim_times 1 ${WD}/${s}/${condition}_stim1.1D 'TENT(0, 14, 15)' -stim_label 1 ${condition}_stim1 \
		-stim_times 2 ${WD}/${s}/${condition}_stim2.1D 'TENT(0, 14, 15)' -stim_label 2 ${condition}_stim2 \
		-stim_file 3 ${WD}/${s}/${condition}_motionRuns.1D[0] -stim_label 3 motpar1 -stim_base 3 \
		-stim_file 4 ${WD}/${s}/${condition}_motionRuns.1D[1] -stim_label 4 motpar2 -stim_base 4 \
		-stim_file 5 ${WD}/${s}/${condition}_motionRuns.1D[2] -stim_label 5 motpar3 -stim_base 5 \
		-stim_file 6 ${WD}/${s}/${condition}_motionRuns.1D[3] -stim_label 6 motpar4 -stim_base 6 \
		-stim_file 7 ${WD}/${s}/${condition}_motionRuns.1D[4] -stim_label 7 motpar5 -stim_base 7 \
		-stim_file 8 ${WD}/${s}/${condition}_motionRuns.1D[5] -stim_label 8 motpar6 -stim_base 8 \
		-stim_file 9 ${WD}/${s}/${condition}_RegCSF_TS.1D -stim_label 9 CSF -stim_base 9 \
		-stim_file 10 ${WD}/${s}/${condition}_RegWM_TS.1D -stim_label 10 WM -stim_base 10 \
		-stim_file 11 ${WD}/${s}/${condition}_RegGS_TS.1D -stim_label 11 WM -stim_base 11 \
		-iresp 1 ${condition}_stim1_FIR \
		-iresp 2 ${condition}_stim2_FIR \
		-rout \
		-nocout \
		-bucket ${condition}_FIR_stats \
		-x1D ${condition}_FIR_design_mat \
		-GOFORIT 100\
		-noFDR \
		-errts ${s}_FIR_${condition}_errts.nii.gz \
		-allzero_OK	-jobs 3
	done
done



