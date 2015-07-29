#!/bin/bash
# extract FIR timecourse for each condition from fROIs

WD='/home/despoB/kaihwang/TRSE/TDSigEI'
cd $WD


for s in $(ls -d 5*); do
	cd ${WD}/${s}

	for ROI in PPA FFA; do
		for condition in FH Fo Fp HF Ho Hp; do
			3dmaskave -mask ${ROI}masked.nii.gz -q ${condition}_FIR+tlrc > ${WD}/FIR_1Ds/${s}_${ROI}_${condition}.1D
		done
	done	


done
#${ROI}_indiv_ROI+tlrc