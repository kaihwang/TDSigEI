#!/bin/bash
# script for group analysis of MTD regression. using 3dMEMA taking within subject GLT to group level
# reviewer being picky so wrote a permutation version.

RANDOM=$$$(date +%s)

#To use an array, data sets must be named with a sequential, numeric value (e.g. sub1, sub2, sub3).
#To define the array, use the qsub -t option, followed by the numeric value, e.g. ‘-t 1-3’.
#Your script will be run once for each number in the array. The array value may be referenced in your script as the SGE_TASK_ID variable.

#### here are the list of briks numbers to permute, sign was flipped in 3dDeconvolve (but make sure use the MTDperm version)
# for MTD_Target-Baseline
#MTD_TargetvsBaseline=(0 2)

# for BC_Target-Baseline
#BC_TargetvsBaseline=(4 6)

# for BC_Attn-Baseline_VC
#BC_AttnvsBaseline_VC=(8 10)

# 3dclust on brik 1, thresh 2.06
# 3dclust -dxyz=1 -1thresh 2.06 0 0 FIR_MTD_Target-Baseline_w15_groupMEMA+tlrc[1] > tmp
# cat tmp | head -n 13 | tail -n 1 | awk '{print $1}'

for i in ${SGE_TASK_ID}; do
	for contrast in MTD_TargetvsBaseline BC_TargetvsBaseline BC_AttnvsBaseline_VC; do
		echo "#!/bin/bash
		cd /home/despoB/kaihwang/TRSE/TDSigEI/Group 
		3dMEMA -prefix /home/despoB/kaihwang/TRSE/TDSigEI/Group/${contrast}_groupMEMA_perm${i} \\
		-set ${contrast} \\" > /home/despoB/kaihwang/tmp/${contrast}_groupMEMA_perm${i}.sh

		cd /home/despoB/kaihwang/TRSE/TDSigEI/

		for s in $(/bin/ls -d 5*); do

			case ${contrast} in
				MTD_TargetvsBaseline )
					briks=(0 2);;
				BC_TargetvsBaseline )
					briks=(4 6);;
				BC_AttnvsBaseline_VC )
					briks=(8 10);;		
			esac
			
			permutedbrik=${briks[$RANDOM % ${#briks[@]} ]}
			tbrik=$((permutedbrik+1))

			echo "${s} /home/despoB/TRSEPPI/TDSigEI/${s}/betas_for_permute+tlrc[${permutedbrik}] /home/despoB/TRSEPPI/TDSigEI/${s}/betas_for_permute+tlrc[${tbrik}] \\" >> /home/despoB/kaihwang/tmp/${contrast}_groupMEMA_perm${i}.sh
		done

		echo "-cio -mask /home/despoB/TRSEPPI/TDSigEI/ROIs/100overlap_mask+tlrc " >> /home/despoB/kaihwang/tmp/${contrast}_groupMEMA_perm${i}.sh

		#save cluster outputs
		echo "3dclust -dxyz=1 -1thresh 2.06 0 0 /home/despoB/kaihwang/TRSE/TDSigEI/Group/${contrast}_groupMEMA_perm${i}+tlrc[1] > /home/despoB/kaihwang/tmp/${contrast}_groupMEMA_perm${i}" >> /home/despoB/kaihwang/tmp/${contrast}_groupMEMA_perm${i}.sh

		#save largest cluster size to file
		echo "cat /home/despoB/kaihwang/tmp/${contrast}_groupMEMA_perm${i} | head -n 13 | tail -n 1 | awk '{print $1}' >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/${contrast}_clusters" >> /home/despoB/kaihwang/tmp/${contrast}_groupMEMA_perm${i}.sh
		echo "rm /home/despoB/kaihwang/TRSE/TDSigEI/Group/${contrast}_groupMEMA_perm${i}* " >> /home/despoB/kaihwang/tmp/${contrast}_groupMEMA_perm${i}.sh
		
		#qsub -l mem_free=3G -V -t 1-2 -M kaihwang -m e -e ~/tmp -o ~/tmp /home/despoB/kaihwang/TRSE/TDSigEI/Group/groupstat_${dset}_${contrast}.sh
		. /home/despoB/kaihwang/tmp/${contrast}_groupMEMA_perm${i}.sh

	done
done



#cbrik=$(3dinfo -verb /home/despoB/TRSEPPI/TDSigEI/${s}/FIR_w${w}_MTD_BC_stats_REML+tlrc | grep "${contrast}#0_Coef" | grep -o ' #[0-9]\{1,3\}' | grep -o '[0-9]\{1,3\}')
#tbrik=$(3dinfo -verb /home/despoB/TRSEPPI/TDSigEI/${s}/FIR_w${w}_MTD_BC_stats_REML+tlrc | grep "${contrast}#0_Tstat" | grep -o ' #[0-9]\{1,3\}' | grep -o '[0-9]\{1,3\}')