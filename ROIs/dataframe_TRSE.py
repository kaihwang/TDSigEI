# read FIR data into dataframe

import pandas as pd
import glob
import os
import numpy as np
#import scipy.stats
#from ggplot import *

os.chdir('/home/despoB/kaihwang/TRSE/TDSigEI')
Subjects = [1106, 1107, 1109, 1110, 1111, 1112, 1113, 1114, 1116, 1401, 1403, 1404, 1405, 1406, 1407, 1408, 1409, 1411, 1412, 1413, 1414, 1415, 1416, 1417, 1418, 1419, 1422, 1423, 1426, 1427, 1429, 1430, 1431, 620, 623, 627, 628, 629, 630, 631, 632, 633, 634, 636, 637, 638, 639, 640, 7601, 7604, 7611, 7613, 7614, 7616, 7620, 7621]
#Subjects = [503, 505, 508, 509, 512, 513, 516, 517, 518, 519, 523, 527, 528, 529, 530, 532, 534]


os.chdir('/home/despoB/kaihwang/TRSE/TRSEPPI/Group/FIR_1Ds')
ROIs = ['FFA', 'PPA', 'V1', 'MFG', 'FEF', 'RIFJ', 'LMFG']
Conditions = ['categorize_face', 'categorize_scene', 'relevant_face', 'relevant_scene', 'irrelevant_face', 'irrelevant_scene', 'both_face', 'both_scene',]
#['TD', 'To', 'P']

FIR_df = pd.DataFrame()
for s in Subjects:

	for roi in ROIs:

		for i, cond in enumerate(Conditions):
			#if roi=='FFA':
			#	c = F_conditions[i]
			#if roi=='PPA':	
			#	c = H_conditions[i]
			
			fn = '/home/despoB/kaihwang/TRSE/TRSEPPI/Group/FIR_1Ds/%s_%s_%s.1D' %(s, roi, cond)

			tmpdf = pd.DataFrame()
			tmpdf['Beta'] = np.loadtxt(fn)
			tmpdf['ROI'] = roi
			tmpdf['Subj'] = int(s)
			tmpdf['Condition'] = cond
			tmpdf['Volume'] = np.arange(1,16)

			FIR_df = FIR_df.append(tmpdf,  ignore_index=True)


FIR_df.to_csv('/home/despoB/kaihwang/bin/TDSigEI/Data/TRSEFIR_df.csv')

#groupedDF = FIR_df.groupby(['ROI','Condition','Volume'])
#SEMdf = groupedDF.aggregate(scipy.stats.sem)
#MEANdf = groupedDF.aggregate(np.mean)
#plotdata = MEANdf.reset_index()
#ggplot(aes(x='Volume', y='Beta', colour='Condition'), data = FIR_df) + stat_smooth(se=True)+ facet_wrap('ROI') + xlim(1, 21)