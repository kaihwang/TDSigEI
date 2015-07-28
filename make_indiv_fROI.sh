#!/bin/bash
# create individual functional ROIs

WD='/home/despoB/kaihwang/TRSE/TDSigEI'
cd $WD


#for FFA and PPA
# for s in $(ls -d 5*); do
# 	cd ${WD}/${s}/

# 	# fomd brik number with the face v house contrast
# 	brik_num=$(3dinfo -verb Localizer_PPAFFA_stats_REML+tlrc | grep BaseFaces-Scenes#0_Tstat | grep -o '#[0-9][0-9]' | grep -Eo [0-9]{2})

# 	# extract contrast
# 	3dTcat -prefix face_v_house_tstat Localizer_PPAFFA_stats_REML+tlrc[$brik_num]

# 	# creat individual FFA mask
# 	3dcalc -a face_v_house_tstat+tlrc -b /home/despoB/kaihwang/TRSE/TDSigEI/Group/Group_FFA_mask.nii.gz \
# 	-expr 'a*b' -short -prefix face_FFAmasked
# 	3dmaxima -input face_FFAmasked+tlrc -min_dist 6 -spheres_1toN -out_rad 5 -prefix FFA_ROIs -thresh 1
# 	3dcalc -a FFA_ROIs+tlrc -expr 'equals(a,1)' -prefix FFA_indiv_ROI

# 	# creat individual PPA mask
# 	3dcalc -a face_v_house_tstat+tlrc -b /home/despoB/kaihwang/TRSE/TDSigEI/Group/Group_PPA_mask.nii.gz \
# 	-expr 'a*b' -short -prefix house_PPAmasked
# 	3dmaxima -input house_PPAmasked+tlrc -min_dist 6 -neg_ext -spheres_1toN -out_rad 5 -prefix PPA_ROIs -thresh -1
# 	3dcalc -a PPA_ROIs+tlrc -expr 'equals(a,1)' -prefix PPA_indiv_ROI

# done


cd $WD

for s in $(ls -d 5*); do
	cd ${WD}/${s}/

	# fomd brik number with the face v house contrast
	brik_num=$(3dinfo -verb Localizer_Motor_stats_REML+tlrc | grep BaseRH-LH#0_Tstat | grep -o '#[0-9][0-9]' | grep -Eo [0-9]{2})

	# extract contrast
	3dTcat -prefix RH_v_LH_tstat Localizer_Motor_stats_REML+tlrc[$brik_num]

	# creat individual FFA mask
	# note here the mask is reversed because naming was flipped when creating group mask.
	3dcalc -a RH_v_LH_tstat+tlrc -b /home/despoB/kaihwang/TRSE/TDSigEI/Group/Group_LH_mask.nii.gz \
	-expr 'a*b' -short -prefix RH_masked
	3dmaxima -input RH_masked+tlrc -min_dist 6 -spheres_1toN -out_rad 5 -prefix RH_ROIs -thresh 0.01
	3dcalc -a RH_ROIs+tlrc -expr 'equals(a,1)' -prefix RH_indiv_ROI

	# creat individual PPA mask
	3dcalc -a RH_v_LH_tstat+tlrc -b /home/despoB/kaihwang/TRSE/TDSigEI/Group/Group_RH_mask.nii.gz \
	-expr 'a*b' -short -prefix LH_masked
	3dmaxima -input LH_masked+tlrc -min_dist 6 -neg_ext -spheres_1toN -out_rad 5 -prefix LH_ROIs -thresh -0.01
	3dcalc -a LH_ROIs+tlrc -expr 'equals(a,1)' -prefix LH_indiv_ROI

done