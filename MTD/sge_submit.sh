#!/bin/bash

#for SGE jobs

#mkdir tmp;
WD='/home/despoB/TRSEPPI/TDSigEI'
SCRIPTS='/home/despoB/kaihwang/bin/TDSigEI'

cd ${WD}

for Subject in $(/bin/ls -d 5*); do

	sed "s/s in 503/s in ${Subject}/g" < ${SCRIPTS}/MTD/run_MTD_reg_model.sh> ~/tmp/MTDmodel_${Subject}.sh
	qsub -V -M kaihwang -m e -e ~/tmp -o ~/tmp ~/tmp/MTDmodel_${Subject}.sh
		
done
