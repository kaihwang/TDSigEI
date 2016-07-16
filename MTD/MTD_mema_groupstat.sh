#!/bin/bash
# script for group analysis of MTD regression. using 3dMEMA taking within subject GLT to group level

#### glt coding from 3dDeconvolve
# -gltsym 'SYM: +0.5*MTD_FH_FFA-VC +0.5*MTD_HF_PPA-VC' -glt_label 1 MTD_Target \
# -gltsym 'SYM: +0.5*MTD_HF_FFA-VC +0.5*MTD_FH_PPA-VC' -glt_label 2 MTD_Distractor \
# -gltsym 'SYM: +0.5*MTD_Fp_FFA-VC +0.5*MTD_Hp_PPA-VC' -glt_label 3 MTD_Target_Baseline \
# -gltsym 'SYM: +0.5*MTD_Hp_FFA-VC +0.5*MTD_Fp_PPA-VC' -glt_label 4 MTD_Distractor_Baseline \
# -gltsym 'SYM: +1*MTD_FH_FFA-VC +1*MTD_HF_PPA-VC -1*MTD_Fp_FFA-VC -1*MTD_Hp_PPA-VC' -glt_label 5 MTD_Target-Baseline \
# -gltsym 'SYM: +1*MTD_HF_FFA-VC +1*MTD_FH_PPA-VC -1*MTD_Fp_FFA-VC -1*MTD_Hp_PPA-VC' -glt_label 6 MTD_Distractor-Baseline \
# -gltsym 'SYM: +1*MTD_FH_FFA-VC +1*MTD_HF_PPA-VC -1*MTD_HF_FFA-VC -1*MTD_FH_PPA-VC' -glt_label 7 MTD_Target-Distractor \
# -gltsym 'SYM: +0.5*BC_FH_FFA +0.5*BC_HF_PPA' -glt_label 8 BC_Target \
# -gltsym 'SYM: +0.5*BC_HF_FFA +0.5*BC_FH_PPA' -glt_label 9 BC_Distractor \
# -gltsym 'SYM: +0.5*BC_Fp_FFA +0.5*BC_Hp_PPA' -glt_label 10 BC_Target_Baseline \
# -gltsym 'SYM: +0.5*BC_Hp_FFA +0.5*BC_Fp_PPA' -glt_label 11 BC_Distractor_Baseline \
# -gltsym 'SYM: +1*BC_FH_FFA +1*BC_HF_PPA -1*BC_Fp_FFA -1*BC_Hp_PPA' -glt_label 12 BC_Target-Baseline \
# -gltsym 'SYM: +1*BC_HF_FFA +1*BC_FH_PPA -1*BC_Fp_FFA -1*BC_Hp_PPA' -glt_label 13 BC_Distractor-Baseline \
# -gltsym 'SYM: +1*BC_FH_FFA +1*BC_HF_PPA -1*BC_HF_FFA -1*BC_FH_PPA' -glt_label 14 BC_Target-Distractor \

for contrast in MTD_Target MTD_Distractor MTD_Target_Baseline MTD_Distractor_Baseline MTD_Target-Baseline MTD_Distractor-Baseline MTD_Target-Distractor BC_Target BC_Distractor BC_Target_Baseline BC_Distractor_Baseline BC_Target-Baseline BC_Distractor-Baseline BC_Target-Distractor; do
	for dset in FIR; do
		echo "cd /home/despoB/kaihwang/TRSE/TDSigEI/Group 
		3dMEMA -prefix /home/despoB/kaihwang/TRSE/TDSigEI/Group/${dset}_${contrast}_groupMEMA \\
		-set ${contrast} \\" > /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_${dset}_${contrast}.sh

		cd /home/despoB/kaihwang/TRSE/TDSigEI/


		for s in $(/bin/ls -d 5*); do
			cbrik=$(3dinfo -verb /home/despoB/TRSEPPI/TDSigEI/${s}/FIR_w15_MTD_BC_stats_REML+tlrc | grep "${contrast}#0_Coef" | grep -o ' #[0-9]\{1,3\}' | grep -o '[0-9]\{1,3\}')
			tbrik=$(3dinfo -verb /home/despoB/TRSEPPI/TDSigEI/${s}/FIR_w15_MTD_BC_stats_REML+tlrc | grep "${contrast}#0_Tstat" | grep -o ' #[0-9]\{1,3\}' | grep -o '[0-9]\{1,3\}')
			echo "${s} /home/despoB/TRSEPPI/TDSigEI/${s}/${dset}_w15_MTD_BC_stats_REML+tlrc[${cbrik}] /home/despoB/TRSEPPI/TDSigEI/${s}/${dset}_w15_MTD_BC_stats_REML+tlrc[${tbrik}] \\" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_${dset}_${contrast}.sh
		done

		echo "-cio -mask /home/despoB/TRSEPPI/TDSigEI/ROIs/100overlap_mask+tlrc " >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_${dset}_${contrast}.sh

		#qsub -l mem_free=3G -V -M kaihwang -m e -e ~/tmp -o ~/tmp /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_${dset}_${contrast}.sh
		. /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_${dset}_${contrast}.sh

	done
done





