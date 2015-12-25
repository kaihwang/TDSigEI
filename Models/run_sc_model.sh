#!/bin/bash
# script to run seed correlation


WD='/home/despoB/kaihwang/TRSE/TDSigEI'
SCRIPTS='/home/despoB/kaihwang/TRSE/TDSigEI/Scripts'
#503 505 508 509 510 512 513 516 517 518 519 523 527 528 529 530 532 534 531
# 510

for s in 503; do
	cd ${WD}/${s}


	for condition in FH HF Fo Ho Fp Hp; do
	
		for ROI in FFA PPA; do

			# extract seed signal
			3dmaskave -mask ${ROI}_indiv_ROI.nii.gz -q \
			${s}_FIR_${condition}_errts.nii.gz > 1Ds/${ROI}_${condition}_seedTS.1D

			#3dmaskave -q -mask subject_mask.nii.gz \
			#${s}_FIR_${condition}_errts.nii.gz > gs.1D

			# rm seedcon_${ROI}_${condition}_stats*
			# # run FIR + motor response model to extract residuals
			# 3dDeconvolve -input ${s}_FIR_${condition}_errts.nii.gz \
			# -mask ${WD}/ROIs/100overlap_mask+tlrc \
			# -polort A \
			# -num_stimts 1 \
			# -censor ${WD}/${s}/1Ds/${s}_${condition}_censor.1D \
			# -stim_file 1 ${ROI}_${condition}_seedTS.1D -stim_label 1 ${ROI}_seedTS \
			# -fout \
			# -rout \
			# -tout \
			# -bucket seedcon_${ROI}_${condition}_stats \
			# -GOFORIT 100 \
			# -noFDR 

			# rm Corrcoef_seed${ROI}_${condition}*
			# 3dcalc -a seedcon_${ROI}_${condition}_stats+tlrc[4] \
			# -b seedcon_${ROI}_${condition}_stats+tlrc[2] \
			# -expr 'ispositive(b)*sqrt(a)-isnegative(b)*sqrt(a)' \
			# -prefix Corrcoef_seed${ROI}_${condition}
		

			# extract tha ts
			3dROIstats -mask ${WD}/Group/thalamus_atlas.nii.gz -quiet \
			${s}_FIR_${condition}_errts.nii.gz > 1Ds/Tha_${condition}_seedTS.1D
			
			rm seedcon_${ROI}_${condition}_thareg_stats*
			# run FIR + motor response model to extract residuals
			3dDeconvolve -input ${s}_FIR_${condition}_errts.nii.gz \
			-mask ${WD}/ROIs/100overlap_mask+tlrc \
			-polort A \
			-num_stimts 8 \
			-censor ${WD}/${s}/1Ds/${s}_${condition}_censor.1D \
			-stim_file 1 1Ds/${ROI}_${condition}_seedTS.1D -stim_label 1 ${ROI}_seedTS \
			-stim_file 2 1Ds/Tha_${condition}_seedTS.1D[0] -stim_label 2 Tha_seedTS0 -stim_base 2 \
			-stim_file 3 1Ds/Tha_${condition}_seedTS.1D[1] -stim_label 3 Tha_seedTS1 -stim_base 3 \
			-stim_file 4 1Ds/Tha_${condition}_seedTS.1D[2] -stim_label 4 Tha_seedTS2 -stim_base 4 \
			-stim_file 5 1Ds/Tha_${condition}_seedTS.1D[3] -stim_label 5 Tha_seedTS3 -stim_base 5 \
			-stim_file 6 1Ds/Tha_${condition}_seedTS.1D[4] -stim_label 6 Tha_seedTS4 -stim_base 6 \
			-stim_file 7 1Ds/Tha_${condition}_seedTS.1D[5] -stim_label 7 Tha_seedTS5 -stim_base 7 \
			-stim_file 8 1Ds/Tha_${condition}_seedTS.1D[6] -stim_label 8 Tha_seedTS6 -stim_base 8 \
			-fout \
			-rout \
			-tout \
			-bucket seedcon_${ROI}_${condition}_thareg_stats \
			-GOFORIT 100 \
			-noFDR 

			rm Corrcoef_seed${ROI}_${condition}_thareg*
			3dcalc -a seedcon_${ROI}_${condition}_thareg_stats+tlrc[4] \
			-b seedcon_${ROI}_${condition}_thareg_stats+tlrc[2] \
			-expr 'ispositive(b)*sqrt(a)-isnegative(b)*sqrt(a)' \
			-prefix Corrcoef_seed${ROI}_${condition}_thareg


		done
	done
done


