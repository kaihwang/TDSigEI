import os, sys, numpy as np


WD = '/home/despoB/TRSEPPI/TRSETMS/'

subjects = ['107', '108', '109', '110', '111', '112', '113', '114', '115', '116', '117', '118']

def createFolderStructure(subjects):
	os.chdir(WD)
	for subj in subjects:
		# Create subject folders and create IFG and VERT folders within those.
		os.system('mkdir ./{0}/'.format(subj))

		# Copy over unprocessed anatomical NIFTI file and functional tar.
		os.system("cp /home/despo/TRSETMS/{0}/VERT/epi/anat.nii {1}/{0}/VERT/anat.nii".format(subj, WD))
		os.system("cp /home/despo/TRSETMS/{0}/VERT/epi/raw_nii.tgz {1}/{0}/VERT/raw_nii.tgz".format(subj, WD))
		os.system("cp /home/despo/TRSETMS/{0}/IFG/epi/anat.nii {1}/{0}/IFG/anat.nii".format(subj, WD))
		os.system("cp /home/despo/TRSETMS/{0}/IFG/epi/raw_nii.tgz {1}/{0}/IFG/raw_nii.tgz".format(subj, WD))

createFolderStructure(subjects)