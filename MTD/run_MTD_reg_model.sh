# script to run MTD regression model


WD='/home/despoB/kaihwang/TRSE/TDSigEI'
SCRIPT='/home/despoB/kaihwang/TRSE/TDSigEI/Scripts'
MTD='/home/despoB/kaihwang/bin/TDSigEI/MTD'
TRrange=(3..101 105..203 207..305 309..407) #skip initials

cd $WD
for s in 503; do

	mkdir /tmp/${s}

	cd /tmp/${s}/

	#nusiance

	for dset in nusiance FIR; do

		for condition in FH Fo Fp HF Ho Hp; do  # 

			cat ${SCRIPT}/${s}_run_order | grep "${condition}" >  /tmp/${s}/${s}_${condition}_motormapping_order


			## do visual coupling
			# save TS
			for run in 1 2 3 4; do

				3dmaskave -mask ${WD}/${s}/FFA_indiv_ROI.nii.gz -q \
				${WD}/${s}/${s}_${dset}_${condition}_errts.nii.gz[${TRrange[$(($run-1))]}] > /tmp/${s}/${dset}_Reg_${condition}_FFA_run${run}.1D

				3dmaskave -mask ${WD}/${s}/PPA_indiv_ROI.nii.gz -q \
				${WD}/${s}/${s}_${dset}_${condition}_errts.nii.gz[${TRrange[$(($run-1))]}] > /tmp/${s}/${dset}_Reg_${condition}_PPA_run${run}.1D

				3dmaskave -mask ${WD}/${s}/PrimVis_indiv_ROI.nii.gz -q \
				${WD}/${s}/${s}_${dset}_${condition}_errts.nii.gz[${TRrange[$(($run-1))]}] > /tmp/${s}/${dset}_Reg_${condition}_VC_run${run}.1D

				echo "/tmp/${s}/${dset}_Reg_${condition}_FFA_run${run}.1D /tmp/${s}/${dset}_Reg_${condition}_VC_run${run}.1D /tmp/${s}/${dset}_Reg_${condition}_run${run}_VC-FFA.1D" | python ${MTD}/run_MTD.py
				echo "/tmp/${s}/${dset}_Reg_${condition}_PPA_run${run}.1D /tmp/${s}/${dset}_Reg_${condition}_VC_run${run}.1D /tmp/${s}/${dset}_Reg_${condition}_run${run}_VC-PPA.1D" | python ${MTD}/run_MTD.py

				#save temp nii output
				3dTcat -prefix /tmp/${s}/${dset}_Reg_${condition}_errts_run${run}.nii.gz ${WD}/${s}/${s}_${dset}_${condition}_errts.nii.gz[${TRrange[$(($run-1))]}]
			done

			#concat TS
			cat $(ls /tmp/${s}/${dset}_Reg_${condition}_run*_VC-FFA.1D | sort -V) > /tmp/${s}/${dset}_Reg_FFA-VC_${condition}_runs.1D	
			cat $(ls /tmp/${s}/${dset}_Reg_${condition}_run*_VC-PPA.1D | sort -V) > /tmp/${s}/${dset}_Reg_PPA-VC_${condition}_runs.1D	
			

			# run model
			for ROI in FFA PPA; do
				3dDeconvolve \
				-input /tmp/${s}/${dset}_Reg_${condition}_errts_run1.nii.gz[6..94] \
				/tmp/${s}/${dset}_Reg_${condition}_errts_run2.nii.gz[6..94] \
				/tmp/${s}/${dset}_Reg_${condition}_errts_run3.nii.gz[6..94] \
				/tmp/${s}/${dset}_Reg_${condition}_errts_run4.nii.gz[6..94] \
				-mask ${WD}/ROIs/100overlap_mask+tlrc \
				-polort A \
				-num_stimts 1 \
				-stim_file 1 /tmp/${s}/${dset}_Reg_${ROI}-VC_${condition}_runs.1D -stim_label 1 ${condition}_${ROI}-VC \
				-fout \
				-rout \
				-tout \
				-bucket /tmp/${s}/MTD_${dset}Reg_${condition}_${ROI}-VC_stats \
				-GOFORIT 100 \
				-noFDR

				. /tmp/${s}/MTD_${dset}Reg_${condition}_${ROI}-VC_stats.REML_cmd
			done

		
			## do motor coupling

			for motormapping in 1 2; do
			#motor mapping 1, RH-Face LH-Scene
			#motor mapping 2, RH-Scene, LH-Face	
			
				r=1
				for run in $(cat /tmp/${s}/${s}_${condition}_motormapping_order | grep -n "${condition},${motormapping}" | cut -f1 -d:); do
					#extract TS
					3dmaskave -mask ${WD}/${s}/FFA_indiv_ROI.nii.gz -q \
					${WD}/${s}/${s}_${dset}_${condition}_errts.nii.gz[${TRrange[$(($run-1))]}] > /tmp/${s}/${dset}_Reg_${condition}_FFA_motor${motormapping}_run${r}.1D
					3dmaskave -mask ${WD}/${s}/PPA_indiv_ROI.nii.gz -q \
					${WD}/${s}/${s}_${dset}_${condition}_errts.nii.gz[${TRrange[$(($run-1))]}] > /tmp/${s}/${dset}_Reg_${condition}_PPA_motor${motormapping}_run${r}.1D
					3dmaskave -mask ${WD}/${s}/RH_indiv_ROI.nii.gz -q \
					${WD}/${s}/${s}_${dset}_${condition}_errts.nii.gz[${TRrange[$(($run-1))]}] > /tmp/${s}/${dset}_Reg_${condition}_RH_motor${motormapping}_run${r}.1D
					3dmaskave -mask ${WD}/${s}/LH_indiv_ROI.nii.gz -q \
					${WD}/${s}/${s}_${dset}_${condition}_errts.nii.gz[${TRrange[$(($run-1))]}] > /tmp/${s}/${dset}_Reg_${condition}_LH_motor${motormapping}_run${r}.1D

					#MTD
					echo "/tmp/${s}/${dset}_Reg_${condition}_FFA_motor${motormapping}_run${r}.1D /tmp/${s}/${dset}_Reg_${condition}_RH_motor${motormapping}_run${r}.1D /tmp/${s}/${dset}_Reg_${condition}_motor${motormapping}_run${r}_FFA-RH.1D" | python ${MTD}/run_MTD.py
					echo "/tmp/${s}/${dset}_Reg_${condition}_FFA_motor${motormapping}_run${r}.1D /tmp/${s}/${dset}_Reg_${condition}_LH_motor${motormapping}_run${r}.1D /tmp/${s}/${dset}_Reg_${condition}_motor${motormapping}_run${r}_FFA-LH.1D" | python ${MTD}/run_MTD.py
					echo "/tmp/${s}/${dset}_Reg_${condition}_PPA_motor${motormapping}_run${r}.1D /tmp/${s}/${dset}_Reg_${condition}_RH_motor${motormapping}_run${r}.1D /tmp/${s}/${dset}_Reg_${condition}_motor${motormapping}_run${r}_PPA-RH.1D" | python ${MTD}/run_MTD.py
					echo "/tmp/${s}/${dset}_Reg_${condition}_PPA_motor${motormapping}_run${r}.1D /tmp/${s}/${dset}_Reg_${condition}_LH_motor${motormapping}_run${r}.1D /tmp/${s}/${dset}_Reg_${condition}_motor${motormapping}_run${r}_PPA-LH.1D" | python ${MTD}/run_MTD.py

					3dTcat -prefix /tmp/${s}/${dset}_Reg_${condition}_motor${motormapping}_errts_run${r}.nii.gz \
					${WD}/${s}/${s}_${dset}_${condition}_errts.nii.gz[${TRrange[$(($run-1))]}]

					r=$(($r+1))
				done
			done
				
			#concat
			#FFA-M
			cat /tmp/${s}/${dset}_Reg_${condition}_motor1_run1_FFA-RH.1D /tmp/${s}/${dset}_Reg_${condition}_motor1_run2_FFA-RH.1D /tmp/${s}/${dset}_Reg_${condition}_motor2_run1_FFA-LH.1D /tmp/${s}/${dset}_Reg_${condition}_motor2_run2_FFA-LH.1D > /tmp/${s}/${dset}_Reg_${condition}_FFA-M.1D
			#FFA-NM
			cat /tmp/${s}/${dset}_Reg_${condition}_motor1_run1_FFA-LH.1D /tmp/${s}/${dset}_Reg_${condition}_motor1_run2_FFA-LH.1D /tmp/${s}/${dset}_Reg_${condition}_motor2_run1_FFA-RH.1D /tmp/${s}/${dset}_Reg_${condition}_motor2_run2_FFA-RH.1D > /tmp/${s}/${dset}_Reg_${condition}_FFA-NM.1D
			
			#PPA-M
			cat /tmp/${s}/${dset}_Reg_${condition}_motor1_run1_PPA-LH.1D /tmp/${s}/${dset}_Reg_${condition}_motor1_run2_PPA-LH.1D /tmp/${s}/${dset}_Reg_${condition}_motor2_run1_PPA-RH.1D /tmp/${s}/${dset}_Reg_${condition}_motor2_run2_PPA-RH.1D > /tmp/${s}/${dset}_Reg_${condition}_PPA-M.1D
			#PPA-NM
			cat /tmp/${s}/${dset}_Reg_${condition}_motor1_run1_PPA-RH.1D /tmp/${s}/${dset}_Reg_${condition}_motor1_run2_PPA-RH.1D /tmp/${s}/${dset}_Reg_${condition}_motor2_run1_PPA-LH.1D /tmp/${s}/${dset}_Reg_${condition}_motor2_run2_PPA-LH.1D > /tmp/${s}/${dset}_Reg_${condition}_PPA-NM.1D
				

			# run model
			for cond in FFA-M FFA-NM PPA-M PPA-NM; do

				3dDeconvolve \
				-input /tmp/${s}/${dset}_Reg_${condition}_motor1_errts_run1.nii.gz[6..94] \
				/tmp/${s}/${dset}_Reg_${condition}_motor1_errts_run2.nii.gz[6..94] \
				/tmp/${s}/${dset}_Reg_${condition}_motor2_errts_run1.nii.gz[6..94] \
				/tmp/${s}/${dset}_Reg_${condition}_motor2_errts_run2.nii.gz[6..94] \
				-mask ${WD}/ROIs/100overlap_mask+tlrc \
				-polort A \
				-num_stimts 1 \
				-stim_file 1 /tmp/${s}/${dset}_Reg_${condition}_${cond}.1D -stim_label 1 ${condition}_${cond} \
				-fout \
				-rout \
				-tout \
				-bucket /tmp/${s}/MTD_${dset}Reg_${condition}_${cond}_stats \
				-GOFORIT 100 \
				-noFDR

				. /tmp/${s}/MTD_${dset}Reg_${condition}_${cond}_stats.REML_cmd
			done
		done
	done

	mv /tmp/${s}/MTD* ${WD}/${s}
	cd ${WD}/${s} 
	rm -rf /tmp/${s}/
done


