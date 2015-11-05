import os, numpy as np, nibabel as nib
from sklearn.decomposition import PCA
from scipy.stats.stats import pearsonr

dataPath = '/home/despoB/kaihwang/TRSE/TDSigEI/'
subjects = ['503', '505', '508', '509', '510', '512', '513', '516', '517', '518', '519', '523', '527', '528', '529', '530', '531', '532', '534']

# blocks_to_keep = range(1,20) + range(28,47) + range(55,74) + range(82,101) \
# + range(1+102,20+102) + range(28+102,47+102) + range(55+102,74+102) + range(82+102,101+102) \
# + range(1+204,20+204) + range(28+204,47+204) + range(55+204,74+204) + range(82+204,101+204) \
# + range(1+306,20+306) + range(28+306,47+306) + range(55+306,74+306) + range(82+306,101+306) 


for subj in subjects:

    os.chdir(dataPath+subj)
    #convert to nifti
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

    # Measure 1: Representation selectivity
    corrFuncFace = lambda c: np.array(pearsonr(c, Fo_ffa)) - np.array(pearsonr(c, Ho_ffa))
    corrFuncHouse = lambda c: np.array(pearsonr(c, Ho_ppa)) - np.array(pearsonr(c, Fo_ppa))

    print("sujbect " + str(subj))
    faceAttn = corrFuncFace(FH_ffa)
    faceBaseline = corrFuncFace(Fp_ffa)
    faceInhib = corrFuncFace(HF_ffa)
    HouseAttn = corrFuncHouse(HF_ppa)
    HouseBaseline = corrFuncHouse(Hp_ppa)
    HouseInhib = corrFuncHouse(FH_ppa)
    print ("Measure 1: Representation Selectivity")
    print('\tFace Attn: {0}\n\t Face Baseline: {1}\n\t Face Inhibition {2}'.format(faceAttn[0], faceBaseline[0], faceInhib[0]))
    print('\tHouse Attn: {0}\n\t House Baseline: {1}\n\t House Inhibition {2}'.format(HouseAttn[0], HouseBaseline[0], HouseInhib[0]))

    # Measure 2a: Representation similarity compared to passive condition as template
    corrFunc2 = lambda a, c, d: np.array(pearsonr(a, d)) - np.array(pearsonr(c, d))
    repEnhancement = corrFunc2(FH_ffa, Fo_ffa, Fp_ffa)
    repSuppression = corrFunc2(HF_ffa, Fo_ffa, Fp_ffa)
    print('Measure 2a: Face region Representation Similarity compared to passive condition as template')
    print('\tRepresentation Enhancement: {0}'.format(repEnhancement[0]))
    print('\tRepresentation Suppression: {0}'.format(repSuppression[0]))

    #Measure 2b: Compared to target only condition as template
    repEnhancementB = corrFunc2(FH_ffa, Fp_ffa, Fo_ffa)
    repSuppressionB = corrFunc2(HF_ffa, Fp_ffa, Fo_ffa)
    print('Measure 2b: Face region Representation Similarity compared to target only condition as template')
    print('\tRepresentation Enhancement: {0}'.format(repEnhancementB[0]))
    print('\tRepresentation Suppression: {0}'.format(repSuppressionB[0]))

    repEnhancement = corrFunc2(HF_ppa, Ho_ppa, Hp_ppa)
    repSuppression = corrFunc2(FH_ppa, Ho_ppa, Hp_ppa)
    print('Measure 2a: House region Representation Similarity compared to passive condition as template')
    print('\tRepresentation Enhancement: {0}'.format(repEnhancement[0]))
    print('\tRepresentation Suppression: {0}'.format(repSuppression[0]))

    #Measure 2b: Compared to target only condition as template
    repEnhancementB = corrFunc2(HF_ppa, Hp_ppa, Ho_ppa)
    repSuppressionB = corrFunc2(FH_ppa, Hp_ppa, Ho_ppa)
    print('Measure 2b: House region Representation Similarity compared to target only condition as template')
    print('\tRepresentation Enhancement: {0}'.format(repEnhancementB[0]))
    print('\tRepresentation Suppression: {0}'.format(repSuppressionB[0]))

