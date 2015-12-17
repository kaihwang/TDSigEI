import os, numpy as np, nibabel as nib
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA
from scipy.stats.stats import pearsonr

dataPath = '/home/despoB/kaihwang/TRSE/TDSigEI/'
subjects = ['503', '505', '508', '509', '510', '512', '513', '516', '517', '518', '519', '523', '527', '528', '529', '530', '531', '532', '534']

#Load the masks
tFEF_mask = nib.load(dataPath + 'ROIs/T_FEF.nii.gz').get_data() # 777 voxels
dFEF_mask = nib.load(dataPath + 'ROIs/D_FEF.nii.gz').get_data() # 838 voxels

conditions = ['FH', 'Fo', 'Fp', 'HF', 'Ho', 'Hp']

mask = dFEF_mask
for subj in subjects:
	print '*************SUBJECT {0}*************'.format(subj)
	for cond in conditions:
		print '---Condition {0}---'.format(cond)
		image  = nib.load(dataPath + subj + '/{0}_nusiance_{1}_errts.nii.gz'.format(subj, cond)).get_data()
		image_mask = image[mask!=0]

	# Load the functional data and apply the target and distractor FEF masks.
	print 'Load the functional data and apply the masks'

	FH = nib.load(dataPath + subj + '/{0}_nusiance_FH_errts.nii.gz'.format(subj)).get_data()
	FH_t, FH_d = FH[tFEF_mask!=0], FH[dFEF_mask!=0]

	Fo = nib.load(dataPath + subj + '/{0}_nusiance_Fo_errts.nii.gz'.format(subj)).get_data()
	Fo_t, Fo_d = Fo[tFEF_mask!=0], Fo[dFEF_mask!=0]

	Fp = nib.load(dataPath + subj + '/{0}_nusiance_Fp_errts.nii.gz'.format(subj)).get_data()
	Fp_t, Fp_d = Fp[tFEF_mask!=0], Fp[dFEF_mask!=0]

	HF = nib.load(dataPath + subj + '/{0}_nusiance_HF_errts.nii.gz'.format(subj)).get_data()
	HF_t, HF_d = HF[tFEF_mask!=0], HF[dFEF_mask!=0]

	Ho = nib.load(dataPath + subj + '/{0}_nusiance_Ho_errts.nii.gz'.format(subj)).get_data()
	Ho_t, Ho_d = Ho[tFEF_mask!=0], Ho[dFEF_mask!=0]

	Hp = nib.load(dataPath + subj + '/{0}_nusiance_Hp_errts.nii.gz'.format(subj)).get_data()
	Hp_t, Hp_d = Hp[tFEF_mask!=0], Hp[dFEF_mask!=0]

	print 'Done loading data. Now running the model.'
	model = '''3dDeconvolve -input {2}{0}/{0}_nusiance_{1}_errts.nii.gz \
-concat '1D: 0 102 204 306' \
-mask {2}ROIs/100overlap_mask+tlrc \
-polort A \
-num_stimts 1  \
-censor {2}{0}/1Ds/{0}_{1}_censor.1D \
-stim_times 1 {2}{0}/1Ds/{1}_stimtime.1D 'TENT(-1.5, 28.5, 20)' -stim_label 1 {1}_FIR \
-ortvec {0}/{1}_d.1D D_FEF \
-iresp 1 {0}/{1}_FIR_D_FEFremoved \
-rout \
-bucket {0}/FIR_{1}_stats_D_FEFremoved \
-x1D {0}/FIR_{1}_design_mat_D_FEFremoved \
-GOFORIT 100 \
-noFDR \
-errts {0}/{0}_FIR_{1}_errts_D_FEFremoved.nii.gz \
-allzero_OK'''

	for cond in conditions:
		pca = PCA(n_components=20)
		pca.fit(eval(cond + '_d'))
		filename = '{0}_d.1D'.format(cond)
		np.savetxt(subj + '/' + filename, pca.components_.transpose())
		print('PCA components for {0} {1} saved!'.format(subj, cond))

		thisMod = model.format(subj, cond, dataPath)
		print(thisMod)
		os.system(thisMod)
