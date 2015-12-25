
WD='/home/despoB/kaihwang/TRSE/TDSigEI'
SCRIPTS='/home/despoB/kaihwang/TRSE/TDSigEI/Scripts'
#503 505 508 509 510 512 513 516 517 518 519 523 527 528 529 530 532 534 531
# 510

for s in 503; do

	cd ${WD}/${s}/MPRAGE
	recon-all -subjid ${s} -i mprage.nii.gz -all

done
