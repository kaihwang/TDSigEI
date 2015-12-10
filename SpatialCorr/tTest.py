import os, numpy as np, nibabel as nib
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA
from scipy.stats import ttest_rel, ttest_ind
import pandas as pd

# Get the scores from without partial regression
spatialCorr = np.loadtxt('SpatialCorr_df.csv', skiprows=1, delimiter=',')[:,1:]
subjects, ffaEnhance, ffaSuppress, ppaEnhance, ppaSuppress = spatialCorr.T

# Get the scores from partial regression output
spatialCorr_reg = np.loadtxt('SpatialCorr_df_pReg.csv', skiprows=1, delimiter=',')[:,1:]
subjects_reg, ffaEnhance_reg, ffaSuppress_reg, ppaEnhance_reg, ppaSuppress_reg = spatialCorr_reg.T

# Run paired t-test
tStat_ffaEn, pVal_ffaEn = ttest_rel(ffaEnhance, ffaEnhance_reg)
tStat_ffaSup, pVal_ffaSup = ttest_rel(ffaSuppress, ffaSuppress_reg)
tStat_ppaEn, pVal_ppaEn = ttest_rel(ppaEnhance, ppaEnhance_reg)
tStat_ppaSup, pVal_ppaSup = ttest_rel(ppaSuppress, ppaSuppress_reg)


print 'FFA Enhancement: t-Stat={0}, p-value={1}'.format(tStat_ffaEn, pVal_ffaEn)
print 'FFA Suppression: t-Stat={0}, p-value={1}'.format(tStat_ffaSup, pVal_ffaSup)
print 'PPA Enhancement: t-Stat={0}, p-value={1}'.format(tStat_ppaEn, pVal_ppaEn)
print 'PPA Suppression: t-Stat={0}, p-value={1}'.format(tStat_ppaSup,pVal_ppaSup)
