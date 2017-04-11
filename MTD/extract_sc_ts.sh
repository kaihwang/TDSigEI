# script for extracting signal for MTD and BC connectivity


WD='/home/despoB/kaihwang/TRSE/TDSigEI'
SCRIPT='/home/despoB/kaihwang/TRSE/TDSigEI/Scripts'
MTD='/home/despoB/kaihwang/bin/TDSigEI/MTD'
TRrange=(0..101 102..203 204..305 306..407)  #skip first 3 volumens for all runs because of intial transition effects in data

cd $WD
for s in 503; do

	mkdir /tmp/${s}

	cd /tmp/${s}/

	#repeat for two different datasets
	for dset in nusiance FIR; do #FIR 

		for condition in FH Fo Fp HF Ho Hp; do  # Fo Fp HF Ho Hp

			#cat ${SCRIPT}/${s}_run_order | grep "${condition}" >  /tmp/${s}/${s}_${condition}_motormapping_order

			## do visual coupling
			# save TS 
			# every TS should be 99 elements long! first 3 volumes excluded!
			for run in 1 2 3 4; do

				#save temp nii output
				3dTcat -prefix /tmp/${s}/${dset}_Reg_${condition}_errts_run${run}.nii.gz ${WD}/${s}/${s}_${dset}_${condition}_errts.nii.gz[${TRrange[$(($run-1))]}]
				
				3dmaskave -mask ${WD}/${s}/FFA_indiv_ROI.nii.gz -q \
				/tmp/${s}/${dset}_Reg_${condition}_errts_run${run}.nii.gz > /tmp/${s}/${dset}_Reg_${condition}_FFA_run${run}.1D

				3dmaskave -mask ${WD}/${s}/PPA_indiv_ROI.nii.gz -q \
				/tmp/${s}/${dset}_Reg_${condition}_errts_run${run}.nii.gz > /tmp/${s}/${dset}_Reg_${condition}_PPA_run${run}.1D

				3dmaskave -mask ${WD}/${s}/V1_indiv_ROI.nii.gz -q \
				/tmp/${s}/${dset}_Reg_${condition}_errts_run${run}.nii.gz > /tmp/${s}/${dset}_Reg_${condition}_VC_run${run}.1D

				cp /tmp/${s}/${dset}_Reg_${condition}_FFA_run${run}.1D ${WD}/${s}/1Ds
				cp /tmp/${s}/${dset}_Reg_${condition}_PPA_run${run}.1D ${WD}/${s}/1Ds
				cp /tmp/${s}/${dset}_Reg_${condition}_VC_run${run}.1D ${WD}/${s}/1Ds				

				# 3dBandpass -prefix /tmp/${s}/${dset}_BPReg_${condition}_errts_run${run}.nii.gz -input /tmp/${s}/${dset}_Reg_${condition}_errts_run${run}.nii.gz -band 0 0.1

				# 3dmaskave -mask ${WD}/${s}/FFA_indiv_ROI.nii.gz -q \
				# /tmp/${s}/${dset}_BPReg_${condition}_errts_run${run}.nii.gz > /tmp/${s}/${dset}_BPReg_${condition}_FFA_run${run}.1D

				# 3dmaskave -mask ${WD}/${s}/PPA_indiv_ROI.nii.gz -q \
				# /tmp/${s}/${dset}_BPReg_${condition}_errts_run${run}.nii.gz > /tmp/${s}/${dset}_BPReg_${condition}_PPA_run${run}.1D

				# 3dmaskave -mask ${WD}/${s}/V1_indiv_ROI.nii.gz -q \
				# /tmp/${s}/${dset}_BPReg_${condition}_errts_run${run}.nii.gz > /tmp/${s}/${dset}_BPReg_${condition}_VC_run${run}.1D

				# cp /tmp/${s}/${dset}_BPReg_${condition}_FFA_run${run}.1D ${WD}/${s}/1Ds
				# cp /tmp/${s}/${dset}_BPReg_${condition}_PPA_run${run}.1D ${WD}/${s}/1Ds
				# cp /tmp/${s}/${dset}_BPReg_${condition}_VC_run${run}.1D ${WD}/${s}/1Ds

			done
		done
	done	

	cd ${WD}/${s} 
	rm -rf /tmp/${s}/
done


