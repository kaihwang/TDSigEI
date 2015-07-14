import fileinput
import csv
import sys
import pandas as pd
import glob
import numpy as np
import os.path

#parse block order
os.chdir('/home/despoB/kaihwang/TRSE/TDSigEI')
Subjects = glob.glob('5*')
#Subjects =[503, 505, 508, 509, 512, 513, 516, 517, 518, 523, 527]

os.chdir('/home/despoB/kaihwang/TRSE/TDSigEI/Scripts/Logs')

for s in Subjects:

	fn = '/home/despoB/TRSEPPI/TDSigEI/Scripts/%s_run_order' %s
	
	filestring = 'fMRI_Data_%s*.txt' %s
	timing_logs = glob.glob(filestring)

	df = pd.read_table(timing_logs[3], header= None).append(pd.read_table(timing_logs[2], header= None)).append(pd.read_table(timing_logs[1],header= None)).append(pd.read_table(timing_logs[0], header= None))
	df.columns = ['SubjID', 'Condition', 'MotorMapping', 'Target', 'Accu', 'FA', 'RH', 'LH', 'RT', 'OnsetTime', 'pic']

	df['Block'] = np.repeat(np.arange(1, 25),48)

	run_order = df.groupby(['Block', 'Condition', 'MotorMapping']).sum().reset_index()[['Block', 'Condition', 'MotorMapping']]
	if os.path.isfile(fn) is False:			
		run_order[['Condition','MotorMapping']].to_csv(fn, index=None, header=None, )
	
	#write out mapping runs
	mapping_runs = run_order[(run_order['Condition'] == 'Hp') | (run_order['Condition'] == 'Fp')]['Block'].values
	fn = '/home/despoB/TRSEPPI/TDSigEI/Scripts/%s_mapping_runs' %s
	if os.path.isfile(fn) is False:			
		np.savetxt(fn, mapping_runs, fmt='%2d')

	#write out target+distractor (TD) runs
	TD_runs = run_order[(run_order['Condition'] == 'HF') | (run_order['Condition'] == 'FH')]['Block'].values	
	fn = '/home/despoB/TRSEPPI/TDSigEI/Scripts/%s_TD_runs' %s
	if os.path.isfile(fn) is False:			
		np.savetxt(fn, TD_runs, fmt='%2d')

	#write out target only runs	
	To_runs = run_order[(run_order['Condition'] == 'Ho') | (run_order['Condition'] == 'Fo')]['Block'].values	
	fn = '/home/despoB/TRSEPPI/TDSigEI/Scripts/%s_To_runs' %s
	if os.path.isfile(fn) is False:			
		np.savetxt(fn, To_runs, fmt='%2d')


	#create TD stimulus timing for gPPI analysis
	TD_FT_stimtime = [['*']*8] #8 runs of TD conditions
	TD_FD_stimtime = [['*']*8] 
	TD_HT_stimtime = [['*']*8] 
	TD_HD_stimtime = [['*']*8] 
	TD_RH_stimtime = [['*']*8] #extract responses
	TD_LH_stimtime = [['*']*8] 

	for i, block in enumerate(TD_runs):
		block_df = df[df['Block']==block].reset_index()
		FT_block_trials = []
		FD_block_trials = []
		HT_block_trials = []
		HD_block_trials = []
		RH_block_trials = []
		LH_block_trials = []

		for tr in np.arange(0, len(block_df)):
			
			if block_df.loc[tr,'Condition'] in ('FH'):
				FT_block_trials.append(block_df.loc[tr,'OnsetTime'])
				HD_block_trials.append(block_df.loc[tr,'OnsetTime'])

			if block_df.loc[tr,'Condition'] in ('HF'):	
				HT_block_trials.append(block_df.loc[tr,'OnsetTime'])
				FD_block_trials.append(block_df.loc[tr,'OnsetTime'])

			if block_df.loc[tr,'RH'] and block_df.loc[tr,'Condition'] in ('FH', 'HF'):
				RH_block_trials.append(block_df.loc[tr,'OnsetTime'] + block_df.loc[tr,'RT'])  						
			
			if block_df.loc[tr,'LH'] and block_df.loc[tr,'Condition'] in ('HF', 'FH'):
				LH_block_trials.append(block_df.loc[tr,'OnsetTime'] + block_df.loc[tr,'RT'])

		if any(FT_block_trials):
			TD_FT_stimtime[0][i] = FT_block_trials
		if any(FD_block_trials):
			TD_FD_stimtime[0][i] = FD_block_trials
		if any(HT_block_trials):
			TD_HT_stimtime[0][i] = HT_block_trials
		if any(HD_block_trials):
			TD_HD_stimtime[0][i] = HD_block_trials
		if any(RH_block_trials):
			TD_RH_stimtime[0][i] = RH_block_trials
		if any(LH_block_trials):
			TD_LH_stimtime[0][i] = LH_block_trials	

	fn = '/home/despoB/TRSEPPI/TDSigEI/Scripts/%s_TD_FT_stimtime.1D' %s
	if os.path.isfile(fn) is False:
		f = open(fn, 'w')
		for val in TD_FT_stimtime[0]:
			if val =='*':
				f.write(val + '\n')
			else:
				f.write(np.array2string(np.around(val,2)).replace('\n','')[4:-1] + '\n')
		f.close()

	fn = '/home/despoB/TRSEPPI/TDSigEI/Scripts/%s_TD_FD_stimtime.1D' %s
	if os.path.isfile(fn) is False:
		f = open(fn, 'w')
		for val in TD_FD_stimtime[0]:
			if val =='*':
				f.write(val + '\n')
			else:
				f.write(np.array2string(np.around(val,2)).replace('\n','')[4:-1] + '\n')
		f.close()

	fn = '/home/despoB/TRSEPPI/TDSigEI/Scripts/%s_TD_HT_stimtime.1D' %s
	if os.path.isfile(fn) is False:
		f = open(fn, 'w')
		for val in TD_HT_stimtime[0]:
			if val =='*':
				f.write(val + '\n')
			else:
				f.write(np.array2string(np.around(val,2)).replace('\n','')[4:-1] + '\n')
		f.close()

	fn = '/home/despoB/TRSEPPI/TDSigEI/Scripts/%s_TD_HD_stimtime.1D' %s
	if os.path.isfile(fn) is False:
		f = open(fn, 'w')
		for val in TD_HD_stimtime[0]:
			if val =='*':
				f.write(val + '\n')
			else:
				f.write(np.array2string(np.around(val,2)).replace('\n','')[4:-1] + '\n')
		f.close()				

	fn = '/home/despoB/TRSEPPI/TDSigEI/Scripts/%s_TD_RH_stimtime.1D' %s
	if os.path.isfile(fn) is False:
		f = open(fn, 'w')
		for val in TD_RH_stimtime[0]:
			if val =='*':
				f.write(val + '\n')
			else:
				f.write(np.array2string(np.around(val,2)).replace('\n','')[4:-1] + '\n')
		f.close()				


	fn = '/home/despoB/TRSEPPI/TDSigEI/Scripts/%s_TD_LH_stimtime.1D' %s
	if os.path.isfile(fn) is False:
		f = open(fn, 'w')
		for val in TD_LH_stimtime[0]:
			if val =='*':
				f.write(val + '\n')
			else:
				f.write(np.array2string(np.around(val,2)).replace('\n','')[4:-1] + '\n')
		f.close()				


	


	#create To stimulus timing for gPPI analysis
	To_Fo_stimtime = [['*']*8] #8 runs of To conditions
	To_Ho_stimtime = [['*']*8] 
	To_RH_stimtime = [['*']*8] #extract responses
	To_LH_stimtime = [['*']*8] 

	for i, block in enumerate(To_runs):
		block_df = df[df['Block']==block].reset_index()
		Fo_block_trials = []
		Ho_block_trials = []
		RH_block_trials = []
		LH_block_trials = []

		for tr in np.arange(0, len(block_df)):
			
			if block_df.loc[tr,'Condition'] in ('Fo'):
				Fo_block_trials.append(block_df.loc[tr,'OnsetTime'])

			if block_df.loc[tr,'Condition'] in ('Ho'):	
				Ho_block_trials.append(block_df.loc[tr,'OnsetTime'])

			if block_df.loc[tr,'RH'] and block_df.loc[tr,'Condition'] in ('Fo', 'Ho'):
				RH_block_trials.append(block_df.loc[tr,'OnsetTime'] + block_df.loc[tr,'RT'])  						
			
			if block_df.loc[tr,'LH'] and block_df.loc[tr,'Condition'] in ('Ho', 'Fo'):
				LH_block_trials.append(block_df.loc[tr,'OnsetTime'] + block_df.loc[tr,'RT'])

		if any(Fo_block_trials):
			To_Fo_stimtime[0][i] = Fo_block_trials

		if any(Ho_block_trials):
			To_Ho_stimtime[0][i] = Ho_block_trials

		if any(RH_block_trials):
			To_RH_stimtime[0][i] = RH_block_trials

		if any(LH_block_trials):
			To_LH_stimtime[0][i] = LH_block_trials	

	fn = '/home/despoB/TRSEPPI/TDSigEI/Scripts/%s_To_Fo_stimtime.1D' %s
	if os.path.isfile(fn) is False:
		f = open(fn, 'w')
		for val in To_Fo_stimtime[0]:
			if val =='*':
				f.write(val + '\n')
			else:
				f.write(np.array2string(np.around(val,2)).replace('\n','')[4:-1] + '\n')
		f.close()


	fn = '/home/despoB/TRSEPPI/TDSigEI/Scripts/%s_To_Ho_stimtime.1D' %s
	if os.path.isfile(fn) is False:
		f = open(fn, 'w')
		for val in To_Ho_stimtime[0]:
			if val =='*':
				f.write(val + '\n')
			else:
				f.write(np.array2string(np.around(val,2)).replace('\n','')[4:-1] + '\n')
		f.close()
			

	fn = '/home/despoB/TRSEPPI/TDSigEI/Scripts/%s_To_RH_stimtime.1D' %s
	if os.path.isfile(fn) is False:
		f = open(fn, 'w')
		for val in To_RH_stimtime[0]:
			if val =='*':
				f.write(val + '\n')
			else:
				f.write(np.array2string(np.around(val,2)).replace('\n','')[4:-1] + '\n')
		f.close()				


	fn = '/home/despoB/TRSEPPI/TDSigEI/Scripts/%s_To_LH_stimtime.1D' %s
	if os.path.isfile(fn) is False:
		f = open(fn, 'w')
		for val in To_LH_stimtime[0]:
			if val =='*':
				f.write(val + '\n')
			else:
				f.write(np.array2string(np.around(val,2)).replace('\n','')[4:-1] + '\n')
		f.close()		




	#create localizer regressors
	Face_stimtime = [['*']*8] #8 runs of FP HP 
	House_stimtime = [['*']*8]
	RH_stimtime = [['*']*8]
	LH_stimtime = [['*']*8]

	for i, block in enumerate(mapping_runs):
		block_df = df[df['Block']==block].reset_index()
		Face_block_trials = []
		House_block_trials = []
		RH_block_trials = []
		LH_block_trials = []
		
		for tr in np.arange(0, len(block_df)):
			
			if block_df.loc[tr,'Condition'] in ('Fp'):
				Face_block_trials.append(block_df.loc[tr,'OnsetTime'])

			if block_df.loc[tr,'Condition'] in ('Hp'):	
				House_block_trials.append(block_df.loc[tr,'OnsetTime'])

			if block_df.loc[tr,'RH'] and block_df.loc[tr,'Condition'] in ('Fp', 'Hp'):
				RH_block_trials.append(block_df.loc[tr,'OnsetTime'] + block_df.loc[tr,'RT'])  						
			
			if block_df.loc[tr,'LH'] and block_df.loc[tr,'Condition'] in ('Fp', 'Hp'):
				LH_block_trials.append(block_df.loc[tr,'OnsetTime'] + block_df.loc[tr,'RT'])

		if any(Face_block_trials):
			Face_stimtime[0][i] = Face_block_trials
		if any(House_block_trials):
			House_stimtime[0][i] = House_block_trials
		if any(RH_block_trials):
			RH_stimtime[0][i] = RH_block_trials
		if any(LH_block_trials):	
			LH_stimtime[0][i] = LH_block_trials

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

# FIR regressors for TD condition


for tr in np.arange(0,18):
    StimTime = block_start_time + tr * 1.5
    g = tr+1
    fn = '/home/despoB/TRSEPPI/TDSigEI/Scripts/FIR_%s.1D' %g
    if os.path.isfile(fn) is False:
    	np.savetxt(fn, StimTime, fmt='%2.2f')




	
