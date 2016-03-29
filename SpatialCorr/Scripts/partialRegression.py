import os, numpy as np, nibabel as nib
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA
from scipy.stats.stats import pearsonr

dataPath = '/home/despoB/kaihwang/TRSE/TDSigEI/'

#Load the masks
#tFEF_mask = nib.load(dataPath + 'ROIs/T_FEF.nii.gz').get_data() # 777 voxels
#dFEF_mask = nib.load(dataPath + 'ROIs/D_FEF.nii.gz').get_data() # 838 voxels
#pre = nib.load(dataPath + 'ROIs/Pre.nii.gz').get_data()
L_IPS = nib.load(dataPath+ 'ROIs/L_IPS.nii.gz').get_data()
#R_IPS = nib.load(dataPath + 'ROIs/R_IPS.nii.gz').get_data()
#thalamus = nib.load(dataPath + 'ROIs/thalamus_mask.nii.gz').get_data()

subjects = ['503', '505', '508', '509', '510', '512', '513', '516', '517', '518', '519', '523', '527', '528', '529', '530', '531', '532', '534']
conditions = ['FH', 'Fo', 'Fp', 'HF', 'Ho', 'Hp']

subs = subjects[2:3]
conds = conditions[-2:]
mask = L_IPS
maskName = 'L_IPS'

model = '''3dDeconvolve -input {2}{0}/{0}_nusiance_{1}_errts.nii.gz \
-concat '1D: 0 102 204 306' \
-mask {2}ROIs/100overlap_mask+tlrc \
-polort A \
-num_stimts 1  \
-censor {2}{0}/1Ds/{0}_{1}_censor.1D \
-stim_times 1 {2}{0}/1Ds/{1}_stimtime.1D 'TENT(-1.5, 28.5, 20)' -stim_label 1 {1}_FIR \
-ortvec {0}/{1}_{3}.1D {3} \
-iresp 1 {0}/{3}removed/{1}_FIR_{3}removed \
-rout \
-bucket {0}/FIR_{1}_stats_{3}removed \
-x1D {0}/FIR_{1}_design_mat_{3}removed \
-GOFORIT 100 \
-noFDR \
-errts {0}/{0}_FIR_{1}_errts_{3}removed.nii.gz \
-allzero_OK'''


def partialRegressionPipeline(mask=mask, maskName=maskName, subjects=subs, model=model, conditions=conds):
	for subj in subjects:
		print '******************SUBJECT {0}******************'.format(subj)
		for cond in conditions:
			print '=========Condition {0}=========='.format(cond)

			# Load the subject-condition image and apply the mask 
			print 'Load the functional data and apply the masks'
			image = nib.load(dataPath + subj + '/{0}_nusiance_{1}_errts.nii.gz'.format(subj, cond)).get_data()
			image_mask = image[mask!=0]

			# PCA 
			pca = PCA(n_components=20)
			pca.fit(image_mask)
			filename = '{0}_{1}.1D'.format(cond, maskName)
			np.savetxt(subj + '/' + filename, pca.components_.transpose())
			print('PCA components for {0} {1} saved!'.format(subj, cond))

			thisMod = model.format(subj, cond, dataPath, maskName)
			print(thisMod)
			os.system(thisMod)


partialRegressionPipeline()
