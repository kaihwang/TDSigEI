WD='/home/despoB/kaihwang/TRSE/TDSigEI'
cd $WD

echo "" > ~/MTD_More_MD_rs
echo "" > ~/MTD_More_AN_rs
echo "" > ~/MTD_More_PuM_rs
echo "" > ~/MTD_More_intralaminar_rs

for s in $(ls -d 5*); do

	for ROIs in More_MD_rs More_AN_rs More_PuM_rs More_intralaminar_rs; do
		3dmaskave -mask ~/Rest/ROIs/${ROIs}+tlrc -quiet ${WD}/${s}/FIR_MTD_BC_stats+tlrc[87] >> ~/MTD_${ROIs}
		#3dmaskave -mask ~/Rest/ROIs/${ROIs} -quiet FIR_MTD_BC_stats_REML+tlrc[87] > ~/MTD_${ROIs}
		#3dmaskave -mask ~/Rest/ROIs/${ROIs} -quiet nusiancF_MTD_BC_stats_REML+tlrc[111] > ~/MTD_${ROIs}
		#3dmaskave -mask ~/Rest/ROIs/${ROIs} -quiet nusianc_MTD_BC_stats_REML+tlrc[115] > ~/MTD_${ROIs}

	done

done

cd ~