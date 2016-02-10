WD='/home/despoB/kaihwang/TRSE/TDSigEI'
SCRIPTS='/home/despoB/kaihwang/TRSE/TDSigEI/Scripts'

cd ${WD}
for s in $(ls -d 5*); do #$(ls -d 5*)

	cd $SUBJECTS_DIR/${s}/mri
	#mri_convert -rl rawavg.mgz -rt nearest aparc.a2009s+aseg.mgz ${WD}/${s}/MPRAGE/aparc.a2009s_aseg.nii.gz
	tkregister2 --mov rawavg.mgz --noedit --s ${s} --regheader --reg /home/despoB/kaihwang/Subjects/${s}/mri/register.dat
	
	for ROI in V1 V2; do
		for hemisphere in rh lh; do
			cd $SUBJECTS_DIR/${s}/label
			mri_label2vol --label ${hemisphere}.${ROI}.label --temp \
			/home/despoB/kaihwang/Subjects/${s}/mri/rawavg.mgz \
			--subject ${s} --hemi ${hemisphere} \
			--o ${WD}/${s}/MPRAGE/${hemisphere}_${ROI}.nii.gz --proj frac 0 1 .1 --fillthresh 1 \
			--reg ../mri/register.dat
			
			cd ${WD}/${s}/MPRAGE/
			fslreorient2std ${WD}/${s}/MPRAGE/${hemisphere}_${ROI}.nii.gz ${WD}/${s}/MPRAGE/${hemisphere}_${ROI}.nii.gz

			applywarp --ref=mprage_final.nii.gz \
			--rel \
			--interp=nn \
			--in=${WD}/${s}/MPRAGE/${hemisphere}_${ROI}.nii.gz \
			--warp=mprage_warpcoef.nii.gz \
			-o ${WD}/${s}/PrimVis_${hemisphere}_${ROI}.nii.gz
		done
	done

	rm ${WD}/${s}/V1_indiv_ROI.nii.gz
	rm ${WD}/${s}/V2_indiv_ROI.nii.gz

	#3dcalc -a aparc.a2009s_aseg_mni.nii.gz -expr 'amongst(a,11145,21145)' -prefix ${WD}/${s}/PrimVis_indiv_ROI.nii.gz
	for ROI in V1 V2; do

		3dcalc -a ${WD}/${s}/PrimVis_rh_${ROI}.nii.gz \
		-b ${WD}/${s}/PrimVis_lh_${ROI}.nii.gz \
		-expr 'a+b' -prefix ${WD}/${s}/${ROI}_indiv_ROI.nii.gz
	done	
done

#tkregister2 --mov rawavg.mgz --noedit --s 550 --regheader --reg /home/despoB/kaihwang/Subjects/550/mri/register.dat

# mri_label2vol --label rh.V1.label --temp \
# /home/despoB/kaihwang/Subjects/550/mri/rawavg.mgz \
# --subject 550 --hemi rh \
# --o rh_V1.nii.gz --proj frac 0 1 .1 --fillthresh .3 \
# --reg ../mri/register.dat
