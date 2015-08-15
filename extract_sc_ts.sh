#!/bin/sh
# extract bloc/state/background TS for connectivity. Use residuals after evoke responses have been removed.


WD='/home/despoB/kaihwang/TRSE/TDSigEI'
SCRIPT='/home/despoB/kaihwang/TRSE/TDSigEI/Scripts'
TRrange=(0..101 102..203 204..305 306..407)

cd $WD
for s in 503; do
	cd ${WD}/${s}/


	for condition in FH Fo Fp HF Ho Hp; do

		cat ${SCRIPT}/${s}_run_order | grep "${condition}" >  ${SCRIPT}/${s}tmp
		
		for ROI in FFA PPA RH LH; do

			for motormapping in 1 2; do

				r=1
				for run in $(cat ${SCRIPT}/${s}tmp | grep -n "${condition},${motormapping}" | cut -f1 -d:); do
					3dmaskSVD -mask ${ROI}masked.nii.gz -vnorm -polort 2 \
					-input ${s}_FIR_${condition}_errts.nii.gz[${TRrange[$(($run-1))]}] > ${WD}/SC_1Ds/${s}_${ROI}_${condition}_motor${motormapping}_run${r}.1D
					r=$(($r+1))
				done

			done	
		done
	done
done
 #$(ls -d 5*)