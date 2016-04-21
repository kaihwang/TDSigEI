#!/usr/bin/env python
import os, sys

s = '106'
WD = '/home/despoB/TRSEPPI/TRSETMS/{0}/VERT'.format(s)

def preprocessFunc(blockNum, trueRunNum):
    tmp = '/home/despoB/akshayj/tmp2/{0}_TRSETMS_{1}_{2}'.format(s, blockNum, trueRunNum)
    filename = 'ep2d_neuro_64_TR1000_TRSEblock_{0}.nii'.format(blockNum)
    os.system('mkdir -p ' + tmp)
    os.system('cp {0}/raw_nii/{1} {2}'.format(WD, filename, tmp))
    os.chdir(tmp)
    print os.system('pwd')
    preprocessCommand = '''preprocessFunctional \
-startover \
-despike \
-mprage_bet {0}/mprage/anat_bet.nii.gz \
-tr 1 \
-threshold 98_2 \
-rescaling_method 100_voxelmean \
-template_brain MNI_2mm \
-func_struc_dof bbr \
-warp_interpolation spline \
-no_hp \
-smoothing_kernel 6 \
-slice_acquisition interleaved \
-warpcoef {0}/mprage/anat_warpcoef.nii.gz \
-4d {3}'''.format(WD, blockNum, s, filename)

    print preprocessCommand

    f = open('/home/despoB/akshayj/tmp2/scripts/preFunc_run{0}.sh'.format(trueRunNum), 'w')

    f.write('#!/bin/bash \n')
    f.write('cd {0} \n'.format(tmp))
    f.write(preprocessCommand + '\n')
    f.write('cp -r {0} {1}/run{2}'.format(tmp, WD, trueRunNum))
    
    f.close()
    qsubC = 'qsub -o /home/despoB/akshayj/tmp2/logs/preFuncLog{0} -j yes -N r{0}preFunc -m eas -l mem_free=5G -V /home/despoB/akshayj/tmp2/scripts/preFunc_run{0}.sh'.format(trueRunNum)
    print '\n', qsubC
    os.system(qsubC)

    print 'preprocess command completed'

blocks = [3,4,5, 6, 8, 9, 10, 11, 13, 14, 15, 16, 18, 19, 20, 21, 23, 24, 25, 26]
runs = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20] 

if len(blocks) == len(runs):
    for i in range(len(blocks)):
        print '*****RUN {0}*****'.format(runs[i])
        preprocessFunc(blocks[i], runs[i])
