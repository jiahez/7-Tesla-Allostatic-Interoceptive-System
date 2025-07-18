import os
import numpy as np
import pickle
import pandas as pd

#set variables
n = 90 #numer of subjects

#set paths and files
root_dir = '/autofs/vast/iaslab/FSMAP'
out_dir = os.path.join(root_dir, 'ROIs/eroded')
subj_list = os.path.join(root_dir, f'scripts/subj_n{n}.lst')
seed_list = os.path.join(out_dir, '14_subcortical_ROIs.txt')

#load files
subjects = np.loadtxt(subj_list, dtype='U')
seeds = np.loadtxt(seed_list, dtype='U')
seeds = [s.split('_LIA')[0] for s in seeds]
seeds = [s for s in seeds if 'Hippocampus' not in s]
seeds = [s for s in seeds if 'VSM' not in s]

#correlate eroded and full seed time series for each subject
r_all = []
for subj in subjects:
    data_dir = os.path.join(root_dir, subj, 'rest1_1.25mm/001')
    r = []
    for seed in seeds:
        erode = np.loadtxt(os.path.join(data_dir, f'{seed}_eroded.dat'))
        full = np.loadtxt(os.path.join(data_dir, f'{seed}.dat'))
        r.append(np.corrcoef(erode, full)[0,1])
    r_all.append(r)

#compute M, SD, min, and max r-value for each seed across subjects
r_M = np.mean(r_all,axis=0)
r_SD = np.std(r_all,axis=0)
r_min = np.min(r_all,axis=0)
r_max = np.max(r_all,axis=0)
print(pd.DataFrame(zip(seeds,r_M,r_SD,r_min,r_max), columns=['Seed','M','SD','Min','Max']))

#save subject IDs, seed IDs, and r-values to pickle file
out = {
    'r' : r_all,
    'r_M' : r_M,
    'r_SD' : r_SD,
    'subjects' : subjects,
    'subjects_short' : [s.split('_')[1] for s in subjects],
    'seeds' : seeds
}
pickle.dump(out, open(os.path.join(out_dir, f'eroded_full_ts_correlations_n{n}.pkl'),'wb'))
