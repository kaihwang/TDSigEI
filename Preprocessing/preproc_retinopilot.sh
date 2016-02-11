
for run in run1 run2 run5 run6; do
	cd /home/despoB/kaihwang/TRSE/Retinotopy_Pilot/pilotsub/${run}
	preprocessFunctional \
	-startover \
	-despike \
	-mprage_bet /home/despoB/kaihwang/TRSE/Retinotopy_Pilot/pilotsub/SUMA/brain.nii \
	-tr 2 \
	-threshold 98_2 \
	-rescaling_method 100_voxelmean \
	-template_brain MNI_2mm \
	-func_struc_dof bbr \
	-no_hp \
	-no_warp \
	-no_smooth \
	-warpcoef /home/despoB/kaihwang/TRSE/Retinotopy_Pilot/pilotsub/MPRAGE/mprage_warpcoef.nii.gz \
	-delete_dicom archive \
	-slice_acquisition seqdesc \
	-4d functional.nii.gz
	#applyxfm4D ndktm_functional.nii.gz ../SUMA/brain.nii ndktm_functional_a.nii.gz func_to_struct.mat -singlematrix

	align_epi_anat.py -epi mc_target_brain.nii.gz -anat ../SUMA/brain.nii -anat_has_skull no -epi_base 0 -epi2anat -child_epi ndktm_functional.nii.gz -epi_strip None -volreg off -tshift off -master_epi SOURCE -ginormous_move
done

for run in run3 run4; do
	cd /home/despoB/kaihwang/TRSE/Retinotopy_Pilot/pilotsub/${run}
	preprocessFunctional \
	-startover \
	-despike \
	-mprage_bet /home/despoB/kaihwang/TRSE/Retinotopy_Pilot/pilotsub/SUMA/brain.nii \
	-tr 2.5 \
	-threshold 98_2 \
	-rescaling_method 100_voxelmean \
	-template_brain MNI_2mm \
	-func_struc_dof bbr \
	-no_hp \
	-no_warp \
	-no_smooth \
	-warpcoef /home/despoB/kaihwang/TRSE/Retinotopy_Pilot/pilotsub/MPRAGE/mprage_warpcoef.nii.gz \
	-delete_dicom archive \
	-slice_acquisition seqdesc \
	-4d functional.nii.gz
	
	align_epi_anat.py -epi mc_target_brain.nii.gz -anat ../SUMA/brain.nii -anat_has_skull no -epi_base 0 -epi2anat -child_epi ndktm_functional.nii.gz -epi_strip None -volreg off -tshift off -master_epi SOURCE -ginormous_move
done