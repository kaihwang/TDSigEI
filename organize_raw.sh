#!/bin/bash


WD='/home/despoB/kaihwang/TDSigEI'

cd ${WD}
for subj in $(ls -d *); do

	cd ${WD}/${subj}

	mprage_dir=$(ls -d MEMPRAGE_P2_RMS*)

	if [ ! -d MPRAGE ]; then
		ln -s MPRAGE ${mprage_dir}
	fi	
	
	BOLD_DIRs=($(ls -d tmsMRI_sequence_PA_TR1500_4mm_* | sort -V))

	for r in $(seq 1 14); do
		i=$(($r-1))

		if [ ! -d run${r} ]; then
			ln -s run${r} ${BOLD_DIRs[i]}
		fi


	done
	




done