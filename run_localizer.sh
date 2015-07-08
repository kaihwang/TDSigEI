#!/bin/bash
# script to localize FFA and PPA

WD='/home/despoB/kaihwang/TRSE/TDSigEI'
SCRIPTS='/home/despoB/kaihwang/TRSE/TDSigEI/Scripts'

for s in 503; do
	cd ${WD}/${s}

	ln -s /home/despoB/kaihwang/standard/mni_icbm152_nlin_asym_09c/mni_icbm152_t1_tal_nlin_asym_09c_brain.nii \
	template_brain.nii
	
	cat $(ls ${WD}/${s}/run*/motion.par | sort -V) > ${WD}/${s}/Motion_allruns.1D

	3dDeconvolve -input $(ls run*/ns*functional_6.nii.gz | sort -V) \
	-mask /home/despoB/kaihwang/TRSE/TDSigEI/ROIs/overlap.nii.gz \
	-polort A \
	-num_stimts 8 \
	-stim_times 1 ${WD}/Scripts/${s}_face_stimtime.1D 'GAM' -stim_label 1 Faces \
	-stim_times 2 ${WD}/Scripts/${s}_house_stimtime.1D 'GAM' -stim_label 2 Scenes \
	-stim_file 3 ${WD}/${s}/Motion_allruns.1D[0] -stim_label 3 motpar1 -stim_base 3 \
	-stim_file 4 ${WD}/${s}/Motion_allruns.1D[1] -stim_label 4 motpar2 -stim_base 4 \
	-stim_file 5 ${WD}/${s}/Motion_allruns.1D[2] -stim_label 5 motpar3 -stim_base 5 \
	-stim_file 6 ${WD}/${s}/Motion_allruns.1D[3] -stim_label 6 motpar4 -stim_base 6 \
	-stim_file 7 ${WD}/${s}/Motion_allruns.1D[4] -stim_label 7 motpar5 -stim_base 7 \
	-stim_file 8 ${WD}/${s}/Motion_allruns.1D[5] -stim_label 8 motpar6 -stim_base 8 \
	-gltsym 'SYM: +1*Faces' -glt_label 1 Faces \
	-gltsym 'SYM: +1*Scenes' -glt_label 2 Scenes \
	-gltsym 'SYM: +1*Faces -1*Scenes' -glt_label 3 Faces-Scenes \
	-fout \
	-rout \
	-tout \
	-bucket Localizer_FFAPPA_stats \
	-x1D Localizer_FFAPPA_design_mat \
	-x1D_stop  

	. Localizer_FFAPPA_stats.REML_cmd 

	3dDeconvolve -input $(ls run*/ns*functional_6.nii.gz | sort -V) \
	-mask /home/despoB/kaihwang/TRSE/TDSigEI/ROIs/overlap.nii.gz \
	-polort A \
	-num_stimts 8 \
	-stim_times 1 ${WD}/Scripts/${s}_LH_stimtime.1D 'GAM' -stim_label 1 LH \
	-stim_times 2 ${WD}/Scripts/${s}_RH_stimtime.1D 'GAM' -stim_label 2 RH \
	-stim_file 3 ${WD}/${s}/Motion_allruns.1D[0] -stim_label 3 motpar1 -stim_base 3 \
	-stim_file 4 ${WD}/${s}/Motion_allruns.1D[1] -stim_label 4 motpar2 -stim_base 4 \
	-stim_file 5 ${WD}/${s}/Motion_allruns.1D[2] -stim_label 5 motpar3 -stim_base 5 \
	-stim_file 6 ${WD}/${s}/Motion_allruns.1D[3] -stim_label 6 motpar4 -stim_base 6 \
	-stim_file 7 ${WD}/${s}/Motion_allruns.1D[4] -stim_label 7 motpar5 -stim_base 7 \
	-stim_file 8 ${WD}/${s}/Motion_allruns.1D[5] -stim_label 8 motpar6 -stim_base 8 \
	-gltsym 'SYM: +1*LH' -glt_label 1 LH \
	-gltsym 'SYM: +1*RH' -glt_label 2 RH \
	-gltsym 'SYM: +1*LH -1*RH' -glt_label 3 LH-RH \
	-fout \
	-rout \
	-tout \
	-bucket Localizer_Motor_stats \
	-x1D Localizer_Motor_design_mat \
	-x1D_stop  

	. Localizer_Motor_stats.REML_cmd 

done
