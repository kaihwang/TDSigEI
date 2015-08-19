#!/bin/bash

#for SGE jobs

#mkdir tmp;
WD='/home/despoB/TRSEPPI/TDSigEI'
SCRIPTS='/home/despoB/kaihwang/bin/TDSigEI'

cd ${WD}

for Subject in $(ls -d 5*); do

	# if [ ! -e ${WD}/${Subject}/gPPI_PPA_Full_model_stats_REMLvar+tlrc.HEAD ]; then
	# 	sed "s/s in 503/s in ${Subject}/g" < ${SCRIPTS}/run_PPI_model.sh> ~/tmp/PPI_${Subject}.sh
	# 	qsub -l mem_free=5G -V -M kaihwang -m e -e ~/tmp -o ~/tmp ~/tmp/PPI_${Subject}.sh
	# fi	

	#if [ ! -e ${WD}/${Subject}/${Subject}_FIR_Hp_errts.nii.gz ]; then
	sed "s/s in 503/s in ${Subject}/g" < ${SCRIPTS}/run_localizer.sh> ~/tmp/loc_${Subject}.sh
	qsub -l mem_free=5G -V -M kaihwang -m e -e ~/tmp -o ~/tmp ~/tmp/loc_${Subject}.sh
	#fi	
done
