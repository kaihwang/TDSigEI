WD='/home/despoB/kaihwang/TRSE/TDSigEI'
SCRIPTS='/home/despoB/kaihwang/TRSE/TDSigEI/Scripts'

cd ${WD}
for s in $(ls -d 5*); do

	cd $SUBJECTS_DIR/${s}/mri
	mri_convert -rl rawavg.mgz -rt nearest aparc+aseg.mgz ${WD}/${s}/MPRAGE/aparc_aseg.nii.gz
	cd ${WD}/${s}/MPRAGE/
	fslreorient2std aparc_aseg.nii.gz aparc_aseg.nii.gz

	applywarp --ref=mprage_final.nii.gz \
	--rel \
	--interp=nn \
	--in=aparc_aseg.nii.gz \
	--warp=mprage_warpcoef.nii.gz \
	-o aparc_aseg_mni.nii.gz

	3dcalc -a aparc_aseg_mni.nii.gz -expr 'amongst(a,2013,1013)' -prefix ${WD}/${s}/PrimVis_indiv_ROI.nii.gz

done




