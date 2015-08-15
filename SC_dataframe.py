# read residual ts data into dataframe

import pandas as pd
import glob
import os
import numpy as np
import scipy.stats
from ggplot import *

#os.chdir('/home/despoB/kaihwang/TRSE/TDSigEI')
#Subjects = glob.glob('5*')
Subjects = [503, 505, 508, 509, 512, 513, 516, 517, 518, 519, 523, 527, 528, 529, 530, 532, 534]

ROIs = ['FFA', 'PPA', 'RH', 'LH']
Conditions = ['FH', 'Fo', 'Fp', 'HF', 'Ho', 'Hp']
MotorMapping = ['motor1', 'motor2']
Runs = ['run1', 'run2']
#['TD', 'To', 'P']


TS_df = pd.DataFrame()
for s in Subjects:

		for i, cond in enumerate(Conditions):
			
			for m, mapping in enumerate(MotorMapping):
				for r, run in enumerate(Runs):
					
					tmpdf = pd.DataFrame()
					tmpdf['Time'] = np.arange(1,103)
					tmpdf['Subject'] = s
					tmpdf['Condition'] = cond
					tmpdf['MotorMapping'] = m+1
					tmpdf['Run'] = r+1
					
					for roi in ROIs:
						fn = '/home/despoB/kaihwang/TRSE/TDSigEI/SC_1Ds/%s_%s_%s_%s_%s.1D' %(s, roi, cond, mapping, run)
						tmpdf[roi] = np.loadtxt(fn)
						

					TS_df = TS_df.append(tmpdf,  ignore_index=True)

os.chdir('/home/despoB/kaihwang/bin/TDSigEI/')
TS_df.to_csv('/home/despoB/kaihwang/bin/TDSigEI/Data/TS_df.csv')

#groupedDF = FIR_df.groupby(['ROI','Condition','Volume'])
#SEMdf = groupedDF.aggregate(scipy.stats.sem)
#MEANdf = groupedDF.aggregate(np.mean)
#plotdata = MEANdf.reset_index()
#ggplot(aes(x='Volume', y='Beta', colour='Condition'), data = FIR_df) + stat_smooth(se=True)+ facet_wrap('ROI') + xlim(1, 21)