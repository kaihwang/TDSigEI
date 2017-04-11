# script to run MTD regression model


WD='/home/despoB/kaihwang/TRSE/TDSigEI'
SCRIPT='/home/despoB/kaihwang/TRSE/TDSigEI/Scripts'
MTD='/home/despoB/kaihwang/bin/TDSigEI/MTD'
TRrange=(0..101 102..203 204..305 306..407) 

cd $WD
for s in 503; do

	rm -rf /tmp/${s}/
	mkdir /tmp/${s}

	cd /tmp/${s}/

	#repeat for two different datasets
	for dset in nusiance FIR; do #FIR nusiance

		for condition in FH Fo Fp HF Ho Hp; do  # Fo Fp HF Ho Hp

			## do visual coupling
			# save TS 
			# every TS should be 99 elements long! first 3 volumes excluded!
			for run in 1 2 3 4; do

				#save temp nii output
				3dTcat -prefix /tmp/${s}/${dset}_Reg_${condition}_errts_run${run}.nii.gz ${WD}/${s}/${s}_${dset}_${condition}_errts.nii.gz[${TRrange[$(($run-1))]}]
				#3dBandpass -prefix /tmp/${s}/${dset}_BPReg_${condition}_errts_run${run}.nii.gz -input /tmp/${s}/${dset}_Reg_${condition}_errts_run${run}.nii.gz -band 0 0.1
				
				3dmaskave -mask ${WD}/${s}/FFA_indiv_ROI.nii.gz -q \
				/tmp/${s}/${dset}_Reg_${condition}_errts_run${run}.nii.gz > /tmp/${s}/${dset}_Reg_${condition}_FFA_run${run}.1D

				3dmaskave -mask ${WD}/${s}/PPA_indiv_ROI.nii.gz -q \
				/tmp/${s}/${dset}_Reg_${condition}_errts_run${run}.nii.gz > /tmp/${s}/${dset}_Reg_${condition}_PPA_run${run}.1D

				3dmaskave -mask ${WD}/${s}/V1_indiv_ROI.nii.gz -q \
				/tmp/${s}/${dset}_Reg_${condition}_errts_run${run}.nii.gz > /tmp/${s}/${dset}_Reg_${condition}_VC_run${run}.1D

				#cp /tmp/${s}/${dset}_Reg_${condition}_FFA_run${run}.1D ${WD}/${s}/1Ds
				#cp /tmp/${s}/${dset}_Reg_${condition}_PPA_run${run}.1D ${WD}/${s}/1Ds
				#cp /tmp/${s}/${dset}_Reg_${condition}_VC_run${run}.1D ${WD}/${s}/1Ds

				#loop through windows
				for w in 5 10 15; do
					echo "/tmp/${s}/${dset}_Reg_${condition}_FFA_run${run}.1D /tmp/${s}/${dset}_Reg_${condition}_VC_run${run}.1D /tmp/${s}/${dset}_Reg_w${w}_${condition}_run${run}_VC-FFA.1D ${w}" | python ${MTD}/run_MTD.py
					echo "/tmp/${s}/${dset}_Reg_${condition}_PPA_run${run}.1D /tmp/${s}/${dset}_Reg_${condition}_VC_run${run}.1D /tmp/${s}/${dset}_Reg_w${w}_${condition}_run${run}_VC-PPA.1D ${w}" | python ${MTD}/run_MTD.py
				done

			done

			#concat TS
			#TD regressors
			for w in 5 10 15; do
				cat $(/bin/ls /tmp/${s}/${dset}_Reg_w${w}_${condition}_run*_VC-FFA.1D | sort -V) > /tmp/${s}/${dset}_MTDReg_w${w}_FFA-VC_${condition}_runs.1D	
				cat $(/bin/ls /tmp/${s}/${dset}_Reg_w${w}_${condition}_run*_VC-PPA.1D | sort -V) > /tmp/${s}/${dset}_MTDReg_w${w}_PPA-VC_${condition}_runs.1D	
			done

			#BC regressors
			cat $(/bin/ls /tmp/${s}/${dset}_Reg_${condition}_FFA_run*.1D | sort -V) > /tmp/${s}/${dset}_BCReg_FFA_${condition}_runs.1D
			cat $(/bin/ls /tmp/${s}/${dset}_Reg_${condition}_PPA_run*.1D | sort -V) > /tmp/${s}/${dset}_BCReg_PPA_${condition}_runs.1D
			cat $(/bin/ls /tmp/${s}/${dset}_Reg_${condition}_VC_run*.1D | sort -V) > /tmp/${s}/${dset}_BCReg_VC_${condition}_runs.1D

			# need to create zero factors for combining TD and P conditions...
			yes "0" | head -n 396 > /tmp/${s}/ZEROs

		done

		# messy compiling regressors
		for w in 5 10 15; do
			cat /tmp/${s}/${dset}_MTDReg_w${w}_FFA-VC_FH_runs.1D /tmp/${s}/ZEROs /tmp/${s}/ZEROs /tmp/${s}/ZEROs > /tmp/${s}/${dset}_MTDReg_w${w}_FFA-VC_FH_all.1D
			cat /tmp/${s}/${dset}_MTDReg_w${w}_PPA-VC_FH_runs.1D /tmp/${s}/ZEROs /tmp/${s}/ZEROs /tmp/${s}/ZEROs > /tmp/${s}/${dset}_MTDReg_w${w}_PPA-VC_FH_all.1D
			cat /tmp/${s}/ZEROs /tmp/${s}/${dset}_MTDReg_w${w}_FFA-VC_HF_runs.1D /tmp/${s}/ZEROs /tmp/${s}/ZEROs > /tmp/${s}/${dset}_MTDReg_w${w}_FFA-VC_HF_all.1D
			cat /tmp/${s}/ZEROs /tmp/${s}/${dset}_MTDReg_w${w}_PPA-VC_HF_runs.1D /tmp/${s}/ZEROs /tmp/${s}/ZEROs > /tmp/${s}/${dset}_MTDReg_w${w}_PPA-VC_HF_all.1D
			cat /tmp/${s}/ZEROs /tmp/${s}/ZEROs /tmp/${s}/${dset}_MTDReg_w${w}_FFA-VC_Hp_runs.1D /tmp/${s}/ZEROs > /tmp/${s}/${dset}_MTDReg_w${w}_FFA-VC_Hp_all.1D
			cat /tmp/${s}/ZEROs /tmp/${s}/ZEROs /tmp/${s}/${dset}_MTDReg_w${w}_PPA-VC_Hp_runs.1D /tmp/${s}/ZEROs > /tmp/${s}/${dset}_MTDReg_w${w}_PPA-VC_Hp_all.1D
			cat /tmp/${s}/ZEROs /tmp/${s}/ZEROs /tmp/${s}/ZEROs /tmp/${s}/${dset}_MTDReg_w${w}_FFA-VC_Fp_runs.1D > /tmp/${s}/${dset}_MTDReg_w${w}_FFA-VC_Fp_all.1D
			cat /tmp/${s}/ZEROs /tmp/${s}/ZEROs /tmp/${s}/ZEROs /tmp/${s}/${dset}_MTDReg_w${w}_PPA-VC_Fp_runs.1D > /tmp/${s}/${dset}_MTDReg_w${w}_PPA-VC_Fp_all.1D
		done

		cat /tmp/${s}/${dset}_BCReg_FFA_FH_runs.1D /tmp/${s}/ZEROs /tmp/${s}/ZEROs /tmp/${s}/ZEROs > /tmp/${s}/${dset}_BCReg_FFA_FH_all.1D
		cat /tmp/${s}/${dset}_BCReg_PPA_FH_runs.1D /tmp/${s}/ZEROs /tmp/${s}/ZEROs /tmp/${s}/ZEROs > /tmp/${s}/${dset}_BCReg_PPA_FH_all.1D
		cat /tmp/${s}/${dset}_BCReg_VC_FH_runs.1D /tmp/${s}/ZEROs /tmp/${s}/ZEROs /tmp/${s}/ZEROs > /tmp/${s}/${dset}_BCReg_VC_FH_all.1D
		cat /tmp/${s}/ZEROs /tmp/${s}/${dset}_BCReg_FFA_HF_runs.1D /tmp/${s}/ZEROs /tmp/${s}/ZEROs > /tmp/${s}/${dset}_BCReg_FFA_HF_all.1D
		cat /tmp/${s}/ZEROs /tmp/${s}/${dset}_BCReg_PPA_HF_runs.1D /tmp/${s}/ZEROs /tmp/${s}/ZEROs > /tmp/${s}/${dset}_BCReg_PPA_HF_all.1D
		cat /tmp/${s}/ZEROs /tmp/${s}/${dset}_BCReg_VC_HF_runs.1D /tmp/${s}/ZEROs /tmp/${s}/ZEROs > /tmp/${s}/${dset}_BCReg_VC_HF_all.1D
		cat /tmp/${s}/ZEROs /tmp/${s}/ZEROs /tmp/${s}/${dset}_BCReg_FFA_Hp_runs.1D /tmp/${s}/ZEROs > /tmp/${s}/${dset}_BCReg_FFA_Hp_all.1D
		cat /tmp/${s}/ZEROs /tmp/${s}/ZEROs /tmp/${s}/${dset}_BCReg_PPA_Hp_runs.1D /tmp/${s}/ZEROs > /tmp/${s}/${dset}_BCReg_PPA_Hp_all.1D
		cat /tmp/${s}/ZEROs /tmp/${s}/ZEROs /tmp/${s}/${dset}_BCReg_VC_Hp_runs.1D /tmp/${s}/ZEROs > /tmp/${s}/${dset}_BCReg_VC_Hp_all.1D
		cat /tmp/${s}/ZEROs /tmp/${s}/ZEROs /tmp/${s}/ZEROs /tmp/${s}/${dset}_BCReg_FFA_Fp_runs.1D > /tmp/${s}/${dset}_BCReg_FFA_Fp_all.1D
		cat /tmp/${s}/ZEROs /tmp/${s}/ZEROs /tmp/${s}/ZEROs /tmp/${s}/${dset}_BCReg_PPA_Fp_runs.1D > /tmp/${s}/${dset}_BCReg_PPA_Fp_all.1D
		cat /tmp/${s}/ZEROs /tmp/${s}/ZEROs /tmp/${s}/ZEROs /tmp/${s}/${dset}_BCReg_VC_Fp_runs.1D > /tmp/${s}/${dset}_BCReg_VC_Fp_all.1D

		cat ${WD}/${s}/${s}_FH_censor.1D ${WD}/${s}/${s}_HF_censor.1D ${WD}/${s}/${s}_Hp_censor.1D ${WD}/${s}/${s}_Fp_censor.1D > /tmp/${s}/censor.1D

		# run big model!
		for w in 5 10 15; do
			3dDeconvolve \
			-input /tmp/${s}/${dset}_Reg_FH_errts_run1.nii.gz \
			/tmp/${s}/${dset}_Reg_FH_errts_run2.nii.gz \
			/tmp/${s}/${dset}_Reg_FH_errts_run3.nii.gz \
			/tmp/${s}/${dset}_Reg_FH_errts_run4.nii.gz \
			/tmp/${s}/${dset}_Reg_HF_errts_run1.nii.gz \
			/tmp/${s}/${dset}_Reg_HF_errts_run2.nii.gz \
			/tmp/${s}/${dset}_Reg_HF_errts_run3.nii.gz \
			/tmp/${s}/${dset}_Reg_HF_errts_run4.nii.gz \
			/tmp/${s}/${dset}_Reg_Hp_errts_run1.nii.gz \
			/tmp/${s}/${dset}_Reg_Hp_errts_run2.nii.gz \
			/tmp/${s}/${dset}_Reg_Hp_errts_run3.nii.gz \
			/tmp/${s}/${dset}_Reg_Hp_errts_run4.nii.gz \
			/tmp/${s}/${dset}_Reg_Fp_errts_run1.nii.gz \
			/tmp/${s}/${dset}_Reg_Fp_errts_run2.nii.gz \
			/tmp/${s}/${dset}_Reg_Fp_errts_run3.nii.gz \
			/tmp/${s}/${dset}_Reg_Fp_errts_run4.nii.gz \
			-mask ${WD}/ROIs/100overlap_mask+tlrc \
			-polort A \
			-num_stimts 20 \
			-censor /tmp/${s}/censor.1D \
			-stim_file 1 /tmp/${s}/${dset}_MTDReg_w${w}_FFA-VC_FH_all.1D -stim_label 1 MTD_FH_FFA-VC \
			-stim_file 2 /tmp/${s}/${dset}_MTDReg_w${w}_PPA-VC_FH_all.1D -stim_label 2 MTD_FH_PPA-VC \
			-stim_file 3 /tmp/${s}/${dset}_MTDReg_w${w}_FFA-VC_HF_all.1D -stim_label 3 MTD_HF_FFA-VC \
			-stim_file 4 /tmp/${s}/${dset}_MTDReg_w${w}_PPA-VC_HF_all.1D -stim_label 4 MTD_HF_PPA-VC \
			-stim_file 5 /tmp/${s}/${dset}_MTDReg_w${w}_FFA-VC_Hp_all.1D -stim_label 5 MTD_Hp_FFA-VC \
			-stim_file 6 /tmp/${s}/${dset}_MTDReg_w${w}_PPA-VC_Hp_all.1D -stim_label 6 MTD_Hp_PPA-VC \
			-stim_file 7 /tmp/${s}/${dset}_MTDReg_w${w}_FFA-VC_Fp_all.1D -stim_label 7 MTD_Fp_FFA-VC \
			-stim_file 8 /tmp/${s}/${dset}_MTDReg_w${w}_PPA-VC_Fp_all.1D -stim_label 8 MTD_Fp_PPA-VC \
			-stim_file 9 /tmp/${s}/${dset}_BCReg_FFA_FH_all.1D -stim_label 9 BC_FH_FFA \
			-stim_file 10 /tmp/${s}/${dset}_BCReg_PPA_FH_all.1D -stim_label 10 BC_FH_PPA \
			-stim_file 11 /tmp/${s}/${dset}_BCReg_FFA_HF_all.1D -stim_label 11 BC_HF_FFA \
			-stim_file 12 /tmp/${s}/${dset}_BCReg_PPA_HF_all.1D -stim_label 12 BC_HF_PPA \
			-stim_file 13 /tmp/${s}/${dset}_BCReg_FFA_Hp_all.1D -stim_label 13 BC_Hp_FFA \
			-stim_file 14 /tmp/${s}/${dset}_BCReg_PPA_Hp_all.1D -stim_label 14 BC_Hp_PPA \
			-stim_file 15 /tmp/${s}/${dset}_BCReg_FFA_Fp_all.1D -stim_label 15 BC_Fp_FFA \
			-stim_file 16 /tmp/${s}/${dset}_BCReg_PPA_Fp_all.1D -stim_label 16 BC_Fp_PPA \
			-stim_file 17 /tmp/${s}/${dset}_BCReg_VC_FH_all.1D -stim_label 17 BC_FH_VC \
			-stim_file 18 /tmp/${s}/${dset}_BCReg_VC_HF_all.1D -stim_label 18 BC_HF_VC \
			-stim_file 19 /tmp/${s}/${dset}_BCReg_VC_Hp_all.1D -stim_label 19 BC_Hp_VC \
			-stim_file 20 /tmp/${s}/${dset}_BCReg_VC_Fp_all.1D -stim_label 20 BC_Fp_VC \
			-num_glt 17 \
			-gltsym 'SYM: +0.5*MTD_FH_FFA-VC +0.5*MTD_HF_PPA-VC' -glt_label 1 MTD_Target \
			-gltsym 'SYM: +0.5*MTD_HF_FFA-VC +0.5*MTD_FH_PPA-VC' -glt_label 2 MTD_Distractor \
			-gltsym 'SYM: +0.5*MTD_Fp_FFA-VC +0.5*MTD_Hp_PPA-VC' -glt_label 3 MTD_Target_Baseline \
			-gltsym 'SYM: +0.5*MTD_Hp_FFA-VC +0.5*MTD_Fp_PPA-VC' -glt_label 4 MTD_Distractor_Baseline \
			-gltsym 'SYM: +1*MTD_FH_FFA-VC +1*MTD_HF_PPA-VC -1*MTD_Fp_FFA-VC -1*MTD_Hp_PPA-VC' -glt_label 5 MTD_Target-Baseline \
			-gltsym 'SYM: +1*MTD_HF_FFA-VC +1*MTD_FH_PPA-VC -1*MTD_Fp_FFA-VC -1*MTD_Hp_PPA-VC' -glt_label 6 MTD_Distractor-Baseline \
			-gltsym 'SYM: +1*MTD_FH_FFA-VC +1*MTD_HF_PPA-VC -1*MTD_HF_FFA-VC -1*MTD_FH_PPA-VC' -glt_label 7 MTD_Target-Distractor \
			-gltsym 'SYM: +0.5*BC_FH_FFA +0.5*BC_HF_PPA' -glt_label 8 BC_Target \
			-gltsym 'SYM: +0.5*BC_HF_FFA +0.5*BC_FH_PPA' -glt_label 9 BC_Distractor \
			-gltsym 'SYM: +0.5*BC_Fp_FFA +0.5*BC_Hp_PPA' -glt_label 10 BC_Target_Baseline \
			-gltsym 'SYM: +0.5*BC_Hp_FFA +0.5*BC_Fp_PPA' -glt_label 11 BC_Distractor_Baseline \
			-gltsym 'SYM: +1*BC_FH_FFA +1*BC_HF_PPA -1*BC_Fp_FFA -1*BC_Hp_PPA' -glt_label 12 BC_Target-Baseline \
			-gltsym 'SYM: +1*BC_HF_FFA +1*BC_FH_PPA -1*BC_Fp_FFA -1*BC_Hp_PPA' -glt_label 13 BC_Distractor-Baseline \
			-gltsym 'SYM: +1*BC_FH_FFA +1*BC_HF_PPA -1*BC_HF_FFA -1*BC_FH_PPA' -glt_label 14 BC_Target-Distractor \
			-gltsym 'SYM: +1*BC_FH_VC +1*BC_HF_VC -1*BC_Fp_VC -1*BC_Hp_VC' -glt_label 15 BC_Attn-Baseline_VC \
			-gltsym 'SYM: +1*BC_FH_VC -1*BC_Fp_VC' -glt_label 16 BC_FH-Baseline_VC \
			-gltsym 'SYM: +1*BC_HF_VC -1*BC_Hp_VC' -glt_label 17 BC_HF-Baseline_VC \
			-fout \
			-rout \
			-tout \
			-nocout \
			-bucket /tmp/${s}/${dset}_w${w}_MTD_BC_stats \
			-GOFORIT 100 \
			-noFDR \
			-x1D_stop

			. /tmp/${s}/${dset}_w${w}_MTD_BC_stats.REML_cmd
			
			mv ${dset}_w${w}_MTD_BC_stats_REML+tlrc* ${WD}/${s}/
			
			#mv ${dset}_w${w}_MTD_BC_stats+tlrc* ${WD}/${s}/
		done
	done	


	cd ${WD}/${s} 
	rm -rf /tmp/${s}/

done


