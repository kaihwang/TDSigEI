import matplotlib.pyplot as plt, numpy as np
from scipy.stats import ttest_rel as tt

spcorr = np.loadtxt('./TRSE/SpCorrTRSEIFG.csv',delimiter=',',skiprows=1,usecols=(0,1,3,4,5,6))
repEn_ffa, repSup_ffa = spcorr[:,2], spcorr[:,3]
repEn_ppa, repSup_ppa = spcorr[:,4], spcorr[:,5]

spcorr2 = np.loadtxt('./TRSE/SpCorrTRSEVERT.csv', delimiter=',',skiprows=1,usecols=(0,1,3,4,5,6))
repEn_ffa2, repSup_ffa2 = spcorr2[:,2], spcorr[:, 3]
repEn_ppa2, repSup_ppa2 = spcorr2[:,4], spcorr[:,5]

print "FFA Rep Suppression t-test:", tt(repEn_ffa, repSup_ffa)
print "PPA Rep Suppression t_test:", tt(repEn_ppa, repSup_ppa)
fig, ax = plt.subplots()

enhanceMeans = [np.mean(repEn_ffa), np.mean(repEn_ffa2), np.mean(repEn_ppa), np.mean(repEn_ppa2)]
suppressMeans = [np.mean(repSup_ffa),np.mean(repSup_ffa2), np.mean(repSup_ppa), np.mean(repSup_ppa2)]
enhanceStd = [np.std(repEn_ffa), np.std(repEn_ffa2), np.std(repEn_ppa), np.std(repEn_ppa2)]
suppressStd = [np.std(repSup_ffa), np.std(repSup_ffa2),  np.std(repSup_ppa), np.std(repSup_ppa2)]

rects1 = ax.bar(np.arange(4), enhanceMeans, 0.35, color='g', yerr=enhanceStd)
rects2 = ax.bar(np.arange(4)+0.35, suppressMeans, 0.35, color = 'b', yerr=suppressStd)

ax.set_ylabel('Spatial Correlation Coefficient')
ax.set_title('Spatial Correlation in FFA and PPA across TMS conditions')
ax.set_xticks(np.arange(4) + 0.35)
ax.set_xticklabels(('FFA_ifg','FFA_vert', 'PPA_ifg', 'PPA_vert'))
ax.set_xlabel('TMS conditions in different functional subregions')
ax.legend((rects1[0],rects2[0]), ('Enhancement', 'Suppression'))

ax.axhline(y=0, color='k')
ax.axvline(x=0, color='k')



plt.show()
