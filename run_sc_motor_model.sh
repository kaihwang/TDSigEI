#!/bin/sh
# extract bloc/state/background TS for connectivity. Use residuals after evoke responses have been removed.


WD='/home/despoB/kaihwang/TRSE/TDSigEI'
SCRIPT='/home/despoB/kaihwang/TRSE/TDSigEI/Scripts'
TRrange=(0..101 102..203 204..305 306..407)

cd $WD
for s in 503; do
	cd ${WD}/${s}/
	# rm ${s}_RH*
	# rm ${s}_LH*
	
	# #extract seed TS and runs separated by motmor mapping
	# #FH HF Fo Ho Fp Hp
	# for condition in FH HF Fo Ho Fp Hp; do
	# 	rm ${s}_FIR_${condition}_motor*

	# 	cat ${SCRIPT}/${s}_run_order | grep "${condition}" >  ${SCRIPT}/${s}tmp

	# 	for motormapping in 1 2; do
		
	# 		r=1
	# 		for run in $(cat ${SCRIPT}/${s}tmp | grep -n "${condition},${motormapping}" | cut -f1 -d:); do
	# 			for ROI in RH LH; do

	# 				#3dmaskave -q -mask subject_mask.nii.gz ${s}_FIR_${condition}_errts.nii.gz[${TRrange[$(($run-1))]}] > gs.1D
	# 				3dmaskave -mask ${ROI}_indiv_ROI.nii.gz -q \
	# 				${s}_FIR_${condition}_errts.nii.gz[${TRrange[$(($run-1))]}] > ${WD}/${s}/${ROI}_${condition}_motor${motormapping}_run${r}.1D
	# 			done
			
	# 			3dTcat -prefix ${s}_FIR_${condition}_motor${motormapping}_run${r}_errts.nii.gz \
	# 			${s}_FIR_${condition}_errts.nii.gz[${TRrange[$(($run-1))]}]

	# 			1d_tool.py -select_rows "${TRrange[$(($run-1))]}" -infile ${WD}/${s}/1Ds/${s}_${condition}_censor.1D -overwrite \
	# 			-write censor_${condition}_motor${motormapping}_run${r}.1D
				
	# 			r=$(($r+1))	
	# 		done	
	# 	done
	# done


	# #create seed TS and functional data reorganized by motor mapping and condition
	# #motor mapping:
	# #Motor1 RH-F, LH-H
	# #Motor2 RH-H, LH-F

	# #TD
	# cat RH_FH_motor1_run1.1D RH_FH_motor1_run2.1D RH_HF_motor2_run1.1D RH_HF_motor2_run2.1D > RH_TD_seedTS.1D
	# 3dTcat -prefix ${s}_RH_TD_errts.nii.gz \
	# ${s}_FIR_FH_motor1_run1_errts.nii.gz \
	# ${s}_FIR_FH_motor1_run2_errts.nii.gz \
	# ${s}_FIR_HF_motor2_run1_errts.nii.gz \
	# ${s}_FIR_HF_motor2_run2_errts.nii.gz

	# cat LH_HF_motor1_run1.1D LH_HF_motor1_run2.1D LH_FH_motor2_run1.1D LH_FH_motor2_run2.1D > LH_TD_seedTS.1D
	# 3dTcat -prefix ${s}_LH_TD_errts.nii.gz \
	# ${s}_FIR_HF_motor1_run1_errts.nii.gz \
	# ${s}_FIR_HF_motor1_run2_errts.nii.gz \
	# ${s}_FIR_FH_motor2_run1_errts.nii.gz \
	# ${s}_FIR_FH_motor2_run2_errts.nii.gz

	# #To
	# cat RH_Fo_motor1_run1.1D RH_Fo_motor1_run2.1D RH_Ho_motor2_run1.1D RH_Ho_motor2_run2.1D > RH_To_seedTS.1D
	# 3dTcat -prefix ${s}_RH_To_errts.nii.gz \
	# ${s}_FIR_Fo_motor1_run1_errts.nii.gz \
	# ${s}_FIR_Fo_motor1_run2_errts.nii.gz \
	# ${s}_FIR_Ho_motor2_run1_errts.nii.gz \
	# ${s}_FIR_Ho_motor2_run2_errts.nii.gz

	# cat LH_Ho_motor1_run1.1D LH_Ho_motor1_run2.1D LH_Fo_motor2_run1.1D LH_Fo_motor2_run2.1D > LH_To_seedTS.1D
	# 3dTcat -prefix ${s}_LH_To_errts.nii.gz \
	# ${s}_FIR_Ho_motor1_run1_errts.nii.gz \
	# ${s}_FIR_Ho_motor1_run2_errts.nii.gz \
	# ${s}_FIR_Fo_motor2_run1_errts.nii.gz \
	# ${s}_FIR_Fo_motor2_run2_errts.nii.gz

	# #P
	# cat RH_Fp_motor1_run1.1D RH_Fp_motor1_run2.1D RH_Hp_motor2_run1.1D RH_Hp_motor2_run2.1D > RH_P_seedTS.1D
	# 3dTcat -prefix ${s}_RH_P_errts.nii.gz \
	# ${s}_FIR_Fp_motor1_run1_errts.nii.gz \
	# ${s}_FIR_Fp_motor1_run2_errts.nii.gz \
	# ${s}_FIR_Hp_motor2_run1_errts.nii.gz \
	# ${s}_FIR_Hp_motor2_run2_errts.nii.gz

	# cat LH_Hp_motor1_run1.1D LH_Hp_motor1_run2.1D LH_Fp_motor2_run1.1D LH_Fp_motor2_run2.1D > LH_P_seedTS.1D
	# 3dTcat -prefix ${s}_LH_P_errts.nii.gz \
	# ${s}_FIR_Hp_motor1_run1_errts.nii.gz \
	# ${s}_FIR_Hp_motor1_run2_errts.nii.gz \
	# ${s}_FIR_Fp_motor2_run1_errts.nii.gz \
	# ${s}_FIR_Fp_motor2_run2_errts.nii.gz

	# #D
	# cat RH_HF_motor1_run1.1D RH_HF_motor1_run2.1D RH_FH_motor2_run1.1D RH_FH_motor2_run2.1D > RH_D_seedTS.1D
	# 3dTcat -prefix ${s}_RH_D_errts.nii.gz \
	# ${s}_FIR_HF_motor1_run1_errts.nii.gz \
	# ${s}_FIR_HF_motor1_run2_errts.nii.gz \
	# ${s}_FIR_FH_motor2_run1_errts.nii.gz \
	# ${s}_FIR_FH_motor2_run2_errts.nii.gz

	# cat LH_FH_motor1_run1.1D LH_FH_motor1_run2.1D LH_HF_motor2_run1.1D LH_HF_motor2_run2.1D > LH_D_seedTS.1D
	# 3dTcat -prefix ${s}_LH_D_errts.nii.gz \
	# ${s}_FIR_FH_motor1_run1_errts.nii.gz \
	# ${s}_FIR_FH_motor1_run2_errts.nii.gz \
	# ${s}_FIR_HF_motor2_run1_errts.nii.gz \
	# ${s}_FIR_HF_motor2_run2_errts.nii.gz

	# #concate censor files
	# cat censor_FH_motor1_run1.1D censor_FH_motor1_run2.1D censor_HF_motor2_run1.1D censor_HF_motor2_run2.1D > censor_RH_TD.1D
	# cat censor_HF_motor1_run1.1D censor_HF_motor1_run2.1D censor_FH_motor2_run1.1D censor_FH_motor2_run2.1D > censor_LH_TD.1D

	# cat censor_Fo_motor1_run1.1D censor_Fo_motor1_run2.1D censor_Ho_motor2_run1.1D censor_Ho_motor2_run2.1D > censor_RH_To.1D
	# cat censor_Ho_motor1_run1.1D censor_Ho_motor1_run2.1D censor_Fo_motor2_run1.1D censor_Fo_motor2_run2.1D > censor_LH_To.1D

	# cat censor_Fp_motor1_run1.1D censor_Fp_motor1_run2.1D censor_Hp_motor2_run1.1D censor_Hp_motor2_run2.1D > censor_RH_P.1D
	# cat censor_Hp_motor1_run1.1D censor_Hp_motor1_run2.1D censor_Fp_motor2_run1.1D censor_Fp_motor2_run2.1D > censor_LH_P.1D

	# cat censor_HF_motor1_run1.1D censor_HF_motor1_run2.1D censor_FH_motor2_run1.1D censor_FH_motor2_run2.1D > censor_RH_D.1D
	# cat censor_FH_motor1_run1.1D censor_FH_motor1_run2.1D censor_HF_motor2_run1.1D censor_HF_motor2_run2.1D > censor_LH_D.1D

	# #remove tmp concat files
	# for condition in FH HF Fo Ho Fp Hp; do
	# 	rm ${s}_FIR_${condition}_motor*
	# done


	# seed con
	# for condition in TD To P D; do
	
	# 	for ROI in RH LH; do

	# 		rm seedcon_${ROI}_${condition}_stats*
	# 		# run FIR + motor response model to extract residuals
	# 		3dDeconvolve -input ${s}_${ROI}_${condition}_errts.nii.gz \
	# 		-mask ${WD}/ROIs/100overlap_mask+tlrc \
	# 		-polort A \
	# 		-num_stimts 1 \
	# 		-censor censor_${ROI}_${condition}.1D \
	# 		-stim_file 1 ${ROI}_${condition}_seedTS.1D -stim_label 1 ${ROI}_seedTS \
	# 		-fout \
	# 		-rout \
	# 		-tout \
	# 		-bucket seedcon_${ROI}_${condition}_stats \
	# 		-GOFORIT 100 \
	# 		-noFDR 

	# 		rm Corrcoef_seed${ROI}_${condition}*
	# 		3dcalc -a seedcon_${ROI}_${condition}_stats+tlrc[4] \
	# 		-b seedcon_${ROI}_${condition}_stats+tlrc[2] \
	# 		-expr 'ispositive(b)*sqrt(a)-isnegative(b)*sqrt(a)' \
	# 		-prefix Corrcoef_seed${ROI}_${condition}
	# 	done
	# done

	#seedcon with tha regression
	for condition in TD To P D; do
	
		for ROI in RH LH; do

			3dROIstats -mask ${WD}/Group/thalamus_atlas.nii.gz -quiet \
			${s}_${ROI}_${condition}_errts.nii.gz > 1Ds/Tha_${ROI}_${condition}_seedTS.1D

			rm seedcon_${ROI}_${condition}_thareg_stats*
			# run FIR + motor response model to extract residuals
			3dDeconvolve -input ${s}_${ROI}_${condition}_errts.nii.gz \
			-mask ${WD}/ROIs/100overlap_mask+tlrc \
			-polort A \
			-num_stimts 8 \
			-censor 1Ds/censor_${ROI}_${condition}.1D \
			-stim_file 1 1Ds/${ROI}_${condition}_seedTS.1D -stim_label 1 ${ROI}_seedTS \
			-stim_file 2 1Ds/Tha_${ROI}_${condition}_seedTS.1D[0] -stim_label 2 Tha_seedTS0 -stim_base 2 \
			-stim_file 3 1Ds/Tha_${ROI}_${condition}_seedTS.1D[1] -stim_label 3 Tha_seedTS1 -stim_base 3 \
			-stim_file 4 1Ds/Tha_${ROI}_${condition}_seedTS.1D[2] -stim_label 4 Tha_seedTS2 -stim_base 4 \
			-stim_file 5 1Ds/Tha_${ROI}_${condition}_seedTS.1D[3] -stim_label 5 Tha_seedTS3 -stim_base 5 \
			-stim_file 6 1Ds/Tha_${ROI}_${condition}_seedTS.1D[4] -stim_label 6 Tha_seedTS4 -stim_base 6 \
			-stim_file 7 1Ds/Tha_${ROI}_${condition}_seedTS.1D[5] -stim_label 7 Tha_seedTS5 -stim_base 7 \
			-stim_file 8 1Ds/Tha_${ROI}_${condition}_seedTS.1D[6] -stim_label 8 Tha_seedTS6 -stim_base 8 \
			-fout \
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
	#mv *.1D 1Ds
done

