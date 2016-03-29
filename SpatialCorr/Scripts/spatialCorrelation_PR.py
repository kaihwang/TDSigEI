import os, numpy as np, nibabel as nib
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA
from scipy.stats.stats import pearsonr
import pandas as pd
import sys

dataPath = '/home/despoB/kaihwang/TRSE/TDSigEI/'
dataPath2 = '/home/despoB/akshayj/TDSigEI/SpatialCorr/'
subjects = ['503', '505', '508', '509', '510', '512', '513', '516', '517', '518', '519', '523', '527', '528', '529', '530', '531', '532', '534']

repEnhanceArrFFA = np.zeros((len(subjects), 21))
repSuppArrFFA = np.zeros((len(subjects), 21))
repEnhanceArrPPA = np.zeros((len(subjects), 21))
repSuppArrPPA = np.zeros((len(subjects), 21))

SpatialCorrDF = pd.DataFrame()
SpatialCorrDF_pReg = pd.DataFrame()
corrFunc2 = lambda a, c, d: np.array(pearsonr(a, d)) - np.array(pearsonr(c, d))
subjNum = 0

def computeCorrelation(beta_weights, masks):
    FH_beta, HF_beta, Fo_beta, Ho_beta, Fp_beta, Hp_beta = beta_weights
    ffa, ppa = masks

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

    FH_ffaT = FH_beta[ffa!=0]
    HF_ffaT = HF_beta[ffa!=0]
    FH_ppaT = FH_beta[ppa!=0]
    HF_ppaT = HF_beta[ppa!=0]

    #1. Compared to target only condition as template for FFA
    ffaRepEnhancement = corrFunc2(FH_ffa, Fp_ffa, Fo_ffa)[0]
    ffaRepSuppression = corrFunc2(HF_ffa, Fp_ffa, Fo_ffa)[0]
    print('1. FFA Representation Similarity compared to attention only')
    print('\tRepresentation Enhancement: {0}'.format(ffaRepEnhancement))
    print('\tRepresentation Suppression: {0}'.format(ffaRepSuppression))

    #2. Compared to target only condition as template for PPA
    ppaRepEnhancement = corrFunc2(HF_ppa, Hp_ppa, Ho_ppa)[0]
    ppaRepSuppression = corrFunc2(FH_ppa, Hp_ppa, Ho_ppa)[0]
    print('2. PPA Representation Similarity compared to attention only')
    print('\tRepresentation Enhancement: {0}'.format(ppaRepEnhancement))
    print('\tRepresentation Suppression: {0}'.format(ppaRepSuppression))

    return ffaRepEnhancement, ffaRepSuppression, ppaRepEnhancement, ppaRepSuppression
    
maskName = sys.argv[1]
for i, subj in enumerate(subjects):

    print '*******************{1}. SUBJECT {0}*******************'.format(subj, i)
    SpatialCorrDF.set_value(i, 'Subject', subj)
    SpatialCorrDF_pReg.set_value(i, 'Subject', subj)
    os.chdir(dataPath2+subj)
    #convert to nifti
    files = os.listdir('./{0}removed/'.format(maskName))
    if 'FIR_Hp_{0}removed.nii.gz'.format(maskName) not in files:
        os.system("3dAFNItoNIFTI -prefix FIR_FH_{0}removed.nii.gz {0}removed/FH_FIR_{0}removed+tlrc".format(maskName))
        os.system("3dAFNItoNIFTI -prefix FIR_HF_{0}removed.nii.gz {0}removed/HF_FIR_{0}removed+tlrc".format(maskName))
        os.system("3dAFNItoNIFTI -prefix FIR_Fo_{0}removed.nii.gz {0}removed/Fo_FIR_{0}removed+tlrc".format(maskName))
        os.system("3dAFNItoNIFTI -prefix FIR_Ho_{0}removed.nii.gz {0}removed/Ho_FIR_{0}removed+tlrc".format(maskName))
        os.system("3dAFNItoNIFTI -prefix FIR_Fp_{0}removed.nii.gz {0}removed/Fp_FIR_{0}removed+tlrc".format(maskName))
        os.system("3dAFNItoNIFTI -prefix FIR_Hp_{0}removed.nii.gz {0}removed/Hp_FIR_{0}removed+tlrc".format(maskName))
    else:
        print('Skipping afni to nifti file conversion...')
    FH_beta_pReg = nib.load(dataPath2 + subj + '/FIR_FH_{0}removed.nii.gz'.format(maskName)).get_data()
    HF_beta_pReg = nib.load(dataPath2 + subj + '/FIR_HF_{0}removed.nii.gz'.format(maskName)).get_data()
    Fo_beta_pReg = nib.load(dataPath2 + subj + '/FIR_Fo_{0}removed.nii.gz'.format(maskName)).get_data()
    Ho_beta_pReg = nib.load(dataPath2 + subj + '/FIR_Ho_{0}removed.nii.gz'.format(maskName)).get_data()
    Fp_beta_pReg = nib.load(dataPath2 + subj + '/FIR_Fp_{0}removed.nii.gz'.format(maskName)).get_data()
    Hp_beta_pReg = nib.load(dataPath2 + subj + '/FIR_Hp_{0}removed.nii.gz'.format(maskName)).get_data()

    FH_beta = nib.load(dataPath + subj + '/FIR_FH.nii.gz').get_data()
    HF_beta = nib.load(dataPath + subj + '/FIR_HF.nii.gz').get_data()
    Fo_beta = nib.load(dataPath + subj + '/FIR_Fo.nii.gz').get_data()
    Ho_beta = nib.load(dataPath + subj + '/FIR_Ho.nii.gz').get_data()
    Fp_beta = nib.load(dataPath + subj + '/FIR_Fp.nii.gz').get_data()
    Hp_beta = nib.load(dataPath + subj + '/FIR_Fp.nii.gz').get_data()

    ffa = nib.load(dataPath + subj + '/FFA_indiv_ROI.nii.gz').get_data()
    ppa = nib.load(dataPath + subj + '/PPA_indiv_ROI.nii.gz').get_data()
    
    masks = (ffa, ppa)
    beta_weights1 = [FH_beta, HF_beta, Fo_beta, Ho_beta, Fp_beta, Hp_beta]
    beta_weights2 = [FH_beta_pReg, HF_beta_pReg, Fo_beta_pReg, Ho_beta_pReg, Fp_beta_pReg, Hp_beta_pReg]

    ffaRepEnhancement, ffaRepSuppression, ppaRepEnhancement, ppaRepSuppression = computeCorrelation(beta_weights1, masks)
    ffaRepEnhancement_pReg, ffaRepSuppression_pReg, ppaRepEnhancement_pReg, ppaRepSuppression_pReg = computeCorrelation(beta_weights2, masks)

    SpatialCorrDF.set_value(i, 'FFARepEnhancement', ffaRepEnhancement)
    SpatialCorrDF.set_value(i, 'FFARepSuppression', ffaRepSuppression)
    SpatialCorrDF.set_value(i, 'PPARepEnhancement', ppaRepEnhancement)
    SpatialCorrDF.set_value(i, 'PPARepSuppression', ppaRepSuppression)

    SpatialCorrDF_pReg.set_value(i, 'FFARepEnhancement', ffaRepEnhancement_pReg)
    SpatialCorrDF_pReg.set_value(i, 'FFARepSuppression', ffaRepSuppression_pReg)
    SpatialCorrDF_pReg.set_value(i, 'PPARepEnhancement', ppaRepEnhancement_pReg)
    SpatialCorrDF_pReg.set_value(i, 'PPARepSuppression', ppaRepSuppression_pReg)

    
    # # Measure 4a: Time series correlation coefficient for FFA
    # repEnhanceArr1 = np.zeros(FH_ffaT.shape[1])
    # repSuppArr1 = np.zeros(FH_ffaT.shape[1])
    # for i in range(FH_ffaT.shape[1]):
    #     repEnhanceArr1[i] = corrFunc2(FH_ffaT[:,i], Fp_ffa, Fo_ffa)[0]
    #     repSuppArr1[i] = corrFunc2(HF_ffaT[:, i], Fp_ffa, Fo_ffa)[0]
    # repEnhanceArrFFA[subjNum, :] = repEnhanceArr1
    # repSuppArrFFA[subjNum, :] = repSuppArr1
    # print('Measure 4a: Time series pattern enhancement/suppression for FFA')

    # # Measure 4b: Time series correlation coefficient for PPA
    # repEnhanceArr2 = np.zeros(FH_ppaT.shape[1])
    # repSuppArr2 = np.zeros(FH_ppaT.shape[1])
    # for i in range(FH_ppaT.shape[1]):
    #     repEnhanceArr2[i] = corrFunc2(HF_ppaT[:,i], Hp_ppa, Ho_ppa)[0]
    #     repSuppArr2[i] = corrFunc2(FH_ppaT[:, i], Hp_ppa, Ho_ppa)[0]
    # repEnhanceArrPPA[subjNum, :] = repEnhanceArr2
    # repSuppArrPPA[subjNum, :] = repSuppArr2
    # print('Measure 4b: Time series pattern enhancement/suppression for PPA')
    # print('FFA Shape', FH_ffaT.shape)
    # print('PPA Shape', FH_ppaT.shape)

    subjNum += 1
    #end for loop

SpatialCorrDF.to_csv('/home/despoB/akshayj/TDSigEI/SpatialCorr/CorrOutput/SpatialCorr_df.csv')
SpatialCorrDF_pReg.to_csv('/home/despoB/akshayj/TDSigEI/SpatialCorr/CorrOutput/SpatialCorr_{0}removed.csv'.format(maskName))
# # Average across subjects for PPA
# enhanceMeanPPA = repEnhanceArrPPA.mean(0)
# enhanceErrorPPA = repEnhanceArrPPA.std(0) / np.sqrt(len(subjects))
# suppMeanPPA = repSuppArrPPA.mean(0)
# suppErrorPPA = repSuppArrPPA.std(0) / np.sqrt(len(subjects))

# # Average across subjects for FFA
# enhanceMean = repEnhanceArrFFA.mean(0)
# enhanceError = repEnhanceArrFFA.std(0)/np.sqrt(len(subjects))
# suppressMean = repSuppArrFFA.mean(0)
# suppressError = repSuppArrFFA.std(0)/np.sqrt(len(subjects))

# x = np.linspace(1, len(repSuppArr1), len(repSuppArr1))
# plt.subplot(1, 2, 1)
# plt.plot(x, enhanceMean, ':bo', label='Enhancement')
# plt.plot(x, suppressMean, '-ro', label='Suppression')
# plt.fill_between(x, enhanceMean - 0.75*enhanceError, enhanceMean + 0.75*enhanceError, alpha=0.2, edgecolor='c', facecolor='c')
# plt.fill_between(x, suppressMean - 0.75*suppressError, suppressMean + 0.75*suppressError, alpha = 0.2, edgecolor='m', facecolor='m')
# plt.title('Representation Similarity across time for faces in FFA')
# plt.xlabel('Time')
# plt.ylabel('Correlation Coefficient')
# plt.legend()

# plt.subplot(1, 2, 2)
# plt.plot(x, enhanceMeanPPA, ':bo', label='Enhancement')
# plt.plot(x, suppMeanPPA, '-ro', label='Suppression')
# plt.fill_between(x, enhanceMeanPPA - 0.75*enhanceErrorPPA, enhanceMeanPPA + 0.75*enhanceErrorPPA, alpha=0.2, edgecolor='c', facecolor='c')
# plt.fill_between(x, suppMeanPPA - 0.75*suppErrorPPA, suppMeanPPA + 0.75*suppErrorPPA, alpha=0.2, edgecolor='m', facecolor='m')
# plt.title('Representation Similarity across time for houses in PPA')
# plt.xlabel('Time')
# plt.ylabel('Correlation Coefficient')
# plt.legend()
# plt.show()
