
# flip the sign of betas and tstats for later permutation test
#MTD_Target-Baseline 98 99
#BC_Target-Baseline 126 127
#BC_Attn-Baseline_VC 138 139

cd /home/despoB/kaihwang/TRSE/TDSigEI/

for s in $(/bin/ls -d 5*); do #$(/bin/ls -d 5*)
	
	cd /home/despoB/kaihwang/TRSE/TDSigEI/${s}
	3dcalc -a FIR_w15_MTD_BC_stats_REML+tlrc[98] -expr "-1*a" -prefix mtdbeta
	3dcalc -a FIR_w15_MTD_BC_stats_REML+tlrc[99] -expr "-1*a" -prefix mtdt
	3dcalc -a FIR_w15_MTD_BC_stats_REML+tlrc[126] -expr "-1*a" -prefix bcbeta
	3dcalc -a FIR_w15_MTD_BC_stats_REML+tlrc[127] -expr "-1*a" -prefix bct
	3dcalc -a FIR_w15_MTD_BC_stats_REML+tlrc[138] -expr "-1*a" -prefix vcbeta
	3dcalc -a FIR_w15_MTD_BC_stats_REML+tlrc[139] -expr "-1*a" -prefix vct

	3dTcat -prefix betas_for_permute \
	FIR_w15_MTD_BC_stats_REML+tlrc[98] FIR_w15_MTD_BC_stats_REML+tlrc[99] \
	mtdbeta+tlrc mtdt+tlrc \
	FIR_w15_MTD_BC_stats_REML+tlrc[126] FIR_w15_MTD_BC_stats_REML+tlrc[127] \
	bcbeta+tlrc bct+tlrc \
	FIR_w15_MTD_BC_stats_REML+tlrc[138] FIR_w15_MTD_BC_stats_REML+tlrc[139] \
	vcbeta+tlrc vct+tlrc

done