#!/bin/bash
# create individual functional ROIs

WD='/home/despoB/kaihwang/TRSE/TDSigEI'
cd $WD


#for FFA  PPA
for s in $(ls -d 5*); do
	cd ${WD}/${s}/

	# fomd brik number with the face v house contrast
	#brik_num=$(3dinfo -verb Localizer_PPAFFA_stats_REML+tlrc | grep BaseFaces-Scenes#0_Tstat | grep -o '#[0-9][0-9]' | grep -Eo [0-9]{2})
	# extract contrast
	#3dTcat -prefix face_v_house_tstat Localizer_PPAFFA_stats_REML+tlrc[$brik_num]

	#brik_num=3 
	#$(3dinfo -verb Localizer_PPAFFA_stats_REML+tlrc | grep Faces#0_Tstat | grep -o '#[0-9][0-9]' | grep -Eo [0-9]{2})
	# extract contrast
	#3dTcat -prefix face_tstat Localizer_PPAFFA_stats_REML+tlrc[$brik_num]

	#brik_num=9
	# $(3dinfo -verb Localizer_PPAFFA_stats_REML+tlrc | grep Scenes#0_Tstat | grep -o '#[0-9][0-9]' | grep -Eo [0-9]{2})
	# extract contrast
	#3dTcat -prefix house_tstat Localizer_PPAFFA_stats_REML+tlrc[$brik_num]


	# creat individual FFA mask
	rm FFAmasked.nii.gz
	3dcalc -a face_v_house_tstat+tlrc -b /home/despoB/kaihwang/TRSE/TDSigEI/ROIs/Group_FFA_mask.nii.gz \
	-expr '(ispositive(a*b))*a' -short -prefix FFAmasked.nii.gz
	fslmaths FFAmasked.nii.gz -thrP 95 FFA_indiv_ROI.nii.gz
	#3dmaxima -input FFAmasked+tlrc -min_dist 6 -spheres_1toN -out_rad 2 -prefix FFA_ROIs -thresh 1
	#3dcalc -a FFA_ROIs+tlrc -b FFAmasked+tlrc -expr 'amongst(a,1)' -prefix FFA_indiv_ROI

	# creat individual PPA mask
	rm PPAmasked.nii.gz
	3dcalc -a face_v_house_tstat+tlrc -b /home/despoB/kaihwang/TRSE/TDSigEI/ROIs/Group_PPA_mask.nii.gz \
	-expr '(isnegative(a*b))*a*(-1)' -short -prefix PPAmasked.nii.gz
	fslmaths PPAmasked.nii.gz -thrP 95 PPA_indiv_ROI.nii.gz
	#3dmaxima -input PPAmasked+tlrc -min_dist 6 -spheres_1toN -out_rad 2 -prefix PPA_ROIs -neg_ext -thresh -1
	#3dcalc -a PPA_ROIs+tlrc -b PPAmasked+tlrc -expr 'amongst(a,1)' -prefix PPA_indiv_ROI
	#-neg_ext is flag for sorting negative peaks
done


# cd $WD

# for s in $(ls -d 5*); do
# 	cd ${WD}/${s}/

# 	# fomd brik number with the face v house contrast
# 	brik_num=$(3dinfo -verb Localizer_Motor_stats_REML+tlrc | grep BaseRH-LH#0_Tstat | grep -o '#[0-9][0-9]' | grep -Eo [0-9]{2})

# 	# extract contrast
# 	3dTcat -prefix RH_v_LH_tstat Localizer_Motor_stats_REML+tlrc[$brik_num]

# 	# creat individual FFA mask
# 	# note here the mask is reversed because naming was flipped when creating group mask.
# 	3dcalc -a RH_v_LH_tstat+tlrc -b /home/despoB/kaihwang/TRSE/TDSigEI/Group/Group_LH_mask.nii.gz \
# 	-expr 'a*b' -short -prefix RH_masked
# 	3dmaxima -input RH_masked+tlrc -min_dist 4 -spheres_1toN -out_rad 3 -prefix RH_ROIs -thresh 0.01
# 	3dcalc -a RH_ROIs+tlrc -expr 'equals(a,1)' -prefix RH_indiv_ROI

# 	# creat individual PPA mask
# 	3dcalc -a RH_v_LH_tstat+tlrc -b /home/despoB/kaihwang/TRSE/TDSigEI/Group/Group_RH_mask.nii.gz \
# 	-expr 'a*b' -short -prefix LH_masked
# 	3dmaxima -input LH_masked+tlrc -min_dist 4 -neg_ext -spheres_1toN -out_rad 3 -prefix LH_ROIs -thresh -0.01
# 	3dcalc -a LH_ROIs+tlrc -expr 'equals(a,1)' -prefix LH_indiv_ROI

# done