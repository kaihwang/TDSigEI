#!/bin/bash

#for SGE jobs

#mkdir tmp;
#WD='/home/despoB/TRSEPPI/TDSigEI'
WD='/home/despoB/kaihwang/TRSE/TRSEPPI/AllSubjs'
SCRIPTS='/home/despoB/kaihwang/bin/TDSigEI'

cd ${WD}

for Subject in 1107 1109 1110 1111 1112 1113 1114 1116 1401 140 1403 1404 1405 1406 1407 1408 1409 1411 1412 1413 1414 1415 1416 1417 1418 1419 1422 1423 1426 1427 1429 1430 1431 620 623 627 628 629 630 631 632 633 634 636 637 638 639 640 7601 7604 7611 7613 7614 7616 7620 7621; do #$(/bin/ls -d 5*)
	sed "s/s in 1106/s in ${Subject}/g" < ${SCRIPTS}/MTD/run_MTD_TRSE.sh > ~/tmp/mtd_${Subject}.sh
	qsub -l mem_free=20G -V -M kaihwang -m e -e ~/tmp -o ~/tmp ~/tmp/mtd_${Subject}.sh
done
