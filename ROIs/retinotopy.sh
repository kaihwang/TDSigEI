cd /home/despoB/kaihwang/TRSE/Retinotopy_Pilot/pilotsub

@RetinoProc -TR 2.0 \
-period_pol 40 \
-period_ecc 40 \
-pre_pol 0 \
-pre_ecc 0 \
-nwedges 1 \
-no_tshift \
-noVR \
-ignore 0 \
-clw run1/ndktm_functional_al+orig \
-ccw run2/ndktm_functional_al+orig \
-anat_vol SUMA/retinopilot_SurfVol+orig.HEAD \
-surf_vol SUMA/retinopilot_SurfVol+orig.HEAD \
-spec_left SUMA/retinopilot_lh.spec \
-spec_right SUMA/retinopilot_rh.spec \
-sid retinopilot \
-out_dir Retinotopy_Runs12

@RetinoProc -TR 2.5 \
-period_pol 50 \
-period_ecc 50 \
-pre_pol 0 \
-pre_ecc 0 \
-nwedges 1 \
-no_tshift \
-noVR \
-ignore 0 \
-clw run3/ndktm_functional_al+orig \
-ccw run4/ndktm_functional_al+orig \
-anat_vol SUMA/retinopilot_SurfVol+orig.HEAD \
-surf_vol SUMA/retinopilot_SurfVol+orig.HEAD \
-spec_left SUMA/retinopilot_lh.spec \
-spec_right SUMA/retinopilot_rh.spec \
-sid retinopilot \
-out_dir Retinotopy_Runs34

@RetinoProc -TR 2.0 \
-period_pol 40 \
-period_ecc 40 \
-pre_pol 0 \
-pre_ecc 0 \
-nwedges 1 \
-no_tshift \
-noVR \
-ignore 0 \
-clw run5/ndktm_functional_al+orig \
-ccw run6/ndktm_functional_al+orig \
-anat_vol SUMA/retinopilot_SurfVol+orig.HEAD \
-surf_vol SUMA/retinopilot_SurfVol+orig.HEAD \
-spec_left SUMA/retinopilot_lh.spec \
-spec_right SUMA/retinopilot_rh.spec \
-sid retinopilot \
-out_dir Retinotopy_Runs56

# 3dVol2Surf \
# -spec SUMA/Sub4_rh.spec \
# -surf_A rh.smoothwm \
# -sv SVol@Epi+orig \
# -grid_parent RH_V1TMS_MC_sep_tBeta_1.6+orig \
# -map_func mask \
# -debug 2 \
# -out_niml RH_V1TMS_MC_sep_tBeta_1.6.niml.dset\


# 3dSurf2Vol                           \
#        -spec         SUMA/S6_lh.spec \
#        -surf_A       lh.smoothwm \
#        -sv           SVol@Epi+orig \
#        -grid_parent  S6_EXP01-012-EPI-POL_preproc_mc_b_hp+orig \
#        -sdata_1D     LH_LO1.1D.roi        \
#        -map_func     mode                \
#        -f_steps      10                  \
#        -prefix       LH_LO1 \

# 3drefit -view tlrc -space tlrc LHWM_Zbeta_200_tlrc+orig \
# 3drefit -view tlrc -space tlrc LH_V1to3_al+orig \
