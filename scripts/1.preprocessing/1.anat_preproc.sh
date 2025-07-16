#!/bin/bash
#SBATCH --job-name=j_anat_preproc
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

# Create Freesurfer output directory
export SUBJECTS_DIR="$STUDY_DIR/derivatives/Freesurfer_${freesurfer_version}"
mkdir -p "$SUBJECTS_DIR"

# Extract subject ID from participants.tsv (adjust +1 to account for header)
subj=$(sed -n -E "$((SLURM_ARRAY_TASK_ID + 1))s/sub-(\S*)\>.*/\1/p" "$STUDY_DIR/rawdata/participants.tsv")

if [ -z "$subj" ]; then
    echo "Subject ID could not be extracted for SLURM_ARRAY_TASK_ID=$SLURM_ARRAY_TASK_ID"
    exit 1
fi

echo "Processing subject: $subj"

# Set up subject output directories
deriv_subj_dir="$STUDY_DIR/derivatives/$subj"
scripts_dir="$STUDY_DIR/scripts"
anat_dir="$deriv_subj_dir/anat"
func_dir="$deriv_subj_dir/func"
mkdir -p "$anat_dir" "$func_dir"

# Step 1: Reorient structural to standard orientation
input_T1="$STUDY_DIR/rawdata/$subj/anat/${subj}_T1w.nii.gz"
reoriented_T1="$anat_dir/${subj}_T1w_r.nii.gz"
fslreorient2std "$input_T1" "$reoriented_T1"

# Step 2: Bias field correction
bfc_T1="$anat_dir/${subj}_T1w_r_bfc.nii.gz"
"$scripts_dir/1.preprocessing/scripts/BrainstemNavigator1.0/Tutorial/run_bfc.sh" --i "$reoriented_T1" --o "$bfc_T1"

# Step 3: Convert to .mgz and set up Freesurfer structure
orig_dir="$SUBJECTS_DIR/$subj/mri/orig"
mkdir -p "$orig_dir"
mri_convert "$bfc_T1" "$orig_dir/001.mgz"

# Step 4: Run recon-all
cmd="recon-all -subject $subj -all"
echo "Running Freesurfer recon-all for subject $subj (Task ID: $SLURM_ARRAY_TASK_ID)"
echo "Command line: $cmd"
eval $cmd
exitcode=$?

# Step 5: Log result
logfile="${SLURM_JOB_NAME}.${SLURM_ARRAY_JOB_ID}.tsv"
echo -e "$subj\t${SLURM_ARRAY_TASK_ID}\t$exitcode" >> "$logfile"

echo "Finished Freesurfer for subject $subj with exit code $exitcode"
exit $exitcode
