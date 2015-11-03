#!/bin/bash
# script to localize FFA and PPA

WD='/home/despoB/kaihwang/TRSE/TDSigEI'
SCRIPTS='/home/despoB/kaihwang/TRSE/TDSigEI/Scripts'

#503 505 508 509 510 512 513 516 517 518 519 523 527 528 529 530 532 534 531

for s in 503; do
	cd ${WD}/${s}

	rm Localizer_Motor*
	rm Localizer_PPAFFA*
	rm *Mapping*

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


	if [ ! -e ${WD}/${s}/template_brain.nii ]; then
		ln -s /home/despoB/kaihwang/standard/mni_icbm152_nlin_asym_09c/mni_icbm152_t1_tal_nlin_asym_09c_brain.nii \
		template_brain.nii
	fi

	#extract mapping runs
	for run in $(cat ${SCRIPTS}/${s}_mapping_runs); do
		
		if [ ! -e ${WD}/${s}/Mapping_run${run}.nii.gz ]; then
			ln -s ${WD}/${s}/run${run}/nswdktm_functional_6.nii.gz ${WD}/${s}/Mapping_run${run}.nii.gz
		fi
		
		if [ ! -e ${WD}/${s}/Mapping_run${run}_motpar.1D ]; then
			ln -s ${WD}/${s}/run${run}/motion.par ${WD}/${s}/Mapping_run${run}_motpar.1D
		fi

		3dmaskave -quiet -mask ${WD}/${s}/CSF_erode.nii.gz ${WD}/${s}/Mapping_run${run}.nii.gz > ${WD}/${s}/CSF_TS_Mapping_run${run}.1D
		3dmaskave -quiet -mask ${WD}/${s}/WM_erode.nii.gz ${WD}/${s}/Mapping_run${run}.nii.gz > ${WD}/${s}/WM_TS_Mapping_run${run}.1D
		3dmaskave -quiet -mask ${WD}/${s}/subject_mask.nii.gz ${WD}/${s}/Mapping_run${run}.nii.gz > ${WD}/${s}/GS_TS_Mapping_run${run}.1D

	done

	cat $(ls ${WD}/${s}/Mapping_run*_motpar.1D | sort -V) > ${WD}/${s}/Motion_mapping_runs.1D

	1d_tool.py -infile ${WD}/${s}/Motion_mapping_runs.1D \
	-set_nruns 8 -show_censor_count -censor_motion 0.3 ${s}_mapping -censor_prev_TR -overwrite

	#tissue regressors
	cat $(ls ${WD}/${s}/CSF_TS_Mapping_run*.1D | sort -V) > ${WD}/${s}/RegCSF_Mapping_TS.1D
	cat $(ls ${WD}/${s}/WM_TS_Mapping_run*.1D | sort -V) > ${WD}/${s}/RegWM_Mapping_TS.1D
	cat $(ls ${WD}/${s}/GS_TS_Mapping_run*.1D | sort -V) > ${WD}/${s}/RegGS_Mapping_TS.1D

	#nusiance model
	3dDeconvolve -input $(ls ${WD}/${s}/Mapping_run*.nii.gz | sort -V) \
	-mask ${WD}/ROIs/100overlap_mask+tlrc \
	-polort A \
	-num_stimts 9 \
	-censor ${s}_mapping_censor.1D \
	-stim_file 1 ${WD}/${s}/RegCSF_Mapping_TS.1D -stim_label 1 CSF -stim_base 1 \
	-stim_file 2 ${WD}/${s}/RegWM_Mapping_TS.1D -stim_label 2 WM -stim_base 2 \
	-stim_file 3 ${WD}/${s}/Motion_mapping_runs.1D[0] -stim_label 3 motpar1 -stim_base 3 \
	-stim_file 4 ${WD}/${s}/Motion_mapping_runs.1D[1] -stim_label 4 motpar2 -stim_base 4 \
	-stim_file 5 ${WD}/${s}/Motion_mapping_runs.1D[2] -stim_label 5 motpar3 -stim_base 5 \
	-stim_file 6 ${WD}/${s}/Motion_mapping_runs.1D[3] -stim_label 6 motpar4 -stim_base 6 \
	-stim_file 7 ${WD}/${s}/Motion_mapping_runs.1D[4] -stim_label 7 motpar5 -stim_base 7 \
	-stim_file 8 ${WD}/${s}/Motion_mapping_runs.1D[5] -stim_label 8 motpar6 -stim_base 8 \
	-stim_file 9 ${WD}/${s}/RegGS_Mapping_TS.1D -stim_label 9 GS -stim_base 9 \
	-nobucket \
	-noFDR \
	-errts ${s}_nusiance_Mapping_errts.nii.gz \
	-GOFORIT


	#localier 
	3dDeconvolve -input ${s}_nusiance_Mapping_errts.nii.gz \
	-mask ${WD}/ROIs/100overlap_mask+tlrc \
	-concat '1D: 0 102 204 306 408 510 612 714' \
	-polort A \
	-num_stimts 8 \
	-censor ${s}_mapping_censor.1D \
	-stim_times 1 ${WD}/Scripts/${s}_RH_stimtime.1D 'SPMG2' -stim_label 1 RH \
	-stim_times 2 ${WD}/Scripts/${s}_LH_stimtime.1D 'SPMG2' -stim_label 2 LH \
	-stim_file 3 ${WD}/${s}/Motion_mapping_runs.1D[0] -stim_label 3 motpar1 -stim_base 3 \
	-stim_file 4 ${WD}/${s}/Motion_mapping_runs.1D[1] -stim_label 4 motpar2 -stim_base 4 \
	-stim_file 5 ${WD}/${s}/Motion_mapping_runs.1D[2] -stim_label 5 motpar3 -stim_base 5 \
	-stim_file 6 ${WD}/${s}/Motion_mapping_runs.1D[3] -stim_label 6 motpar4 -stim_base 6 \
	-stim_file 7 ${WD}/${s}/Motion_mapping_runs.1D[4] -stim_label 7 motpar5 -stim_base 7 \
	-stim_file 8 ${WD}/${s}/Motion_mapping_runs.1D[5] -stim_label 8 motpar6 -stim_base 8 \
	-gltsym 'SYM: +1*RH[0] -1*LH[0] \ +1*RH[1] -1*LH[1] ' -glt_label 1 FtestRH-LH \
	-gltsym 'SYM: +1*RH[0] -1*LH[0]' -glt_label 2 BaseRH-LH \
	-gltsym 'SYM: +1*RH[1] -1*LH[1]' -glt_label 3 DerivRH-LH \
	-fout \
	-rout \
	-tout \
	-bucket Localizer_Motor_stats \
	-x1D Localizer_Motor_design_mat \
	-GOFORIT \
	-x1D_stop  

	. Localizer_Motor_stats.REML_cmd 


	3dDeconvolve -input ${s}_nusiance_Mapping_errts.nii.gz \
	-mask ${WD}/ROIs/100overlap_mask+tlrc \
	-polort A \
	-concat '1D: 0 102 204 306 408 510 612 714' \
	-num_stimts 8 \
	-censor ${s}_mapping_censor.1D \
	-stim_times 1 ${WD}/Scripts/${s}_face_stimtime.1D 'SPMG2' -stim_label 1 Faces \
	-stim_times 2 ${WD}/Scripts/${s}_house_stimtime.1D 'SPMG2' -stim_label 2 Scenes \
	-stim_file 3 ${WD}/${s}/Motion_mapping_runs.1D[0] -stim_label 3 motpar1 -stim_base 3 \
	-stim_file 4 ${WD}/${s}/Motion_mapping_runs.1D[1] -stim_label 4 motpar2 -stim_base 4 \
	-stim_file 5 ${WD}/${s}/Motion_mapping_runs.1D[2] -stim_label 5 motpar3 -stim_base 5 \
	-stim_file 6 ${WD}/${s}/Motion_mapping_runs.1D[3] -stim_label 6 motpar4 -stim_base 6 \
	-stim_file 7 ${WD}/${s}/Motion_mapping_runs.1D[4] -stim_label 7 motpar5 -stim_base 7 \
	-stim_file 8 ${WD}/${s}/Motion_mapping_runs.1D[5] -stim_label 8 motpar6 -stim_base 8 \
	-gltsym 'SYM: +1*Faces[0] -1*Scenes[0] \ +1*Faces[1] -1*Scenes[1]' -glt_label 1 FtestFaces-Scenes \
	-gltsym 'SYM: +1*Faces[0] -1*Scenes[0]' -glt_label 2 BaseFaces-Scenes \
	-gltsym 'SYM: +1*Faces[1] -1*Scenes[1]' -glt_label 3 DerivFaces-Scenes \
	-fout \
	-rout \
	-tout \
	-bucket Localizer_PPAFFA_stats \
	-x1D Localizer_PPAFFA_design_mat \
	-GOFORIT \
	-x1D_stop  

	. Localizer_PPAFFA_stats.REML_cmd 

	mv *.1D 1Ds
done
