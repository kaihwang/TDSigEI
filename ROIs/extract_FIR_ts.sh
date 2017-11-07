#!/bin/bash
# extract FIR timecourse for each condition from fROIs

WD='/home/despoB/kaihwang/TRSE/TDSigEI'
cd $WD


for s in $(/bin/ls -d 5*); do
	cd ${WD}/${s}

	#indiv ROIs
	# for ROI in V1 PPA FFA; do
	# 	for condition in FH Fo Fp HF Ho Hp; do
	# 		#3dmaskave -mask ${ROI}_indiv_ROI.nii.gz -q ${condition}_FIR+tlrc > ${WD}/FIR_1Ds/${s}_${ROI}_${condition}.1D
	# 		#3dmaskSVD -mask ${ROI}masked.nii.gz \
	# 		#-input ${condition}_FIR+tlrc > ${WD}/FIR_1Ds/${s}_${ROI}_${condition}.1D 
	# 		#3dmaskave -mask ${ROI}_indiv_ROI.nii.gz -q ${condition}_FIR+tlrc[4..14] > ${WD}/FIR_1Ds/${s}_${ROI}_${condition}_peak.1D
	# 	done
	# done	

	#group ROIs

	for condition in FH Fo Fp HF Ho Hp; do
		#3dmaskave -mask ${WD}/ROIs/RIFJ.nii.gz -q ${condition}_FIR+tlrc > ${WD}/FIR_1Ds/${s}_IFJ_${condition}.1D
		#3dmaskave -mask ${WD}/ROIs/R_IPS.nii.gz -q ${condition}_FIR+tlrc > ${WD}/FIR_1Ds/${s}_IPS_${condition}.1D
		#3dmaskave -mask ${WD}/ROIs/FEF_BC.nii.gz -q ${condition}_FIR+tlrc > ${WD}/FIR_1Ds/${s}_FEF_${condition}.1D
		#3dmaskSVD -mask ${ROI}masked.nii.gz \
		3dmaskave -mask ${WD}/ROIs/MD.nii.gz -q ${condition}_FIR+tlrc > ${WD}/FIR_1Ds/${s}_MD_${condition}.1D
		3dmaskave -mask ${WD}/ROIs/AN.nii.gz -q ${condition}_FIR+tlrc > ${WD}/FIR_1Ds/${s}_AN_${condition}.1D
		3dmaskave -mask ${WD}/ROIs/VL.nii.gz -q ${condition}_FIR+tlrc > ${WD}/FIR_1Ds/${s}_VL_${condition}.1D
		3dmaskave -mask ${WD}/ROIs/Pu.nii.gz -q ${condition}_FIR+tlrc > ${WD}/FIR_1Ds/${s}_Pu_${condition}.1D	

		#-input ${condition}_FIR+tlrc > ${WD}/FIR_1Ds/${s}_${ROI}_${condition}.1D 
	done


done
#${ROI}_indiv_ROI+tlrc
