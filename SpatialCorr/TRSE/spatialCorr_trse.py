import os, sys, numpy as np, nibabel as nib
from sklearn.decomposition import PCA
from scipy.stats.stats import pearsonr
import pandas as pd 
import numpy.linalg as npl

#dataPath = '/home/despoB/kaihwang/TRSE/TDSigEI/'
dataPath = '/home/despoB/TRSEPPI/TRSEPPI/AllSubjs'
subjects = ['620', '623', '627', '628', '629', '630', '631', '632', '633', '634', '636', '637', '638', '639', '640', '903', '905', '906', '910', '912', '1106', '1107', '1109', '1110', '1111', '1112', '1113', '1114', '1116', '1401', '1402', '1403', '1404', '1405', '1406', '1407', '1408', '1409', '1411', '1412', '1413', '1414', '1415', '1416', '1417', '1418', '1419', '1421', '1422', '1423', '1426', '1427', '1429', '1430', '1431', '2102', '2110', '2111', '2115', '2116', '2118', '2119', '2121', '2122', '2123', '2124', '7601', '7604', '7611', '7613', '7614', '7616', '7620', '7621']
print len(subjects)

#output vars
SpatialCorrDF = pd.DataFrame()
HF_betas = []
FH_betas = []
output = open('/home/despoB/akshayj/TDSigEI/SpatialCorr/TRSE/spCorr1.out', 'wb')
PRINT = output.write

def extractSubbricks(subbrickNum, conditionName, ffaMask, ppaMask):
    files = os.listdir('.')
    fileName = conditionName + '.nii.gz'
    if '{0}.nii.gz'.format(conditionName) not in files:
        command = "3dcalc -a Test_stats+tlrc[{0}] -expr 'a' -prefix {1}.nii.gz"
        os.system(command.format(subbrickNum, conditionName))
    beta = nib.load('{0}.nii.gz'.format(conditionName)).get_data()
    return beta, beta[ffaMask!=0], beta[ppaMask!=0]
    
def runSubjects(i, subj):
    SpatialCorrDF.set_value(i, 'Subject', subj)
    os.chdir(dataPath+'/'+subj)

    ### FFA and PPA MASKS: convert to nifti and load in
    files = os.listdir('.')
    if 'PPA_indiv_ROI.nii.gz' not in files: 
        os.system("3dAFNItoNIFTI -prefix FFA_indiv_ROI.nii.gz FFA_indiv_ROI+tlrc")
        os.system("3dAFNItoNIFTI -prefix PPA_indiv_ROI.nii.gz PPA_indiv_ROI+tlrc")
    else:
        PRINT("Skipping AFNI to NIFTI file conversion...")

    ffaMask = nib.load('FFA_indiv_ROI.nii.gz').get_data()
    ppaMask = nib.load('PPA_indiv_ROI.nii.gz').get_data()

    # Extract 8 subbricks of beta weights for conditions
    relevantFace, rF_ffa, rF_ppa = extractSubbricks('18', 'relevant_face', ffaMask, ppaMask)
    irrelevantFace, iF_ffa, iF_ppa = extractSubbricks('22', 'irrelevant_face', ffaMask, ppaMask)
    relevantScene, rS_ffa, rS_ppa = extractSubbricks('26', 'relevant_scene', ffaMask, ppaMask)
    irrelevantScene, iS_ffa, iS_ppa = extractSubbricks('30', 'irrelevant_scene', ffaMask, ppaMask)
    bothFace, bF_ffa, bF_ppa = extractSubbricks('2', 'both_face', ffaMask, ppaMask)
    bothScene, bS_ffa, bS_ppa = extractSubbricks('6', 'both_scene', ffaMask, ppaMask)
    categorizeFace, cF_ffa, cF_ppa = extractSubbricks('14', 'categorize_face', ffaMask, ppaMask)
    categorizeScene, cS_ffa, cS_ppa = extractSubbricks('10', 'categorize_scene', ffaMask, ppaMask)
    
    ######### Representation similarity ############### 
    corrFunc2 = lambda a, c, d: np.array(pearsonr(a, d)) - np.array(pearsonr(c, d))

    # Compared to target only condition as template, FFA, passive viewing as baseline
    repEnhanceFFA = corrFunc2(rF_ffa, cF_ffa, bF_ffa)
    repSuppressFFA = corrFunc2(iF_ffa, cF_ffa, bF_ffa)
    PRINT('FFA Representation Similarity Analysis')
    PRINT('\tRepresentation Enhancement: {0}'.format(repEnhanceFFA))
    PRINT('\tRepresentation Suppression: {0}'.format(repSuppressFFA))
    SpatialCorrDF.set_value(i, 'FFARepEnhancement', repEnhanceFFA[0])
    SpatialCorrDF.set_value(i, 'FFARepSuppression', repSuppressFFA[0])

    # Compared to target only condition as template, PPA
    repEnhancePPA = corrFunc2(rS_ppa, cS_ppa, bS_ppa)
    repSuppressPPA = corrFunc2(iS_ppa, cS_ppa, bS_ppa)
    PRINT('PPA Representation Similarity Analysis')
    PRINT('\tRepresentation Enhancement: {0}'.format(repEnhancePPA))
    PRINT('\tRepresentation Suppression: {0}'.format(repSuppressPPA))
    SpatialCorrDF.set_value(i, 'PPARepEnhancement', repEnhancePPA[0])
    SpatialCorrDF.set_value(i, 'PPARepSuppression', repSuppressPPA[0])


for i, subj in enumerate(subjects):
    PRINT('******************* {1}. Subject {0} *****************'.format(subj, i+1))
    runSubjects(i, subj)

SpatialCorrDF.to_csv('/home/despoB/akshayj/TDSigEI/SpatialCorr/TRSE/RepCorr_TRSE.csv')
sys.exit(0)

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
