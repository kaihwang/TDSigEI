#!/bin/bash
# create individual functional ROIs

WD='/home/despoB/kaihwang/TRSE/TDSigEI'
cd $WD


#for FFA  PPA
for s in $(ls -d 5*); do
	cd ${WD}/${s}/

	# rm lib_GM_mask.nii.gz
	# rm subject_mask.nii.gz
	# ln -s run1/subject_mask.nii.gz subject_mask.nii.gz
	# 3dcalc -a subject_mask.nii.gz -b WM_orig.nii.gz -c CSF_orig.nii.gz -expr 'ispositive(a-b-c)' -prefix lib_GM_mask.nii.gz

	rm face_v_house_tstat*
	#find brik number with the face v house contrast
	brik_num=$(3dinfo -verb Localizer_PPAFFA_stats_REML+tlrc | grep BaseFaces-Scenes#0_Tstat | grep -o '#[0-9][0-9]' | grep -Eo [0-9]{2})
	# extract contrast
	3dTcat -prefix face_v_house_tstat Localizer_PPAFFA_stats_REML+tlrc[$brik_num]

	#brik_num=3 
	#$(3dinfo -verb Localizer_PPAFFA_stats_REML+tlrc | grep Faces#0_Tstat | grep -o '#[0-9][0-9]' | grep -Eo [0-9]{2})
	# extract contrast
	#3dTcat -prefix face_tstat Localizer_PPAFFA_stats_REML+tlrc[$brik_num]

	#brik_num=9
	# $(3dinfo -verb Localizer_PPAFFA_stats_REML+tlrc | grep Scenes#0_Tstat | grep -o '#[0-9][0-9]' | grep -Eo [0-9]{2})
	# extract contrast
	#3dTcat -prefix house_tstat Localizer_PPAFFA_stats_REML+tlrc[$brik_num]


	# creat individual FFA mask
	rm FFAmasked*
	rm FFA_ROIs*
	rm FFA_indiv_ROI*

	3dcalc \
	-a face_v_house_tstat+tlrc \
	-b /home/despoB/kaihwang/TRSE/TDSigEI/ROIs/Group_FFA_mask.nii.gz \
	-expr 'ispositive(a*b)' -short -prefix FFAmasked.nii.gz
	#fslmaths FFAmasked.nii.gz -thrP 75 FFA_indiv_ROI.nii.gz

	#write out top 50 voxels as ROI
	3dmaskdump -mask FFAmasked.nii.gz -quiet FFAmasked.nii.gz | sort -k4 -n -r | head -n 500 | 3dUndump -master FFAmasked.nii.gz -ijk -prefix FFA_indiv_ROI.nii.gz stdin

	#3dmaxima -input FFAmasked+tlrc -min_dist 4 -spheres_1toN -out_rad 2 -prefix FFA_ROIs -thresh 1
	#3dcalc -a FFA_ROIs+tlrc -b FFAmasked+tlrc -expr 'amongst(a,1)' -prefix FFA_indiv_ROI

	# creat individual PPA mask
	rm PPAmasked*
	rm PPA_ROIs*
	rm PPA_indiv_ROI*
	
	3dcalc \
	-a face_v_house_tstat+tlrc \
	-b /home/despoB/kaihwang/TRSE/TDSigEI/ROIs/Group_PPA_mask.nii.gz \
	-expr 'isnegative(a*b)' -short -prefix PPAmasked.nii.gz
	#fslmaths PPAmasked.nii.gz -thrP 75 PPA_indiv_ROI.nii.gz
	3dmaskdump -mask PPAmasked.nii.gz -quiet PPAmasked.nii.gz | sort -k4 -n -r | head -n 500 | 3dUndump -master PPAmasked.nii.gz -ijk -prefix PPA_indiv_ROI.nii.gz stdin
	
	#3dmaxima -input PPAmasked+tlrc -min_dist 4 -spheres_1toN -out_rad 2 -prefix PPA_ROIs -neg_ext -thresh -1
	#3dcalc -a PPA_ROIs+tlrc -b PPAmasked+tlrc -expr 'amongst(a,1)' -prefix PPA_indiv_ROI
	#-neg_ext is flag for sorting negative peaks
done


# cd $WD

# # for motor
# for s in $(ls -d 5*); do
# 	cd ${WD}/${s}/

# 	#find brik number with the face v house contrast
# 	brik_num=$(3dinfo -verb Localizer_Motor_stats_REML+tlrc | grep BaseRH-LH#0_Tstat | grep -o '#[0-9][0-9]' | grep -Eo [0-9]{2})

# 	# extract contrast
# 	rm RH_v_LH_tstat*
# 	3dTcat -prefix RH_v_LH_tstat Localizer_Motor_stats_REML+tlrc[$brik_num]

# 	# creat individual FFA mask
# 	# note here the group mask is reversed because naming was flipped when creating group mask.
# 	rm RHmasked*
# 	rm RH_masked*
# 	rm RH_ROIs*
# 	rm RH_indiv_ROI*
# 	3dcalc \
# 	-a RH_v_LH_tstat+tlrc \
# 	-b /home/despoB/kaihwang/TRSE/TDSigEI/Group/Group_LH_mask.nii.gz \
# 	-c lib_GM_mask.nii.gz \
# 	-expr 'a*b*c' -short -prefix RHmasked.nii.gz
# 	#fslmaths RHmasked.nii.gz -thrP 75 RH_indiv_ROI.nii.gz
# 	3dmaskdump -mask RHmasked.nii.gz -quiet RHmasked.nii.gz | sort -k4 -n -r | head -n 75 | 3dUndump -master RHmasked.nii.gz -ijk -prefix RH_indiv_ROI.nii.gz stdin
	
# 	#3dmaxima -input RH_masked+tlrc -min_dist 4 -spheres_1toN -out_rad 2 -prefix RH_ROIs -thresh 0.01
# 	#3dcalc -a RH_ROIs+tlrc -expr 'equals(a,1)' -prefix RH_indiv_ROI

# 	# creat individual PPA mask
# 	rm LHmasked*
# 	rm RH_masked*
# 	rm LH_ROIs*
# 	rm LH_indiv_ROI*
# 	3dcalc \
# 	-a RH_v_LH_tstat+tlrc \
# 	-b /home/despoB/kaihwang/TRSE/TDSigEI/Group/Group_RH_mask.nii.gz \
# 	-c lib_GM_mask.nii.gz \
# 	-expr 'a*b*c*(-1)' -short -prefix LHmasked.nii.gz
# 	#fslmaths LHmasked.nii.gz -thrP 75 LH_indiv_ROI.nii.gz
# 	3dmaskdump -mask LHmasked.nii.gz -quiet LHmasked.nii.gz | sort -k4 -n -r | head -n 75 | 3dUndump -master LHmasked.nii.gz -ijk -prefix LH_indiv_ROI.nii.gz stdin
	
# 	#3dmaxima -input LH_masked+tlrc -min_dist 4 -neg_ext -spheres_1toN -out_rad 2 -prefix LH_ROIs -thresh -0.01
# 	#3dcalc -a LH_ROIs+tlrc -expr 'equals(a,1)' -prefix LH_indiv_ROI

# done