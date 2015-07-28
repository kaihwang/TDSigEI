#!/bin/bash
# script to localize FFA and PPA

WD='/home/despoB/kaihwang/TRSE/TDSigEI'
SCRIPTS='/home/despoB/kaihwang/TRSE/TDSigEI/Scripts'

#503 505 508 509 510 512 513 516 517 518 519 523 527 528 529 530 532 534 531

for s in 510; do
	cd ${WD}/${s}

	ln -s /home/despoB/kaihwang/standard/mni_icbm152_nlin_asym_09c/mni_icbm152_t1_tal_nlin_asym_09c_brain.nii \
	template_brain.nii
	
	#extract mapping runs
	for run in $(cat ${SCRIPTS}/${s}_mapping_runs); do
		
		if [ ! -e ${WD}/${s}/Mapping_run${run}.nii.gz ]; then
			ln -s ${WD}/${s}/run${run}/nswdktm_functional_6.nii.gz ${WD}/${s}/Mapping_run${run}.nii.gz
		fi
		
		if [ ! -e ${WD}/${s}/Mapping_run${run}_motpar.1D ]; then
			ln -s ${WD}/${s}/run${run}/motion.par ${WD}/${s}/Mapping_run${run}_motpar.1D
		fi

	done

	cat $(ls ${WD}/${s}/Mapping_run*_motpar.1D | sort -V) > ${WD}/${s}/Motion_mapping_runs.1D

	1d_tool.py -infile ${WD}/${s}/Motion_mapping_runs.1D \
	-set_nruns 8 -show_censor_count -censor_motion 0.5 ${s}_mapping -censor_prev_TR -overwrite


	3dDeconvolve -input $(ls ${WD}/${s}/Mapping_run*.nii.gz | sort -V) \
	-mask ${WD}/ROIs/overlap.nii.gz \
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


	3dDeconvolve -input $(ls ${WD}/${s}/Mapping_run*.nii.gz | sort -V) \
	-mask ${WD}/ROIs/overlap.nii.gz \
	-polort A \
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
done
