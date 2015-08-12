#!/bin/bash
# script for group analysis of gPPI model

#FFA
echo 'cd /home/despoB/kaihwang/TRSE/TDSigEI/Group
3dMEMA -prefix /home/despoB/kaihwang/TRSE/TDSigEI/Group/Group_gPPI_FFA_T.nii.gz \
-cio \
-set gPPI_FFA_T \' > /home/despoB/kaihwang/TRSE/TDSigEI/Group/gPPI_FFA_T.sh

cd /home/despoB/kaihwang/TRSE/TDSigEI/

for s in $(ls -d 5*); do
	echo "$s /home/despoB/kaihwang/TRSE/TDSigEI/$s/gPPI_FFA_Full_model_stats_REML+tlrc[2] /home/despoB/kaihwang/TRSE/TDSigEI/$s/gPPI_FFA_Full_model_stats_REML+tlrc[3] \\" \
	>> /home/despoB/kaihwang/TRSE/TDSigEI/Group/gPPI_FFA_T.sh
done

echo '-mask /home/despoB/kaihwang/TRSE/TDSigEI/ROIs/100overlap_mask+tlrc' >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/gPPI_FFA_T.sh


echo 'cd /home/despoB/kaihwang/TRSE/TDSigEI/Group
3dMEMA -prefix /home/despoB/kaihwang/TRSE/TDSigEI/Group/Group_gPPI_FFA_D.nii.gz \
-cio \
-set gPPI_FFA_D \' > /home/despoB/kaihwang/TRSE/TDSigEI/Group/gPPI_FFA_D.sh

cd /home/despoB/kaihwang/TRSE/TDSigEI/

for s in $(ls -d 5*); do
	echo "$s /home/despoB/kaihwang/TRSE/TDSigEI/$s/gPPI_FFA_Full_model_stats_REML+tlrc[6] /home/despoB/kaihwang/TRSE/TDSigEI/$s/gPPI_FFA_Full_model_stats_REML+tlrc[7] \\" \
	>> /home/despoB/kaihwang/TRSE/TDSigEI/Group/gPPI_FFA_D.sh
done

echo '-mask /home/despoB/kaihwang/TRSE/TDSigEI/ROIs/100overlap_mask+tlrc' >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/gPPI_FFA_D.sh

echo 'cd /home/despoB/kaihwang/TRSE/TDSigEI/Group
3dMEMA -prefix /home/despoB/kaihwang/TRSE/TDSigEI/Group/Group_gPPI_FFA_TvD.nii.gz \
-cio \
-set gPPI_FFA_TvD \' > /home/despoB/kaihwang/TRSE/TDSigEI/Group/gPPI_FFA_TvD.sh

cd /home/despoB/kaihwang/TRSE/TDSigEI/

for s in $(ls -d 5*); do
	echo "$s /home/despoB/kaihwang/TRSE/TDSigEI/$s/gPPI_FFA_Full_model_stats_REML+tlrc[18] /home/despoB/kaihwang/TRSE/TDSigEI/$s/gPPI_FFA_Full_model_stats_REML+tlrc[19] \\" \
	>> /home/despoB/kaihwang/TRSE/TDSigEI/Group/gPPI_FFA_TvD.sh
done

echo '-mask /home/despoB/kaihwang/TRSE/TDSigEI/ROIs/100overlap_mask+tlrc' >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/gPPI_FFA_TvD.sh




#PPA
echo 'cd /home/despoB/kaihwang/TRSE/TDSigEI/Group
3dMEMA -prefix /home/despoB/kaihwang/TRSE/TDSigEI/Group/Group_gPPI_PPA_T.nii.gz \
-cio \
-set gPPI_PPA_T \' > /home/despoB/kaihwang/TRSE/TDSigEI/Group/gPPI_PPA_T.sh

cd /home/despoB/kaihwang/TRSE/TDSigEI/

for s in $(ls -d 5*); do
	echo "$s /home/despoB/kaihwang/TRSE/TDSigEI/$s/gPPI_PPA_Full_model_stats_REML+tlrc[2] /home/despoB/kaihwang/TRSE/TDSigEI/$s/gPPI_PPA_Full_model_stats_REML+tlrc[3] \\" \
	>> /home/despoB/kaihwang/TRSE/TDSigEI/Group/gPPI_PPA_T.sh
done

echo '-mask /home/despoB/kaihwang/TRSE/TDSigEI/ROIs/100overlap_mask+tlrc' >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/gPPI_PPA_T.sh


echo 'cd /home/despoB/kaihwang/TRSE/TDSigEI/Group
3dMEMA -prefix /home/despoB/kaihwang/TRSE/TDSigEI/Group/Group_gPPI_PPA_D.nii.gz \
-cio \
-set gPPI_PPA_D \' > /home/despoB/kaihwang/TRSE/TDSigEI/Group/gPPI_PPA_D.sh

cd /home/despoB/kaihwang/TRSE/TDSigEI/

for s in $(ls -d 5*); do
	echo "$s /home/despoB/kaihwang/TRSE/TDSigEI/$s/gPPI_PPA_Full_model_stats_REML+tlrc[6] /home/despoB/kaihwang/TRSE/TDSigEI/$s/gPPI_PPA_Full_model_stats_REML+tlrc[7] \\" \
	>> /home/despoB/kaihwang/TRSE/TDSigEI/Group/gPPI_PPA_D.sh
done

echo '-mask /home/despoB/kaihwang/TRSE/TDSigEI/ROIs/100overlap_mask+tlrc' >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/gPPI_PPA_D.sh

echo 'cd /home/despoB/kaihwang/TRSE/TDSigEI/Group
3dMEMA -prefix /home/despoB/kaihwang/TRSE/TDSigEI/Group/Group_gPPI_PPA_TvD.nii.gz \
-cio \
-set gPPI_PPA_TvD \' > /home/despoB/kaihwang/TRSE/TDSigEI/Group/gPPI_PPA_TvD.sh

cd /home/despoB/kaihwang/TRSE/TDSigEI/

for s in $(ls -d 5*); do
	echo "$s /home/despoB/kaihwang/TRSE/TDSigEI/$s/gPPI_PPA_Full_model_stats_REML+tlrc[18] /home/despoB/kaihwang/TRSE/TDSigEI/$s/gPPI_PPA_Full_model_stats_REML+tlrc[19] \\" \
	>> /home/despoB/kaihwang/TRSE/TDSigEI/Group/gPPI_PPA_TvD.sh
done

echo '-mask /home/despoB/kaihwang/TRSE/TDSigEI/ROIs/100overlap_mask+tlrc' >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/gPPI_PPA_TvD.sh


cd /home/despoB/kaihwang/TRSE/TDSigEI/Group
qsub -V gPPI_PPA_D.sh
qsub -V gPPI_PPA_T.sh
qsub -V gPPI_PPA_TvD.sh
qsub -V gPPI_FFA_D.sh
qsub -V gPPI_FFA_T.sh
qsub -V gPPI_FFA_TvD.sh
