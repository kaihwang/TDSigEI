import matplotlib.pyplot as plt, numpy as np
from scipy.stats import ttest_rel as tt

spcorr = np.loadtxt('./CorrOutput/SpatialCorr_df.csv',delimiter=',',skiprows=1)
repEn_ffa, repSup_ffa = spcorr[:,2], spcorr[:,3]
repEn_ppa, repSup_ppa = spcorr[:,4], spcorr[:,5]

print "FFA Rep Suppression t-test:", tt(repEn_ffa, repSup_ffa)
print "PPA Rep Suppression t_test:", tt(repEn_ppa, repSup_ppa)
fig, ax = plt.subplots()

enhanceMeans = [np.mean(repEn_ffa), np.mean(repEn_ppa)]
suppressMeans = [np.mean(repSup_ffa), np.mean(repSup_ppa)]
enhanceStd = [np.std(repEn_ffa), np.std(repEn_ppa)]
suppressStd = [np.std(repSup_ffa), np.std(repSup_ppa)]

rects1 = ax.bar(np.arange(2), enhanceMeans, 0.35, color='g', yerr=enhanceStd)
rects2 = ax.bar(np.arange(2)+0.35, suppressMeans, 0.35, color = 'b', yerr=suppressStd)

ax.set_ylabel('Spatial Correlation Coefficient')
ax.set_title('Spatial Correlation in FFA and PPA')
ax.set_xticks(np.arange(2) + 0.35)
ax.set_xticklabels(('FFA', 'PPA'))
ax.legend((rects1[0], rects2[0]), ('Enhancement', 'Suppression'))

ax.axhline(y=0, color='k')
ax.axvline(x=0, color='k')

plt.show()
