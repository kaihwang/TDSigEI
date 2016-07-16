#!/bin/bash
# extract FIR timecourse for each condition from fROIs

WD='/home/despoB/kaihwang/TRSE/TDSigEI'
cd $WD


for s in $(/bin/ls -d 5*); do
	cd ${WD}/${s}

	#indiv ROIs
	for ROI in PPA FFA V1; do
		for condition in FH Fo Fp HF Ho Hp; do
			3dmaskave -mask ${ROI}_indiv_ROI.nii.gz -q ${condition}_FIR+tlrc > ${WD}/FIR_1Ds/${s}_${ROI}_${condition}.1D
			#3dmaskSVD -mask ${ROI}masked.nii.gz \
			#-input ${condition}_FIR+tlrc > ${WD}/FIR_1Ds/${s}_${ROI}_${condition}.1D 
		done
	done	

	#group ROIs

	for condition in FH Fo Fp HF Ho Hp; do
		3dmaskave -mask ${WD}/ROIs/DLPFC_MTD_TD.nii.gz -q ${condition}_FIR+tlrc > ${WD}/FIR_1Ds/${s}_MFG_${condition}.1D
		3dmaskave -mask ${WD}/ROIs/FEF_BC.nii.gz -q ${condition}_FIR+tlrc > ${WD}/FIR_1Ds/${s}_FEF_${condition}.1D
		#3dmaskave -mask ${WD}/ROIs/FEF_BC.nii.gz -q ${condition}_FIR+tlrc > ${WD}/FIR_1Ds/${s}_FEF_${condition}.1D
		#3dmaskSVD -mask ${ROI}masked.nii.gz \
		#-input ${condition}_FIR+tlrc > ${WD}/FIR_1Ds/${s}_${ROI}_${condition}.1D 
	done


done
#${ROI}_indiv_ROI+tlrc
