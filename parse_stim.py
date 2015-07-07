import fileinput
import csv
import sys
import pandas as pd
import glob
import numpy as np
import os.path

#parse block order
cd /home/despoB/kaihwang/TRSE/TDSigEI/
Subjects = glob.glob('5*')

cd /home/despoB/kaihwang/TRSE/TDSigEI/Scripts/Logs

for s in Subjects:
	fn = '/home/despoB/TRSEPPI/TDSigEI/Scripts/%s_block_order' %s
	if os.path.isfile(fn) is False:

		filestring = 'fMRI_Data_%s' %s
		timing_logs = glob.glob(filestring)

		df = pd.read_table(timing_logs[0], header= None).append(pd.read_table(timing_logs[1], header= None)).append(pd.read_table(timing_logs[2], header= None)).append(pd.read_table(timing_logs[3], header= None))
df.columns = ['SubjID', 'Condition', 'MotorMapping', 'Target', 'Accu', 'FA', 'RH', 'LH', 'RT', 'OnsetTime', 'pic']
		df['Block'] = np.repeat(np.arange(1, 25),48)
		df.groupby(['Block', 'Condition', 'MotorMapping']).sum().reset_index()[['Condition','MotorMapping']].to_csv(fn, index=None, header=None, )



#create FIR regressors
block_start_time = np.tile(([1.5, 42, 82.5, 121.5]),[4,1])
for tr in np.arange(0,18):
    StimTime = block_start_time + tr * 1.5
    g = tr+1
    fn = '/home/despoB/TRSEPPI/TDSigEI/Scripts/FIR_%s.1D' %g
    if os.path.isfile(fn) is False:
    	np.savetxt(fn, StimTime, fmt='%2.2f')

	