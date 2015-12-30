WD='/home/despoB/kaihwang/TRSE/TDSigEI'
SCRIPTS='/home/despoB/kaihwang/TRSE/TDSigEI/Scripts'

cd ${WD}
for s in $(ls -d 5*); do

	cd $SUBJECTS_DIR/${s}/mri
	mri_convert -rl rawavg.mgz -rt nearest aparc.a2009s+aseg.mgz ${WD}/${s}/MPRAGE/aparc.a2009s_aseg.nii.gz
	cd ${WD}/${s}/MPRAGE/
	fslreorient2std aparc.a2009s_aseg.nii.gz aparc.a2009s_aseg.nii.gz

	applywarp --ref=mprage_final.nii.gz \
	--rel \
	--interp=nn \
	--in=aparc.a2009s_aseg.nii.gz \
	--warp=mprage_warpcoef.nii.gz \
	-o aparc.a2009s_aseg_mni.nii.gz

	rm ${WD}/${s}/PrimVis_indiv_ROI.nii.gz
	
	3dcalc -a aparc.a2009s_aseg_mni.nii.gz -expr 'amongst(a,11145,21145)' -prefix ${WD}/${s}/PrimVis_indiv_ROI.nii.gz

done




