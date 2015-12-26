#!/bin/sh
# extract bloc/state/background TS for connectivity. Use residuals after evoke responses have been removed.


WD='/home/despoB/kaihwang/TRSE/TDSigEI'
SCRIPT='/home/despoB/kaihwang/TRSE/TDSigEI/Scripts'
TRrange=(3..101 105..203 207..305 309..407) #skip initials

cd $WD
for s in 503; do
	cd ${WD}/${s}/


	for condition in FH Fo Fp HF Ho Hp; do

		cat ${SCRIPT}/${s}_run_order | grep "${condition}" >  ${SCRIPT}/${s}_${condition}_motormapping_order
		
		for ROI in FFA PPA RH LH PrimVis; do

			for motormapping in 1 2; do

				r=1
				for run in $(cat ${SCRIPT}/${s}_${condition}_motormapping_order | grep -n "${condition},${motormapping}" | cut -f1 -d:); do
					#3dmaskave -q -mask subject_mask.nii.gz ${s}_FIR_${condition}_errts.nii.gz[${TRrange[$(($run-1))]}] > gs.1D

					3dmaskave -mask ${ROI}_indiv_ROI.nii.gz -q \
					${s}_FIR_${condition}_errts.nii.gz[${TRrange[$(($run-1))]}] > ${WD}/SC_1Ds/${s}_FIRReg_${ROI}_${condition}_motor${motormapping}_run${r}.1D

					3dmaskave -mask ${ROI}_indiv_ROI.nii.gz -q \
					${s}_nusiance_${condition}_errts.nii.gz[${TRrange[$(($run-1))]}] > ${WD}/SC_1Ds/${s}_NuisanceReg_${ROI}_${condition}_motor${motormapping}_run${r}.1D

					r=$(($r+1))
				done

			done	
		done
	done
done
 #$(ls -d 5*)
 #-ort gs.1D
