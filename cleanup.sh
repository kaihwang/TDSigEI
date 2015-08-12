WD='/home/despoB/TRSEPPI/TDSigEI'
SCRIPTS='/home/despoB/kaihwang/bin/TDSigEI'

cd ${WD}

for Subject in $(ls -d 5*); do

	for r in $(seq 1 1 24); do

		cd ${WD}/${Subject}/run${r}
		preprocessFunctional -cleanup_only

	done

done