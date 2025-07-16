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
TR=2.34
#############################################

# set Freesurfer subjects directory
export SUBJECTS_DIR="$STUDY_DIR/derivatives/Freesurfer_${freesurfer_version}"

# Extract subject ID from participants.tsv
subj=$(sed -n -E "$((SLURM_ARRAY_TASK_ID + 1))s/sub-(\S*)\>.*/\1/p" "$STUDY_DIR/rawdata/participants.tsv")

echo "Processing subject: $subj"

# Slice timing correction
for run in 1 2 3; do
    slicetimer \
        -i "$STUDY_DIR/derivatives/$subj/func/${subj}_task-rest_run-0${run}_bold_reorient.nii.gz" \
        -o "$STUDY_DIR/derivatives/$subj/func/${subj}_task-rest_run-0${run}_bold_reorient_st.nii.gz" \
        --ocustom="scripts/1.preprocessing/configs/sliceorder_123slsms3_asc_inter.txt" \
        -v -r "$TR"
done

# Concatenate 3 functional runs
fslmerge -t "$STUDY_DIR/derivatives/$subj/func/all_merged.nii.gz" \
    "$STUDY_DIR/derivatives/$subj/func/${subj}_task-rest_run-01_bold_reorient_st.nii.gz" \
    "$STUDY_DIR/derivatives/$subj/func/${subj}_task-rest_run-02_bold_reorient_st.nii.gz" \
    "$STUDY_DIR/derivatives/$subj/func/${subj}_task-rest_run-03_bold_reorient_st.nii.gz"

# Coregistration
epi_reg \
    --epi="$STUDY_DIR/derivatives/$subj/func/all_merged.nii.gz" \
    --t1="$STUDY_DIR/derivatives/$subj/anat/${subj}_T1w_r_bfc.nii.gz" \
    --t1brain="$STUDY_DIR/derivatives/$subj/anat/${subj}_T1w_r_bfc.nii.gz" \
    --out="$STUDY_DIR/derivatives/$subj/func/all_merged_coreg"

# Setup Freesurfer-compatible directory structure
mkdir -p "$STUDY_DIR/derivatives/$subj/rest/001"
cp "$STUDY_DIR/derivatives/$subj/func/all_merged_coreg.nii.gz" "$STUDY_DIR/derivatives/$subj/rest/001/f.nii.gz"
gunzip -f "$STUDY_DIR/derivatives/$subj/rest/001/f.nii.gz"

# Motion correction using FreeSurfer's preproc-sess
preproc-sess -s "$subj" -fsd rest -fwhm 0 -per-session -force

# Compute standard deviation map
fslmaths "$STUDY_DIR/derivatives/$subj/rest/001/fmcpr.nii.gz" -Tstd "$STUDY_DIR/derivatives/$subj/rest/001/fmcpr_STD.nii.gz"

# Manually inspect the standardard deviation map to find top 5 voxels in the aqueduct and save it as a mask at $STUDY_DIR/derivatives/$subj/aqueduct_mask_5vx.nii.gz