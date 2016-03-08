WD='/home/despoB/TRSEPPI/TDSigEI'
SCRIPTS='/home/despoB/kaihwang/bin/TDSigEI'

cd ${WD}

for Subject in $(ls -d 5*); do

	#for r in $(seq 1 1 24); do

	#	cd ${WD}/${Subject}/run${r}
	#	preprocessFunctional -cleanup_only

	#done

	cd ${WD}/${Subject}/
	#mkdir MTDs
	#mv MTD* MTDs
	

	#rm Corrcoef*_thareg*
	#mkdir SeedCorr
	#mv Corrcoef* SeedCorr

	#rm ${Subject}_RH*
	#rm ${Subject}_LH*

	#mkdir 1Ds
	mv *.1D 1Ds
	mv *.txt 1Ds
	
done
