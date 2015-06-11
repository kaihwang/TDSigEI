#!/bin/bash


WD='/home/despoB/TRSEPPI/TDSigEI'

cd ${WD}
for subj in $(ls -d *); do

	cd ${WD}/${subj}

	mprage_dir=$(ls -d MEMPRAGE_P2_RMS*)

	if [ ! -d ${WD}/${subj}/MPRAGE ]; then
		ln -s ${mprage_dir} MPRAGE
	fi	
	
	BOLD_DIRs=($(ls -d tmsMRI_sequence_PA_TR1500_4mm_* | sort -V))

	for r in $(seq 1 24); do
		i=$(($r-1))

		if [ ! -d ${WD}/${subj}/run${r} ]; then
			ln -s ${BOLD_DIRs[i]} run${r}
		fi


	done
	




done
