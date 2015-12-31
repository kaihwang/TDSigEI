#!/bin/bash
# script for group analysis of MTD regression. 
# use MVM for 3way ANOVAs


CONDITIONS=(TD P D)

for dset in nusianceReg FIRReg; do
	echo "cd /home/despoB/kaihwang/TRSE/TDSigEI/Group 
	3dMVM -prefix groupstat_MTD_${dset}_vis-m.nii.gz \\
	-bsVars "1" \\
	-cio \\
	-wsVars "roi*condition*match" \\
	-num_glt 15 \\
	-gltLabel 1 TD_vs_P_M -gltCode 1 'condition : 1*TD -1*P match : 1*M' \\
	-gltLabel 2 TD_vs_P_NM -gltCode 2 'condition : 1*TD -1*P match : 1*NM' \\
	-gltLabel 3 D_vs_P_M -gltCode 3 'condition : 1*D -1*P match : 1*M' \\
	-gltLabel 4 D_vs_P_NM -gltCode 4 'condition : 1*D -1*P match : 1*NM' \\
	-gltLabel 5 TD_vs_D_M -gltCode 5 'condition : 1*TD -1*D match : 1*M' \\
	-gltLabel 6 TD_vs_D_NM -gltCode 6 'condition : 1*TD -1*D match : 1*NM' \\
	-gltLabel 7 TD_M -gltCode 7 'condition : 1*TD match : 1*M' \\
	-gltLabel 8 D_M -gltCode 8 'condition : 1*D match : 1*M' \\
	-gltLabel 9 P_M -gltCode 9 'condition : 1*P match : 1*M' \\
	-gltLabel 10 TD_NM -gltCode 10 'condition : 1*TD match : 1*NM' \\
	-gltLabel 11 D_NM -gltCode 11 'condition : 1*D match : 1*NM' \\
	-gltLabel 12 P_NM -gltCode 12 'condition : 1*P match : 1*NM' \\
	-gltLabel 13 TD_M_vs_NM -gltCode 13 'condition : 1*TD match : 1*M -1*NM' \\
	-gltLabel 14 D_M_vs_NM -gltCode 14 'condition : 1*D match : 1*M -1*NM' \\
	-gltLabel 15 P_M_vs_NM -gltCode 15 'condition : 1*P match : 1*M -1*NM' \\
	-dataTable \\
	Subj roi condition match InputFile \\" > /home/despoB/kaihwang/TRSE/TDSigEI/Group/tmp

	cd /home/despoB/kaihwang/TRSE/TDSigEI/

	n=1
	for s in $(/bin/ls -d 5*); do
		
		r=1
		for ROI in FFA; do
			c=0
			for condition in FH Fp HF; do

				for match in M NM; do
					echo "	${s} ${ROI} ${CONDITIONS[c]} ${match} /home/despoB/TRSEPPI/TDSigEI/${s}/MTD_${dset}_${condition}_${ROI}-${match}_stats+tlrc'[2]' \\" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/tmp
				done
				c=$(($c+1))
			done
		done

		r=2
		for ROI in PPA; do
			c=0
			for condition in HF Hp FH; do
				for match in M NM; do
					echo "	${s} ${ROI} ${CONDITIONS[c]} ${match} /home/despoB/TRSEPPI/TDSigEI/${s}/MTD_${dset}_${condition}_${ROI}-${match}_stats+tlrc'[2]' \\" >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/tmp
				done
				c=$(($c+1))
			done
		done

		n=$(($n+1))
	done
	sed '$ s/.$//' /home/despoB/kaihwang/TRSE/TDSigEI/Group/tmp > /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_MTD_vis-m_${dset}.sh
	rm /home/despoB/kaihwang/TRSE/TDSigEI/Group/tmp
	. /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_MTD_vis-m_${dset}.sh
done

