import os, sys, numpy as np
import matplotlib.pyplot as plt

dataPath = '/home/despoB/TRSEPPI/TRSETMS/{0}/IFG'
subjects = ['106']

script = '''3dDeconvolve -input $(ls /home/despoB/TRSEPPI/TRSEPPI/AllSubjs/{0}/run*/nswdkmt_functional*.nii.gz | sort -V) \
-mask /home/despoB/TRSEPPI/TRSEPPI/overlap_mask/TRSE_80perOverlap_mask.nii.gz \
-polort A \
-num_stimts 14 \
-stim_times 1 /home/despoB/TRSEPPI/TRSEPPI/TRSE_scripts/{0}_both_face.txt 'GAM' -stim_label 1 both_face \
-stim_times 2 /home/despoB/TRSEPPI/TRSEPPI/TRSE_scripts/{0}_both_scene.txt 'GAM' -stim_label 2 both_scene \
-stim_times 3 /home/despoB/TRSEPPI/TRSEPPI/TRSE_scripts/{0}_categorize_scene.txt 'GAM' -stim_label 3 categorize_scene \
-stim_times 4 /home/despoB/TRSEPPI/TRSEPPI/TRSE_scripts/{0}_categorize_face.txt 'GAM' -stim_label 4 categorize_face \
-stim_times 5 /home/despoB/TRSEPPI/TRSEPPI/TRSE_scripts/{0}_relevant_face.txt 'GAM' -stim_label 5 relevant_face \
-stim_times 6 /home/despoB/TRSEPPI/TRSEPPI/TRSE_scripts/{0}_irrelevant_face.txt 'GAM' -stim_label 6 irrelevant_face \
-stim_times 7 /home/despoB/TRSEPPI/TRSEPPI/TRSE_scripts/{0}_relevant_scene.txt 'GAM' -stim_label 7 relevant_scene \
-stim_times 8 /home/despoB/TRSEPPI/TRSEPPI/TRSE_scripts/{0}_irrelevant_scene.txt 'GAM' -stim_label 8 irrelevant_scene \
-stim_file 9 /home/despoB/TRSEPPI/TRSEPPI/AllSubjs/{0}/motionRuns.1D[0] -stim_label 9 motpar1 -stim_base 9 \
-stim_file 10 /home/despoB/TRSEPPI/TRSEPPI/AllSubjs/{0}/motionRuns.1D[1] -stim_label 10 motpar2 -stim_base 10 \
-stim_file 11 /home/despoB/TRSEPPI/TRSEPPI/AllSubjs/{0}/motionRuns.1D[2] -stim_label 11 motpar3 -stim_base 11 \
-stim_file 12 /home/despoB/TRSEPPI/TRSEPPI/AllSubjs/{0}/motionRuns.1D[3] -stim_label 12 motpar4 -stim_base 12 \
-stim_file 13 /home/despoB/TRSEPPI/TRSEPPI/AllSubjs/{0}/motionRuns.1D[4] -stim_label 13 motpar5 -stim_base 13 \
-stim_file 14 /home/despoB/TRSEPPI/TRSEPPI/AllSubjs/{0}/motionRuns.1D[5] -stim_label 14 motpar6 -stim_base 14 \
-fout \
-rout \
-tout \
-bucket /home/despoB/TRSEPPI/TRSEPPI/AllSubjs/{0}/Test_stats \
-x1D Output_design_mat \
-GOFORIT'''

for subj in subjects:
    path = dataPath.format(subj)
    os.chdir(path) # Change to subject directory
    os.system('cat $(ls run*/motion.par | sort -V) > motionRuns.par') # Concatenate motion runs
    print os.system('pwd') #Print current path
    print os.system('wc -l motionRuns.par')
    
    f = open('decon_test.sh', 'w')
    scriptVersion = script.format(subj)
    
    f.write(scriptVersion)
    f.close()
    print scriptVersion

    sys.exit(0)
    qsub = 'qsub -m eas -e /home/despoB/akshayj/SGElogs -o /home/despoB/akshayj/SGElogs -N gam{0} -l mem_free=10G -V decon_test.sh' 
    #os.system(qsub.format(subj))
