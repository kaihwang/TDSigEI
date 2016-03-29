import os, numpy as np, nibabel as nib
from sklearn.decomposition import PCA
from scipy.stats.stats import pearsonr
import pandas as pd 
import numpy.linalg as npl

dataPath = '/home/despoB/kaihwang/TRSE/TDSigEI/'
subjects = ['503', '505', '508', '509', '510', '512', '513', '516', '517', '518', '519', '523', '527', '528', '529', '530', '531', '532', '534']
#subjects = ['503']

# blocks_to_keep = range(1,20) + range(28,47) + range(55,74) + range(82,101) \
# + range(1+102,20+102) + range(28+102,47+102) + range(55+102,74+102) + range(82+102,101+102) \
# + range(1+204,20+204) + range(28+204,47+204) + range(55+204,74+204) + range(82+204,101+204) \
# + range(1+306,20+306) + range(28+306,47+306) + range(55+306,74+306) + range(82+306,101+306) 

#output vars
SpatialCorrDF = pd.DataFrame()
HF_betas = []
FH_betas = []

for i, subj in enumerate(subjects):

    SpatialCorrDF.set_value(i, 'Subject', subj)
    os.chdir(dataPath+subj)

    ### convert to nifti
    os.system("3dAFNItoNIFTI -prefix FIR_FH.nii.gz FH_FIR+tlrc")
    os.system("3dAFNItoNIFTI -prefix FIR_HF.nii.gz HF_FIR+tlrc")
    os.system("3dAFNItoNIFTI -prefix FIR_Fo.nii.gz Fo_FIR+tlrc")
    os.system("3dAFNItoNIFTI -prefix FIR_Ho.nii.gz Ho_FIR+tlrc")
    os.system("3dAFNItoNIFTI -prefix FIR_Fp.nii.gz Fp_FIR+tlrc")
    os.system("3dAFNItoNIFTI -prefix FIR_Hp.nii.gz Hp_FIR+tlrc")
    fn = dataPath + subj + '/FIR_FH.nii.gz'
    FH_beta = nib.load(fn).get_data()
    fn = dataPath + subj + '/FIR_HF.nii.gz'
    HF_beta = nib.load(fn).get_data()
    fn = dataPath + subj + '/FIR_Fo.nii.gz'
    Fo_beta = nib.load(fn).get_data()
    fn = dataPath + subj + '/FIR_Ho.nii.gz'
    Ho_beta = nib.load(fn).get_data()
    fn = dataPath + subj + '/FIR_Fp.nii.gz'
    Fp_beta = nib.load(fn).get_data()
    fn = dataPath + subj + '/FIR_Hp.nii.gz'
    Hp_beta = nib.load(fn).get_data()

    ffa = nib.load(dataPath + subj + '/FFA_indiv_ROI.nii.gz').get_data()
    ppa = nib.load(dataPath + subj + '/PPA_indiv_ROI.nii.gz').get_data()
    print(FH_beta.shape, Fp_beta.shape, Fo_beta.shape, Ho_beta.shape, Hp_beta.shape, HF_beta.shape)
    Ho_ffa = Ho_beta[ffa!=0].mean(1)
    Fo_ffa = Fo_beta[ffa!=0].mean(1)
    FH_ffa = FH_beta[ffa!=0].mean(1)
    Fp_ffa = Fp_beta[ffa!=0].mean(1)
    HF_ffa = HF_beta[ffa!=0].mean(1)
    Hp_ffa = Hp_beta[ffa!=0].mean(1)
    Ho_ppa = Ho_beta[ppa!=0].mean(1)
    Fo_ppa = Fo_beta[ppa!=0].mean(1)
    FH_ppa = FH_beta[ppa!=0].mean(1)
    Fp_ppa = Fp_beta[ppa!=0].mean(1)
    HF_ppa = HF_beta[ppa!=0].mean(1)
    Hp_ppa = Hp_beta[ppa!=0].mean(1)

    #append betas for later use
    HF_betas.append(HF_beta.mean(3))
    FH_betas.append(FH_beta.mean(3))

    ### Measure 1: Representation selectivity, not working out, so commented out for now
    # corrFuncFace = lambda c: np.array(pearsonr(c, Fo_ffa)) - np.array(pearsonr(c, Ho_ffa))
    # corrFuncHouse = lambda c: np.array(pearsonr(c, Ho_ppa)) - np.array(pearsonr(c, Fo_ppa))

    # print("sujbect " + str(subj))
    # faceAttn = corrFuncFace(FH_ffa)
    # faceBaseline = corrFuncFace(Fp_ffa)
    # faceInhib = corrFuncFace(HF_ffa)
    # HouseAttn = corrFuncHouse(HF_ppa)
    # HouseBaseline = corrFuncHouse(Hp_ppa)
    # HouseInhib = corrFuncHouse(FH_ppa)
    # print ("Measure 1: Representation Selectivity")
    # print('\tFace Attn: {0}\n\t Face Baseline: {1}\n\t Face Inhibition {2}'.format(faceAttn[0], faceBaseline[0], faceInhib[0]))
    # print('\tHouse Attn: {0}\n\t House Baseline: {1}\n\t House Inhibition {2}'.format(HouseAttn[0], HouseBaseline[0], HouseInhib[0]))

    ### Measure 2: Representation similarity 
    corrFunc2 = lambda a, c, d: np.array(pearsonr(a, d)) - np.array(pearsonr(c, d))

    # Compared to target only condition as template, FFA, passive viewing as baseline
    repEnhancementB = corrFunc2(FH_ffa, Fp_ffa, Fo_ffa)
    repSuppressionB = corrFunc2(HF_ffa, Fp_ffa, Fo_ffa)
    print('FFA Representation Similarity compared to target only condition as template')
    print('\tRepresentation Enhancement: {0}'.format(repEnhancementB[0]))
    print('\tRepresentation Suppression: {0}'.format(repSuppressionB[0]))
    SpatialCorrDF.set_value(i, 'FFARepEnhancement', repEnhancementB[0])
    SpatialCorrDF.set_value(i, 'FFARepSuppression', repSuppressionB[0])

    # Compared to target only condition as template, PPA
    repEnhancementB = corrFunc2(HF_ppa, Hp_ppa, Ho_ppa)
    repSuppressionB = corrFunc2(FH_ppa, Hp_ppa, Ho_ppa)
    print('PPA Representation Similarity compared to target only condition as template')
    print('\tRepresentation Enhancement: {0}'.format(repEnhancementB[0]))
    print('\tRepresentation Suppression: {0}'.format(repSuppressionB[0]))
    SpatialCorrDF.set_value(i, 'PPARepEnhancement', repEnhancementB[0])
    SpatialCorrDF.set_value(i, 'PPARepSuppression', repSuppressionB[0])

    # compared to passive viewing as template, target only condition as baseline
    # repEnhancement = corrFunc2(FH_ffa, Fo_ffa, Fp_ffa)
    # repSuppression = corrFunc2(HF_ffa, Fo_ffa, Fp_ffa)
    # print('Measure 2a: Face region Representation Similarity compared to passive condition as template')
    # print('\tRepresentation Enhancement: {0}'.format(repEnhancement[0]))
    # print('\tRepresentation Suppression: {0}'.format(repSuppression[0]))

    # repEnhancement = corrFunc2(HF_ppa, Ho_ppa, Hp_ppa)
    # repSuppression = corrFunc2(FH_ppa, Ho_ppa, Hp_ppa)
    # print('Measure 2a: House region Representation Similarity compared to passive condition as template')
    # print('\tRepresentation Enhancement: {0}'.format(repEnhancement[0]))
    # print('\tRepresentation Suppression: {0}'.format(repSuppression[0]))

SpatialCorrDF.to_csv('/home/despoB/kaihwang/bin/TDSigEI/Data/SpatialCorr_df.csv')

#### do regression, 
#### following examples here: https://github.com/practical-neuroimaging/pna2015/blob/master/day15/multivoxel_solutions.ipynb

# turn Y into numpy arrays
HF_betas = np.array(HF_betas)
FH_betas = np.array(FH_betas)
print(FH_betas.shape, FH_betas.shape)
#first dimension is the number of subjects, roll it back so x * y * z * num_subj 
HF_betas = np.rollaxis(HF_betas, 0, 4)
FH_betas = np.rollaxis(FH_betas, 0, 4)

#get data dimension numbers, 
n_subjects = HF_betas.shape[3]
vol_shape = HF_betas.shape[0:3]
n_voxels = np.prod(vol_shape)


# Reshape data to n_voxels by n_vols, call this `data_2d`
# Then make result into n_vols by n_voxels
# Check shape is (n_vols, n_voxels)
HF_betas_2d = HF_betas.reshape((n_voxels, n_subjects)).T
FH_betas_2d = FH_betas.reshape((n_voxels, n_subjects)).T
assert HF_betas_2d.shape == (n_subjects, n_voxels)

# do regression model.
# model: Y = aX + b
X = np.ones((n_subjects, 2))
X[:, 0] = SpatialCorrDF['FFARepEnhancement'].values
betas = npl.pinv(X).dot(FH_betas_2d)

# extract contrast data (regressor of interest)
c = np.array([1, 0])
con_data_1d = c.dot(betas)
assert con_data_1d.shape == (n_voxels,)
con_data = con_data_1d.reshape(vol_shape)

# cal t statistic
residuals = FH_betas_2d - X.dot(betas)
RSS = (residuals ** 2).sum(axis=0)
df = n_subjects - npl.matrix_rank(X)
MRSS = RSS / df
MRSS_3d = MRSS.reshape(vol_shape)

iXtX = npl.pinv(X.T.dot(X))
design_variance = c.dot(iXtX).dot(c)

t_statistics = np.nan_to_num(con_data / np.sqrt(MRSS_3d * design_variance))

#save t output
img = nib.load('mni_icbm152_t1_tal_nlin_asym_09c_brain_2mm.nii')
#img_data = img.get_data()
t_img = nib.Nifti1Image(t_statistics, img.affine, img.header)
nib.save(t_img, 'Group_sub_reg_FFA_enh.nii')