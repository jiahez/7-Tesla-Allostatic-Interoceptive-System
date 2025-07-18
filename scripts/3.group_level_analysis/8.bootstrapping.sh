#!/bin/bash
#SBATCH --job-name=j_func_preproc
#SBATCH --partition=short
#SBATCH --time=48:00:00
#SBATCH -n 1
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=4G
#SBATCH --output=logs/%x.%A-%a.out
#SBATCH --error=logs/%x.%A-%a.err

#############################################
freesurfer_version="X.X.X"
export FREESURFER_HOME=/PATH/TO/FREESURFER
source "$FREESURFER_HOME/SetUpFreeSurfer.sh"
#############################################

# set Freesurfer subjects directory
export SUBJECTS_DIR="$STUDY_DIR/derivatives/Freesurfer_${freesurfer_version}" # should be 6.0 or later

# set temp directory
export TMPDIR=$DATA_DIR/tmpdir

# Extract subject ID from participants.tsv
subj=$(sed -n -E "$((SLURM_ARRAY_TASK_ID + 1))s/sub-(\S*)\>.*/\1/p" "$STUDY_DIR/rawdata/participants.tsv")

#set seed and hemi
set seed = $argv[1]
set hemi = $argv[2]

mkdir -p $STUDY_DIR/${seed}.${hemi}/bootstrapping

foreach i (`seq 1 1 1000`)

	#concatenate all subjects' data into one file
	isxconcat-sess -sf $STUDY_DIR/scripts/3.group_level_analysis/subj_lists/subj_iter${i}.lst -analysis ${seed}.${hemi} -contrast ${seed} -o ${seed}.${hemi}/iter${i}

	#compute FC with seed
	mri_glmfit --y ${seed}.${hemi}/iter${i}/${seed}.${hemi}/${seed}/ces.nii.gz --osgm --glmdir ${seed}.${hemi}/iter${i} --nii.gz

	#binarize FC map
	mri_binarize --i ${seed}.${hemi}/iter${i}/osgm/sig.nii.gz --min 1.3 --o ${seed}.${hemi}/bootstrapping/iter${i}_sig_bin1.3.nii.gz

	#remove intermediate directory
	rm -r ${seed}.${hemi}/iter${i}

end

#sum all binarized maps
mri_concat ${seed}.${hemi}/bootstrapping/iter*sig_bin1.3.nii.gz --o ${seed}.${hemi}/bootstrapping/sum_sig_bin1.3.nii.gz --sum
