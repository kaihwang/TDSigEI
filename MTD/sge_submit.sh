#!/bin/bash

#for SGE jobs

#mkdir tmp;
WD='/home/despoB/TRSEPPI/TDSigEI'
SCRIPTS='/home/despoB/kaihwang/bin/TDSigEI'

cd ${WD}

for Subject in 503 508 510 513 517 519 527 529 531 534 537 540 546 549 505 509 512 516 518 523 528 530 532 536 539 542 547 550; do #$(/bin/ls -d 5*)
	sed "s/s in 503/s in ${Subject}/g" < ${SCRIPTS}/MTD/run_MTD_reg_model.sh > ~/tmp/mtd_${Subject}.sh
	qsub -l mem_free=15G -V -M kaihwang -m e -e ~/tmp -o ~/tmp ~/tmp/mtd_${Subject}.sh
done
