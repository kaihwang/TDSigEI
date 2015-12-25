#!/bin/bash
# script for group analysis of loclizer contrast

#ffa ppa of base parameter
echo 'cd /home/despoB/kaihwang/TRSE/TDSigEI/Group
3dMEMA -prefix /home/despoB/kaihwang/TRSE/TDSigEI/Group/Group_Face_v_Scene_base.nii.gz \
-cio \
-set faces-scenes \' > /home/despoB/kaihwang/TRSE/TDSigEI/Group/Face_v_Scene_group_ana.sh

cd /home/despoB/kaihwang/TRSE/TDSigEI/

for s in $(ls -d 5*); do
	echo "$s /home/despoB/kaihwang/TRSE/TDSigEI/$s/Localizer_PPAFFA_stats_REML+tlrc[20] /home/despoB/kaihwang/TRSE/TDSigEI/$s/Localizer_PPAFFA_stats_REML+tlrc[21] \\" \
	>> /home/despoB/kaihwang/TRSE/TDSigEI/Group/Face_v_Scene_group_ana.sh
done

echo '-mask /home/despoB/kaihwang/TRSE/TDSigEI/ROIs/100overlap_mask+tlrc' >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/Face_v_Scene_group_ana.sh

cd /home/despoB/kaihwang/TRSE/TDSigEI/Group
ln -s /home/despoB/kaihwang/standard/mni_icbm152_nlin_asym_09c/mni_icbm152_t1_tal_nlin_asym_09c_brain.nii template_brain.nii
. Face_v_Scene_group_ana.sh

#motor mapping of base parameter
echo 'cd /home/despoB/kaihwang/TRSE/TDSigEI/Group
3dMEMA -prefix /home/despoB/kaihwang/TRSE/TDSigEI/Group/Group_Motor_base.nii.gz \
-cio \
-set RH-LH \' > /home/despoB/kaihwang/TRSE/TDSigEI/Group/Motor_group_ana.sh

cd /home/despoB/kaihwang/TRSE/TDSigEI/

for s in $(ls -d 5*); do
	echo "$s /home/despoB/kaihwang/TRSE/TDSigEI/$s/Localizer_Motor_stats_REML+tlrc[20] /home/despoB/kaihwang/TRSE/TDSigEI/$s/Localizer_Motor_stats_REML+tlrc[21] \\" \
	>> /home/despoB/kaihwang/TRSE/TDSigEI/Group/Motor_group_ana.sh
done

echo '-mask /home/despoB/kaihwang/TRSE/TDSigEI/ROIs/100overlap_mask+tlrc' >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/Motor_group_ana.sh

cd /home/despoB/kaihwang/TRSE/TDSigEI/Group
. Motor_group_ana.sh





#ffa ppa of deriv parameter
echo 'cd /home/despoB/kaihwang/TRSE/TDSigEI/Group
3dMEMA -prefix /home/despoB/kaihwang/TRSE/TDSigEI/Group/Group_Face_v_Scene_deriv.nii.gz \
-cio \
-set faces-scenes \' > /home/despoB/kaihwang/TRSE/TDSigEI/Group/Face_v_Scene_group_ana.sh

cd /home/despoB/kaihwang/TRSE/TDSigEI/

for s in $(ls -d 5*); do
	echo "$s /home/despoB/kaihwang/TRSE/TDSigEI/$s/Localizer_PPAFFA_stats_REML+tlrc[24] /home/despoB/kaihwang/TRSE/TDSigEI/$s/Localizer_PPAFFA_stats_REML+tlrc[25] \\" \
	>> /home/despoB/kaihwang/TRSE/TDSigEI/Group/Face_v_Scene_group_ana.sh
done

echo '-mask /home/despoB/kaihwang/TRSE/TDSigEI/ROIs/100overlap_mask+tlrc' >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/Face_v_Scene_group_ana.sh

cd /home/despoB/kaihwang/TRSE/TDSigEI/Group
ln -s /home/despoB/kaihwang/standard/mni_icbm152_nlin_asym_09c/mni_icbm152_t1_tal_nlin_asym_09c_brain.nii template_brain.nii
. Face_v_Scene_group_ana.sh

#motor mapping of deriv parameter
echo 'cd /home/despoB/kaihwang/TRSE/TDSigEI/Group
3dMEMA -prefix /home/despoB/kaihwang/TRSE/TDSigEI/Group/Group_Motor_deriv.nii.gz \
-cio \
-set RH-LH \' > /home/despoB/kaihwang/TRSE/TDSigEI/Group/Motor_group_ana.sh

cd /home/despoB/kaihwang/TRSE/TDSigEI/

for s in $(ls -d 5*); do
	echo "$s /home/despoB/kaihwang/TRSE/TDSigEI/$s/Localizer_Motor_stats_REML+tlrc[24] /home/despoB/kaihwang/TRSE/TDSigEI/$s/Localizer_Motor_stats_REML+tlrc[25] \\" \
	>> /home/despoB/kaihwang/TRSE/TDSigEI/Group/Motor_group_ana.sh
done

echo '-mask /home/despoB/kaihwang/TRSE/TDSigEI/ROIs/100overlap_mask+tlrc' >> /home/despoB/kaihwang/TRSE/TDSigEI/Group/Motor_group_ana.sh

cd /home/despoB/kaihwang/TRSE/TDSigEI/Group
. Motor_group_ana.sh