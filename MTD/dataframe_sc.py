# read residual ts data into dataframe

import pandas as pd
import glob
import os
import numpy as np
#import scipy.stats
#from ggplot import *

os.chdir('/home/despoB/kaihwang/TRSE/TDSigEI')
Subjects = glob.glob('5*')

ROIpairs = ['FFA-VC', 'PPA-VC']
ROIs = ['FFA', 'PPA']
Conditions = ['FH', 'HF', 'Fp', 'Hp']
dsets = ['FIR'] #'nusiance'


for dset in dsets:
	TS_df = pd.DataFrame()
	for s in Subjects:
			for i, cond in enumerate(Conditions):
				
				#for roi in ROIpairs:	
				tmpdf = pd.DataFrame()
				#fn = '/home/despoB/kaihwang/TRSE/TDSigEI/%s/1Ds/%s_MTDReg_%s_%s_all.1D' %(s, dset, roi, cond)
				#ts = np.loadtxt(fn)
				tmpdf['Time'] = np.arange(1,361)
				tmpdf['Subject'] = s
				tmpdf['Condition'] = cond
				tmpdf['Dataset'] = dset	
				#tmpdf[roi] = ts[ts!=0]

				for roi in ROIpairs:
					fn = '/home/despoB/kaihwang/TRSE/TDSigEI/%s/1Ds/%s_MTDReg_%s_%s_all.1D' %(s, dset, roi, cond)
					ts = np.loadtxt(fn)
					tmpdf[roi] = ts[ts!=0]		

				TS_df = TS_df.append(tmpdf,  ignore_index=True)

	#os.chdir('/home/despoB/kaihwang/bin/TDSigEI/')
	#fn = '/home/despoB/kaihwang/bin/TDSigEI/Data/TS_%s_df.csv' %dset
	#TS_df.to_csv(fn)

#groupedDF = FIR_df.groupby(['ROI','Condition','Volume'])
#SEMdf = groupedDF.aggregate(scipy.stats.sem)
#MEANdf = groupedDF.aggregate(np.mean)
#plotdata = MEANdf.reset_index()
#ggplot(aes(x='Volume', y='Beta', colour='Condition'), data = FIR_df) + stat_smooth(se=True)+ facet_wrap('ROI') + xlim(1, 21)
