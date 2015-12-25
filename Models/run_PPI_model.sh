#!/bin/bash
# script to run PPI model for the TD condition.

WD='/home/despoB/kaihwang/TRSE/TDSigEI'
SCRIPTS='/home/despoB/kaihwang/TRSE/TDSigEI/Scripts'
#503 505 508 509 510 512 513 516 517 518 519 523 527 528 529 530 532 534 531

for s in 503; do
	cd ${WD}/${s}

	#create condition stimtime
	for condition in FT FD HT HD; do
		timing_tool.py -timing ${SCRIPTS}/${s}_TD_${condition}_stimtime.1D \
		-timing_to_1D ${WD}/${s}/gPPI_${condition}_stimtime.1D \
		-tr 1.5 -stim_dur 0.75 -min_frac 0.01 -run_len 153

		#convolve stimulus timing with gamma function to create stim model
		waver -GAM -peak 1 -TR 1  -input ${WD}/${s}/gPPI_${condition}_stimtime.1D -numout 816 > ${WD}/${s}/stim_${condition}_gam.1D
	done

	# normalize tissue masks to extract nuisance signal
	fslreorient2std ${WD}/${s}/MPRAGE/mprage_bet_fast_seg_0.nii.gz ${WD}/${s}/MPRAGE/mprage_bet_fast_seg_0.nii.gz
	applywarp --ref=${WD}/${s}/MPRAGE/mprage_final.nii.gz \
	--rel \
	--interp=nn \
	--in=${WD}/${s}/MPRAGE/mprage_bet_fast_seg_0.nii.gz \
	--warp=${WD}/${s}/MPRAGE/mprage_warpcoef.nii.gz \
	-o ${WD}/${s}/CSF_orig.nii.gz
	3dmask_tool -prefix ${WD}/${s}/CSF_erode.nii.gz -quiet -input ${WD}/${s}/CSF_orig.nii.gz -dilate_result -1

	fslreorient2std ${WD}/${s}/MPRAGE/mprage_bet_fast_seg_2.nii.gz ${WD}/${s}/MPRAGE/mprage_bet_fast_seg_2.nii.gz
	applywarp --ref=${WD}/${s}/MPRAGE/mprage_final.nii.gz \
	--rel \
	--interp=nn \
	--in=${WD}/${s}/MPRAGE/mprage_bet_fast_seg_2.nii.gz \
	--warp=${WD}/${s}/MPRAGE/mprage_warpcoef.nii.gz \
	-o ${WD}/${s}/WM_orig.nii.gz	
	3dmask_tool -prefix ${WD}/${s}/WM_erode.nii.gz -quiet -input ${WD}/${s}/WM_orig.nii.gz -dilate_result -1

	#extract ROI timeseries
	rm CSF_TS_*.1D
	rm WM_TS_*.1D

	for run in $(cat ${SCRIPTS}/${s}_TD_runs); do
		
		if [ ! -e ${WD}/${s}/TD_run${run}.nii.gz ]; then
			ln -s ${WD}/${s}/run${run}/nswdktm_functional_6.nii.gz ${WD}/${s}/TD_run${run}.nii.gz
		fi
			
		if [ ! -e ${WD}/${s}/TD_run${run}_motpar.1D ]; then
			ln -s ${WD}/${s}/run${run}/motion.par ${WD}/${s}/TD_run${run}_motpar.1D
		fi
		
		if [ ! -e ${WD}/${s}/FFA_TS_run${run}.1D ]; then
			3dmaskave -quiet -mask ${WD}/${s}/FFA_indiv_ROI+tlrc ${WD}/${s}/TD_run${run}.nii.gz > ${WD}/${s}/FFA_TS_run${run}.1D
		fi

		if [ ! -e ${WD}/${s}/PPA_TS_run${run}.1D ]; then
			3dmaskave -quiet -mask ${WD}/${s}/PPA_indiv_ROI+tlrc ${WD}/${s}/TD_run${run}.nii.gz > ${WD}/${s}/PPA_TS_run${run}.1D
		fi

		#nuisance signal
		if [ ! -e ${WD}/${s}/CSF_TS_run${run}.1D ]; then
			3dmaskave -quiet -mask ${WD}/${s}/CSF_erode.nii.gz ${WD}/${s}/TD_run${run}.nii.gz > ${WD}/${s}/CSF_TS_run${run}.1D
		fi

		if [ ! -e ${WD}/${s}/WM_TS_run${run}.1D ]; then
			3dmaskave -quiet -mask ${WD}/${s}/WM_erode.nii.gz ${WD}/${s}/TD_run${run}.nii.gz > ${WD}/${s}/WM_TS_run${run}.1D
		fi

		# need to detrend timeseries
		#rm tmp*1D
		if [ ! -e ${WD}/${s}/PPA_TS_run${run}_dt_t.1D ]; then
			rm tmp*1D
			1dtranspose ${WD}/${s}/PPA_TS_run${run}.1D ${WD}/${s}/tmp.1D
			3dDetrend -polort 2 -prefix ${WD}/${s}/tmp_dt.1D ${WD}/${s}/tmp.1D
			1dtranspose ${WD}/${s}/tmp_dt.1D ${WD}/${s}/PPA_TS_run${run}_dt_t.1D
		fi

		#rm tmp*1D
		if [ ! -e ${WD}/${s}/FFA_TS_run${run}_dt_t.1D ]; then
			rm tmp*1D
			1dtranspose ${WD}/${s}/FFA_TS_run${run}.1D ${WD}/${s}/tmp.1D
			3dDetrend -polort 2 -prefix ${WD}/${s}/tmp_dt.1D ${WD}/${s}/tmp.1D
			1dtranspose ${WD}/${s}/tmp_dt.1D ${WD}/${s}/FFA_TS_run${run}_dt_t.1D
		fi
		
	done
	rm tmp*1D

	# concatenate ROI timeseries and motion parameters
	cat $(ls ${WD}/${s}/FFA_TS_*_t.1D | sort -V) > ${WD}/${s}/FFA_TS.1D
	cat $(ls ${WD}/${s}/PPA_TS_*_t.1D | sort -V) > ${WD}/${s}/PPA_TS.1D
	cat $(ls ${WD}/${s}/CSF_TS_*.1D | sort -V) > ${WD}/${s}/CSF_TS.1D
	cat $(ls ${WD}/${s}/WM_TS_*.1D | sort -V) > ${WD}/${s}/WM_TS.1D
	cat $(ls ${WD}/${s}/TD_run*_motpar.1D | sort -V) > ${WD}/${s}/Motion_TD_runs.1D

	#create censor
	1d_tool.py -infile ${WD}/${s}/Motion_TD_runs.1D \
	-set_nruns 8 -show_censor_count -censor_motion 0.3 ${s}_TD -censor_prev_TR -overwrite

	# create gPPI regressors for each condition
	#for condition in FT FD HT FD; do
	1deval -a ${WD}/${s}/FFA_TS.1D -b ${WD}/${s}/stim_FT_gam.1D -expr 'a*b' > ${WD}/${s}/gPPI_FFA_T.1D
	1deval -a ${WD}/${s}/FFA_TS.1D -b ${WD}/${s}/stim_FD_gam.1D -expr 'a*b' > ${WD}/${s}/gPPI_FFA_D.1D
	1deval -a ${WD}/${s}/PPA_TS.1D -b ${WD}/${s}/stim_HT_gam.1D -expr 'a*b' > ${WD}/${s}/gPPI_PPA_T.1D
	1deval -a ${WD}/${s}/PPA_TS.1D -b ${WD}/${s}/stim_HD_gam.1D -expr 'a*b' > ${WD}/${s}/gPPI_PPA_D.1D
	
	#creat target and distractor naming of stimulus model
	cp stim_FT_gam.1D stim_FFA_T_gam.1D
	cp stim_FD_gam.1D stim_FFA_D_gam.1D
	cp stim_HT_gam.1D stim_PPA_T_gam.1D
	cp stim_HD_gam.1D stim_PPA_D_gam.1D


	for ROI in FFA PPA; do
	
		#if [ ! -e gPPI_${ROI}_Full_model_stats.REML_cmd ]; then
	
		# full PPI model,  PPI regressors + stim timing + FFA/PPA timeseries
		3dDeconvolve -input $(ls ${WD}/${s}/TD_run*.nii.gz | sort -V) \
		-mask ${WD}/ROIs/overlap.nii.gz \
		-polort A \
		-censor ${WD}/${s}/${s}_TD_censor.1D \
		-num_stimts 13 \
		-stim_file 1 ${WD}/${s}/gPPI_${ROI}_T.1D -stim_label 1 gPPI_Target \
		-stim_file 2 ${WD}/${s}/gPPI_${ROI}_D.1D -stim_label 2 gPPI_Distractor \
		-stim_file 3 ${WD}/${s}/stim_${ROI}_T_gam.1D -stim_label 3 stim_Target \
		-stim_file 4 ${WD}/${s}/stim_${ROI}_D_gam.1D -stim_label 4 stim_Distractor \
		-stim_file 5 ${WD}/${s}/${ROI}_TS.1D -stim_label 5 ${ROI}_TS -stim_base 5 \
		-stim_file 6 ${WD}/${s}/CSF_TS.1D -stim_label 6 CSF_TS -stim_base 6 \
		-stim_file 7 ${WD}/${s}/WM_TS.1D -stim_label 7 WM_TS  -stim_base 7 \
		-stim_file 8 ${WD}/${s}/Motion_TD_runs.1D[0] -stim_label 8 motpar1 -stim_base 8 \
		-stim_file 9 ${WD}/${s}/Motion_TD_runs.1D[1] -stim_label 9 motpar2 -stim_base 9 \
		-stim_file 10 ${WD}/${s}/Motion_TD_runs.1D[2] -stim_label 10 motpar3 -stim_base 10 \
		-stim_file 11 ${WD}/${s}/Motion_TD_runs.1D[3] -stim_label 11 motpar4 -stim_base 11 \
		-stim_file 12 ${WD}/${s}/Motion_TD_runs.1D[4] -stim_label 12 motpar5 -stim_base 12 \
		-stim_file 13 ${WD}/${s}/Motion_TD_runs.1D[5] -stim_label 13 motpar6 -stim_base 13 \
		-gltsym 'SYM: +1*gPPI_Target -1*gPPI_Distractor' -glt_label 1 gPPI_${ROI}_target-distractor \
		-gltsym 'SYM: +1*stim_Target -1*stim_Distractor' -glt_label 2 stim_Target-Distractor \
		-fout \
		-rout \
		-tout \
		-bucket gPPI_${ROI}_Full_model_stats \
		-x1D gPPI_${ROI}_Full_model_design_mat \
		-x1D_stop  
		
		#sed "s/-rout/-rout -automask/g" < FSLgPPI_Full_model_stats.REML_cmd> 3dREML_FSLgPPI_Full_model_stats_cmd
		. gPPI_${ROI}_Full_model_stats.REML_cmd	
		#fi
	


	done

mkdir 1Ds
mv *.1D 1Ds

done