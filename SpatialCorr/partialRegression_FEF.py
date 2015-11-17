import os, numpy as np, nibabel as nib
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA
from scipy.stats.stats import pearsonr

dataPath = '/home/despoB/kaihwang/TRSE/TDSigEI/'
#subjects = ['503', '505', '508', '509', '510', '512', '513', '516', '517', '518', '519', '523', '527', '528', '529', '530', '531', '532', '534']
subjects = ['503']

#Load the masks
tFEF_mask = nib.load(dataPath + 'ROIs/T_FEF.nii.gz').get_data() # 777 voxels
dFEF_mask = nib.load(dataPath + 'ROIs/D_FEF.nii.gz').get_data() # 838 voxels

corrFunc = lambda a, c, d: np.array(pearsonr(a, d)) - np.array(pearsonr(c, d))

conditions = ['FH', 'Fo', 'Fp', 'HF', 'Ho', 'Hp']

for subj in subjects:
	# Load the functional data and apply the target and distractor FEF masks.
	print 'Load the functional data and apply the masks'

	ffa = nib.load(dataPath + subj + '/FFA_indiv_ROI.nii.gz').get_data()
	ppa = nib.load(dataPath + subj + '/FFA_indiv_ROI.nii.gz').get_data()

	FH = nib.load(dataPath + subj + '/503_nusiance_FH_errts.nii.gz').get_data()
	FH_t = FH[tFEF_mask!=0]
	FH_d = FH[dFEF_mask!=0]
	FH_ffa, FH_ppa = FH[ffa!=0], FH[ppa!=0]
	Fo = nib.load(dataPath + subj + '/503_nusiance_Fo_errts.nii.gz').get_data()
	Fo_t = Fo[tFEF_mask!=0]
	Fo_d = Fo[dFEF_mask!=0]
	Fo_ffa, Fo_ppa = Fo[ffa!=0], Fo[ppa!=0]
	Fp = nib.load(dataPath + subj + '/503_nusiance_Fp_errts.nii.gz').get_data()
	Fp_t = Fp[tFEF_mask!=0]
	Fp_d = Fp[dFEF_mask!=0]
	Fp_ffa, Fp_ppa = Fp[ffa!=0], Fp[ppa!=0]
	HF = nib.load(dataPath + subj + '/503_nusiance_HF_errts.nii.gz').get_data()
	HF_t = HF[tFEF_mask!=0]
	HF_d = HF[dFEF_mask!=0]
	HF_ffa, HF_ppa = HF[ffa!=0], HF[ppa!=0]
	Ho = nib.load(dataPath + subj + '/503_nusiance_Ho_errts.nii.gz').get_data()
	Ho_t = Ho[tFEF_mask!=0]
	Ho_d = Ho[dFEF_mask!=0]
	Ho_ffa, Ho_ppa = Ho[ffa!=0], Ho[ppa!=0]
	Hp = nib.load(dataPath + subj + '/503_nusiance_Hp_errts.nii.gz').get_data()
	Hp_t = Hp[tFEF_mask!=0]
	Hp_d = Hp[dFEF_mask!=0]
	Hp_ffa, Hp_ppa = Hp[ffa!=0], Hp[ppa!=0]

	print 'Done loading data. Now running the model.'
	model = '''3dDeconvolve -input {0}_nusiance_{1}_errts.nii.gz \
	-concat '1D: 0 102 204 306' \
	-mask {2}ROIs/100overlap_mask+tlrc \
	-polort A \
	-num_stimts 2  \
	-censor {2}{0}/{0}_{1}_censor.1D \
	-stim_times 1 {2}{0}/{1}_stimtime.1D 'TENT(-1.5, 28.5, 20)' -stim_label 1 {1}_FIR \
	-stim_times 2 {1}_t.1D -stim_base 2 -stim_label T_FEF  \
	-iresp 1 {1}_FIR_T_FEFremoved \
	-rout \
	-bucket FIR_{1}_stats_T_FEFremoved \
	-x1D FIR_{1}_design_mat_T_FEFremoved \
	-GOFORIT 100\
	-noFDR \
	-errts {0}_FIR_{1}_errts_T_FEFremoved.nii.gz \
	-allzero_OK'''	

	for cond in conditions:
		pca = PCA(n_components=20)
		pca.fit(eval(cond + '_t'))
		filename = '/{0}_t.1D'.format(cond)
		np.savetxt(dataPath + subj + filename, pca.components_)
		print(dataPath + subj + filename + ' saved!')

		pca.fit(eval(cond + '_ffa'))
		stim1file = '/{0}_stimtime.1D'.format(cond)
		np.savetxt(dataPath + subj + stim1file, pca.components_)
		print(dataPath + subj + stim1file + ' saved!')

		thisMod = model.format(subj, cond, dataPath)
		print(thisMod)
		os.system(thisMod)

