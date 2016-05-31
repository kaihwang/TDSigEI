# script to run MTD model on the old TRSE dataset


WD='/home/despoB/kaihwang/TRSE/TRSEPPI/AllSubjs'
SCRIPT='/home/despoB/kaihwang/TRSE/TRSEPPI/TRSE_scripts'
MTD='/home/despoB/kaihwang/bin/TDSigEI/MTD'




for s in 1106; do
	cd $WD/${s}

	3dDeconvolve -input $(/bin/ls run*/nswdkmt_functional*.nii.gz | sort -V) \
	-mask /home/despoB/TRSEPPI/TRSEPPI/overlap_mask/TRSE_80perOverlap_mask.nii.gz \
	-polort A \
	-num_stimts 14 \
	-stim_times 1 ${SCRIPT}/${s}_both_face.txt 'TENT(0, 14, 15)' -stim_label 1 both_face \
	-stim_times 2 ${SCRIPT}/${s}_both_scene.txt 'TENT(0, 14, 15)' -stim_label 2 both_scene \
	-stim_times 3 ${SCRIPT}/${s}_categorize_scene.txt 'TENT(0, 14, 15)' -stim_label 3 categorize_scene \
	-stim_times 4 ${SCRIPT}/${s}_categorize_face.txt 'TENT(0, 14, 15)' -stim_label 4 categorize_face \
	-stim_times 5 ${SCRIPT}/${s}_relevant_face.txt 'TENT(0, 14, 15)' -stim_label 5 relevant_face \
	-stim_times 6 ${SCRIPT}/${s}_irrelevant_face.txt 'TENT(0, 14, 15)' -stim_label 6 irrelevant_face \
	-stim_times 7 ${SCRIPT}/${s}_relevant_scene.txt 'TENT(0, 14, 15)' -stim_label 7 relevant_scene \
	-stim_times 8 ${SCRIPT}/${s}_irrelevant_scene.txt 'TENT(0, 14, 15)' -stim_label 8 irrelevant_scene \
	-stim_file 9 ${WD}/${s}/motionRuns.1D[0] -stim_label 9 motpar1 -stim_base 9 \
	-stim_file 10 ${WD}/${s}/motionRuns.1D[1] -stim_label 10 motpar2 -stim_base 10 \
	-stim_file 11 ${WD}/${s}/motionRuns.1D[2] -stim_label 11 motpar3 -stim_base 11 \
	-stim_file 12 ${WD}/${s}/motionRuns.1D[3] -stim_label 12 motpar4 -stim_base 12 \
	-stim_file 13 ${WD}/${s}/motionRuns.1D[4] -stim_label 13 motpar5 -stim_base 13 \
	-stim_file 14 ${WD}/${s}/motionRuns.1D[5] -stim_label 14 motpar6 -stim_base 14 \
	-iresp 1 both_face_FIR \
	-iresp 2 both_scene_FIR \
	-iresp 3 categorize_scene_FIR \
	-iresp 4 categorize_face_FIR \
	-iresp 5 relevant_face_FIR \
	-iresp 6 irrelevant_face_FIR \
	-iresp 7 relevant_scene_FIR \
	-iresp 8 irrelevant_scene_FIR \
	-rout \
	-nocout \
	-bucket FIR_stats \
	-x1D FIR_design_mat \
	-GOFORIT 100\
	-noFDR \
	-errts FIR_errts.nii.gz \
	-allzero_OK	

	3dmaskave -mask ${WD}/${s}/FFA_indiv_ROI.nii.gz -q ${WD}/${s}/FIR_errts.nii.gz > ${WD}/${s}/FFA_all_ts.1D
	3dmaskave -mask ${WD}/${s}/PPA_indiv_ROI.nii.gz -q ${WD}/${s}/FIR_errts.nii.gz > ${WD}/${s}/PPA_all_ts.1D
	3dmaskave -mask ${WD}/${s}/V1_indiv_ROI.nii.gz -q ${WD}/${s}/FIR_errts.nii.gz > ${WD}/${s}/VC_all_ts.1D


	#split into runs
	r=1
	for n in $(seq 1 114 2167); do
		sed -n "${n}, +113p" FFA_all_ts.1D > BC_run${r}_FFA.1D
		sed -n "${n}, +113p" PPA_all_ts.1D > BC_run${r}_PPA.1D
		sed -n "${n}, +113p" VC_all_ts.1D > BC_run${r}_VC.1D
		r=$(($r+1))
	done

	#cal MTD
	for r in $(seq 1 1 20); do
		echo "${WD}/${s}/BC_run${r}_FFA.1D ${WD}/${s}/BC_run${r}_VC.1D ${WD}/${s}/MTD_run${r}_VC-FFA.1D 15" | python ${MTD}/run_MTD.py
		echo "${WD}/${s}/BC_run${r}_PPA.1D ${WD}/${s}/BC_run${r}_VC.1D ${WD}/${s}/MTD_run${r}_VC-PPA.1D 15" | python ${MTD}/run_MTD.py
	done

	# get zeros
	yes "0" | head -n 114 > ${WD}/${s}/ZEROs
	
	#now the messy business of creatign regressors
	cat MTD_run1_VC-FFA.1D ZEROs ZEROs ZEROs ZEROs ZEROs ZEROs MTD_run8_VC-FFA.1D ZEROs ZEROs MTD_run11_VC-FFA.1D ZEROs ZEROs MTD_run14_VC-FFA.1D ZEROs ZEROs MTD_run17_VC-FFA.1D ZEROs ZEROs ZEROs > ${WD}/${s}/MTD_reg_FH_FFA-VC.1D
	cat MTD_run1_VC-PPA.1D ZEROs ZEROs ZEROs ZEROs ZEROs ZEROs MTD_run8_VC-PPA.1D ZEROs ZEROs MTD_run11_VC-PPA.1D ZEROs ZEROs MTD_run14_VC-PPA.1D ZEROs ZEROs MTD_run17_VC-PPA.1D ZEROs ZEROs ZEROs > ${WD}/${s}/MTD_reg_FH_PPA-VC.1D
	cat ZEROs MTD_run2_VC-PPA.1D ZEROs ZEROs MTD_run5_VC-PPA.1D ZEROs ZEROs ZEROs ZEROs ZEROs ZEROs MTD_run12_VC-PPA.1D ZEROs ZEROs MTD_run15_VC-PPA.1D ZEROs ZEROs MTD_run18_VC-PPA.1D ZEROs ZEROs > ${WD}/${s}/MTD_reg_HF_PPA-VC.1D
	cat ZEROs MTD_run2_VC-FFA.1D ZEROs ZEROs MTD_run5_VC-FFA.1D ZEROs ZEROs ZEROs ZEROs ZEROs ZEROs MTD_run12_VC-FFA.1D ZEROs ZEROs MTD_run15_VC-FFA.1D ZEROs ZEROs MTD_run18_VC-FFA.1D ZEROs ZEROs > ${WD}/${s}/MTD_reg_HF_FFA-VC.1D
	cat ZEROs ZEROs MTD_run3_VC-FFA.1D ZEROs ZEROs MTD_run6_VC-FFA.1D ZEROs ZEROs MTD_run9_VC-FFA.1D ZEROs ZEROs ZEROs ZEROs ZEROs ZEROs MTD_run16_VC-FFA.1D ZEROs ZEROs MTD_run19_VC-FFA.1D ZEROs > ${WD}/${s}/MTD_reg_CAT_FFA-VC.1D
	cat ZEROs ZEROs MTD_run3_VC-PPA.1D ZEROs ZEROs MTD_run6_VC-PPA.1D ZEROs ZEROs MTD_run9_VC-PPA.1D ZEROs ZEROs ZEROs ZEROs ZEROs ZEROs MTD_run16_VC-PPA.1D ZEROs ZEROs MTD_run19_VC-PPA.1D ZEROs > ${WD}/${s}/MTD_reg_CAT_PPA-VC.1D
	cat ZEROs ZEROs ZEROs MTD_run4_VC-PPA.1D ZEROs ZEROs MTD_run7_VC-PPA.1D ZEROs ZEROs MTD_run10_VC-PPA.1D ZEROs ZEROs MTD_run13_VC-PPA.1D ZEROs ZEROs ZEROs MTD_run17_VC-PPA.1D ZEROs ZEROs MTD_run20_VC-PPA.1D > ${WD}/${s}/MTD_reg_BO_PPA-VC.1D
	cat ZEROs ZEROs ZEROs MTD_run4_VC-FFA.1D ZEROs ZEROs MTD_run7_VC-FFA.1D ZEROs ZEROs MTD_run10_VC-FFA.1D ZEROs ZEROs MTD_run13_VC-FFA.1D ZEROs ZEROs ZEROs MTD_run17_VC-FFA.1D ZEROs ZEROs MTD_run20_VC-FFA.1D > ${WD}/${s}/MTD_reg_BO_FFA-VC.1D

	cat BC_run1_FFA.1D ZEROs ZEROs ZEROs ZEROs ZEROs ZEROs BC_run8_FFA.1D ZEROs ZEROs BC_run11_FFA.1D ZEROs ZEROs BC_run14_FFA.1D ZEROs ZEROs BC_run17_FFA.1D ZEROs ZEROs ZEROs > ${WD}/${s}/BC_reg_FH_FFA.1D
	cat BC_run1_PPA.1D ZEROs ZEROs ZEROs ZEROs ZEROs ZEROs BC_run8_PPA.1D ZEROs ZEROs BC_run11_PPA.1D ZEROs ZEROs BC_run14_PPA.1D ZEROs ZEROs BC_run17_PPA.1D ZEROs ZEROs ZEROs > ${WD}/${s}/BC_reg_FH_PPA.1D
	cat BC_run1_VC.1D ZEROs ZEROs ZEROs ZEROs ZEROs ZEROs BC_run8_VC.1D ZEROs ZEROs BC_run11_VC.1D ZEROs ZEROs BC_run14_VC.1D ZEROs ZEROs BC_run17_VC.1D ZEROs ZEROs ZEROs > ${WD}/${s}/BC_reg_FH_VC.1D
	cat ZEROs BC_run2_PPA.1D ZEROs ZEROs BC_run5_PPA.1D ZEROs ZEROs ZEROs ZEROs ZEROs ZEROs BC_run12_PPA.1D ZEROs ZEROs BC_run15_PPA.1D ZEROs ZEROs BC_run18_PPA.1D ZEROs ZEROs > ${WD}/${s}/BC_reg_HF_PPA.1D
	cat ZEROs BC_run2_FFA.1D ZEROs ZEROs BC_run5_FFA.1D ZEROs ZEROs ZEROs ZEROs ZEROs ZEROs BC_run12_FFA.1D ZEROs ZEROs BC_run15_FFA.1D ZEROs ZEROs BC_run18_FFA.1D ZEROs ZEROs > ${WD}/${s}/BC_reg_HF_FFA.1D
	cat ZEROs BC_run2_VC.1D ZEROs ZEROs BC_run5_VC.1D ZEROs ZEROs ZEROs ZEROs ZEROs ZEROs BC_run12_VC.1D ZEROs ZEROs BC_run15_VC.1D ZEROs ZEROs BC_run18_VC.1D ZEROs ZEROs > ${WD}/${s}/BC_reg_HF_VC.1D
	cat ZEROs ZEROs BC_run3_FFA.1D ZEROs ZEROs BC_run6_FFA.1D ZEROs ZEROs BC_run9_FFA.1D ZEROs ZEROs ZEROs ZEROs ZEROs ZEROs BC_run16_FFA.1D ZEROs ZEROs BC_run19_FFA.1D ZEROs > ${WD}/${s}/BC_reg_CAT_FFA.1D
	cat ZEROs ZEROs BC_run3_PPA.1D ZEROs ZEROs BC_run6_PPA.1D ZEROs ZEROs BC_run9_PPA.1D ZEROs ZEROs ZEROs ZEROs ZEROs ZEROs BC_run16_PPA.1D ZEROs ZEROs BC_run19_PPA.1D ZEROs > ${WD}/${s}/BC_reg_CAT_PPA.1D
	cat ZEROs ZEROs BC_run3_VC.1D ZEROs ZEROs BC_run6_VC.1D ZEROs ZEROs BC_run9_VC.1D ZEROs ZEROs ZEROs ZEROs ZEROs ZEROs BC_run16_VC.1D ZEROs ZEROs BC_run19_VC.1D ZEROs > ${WD}/${s}/BC_reg_CAT_VC.1D
	cat ZEROs ZEROs ZEROs BC_run4_PPA.1D ZEROs ZEROs BC_run7_PPA.1D ZEROs ZEROs BC_run10_PPA.1D ZEROs ZEROs BC_run13_PPA.1D ZEROs ZEROs ZEROs BC_run17_PPA.1D ZEROs ZEROs BC_run20_PPA.1D > ${WD}/${s}/BC_reg_BO_PPA.1D
	cat ZEROs ZEROs ZEROs BC_run4_FFA.1D ZEROs ZEROs BC_run7_FFA.1D ZEROs ZEROs BC_run10_FFA.1D ZEROs ZEROs BC_run13_FFA.1D ZEROs ZEROs ZEROs BC_run17_FFA.1D ZEROs ZEROs BC_run20_FFA.1D > ${WD}/${s}/BC_reg_BO_FFA.1D
	cat ZEROs ZEROs ZEROs BC_run4_VC.1D ZEROs ZEROs BC_run7_VC.1D ZEROs ZEROs BC_run10_VC.1D ZEROs ZEROs BC_run13_VC.1D ZEROs ZEROs ZEROs BC_run17_VC.1D ZEROs ZEROs BC_run20_VC.1D > ${WD}/${s}/BC_reg_BO_VC.1D


	3dDeconvolve -input ${WD}/${s}/FIR_errts.nii.gz \
	-concat '1D: 0 114 228 342 456 570 684 798 912 1026 1140 1254 1368 1482 1596 1710 1824 1938 2052 2166' \
	-mask /home/despoB/TRSEPPI/TRSEPPI/overlap_mask/TRSE_80perOverlap_mask.nii.gz \
	-polort A \
	-num_stimts 20 \
	-stim_file 1 ${WD}/${s}/MTD_reg_FH_FFA-VC.1D -stim_label 1 MTD_FH_FFA-VC \
	-stim_file 2 ${WD}/${s}/MTD_reg_FH_PPA-VC.1D -stim_label 2 MTD_FH_PPA-VC \
	-stim_file 3 ${WD}/${s}/MTD_reg_HF_PPA-VC.1D -stim_label 3 MTD_HF_PPA-VC \
	-stim_file 4 ${WD}/${s}/MTD_reg_HF_FFA-VC.1D -stim_label 4 MTD_HF_FFA-VC \
	-stim_file 5 ${WD}/${s}/MTD_reg_CAT_FFA-VC.1D -stim_label 5 MTD_CAT_FFA-VC \
	-stim_file 6 ${WD}/${s}/MTD_reg_CAT_PPA-VC.1D -stim_label 6 MTD_CAT_PPA-VC \
	-stim_file 7 ${WD}/${s}/MTD_reg_BO_PPA-VC.1D -stim_label 7 MTD_BO_PPA-VC.1D \
	-stim_file 8 ${WD}/${s}/MTD_reg_BO_FFA-VC.1D -stim_label 8 MTD_BO_FFA-VC.1D \
	-stim_file 9 ${WD}/${s}/BC_reg_FH_FFA.1D -stim_label 9 BC_FH_FFA \
	-stim_file 10 ${WD}/${s}/BC_reg_FH_PPA.1D -stim_label 10 BC_FH_PPA \
	-stim_file 11 ${WD}/${s}/BC_reg_FH_VC.1D -stim_label 11 BC_FH_VC \
	-stim_file 12 ${WD}/${s}/BC_reg_HF_PPA.1D -stim_label 12 BC_HF_PPA \
	-stim_file 13 ${WD}/${s}/BC_reg_HF_FFA.1D -stim_label 13 BC_HF_FFA \
	-stim_file 14 ${WD}/${s}/BC_reg_HF_VC.1D -stim_label 14 BC_HF_VC \
	-stim_file 15 ${WD}/${s}/BC_reg_CAT_FFA.1D -stim_label 15 BC_CAT_FFA \
	-stim_file 16 ${WD}/${s}/BC_reg_CAT_PPA.1D -stim_label 16 BC_CAT_PPA \
	-stim_file 17 ${WD}/${s}/BC_reg_CAT_VC.1D -stim_label 17 BC_CAT_VC \
	-stim_file 18 ${WD}/${s}/BC_reg_BO_PPA.1D -stim_label 18 BC_BO_PPA \
	-stim_file 19 ${WD}/${s}/BC_reg_BO_FFA.1D -stim_label 19 BC_BO_FFA \
	-stim_file 20 ${WD}/${s}/BC_reg_BO_VC.1D -stim_label 20 BC_BO_VC \
	-num_glt 17 \
	-gltsym 'SYM: +0.5*MTD_FH_FFA-VC +0.5*MTD_HF_PPA-VC' -glt_label 1 MTD_Target \
	-gltsym 'SYM: +0.5*MTD_HF_FFA-VC +0.5*MTD_FH_PPA-VC' -glt_label 2 MTD_Distractor \
	-gltsym 'SYM: +0.5*MTD_CAT_FFA-VC +0.5*MTD_CAT_PPA-VC' -glt_label 3 MTD_Target_Baseline \
	-gltsym 'SYM: +0.5*MTD_CAT_FFA-VC +0.5*MTD_CAT_PPA-VC' -glt_label 4 MTD_Distractor_Baseline \
	-gltsym 'SYM: +1*MTD_FH_FFA-VC +1*MTD_HF_PPA-VC -1*MTD_CAT_FFA-VC -1*MTD_CAT_PPA-VC' -glt_label 5 MTD_Target-Baseline \
	-gltsym 'SYM: +1*MTD_HF_FFA-VC +1*MTD_FH_PPA-VC -1*MTD_CAT_FFA-VC -1*MTD_CAT_PPA-VC' -glt_label 6 MTD_Distractor-Baseline \
	-gltsym 'SYM: +1*MTD_FH_FFA-VC +1*MTD_HF_PPA-VC -1*MTD_HF_FFA-VC -1*MTD_FH_PPA-VC' -glt_label 7 MTD_Target-Distractor \
	-gltsym 'SYM: +0.5*BC_FH_FFA +0.5*BC_HF_PPA' -glt_label 8 BC_Target \
	-gltsym 'SYM: +0.5*BC_HF_FFA +0.5*BC_FH_PPA' -glt_label 9 BC_Distractor \
	-gltsym 'SYM: +0.5*BC_CAT_FFA +0.5*BC_CAT_PPA' -glt_label 10 BC_Target_Baseline \
	-gltsym 'SYM: +0.5*BC_CAT_FFA +0.5*BC_CAT_PPA' -glt_label 11 BC_Distractor_Baseline \
	-gltsym 'SYM: +1*BC_FH_FFA +1*BC_HF_PPA -1*BC_CAT_FFA -1*BC_CAT_PPA' -glt_label 12 BC_Target-Baseline \
	-gltsym 'SYM: +1*BC_HF_FFA +1*BC_FH_PPA -1*BC_CAT_FFA -1*BC_CAT_PPA' -glt_label 13 BC_Distractor-Baseline \
	-gltsym 'SYM: +1*BC_FH_FFA +1*BC_HF_PPA -1*BC_HF_FFA -1*BC_FH_PPA' -glt_label 14 BC_Target-Distractor \
	-gltsym 'SYM: +1*BC_FH_VC +1*BC_HF_VC -1*BC_CAT_VC -1*BC_CAT_VC' -glt_label 15 BC_Attn-Baseline_VC \
	-gltsym 'SYM: +1*BC_FH_VC -1*BC_CAT_VC' -glt_label 16 BC_FH-Baseline_VC \
	-gltsym 'SYM: +1*BC_HF_VC -1*BC_CAT_VC' -glt_label 17 BC_HF-Baseline_VC \
	-tout \
	-nocout \
	-bucket ${WD}/${s}/MTD_BC_stats \
	-GOFORIT 100 \
	-noFDR -x1D_stop

	. ${WD}/${s}/MTD_BC_stats.REML_cmd	

done