#!/bin/bash


WD='/home/despoB/TRSEPPI/TDSigEI'

cd ${WD}
for subj in $(ls -d 5*); do
	if [ "${subj}" != "Raw" ]; then
		cd ${WD}/${subj}

		mprage_dir=$(ls -d MEMPRAGE_P2_RMS*)

		if [ ! -d ${WD}/${subj}/MPRAGE ]; then
			ln -s ${mprage_dir} MPRAGE
		fi	
	
		BOLD_DIRs=($(ls -d tmsMRI_sequence_PA_TR1500_4mm_* | sort -V))

		for r in $(seq 1 24); do
			i=$(($r-1))
	
			if [ $i -le ${#BOLD_DIRs[@]} ] && [ ! -L ${WD}/${subj}/run${r} ]; then
				echo ${BOLD_DIRs[i]}
				ln -s ${BOLD_DIRs[i]} run${r}
				
			fi

		done
	fi

done
