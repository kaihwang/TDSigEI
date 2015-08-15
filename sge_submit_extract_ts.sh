#!/bin/bash

#for SGE jobs

#mkdir tmp;
WD='/home/despoB/TRSEPPI/TDSigEI'
SCRIPTS='/home/despoB/kaihwang/bin/TDSigEI'

cd ${WD}

for Subject in $(ls -d 5*); do

	sed "s/s in 503/s in ${Subject}/g" < ${SCRIPTS}/extract_sc_ts.sh> ~/tmp/ts_${Subject}.sh
	qsub -V -M kaihwang -m e -e ~/tmp -o ~/tmp ~/tmp/ts_${Subject}.sh
		


done
