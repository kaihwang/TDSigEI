#!/bin/bash
# script to run seed correlation


WD='/home/despoB/kaihwang/TRSE/TDSigEI'
SCRIPTS='/home/despoB/kaihwang/TRSE/TDSigEI/Scripts'
#503 505 508 509 510 512 513 516 517 518 519 523 527 528 529 530 532 534 531
# 510

for s in 503 505 508 509 510 512 513 516 517 518 519 523 527 528 529 530 532 534 531; do
	cd ${WD}/${s}


	for condition in FH HF Fo Ho Fp Hp; do
	
		for ROI in FFA PPA; do

			# extract seed signal
			3dmaskSVD -mask ${ROI}_indiv_ROI.nii.gz -vnorm -polort 1 \
			-input ${s}_FIR_${condition}_errts.nii.gz > ${ROI}_${condition}_seedTS.1D


			# run FIR + motor response model to extract residuals
			3dDeconvolve -input ${s}_FIR_${condition}_errts.nii.gz \
			-mask ${WD}/ROIs/100overlap_mask+tlrc \
			-polort A \
			-num_stimts 1 \
			-censor ${WD}/${s}/1Ds/${s}_${condition}_censor.1D \
			-stim_file 1 ${ROI}_${condition}_seedTS.1D -stim_label 1 ${ROI}_seedTS \
			-fout \
			-rout \
			-tout \
			-bucket seedcon_${ROI}_${condition}_stats \
			-GOFORIT 100 \
			-noFDR 

			3dcalc -a seedcon_${ROI}_${condition}_stats+tlrc[4] \
			-b seedcon_${ROI}_${condition}_stats+tlrc[2] \
			-expr 'ispositive(b)*sqrt(a)-isnegative(b)*sqrt(a)' \
			-prefix Corrcoef_seed${ROI}_${condition}
		done


	done

done


