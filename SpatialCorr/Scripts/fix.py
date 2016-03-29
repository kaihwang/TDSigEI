import os

subjs = ['505', '508', '509', '510', '512', '513', '516', '517', '518', '519', '523', '527', '528', '529', '530', '531', '532', '534']
masks = ['thalamus', 'L_IPS', 'R_IPS', 'T_FEF', 'D_FEF', 'pre']
thisDir = os.listdir('.')
for subj in subjs:
    os.system('rm {0}/*design*'.format(subj))
    os.system('rm {0}/*stats*'.format(subj))
    os.system('rm {0}/*errts*'.format(subj))
    for mask in masks:
        size = len(os.listdir('{1}/{0}removed'.format(mask, subj)))
        print '{0} {1} size: {2}'.format(subj, mask, size)
        #os.system('mkdir {0}/{1}removed'.format(subj, mask))
        #os.system('mv {0}/*FIR_{1}removed+tlrc* {0}/{1}removed'.format(subj, mask))
 
    #os.system('mv {0} {2}/{1}'.format(d, s, subjs[i]))
    #print d, subjs[i], s


