import numpy as np
import glob as glob

Files = glob.glob('/home/despoB/TRSEPPI/TDSigEI/5*/*fwhmx.txt')

fwhmx_array = [np.loadtxt(f)[0] for f in Files]
print(np.mean(fwhmx_array, axis=0))