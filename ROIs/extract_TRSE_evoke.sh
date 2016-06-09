#!/bin/bash
# extract FIR timecourse for each condition from fROIs

WD='/home/despoB/kaihwang/TRSE/TRSEPPI/AllSubjs'
cd $WD


for s in $(/bin/ls -d *); do
	cd ${WD}/${s}

	#indiv ROIs
	for ROI in PPA FFA V1; do
		for condition in categorize_face categorize_scene relevant_face relevant_scene irrelevant_face irrelevant_scene both_face both_scene; do
			3dmaskave -mask ${ROI}_indiv_ROI.nii.gz -q ${condition}_FIR+tlrc > /home/despoB/kaihwang/TRSE/TRSEPPI/Group/FIR_1Ds/${s}_${ROI}_${condition}.1D
			#3dmaskSVD -mask ${ROI}masked.nii.gz \
			#-input ${condition}_FIR+tlrc > ${WD}/FIR_1Ds/${s}_${ROI}_${condition}.1D 
		done
	done	

	#group ROIs

	for condition in categorize_face categorize_scene relevant_face relevant_scene irrelevant_face irrelevant_scene both_face both_scene; do
		3dmaskave -mask /home/despoB/kaihwang/TRSE/TDSigEI/ROIs/DLPFC_MTD_TD.nii.gz -q ${condition}_FIR+tlrc > /home/despoB/kaihwang/TRSE/TRSEPPI/Group/FIR_1Ds/${s}_MFG_${condition}.1D
		3dmaskave -mask /home/despoB/kaihwang/TRSE/TDSigEI/ROIs/FEF_BC.nii.gz -q ${condition}_FIR+tlrc > /home/despoB/kaihwang/TRSE/TRSEPPI/Group/FIR_1Ds/${s}_FEF_${condition}.1D
		3dmaskave -mask /home/despoB/kaihwang/TRSE/TDSigEI/Group/RIFJ.nii.gz -q ${condition}_FIR+tlrc > /home/despoB/kaihwang/TRSE/TRSEPPI/Group/FIR_1Ds/${s}_RIFJ_${condition}.1D
		3dmaskave -mask /home/despoB/kaihwang/TRSE/TDSigEI/Group/LMFG.nii.gz -q ${condition}_FIR+tlrc > /home/despoB/kaihwang/TRSE/TRSEPPI/Group/FIR_1Ds/${s}_LMFG_${condition}.1D
		#3dmaskSVD -mask ${ROI}masked.nii.gz \
		#-input ${condition}_FIR+tlrc > ${WD}/FIR_1Ds/${s}_${ROI}_${condition}.1D 
	done


done
