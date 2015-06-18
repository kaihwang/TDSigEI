
#!/bin/bash

#run preprocessMprage on subjects.

WD='/home/despoB/TRSEPPI/TDSigEI'

for s in P001; do
	cd ${WD}/${s}/MPRAGE

	if [ ! -e ${WD}/${s}/MPRAGE/mprage_final.nii.gz ]; then
		
		preprocessMprage -r MNI_2mm -b "-R -f 0.46 -g -0.5" -d a -no_bias -o mprage_final.nii.gz -p "IM*"
	fi
	

done
