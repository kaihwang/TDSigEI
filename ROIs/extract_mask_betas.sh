WD='/home/despoB/kaihwang/TRSE/TDSigEI'
cd $WD

echo "" > /home/despoB/kaihwang/bin/TDSigEI/Data/BC_FEF_FH_FFA
echo "" > /home/despoB/kaihwang/bin/TDSigEI/Data/BC_FEF_HF_FFA
echo "" > /home/despoB/kaihwang/bin/TDSigEI/Data/BC_IPS_FH_FFA
echo "" > /home/despoB/kaihwang/bin/TDSigEI/Data/BC_IPS_HF_FFA
echo "" > /home/despoB/kaihwang/bin/TDSigEI/Data/BC_FEF_FH_PPA
echo "" > /home/despoB/kaihwang/bin/TDSigEI/Data/BC_FEF_HF_PPA
echo "" > /home/despoB/kaihwang/bin/TDSigEI/Data/BC_IPS_FH_PPA
echo "" > /home/despoB/kaihwang/bin/TDSigEI/Data/BC_IPS_HF_PPA
echo "" > /home/despoB/kaihwang/bin/TDSigEI/Data/MTD_MFG_HF_FFA
echo "" > /home/despoB/kaihwang/bin/TDSigEI/Data/MTD_MFG_FH_FFA
echo "" > /home/despoB/kaihwang/bin/TDSigEI/Data/MTD_MFG_HF_PPA
echo "" > /home/despoB/kaihwang/bin/TDSigEI/Data/MTD_MFG_FH_PPA

for s in $(/bin/ls -d 5*); do

	for ROI in BC_FEF BC_IPS; do
		3dmaskave -mask /home/despoB/kaihwang/TRSE/TDSigEI/ROIs/${ROI}.nii.gz \
		-quiet ${WD}/${s}/nusiance_MTD_BC_stats_REML+tlrc[35] >> /home/despoB/kaihwang/bin/TDSigEI/Data/${ROI}_FH_FFA
		
		3dmaskave -mask /home/despoB/kaihwang/TRSE/TDSigEI/ROIs/${ROI}.nii.gz \
		-quiet ${WD}/${s}/nusiance_MTD_BC_stats_REML+tlrc[39] >> /home/despoB/kaihwang/bin/TDSigEI/Data/${ROI}_FH_PPA

		3dmaskave -mask /home/despoB/kaihwang/TRSE/TDSigEI/ROIs/${ROI}.nii.gz \
		-quiet ${WD}/${s}/nusiance_MTD_BC_stats_REML+tlrc[43] >> /home/despoB/kaihwang/bin/TDSigEI/Data/${ROI}_HF_FFA
		
		3dmaskave -mask /home/despoB/kaihwang/TRSE/TDSigEI/ROIs/${ROI}.nii.gz \
		-quiet ${WD}/${s}/nusiance_MTD_BC_stats_REML+tlrc[47] >> /home/despoB/kaihwang/bin/TDSigEI/Data/${ROI}_HF_PPA



		#3dmaskave -mask ~/Rest/ROIs/${ROIs} -quiet FIR_MTD_BC_stats_REML+tlrc[87] > ~/MTD_${ROIs}
		#3dmaskave -mask ~/Rest/ROIs/${ROIs} -quiet nusiancF_MTD_BC_stats_REML+tlrc[111] > ~/MTD_${ROIs}
		#3dmaskave -mask ~/Rest/ROIs/${ROIs} -quiet nusianc_MTD_BC_stats_REML+tlrc[115] > ~/MTD_${ROIs}

	done

	for ROI in MTD_MFG; do
		3dmaskave -mask /home/despoB/kaihwang/TRSE/TDSigEI/ROIs/${ROI}.nii.gz \
		-quiet ${WD}/${s}/FIR_MTD_BC_stats_REML+tlrc[3] >> /home/despoB/kaihwang/bin/TDSigEI/Data/${ROI}_FH_FFA
		
		3dmaskave -mask /home/despoB/kaihwang/TRSE/TDSigEI/ROIs/${ROI}.nii.gz \
		-quiet ${WD}/${s}/FIR_MTD_BC_stats_REML+tlrc[7] >> /home/despoB/kaihwang/bin/TDSigEI/Data/${ROI}_FH_PPA

		3dmaskave -mask /home/despoB/kaihwang/TRSE/TDSigEI/ROIs/${ROI}.nii.gz \
		-quiet ${WD}/${s}/FIR_MTD_BC_stats_REML+tlrc[11] >> /home/despoB/kaihwang/bin/TDSigEI/Data/${ROI}_HF_FFA
		
		3dmaskave -mask /home/despoB/kaihwang/TRSE/TDSigEI/ROIs/${ROI}.nii.gz \
		-quiet ${WD}/${s}/FIR_MTD_BC_stats_REML+tlrc[15] >> /home/despoB/kaihwang/bin/TDSigEI/Data/${ROI}_HF_PPA



		#3dmaskave -mask ~/Rest/ROIs/${ROIs} -quiet FIR_MTD_BC_stats_REML+tlrc[87] > ~/MTD_${ROIs}
		#3dmaskave -mask ~/Rest/ROIs/${ROIs} -quiet nusiancF_MTD_BC_stats_REML+tlrc[111] > ~/MTD_${ROIs}
		#3dmaskave -mask ~/Rest/ROIs/${ROIs} -quiet nusianc_MTD_BC_stats_REML+tlrc[115] > ~/MTD_${ROIs}

	done

done

cd ~