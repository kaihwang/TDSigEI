#!/bin/bash

#for SGE jobs


WD='/home/despoB/TRSEPPI/TDSigEI'
SCRIPTS='/home/despoB/lyang/TDSigEI'

cd ${WD}

for Subject in 503 505 509 511 513; do
	
	#if [ ! -e "${WD}/${Subject}/MPRAGE/${Subject}_MNI_final.nii.gz" ]; then
	#	sed "s/s in 107/s in ${Subject}/g" < ${SCRIPT}/preproc_mprage.sh > ${SCRIPT}/tmp/mprage_${Subject}.sh
	#	qsub -V -M kaihwang -m e -e ~/tmp -o ~/tmp ${SCRIPT}/tmp/mprage_${Subject}.sh  #-l mem_free=5G
	#fi	

	for r in $(seq 1 1 24); do
	
		if [ ! -e "${WD}/${Subject}/run${r}/nswdktm_functional_6.nii.gz" ]; then
			sed "s/s in P001/s in ${Subject}/g; s/run1/run${r}/g " < ${SCRIPTS}/proc_functional.sh > /home/despoB/lyang/tmp/proc_functional_${Subject}_${r}.sh 
			qsub -V -M lyang -m e -e ~/tmp -o ~/tmp /home/despoB/lyang/tmp/proc_functional_${Subject}_${r}.sh   #-l mem_free=5G
		fi
	done

done


# for Subject in $(ls -d *) ; do

# 	if [ ! -e ${WD}/${Subject}/MPRAGE/mprage_final.nii.gz ]; then
# 		sed "s/s in P001/s in ${Subject}/g" < ${SCRIPTS}/proc_mprage.sh> /home/despoB/kaihwang/tmp/proc_mprage_${Subject}.sh
# 		qsub -V -M kaihwang -m e -e ~/tmp -o ~/tmp /home/despoB/kaihwang/tmp/proc_mprage_${Subject}.sh
# 	fi	
# done
