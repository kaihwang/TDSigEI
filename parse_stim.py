import fileinput
import csv
import sys
import pandas as pd
import glob
import numpy as np
import os.path

#parse block order
os.chdir('/home/despoB/kaihwang/TRSE/TDSigEI')
#Subjects = glob.glob('5*')
Subjects =[503, 505, 508, 509, 512, 513, 516, 517, 518, 523, 527]

os.chdir('/home/despoB/kaihwang/TRSE/TDSigEI/Scripts/Logs')

for s in Subjects:

	fn = '/home/despoB/TRSEPPI/TDSigEI/Scripts/%s_block_order' %s
	
	filestring = 'fMRI_Data_%s*.txt' %s
	timing_logs = glob.glob(filestring)

	df = pd.read_table(timing_logs[0], header= None).append(pd.read_table(timing_logs[1], header= None)).append(pd.read_table(timing_logs[2],header= None)).append(pd.read_table(timing_logs[3], header= None))
	df.columns = ['SubjID', 'Condition', 'MotorMapping', 'Target', 'Accu', 'FA', 'RH', 'LH', 'RT', 'OnsetTime', 'pic']

	df['Block'] = np.repeat(np.arange(1, 25),48)

	if os.path.isfile(fn) is False:			
		df.groupby(['Block', 'Condition', 'MotorMapping']).sum().reset_index()[['Condition','MotorMapping']].to_csv(fn, index=None, header=None, )
	
	#create localizer regressors
	Face_stimtime = [['*']*24]
	House_stimtime = [['*']*24]
	RH_stimtime = [['*']*24]
	LH_stimtime = [['*']*24]

	for block in np.arange(1,25):
		block_df = df[df['Block']==block].reset_index()
		Face_block_trials = []
		House_block_trials = []
		RH_block_trials = []
		LH_block_trials = []
		
		for tr in np.arange(0, len(block_df)):
			
			if block_df.loc[tr,'Condition'] in ('Fp', 'Fo', 'FH'):
				Face_block_trials.append(block_df.loc[tr,'OnsetTime'])

			if block_df.loc[tr,'Condition'] in ('Hp', 'Ho', 'HF'):	
				House_block_trials.append(block_df.loc[tr,'OnsetTime'])

			if block_df.loc[tr,'RH']:
				RH_block_trials.append(block_df.loc[tr,'OnsetTime'] + block_df.loc[tr,'RT'] )						
			
			if block_df.loc[tr,'LH']:
				LH_block_trials.append(block_df.loc[tr,'OnsetTime'] + block_df.loc[tr,'RT'])

		if any(Face_block_trials):
			Face_stimtime[0][block-1] = Face_block_trials
		
		if any(House_block_trials):
			House_stimtime[0][block-1] = House_block_trials
		
		if any(RH_block_trials):
			RH_stimtime[0][block-1] = RH_block_trials
		
		if any(LH_block_trials):	
			LH_stimtime[0][block-1] = LH_block_trials

	fn = '/home/despoB/TRSEPPI/TDSigEI/Scripts/%s_face_stimtime.1D' %s
	if os.path.isfile(fn) is False:
		f = open(fn, 'w')
		for val in Face_stimtime[0]:
			if val =='*':
				f.write(val + '\n')
			else:
				f.write(np.array2string(np.around(val,2)).replace('\n','')[4:-1] + '\n')
		f.close()

	fn = '/home/despoB/TRSEPPI/TDSigEI/Scripts/%s_house_stimtime.1D' %s
	if os.path.isfile(fn) is False:
		f = open(fn, 'w')
		for val in House_stimtime[0]:
			if val =='*':
				f.write(val + '\n')
			else:
				f.write(np.array2string(np.around(val,2)).replace('\n','')[4:-1] + '\n')
		f.close()

	fn = '/home/despoB/TRSEPPI/TDSigEI/Scripts/%s_RH_stimtime.1D' %s
	if os.path.isfile(fn) is False:
		f = open(fn, 'w')
		for val in RH_stimtime[0]:
			if val =='*':
				f.write(val + '\n')
			else:
				f.write(np.array2string(np.around(val,2)).replace('\n','')[4:-1] + '\n')
		f.close()

	fn = '/home/despoB/TRSEPPI/TDSigEI/Scripts/%s_LH_stimtime.1D' %s
	if os.path.isfile(fn) is False:
		f = open(fn, 'w')
		for val in LH_stimtime[0]:
			if val =='*':
				f.write(val + '\n')
			else:
				f.write(np.array2string(np.around(val,2)).replace('\n','')[4:-1] + '\n')
		f.close()


#create FIR regressors
block_start_time = np.tile(([1.5, 42, 82.5, 121.5]),[4,1])
for tr in np.arange(0,18):
    StimTime = block_start_time + tr * 1.5
    g = tr+1
    fn = '/home/despoB/TRSEPPI/TDSigEI/Scripts/FIR_%s.1D' %g
    if os.path.isfile(fn) is False:
    	np.savetxt(fn, StimTime, fmt='%2.2f')




	
