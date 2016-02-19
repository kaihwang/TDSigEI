# read FIR data into dataframe

import pandas as pd
import glob
import os
import numpy as np
#import scipy.stats
#from ggplot import *

os.chdir('/home/despoB/kaihwang/TRSE/TDSigEI')
Subjects = glob.glob('5*')
#Subjects = [503, 505, 508, 509, 512, 513, 516, 517, 518, 519, 523, 527, 528, 529, 530, 532, 534]


os.chdir('/home/despoB/kaihwang/TRSE/TDSigEI/FIR_1Ds')
ROIs = ['FFA', 'PPA', 'V1']
Conditions = ['FH', 'Fo', 'Fp', 'HF', 'Ho', 'Hp']
#['TD', 'To', 'P']
F_conditions = ['FH', 'Fo', 'Fp']
H_conditions = ['HF', 'Ho', 'Hp']

FIR_df = pd.DataFrame()
for s in Subjects:

	for roi in ROIs:

		for i, cond in enumerate(Conditions):
			#if roi=='FFA':
			#	c = F_conditions[i]
			#if roi=='PPA':	
			#	c = H_conditions[i]
			
			fn = '/home/despoB/kaihwang/TRSE/TDSigEI/FIR_1Ds/%s_%s_%s.1D' %(s, roi, cond)

			tmpdf = pd.DataFrame()
			tmpdf['Beta'] = np.loadtxt(fn)
			tmpdf['ROI'] = roi
			tmpdf['Subj'] = int(s)
			tmpdf['Condition'] = cond
			tmpdf['Volume'] = np.arange(1,22)

			FIR_df = FIR_df.append(tmpdf,  ignore_index=True)


FIR_df.to_csv('/home/despoB/kaihwang/bin/TDSigEI/Data/FIR_df.csv')

#groupedDF = FIR_df.groupby(['ROI','Condition','Volume'])
#SEMdf = groupedDF.aggregate(scipy.stats.sem)
#MEANdf = groupedDF.aggregate(np.mean)
#plotdata = MEANdf.reset_index()
#ggplot(aes(x='Volume', y='Beta', colour='Condition'), data = FIR_df) + stat_smooth(se=True)+ facet_wrap('ROI') + xlim(1, 21)