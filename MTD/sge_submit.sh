#!/bin/bash

#for SGE jobs

#mkdir tmp;
WD='/home/despoB/TRSEPPI/TDSigEI'
#WD='/home/despoB/kaihwang/TRSE/TRSEPPI/AllSubjs'
SCRIPTS='/home/despoB/kaihwang/bin/TDSigEI'

cd ${WD}

for Subject in $(/bin/ls -d 5*); do #$(/bin/ls -d 5*)
	sed "s/s in 503/s in ${Subject}/g" < ${SCRIPTS}/MTD/run_MTD_reg_model.sh > ~/tmp/mtd_${Subject}.sh
	qsub -l mem_free=11G -V -M kaihwang -m e -e ~/tmp -o ~/tmp ~/tmp/mtd_${Subject}.sh
done
