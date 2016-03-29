import os, numpy as np 
import matplotlib.pyplot as plt
from scipy.stats import ttest_rel, ttest_ind
import sys

maskName = sys.argv[1]

os.chdir('./CorrOutput')
# Get the scores from without partial regression
spatialCorr = np.loadtxt('SpatialCorr_df.csv', skiprows=1, delimiter=',')[:,1:]
subjects, ffaEnhance, ffaSuppress, ppaEnhance, ppaSuppress = spatialCorr.T

# Get the scores from partial regression output
spatialCorr_reg = np.loadtxt('SpatialCorr_{0}removed.csv'.format(maskName), skiprows=1, delimiter=',')[:,1:]
subjects_reg, ffaEnhance_reg, ffaSuppress_reg, ppaEnhance_reg, ppaSuppress_reg = spatialCorr_reg.T

# Run paired t-test
tStat_ffaEn, pVal_ffaEn = ttest_rel(ffaEnhance, ffaEnhance_reg)
tStat_ffaSup, pVal_ffaSup = ttest_rel(ffaSuppress, ffaSuppress_reg)
tStat_ppaEn, pVal_ppaEn = ttest_rel(ppaEnhance, ppaEnhance_reg)
tStat_ppaSup, pVal_ppaSup = ttest_rel(ppaSuppress, ppaSuppress_reg)


print 'FFA Enhancement: t-Stat={0}, p-value={1}'.format(tStat_ffaEn, pVal_ffaEn)
print '\t Direction of Effect: {0}'.format(np.mean(ffaEnhance - ffaEnhance_reg))
print 'FFA Suppression: t-Stat={0}, p-value={1}'.format(tStat_ffaSup, pVal_ffaSup)
print '\t Direction of Effect: {0}'.format(np.mean(ffaSuppress - ffaSuppress_reg))
print 'PPA Enhancement: t-Stat={0}, p-value={1}'.format(tStat_ppaEn, pVal_ppaEn)
print '\t Direction of Effect: {0}'.format(np.mean(ppaEnhance - ppaEnhance_reg))
print 'PPA Suppression: t-Stat={0}, p-value={1}'.format(tStat_ppaSup,pVal_ppaSup)
print '\t Direction of Effect: {0}'.format(np.mean(ppaSuppress - ppaSuppress_reg))
