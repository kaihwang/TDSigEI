
# coding: utf-8

# In[110]:

get_ipython().magic(u'pylab inline')
from __future__ import print_function, division
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import scipy.stats
import brewer2mpl


# In[114]:

# create fROI, extract FIR timeseries, write to dataframe
get_ipython().system(u'. make_indiv_fROI.sh')
get_ipython().system(u'. extract_FIR_ts.sh')
get_ipython().magic(u'run FIR_dataframe.py')


# In[111]:

#load dataframe, calculate mean and SEM
FIR_df = pd.read_csv('Data/FIR_df.csv')

mean_df = FIR_df.groupby(['ROI','Condition','Volume']).aggregate(np.mean).reset_index()
sem_df = FIR_df.groupby(['ROI','Condition','Volume']).aggregate(scipy.stats.sem).reset_index()


# In[113]:

#conditions
ROIs = ['FFA', 'PPA']
Conditions =['FH', 'Fo', 'Fp', 'Hp', 'Ho', 'HF']
x = np.arange(1,22)
#get colormap
cmap = brewer2mpl.get_map('RdBu','diverging', 6)
plt.figure(1)
plt.figure(figsize=(10,5))
for r, roi in enumerate(ROIs):
    plt.subplot(1, 2, r)
    for i, c in enumerate(Conditions):
        y = np.array(mean_df[(mean_df['ROI'] == roi) & (mean_df['Condition'] == c)]['Beta'])
        error = np.array(sem_df[(mean_df['ROI'] == roi) & (mean_df['Condition'] == c)]['Beta'])
        #plt.plot(x, y, color = cmap.hex_colors[i],  )
        plt.fill_between(x, y-error, y+error, alpha=0.5, edgecolor=cmap.hex_colors[i], 
                     facecolor=cmap.hex_colors[i], label=c)
        ylim( -0.2, 1.6 )
        xlim( 1, 21 )
        
        plt.xlabel(roi)

plt.ylabel('% signal change')


# In[ ]:




# In[ ]:



