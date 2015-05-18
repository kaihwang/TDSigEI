#!/bin/bash


WD='/home/despoB/kaihwang/TDSigEI'

for s in P001; do

	cd ${WD}/${s}/run1

	if [ ! -e ${WD}/${s}/run1/nswdktm_functional_6.nii.gz ]; then
		
		preprocessFunctional \
		-cleanup \
		-despike \
		-mprage_bet ${WD}/${s}/MPRAGE/mprage_bet.nii.gz \
		-tr 1.5 \
		-threshold 98_2 \
		-rescaling_method 100_voxelmean \
		-template_brain MNI_2mm \
		-func_struc_dof bbr \
		-warp_interpolation spline \
		-no_hp \
		-smoothing_kernel 6 \
		-warpcoef ${WD}/${s}/MPRAGE/mprage_warpcoef.nii.gz \
		-delete_dicom archive \
		-slice_acquisition seqdesc \
		-dicom "IM*"
	fi
	


done
