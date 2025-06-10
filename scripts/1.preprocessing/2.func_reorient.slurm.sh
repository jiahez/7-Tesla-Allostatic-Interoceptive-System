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
export SUBJECTS_DIR="$STUDY_DIR/derivatives/Freesurfer_${freesurfer_version}"

# Extract subject ID from participants.tsv
subj=$(sed -n -E "$((SLURM_ARRAY_TASK_ID + 1))s/sub-(\S*)\>.*/\1/p" "$STUDY_DIR/rawdata/participants.tsv")

# Check if subject was found
if [ -z "$subj" ]; then
    echo "No subject found for SLURM_ARRAY_TASK_ID=$SLURM_ARRAY_TASK_ID"
    exit 1
fi

echo "Processing subject: $subj"

# REORIENTATION
for run in 1 2 3; do
    input_file="$STUDY_DIR/rawdata/$subj/func/${subj}_task-rest_run-0${run}_bold.nii.gz"
    output_dir="$STUDY_DIR/derivatives/$subj/func"
    output_file="${output_dir}/${subj}_task-rest_run-0${run}_bold.nii.gz"
    reoriented_file="${output_file}_reorient.nii.gz"

    mkdir -p "$output_dir"

    if [ ! -f "$input_file" ]; then
        echo "Missing file: $input_file"
        continue
    fi

    cp "$input_file" "$output_file"
    fslreorient2std "$output_file" "$reoriented_file"
done

# CHECK REORIENTATION CONSISTENCY
get_sform() {
    fslorient -getsform "$STUDY_DIR/derivatives/$subj/func/${subj}_task-rest_$1_bold_reorient.nii.gz"
}

sform01=$(get_sform run-01)
sform02=$(get_sform run-02)
sform03=$(get_sform run-03)

if [[ "$sform01" == "$sform02" ]]; then
    echo "second run checks out"
elif [[ "$sform01" == "$sform03" ]]; then
    echo "third run checks out"
else
    echo "$subj has mismatched orientations"

    # Optional: Print qforms too
    echo "sform01: $sform01"
    echo "sform02: $sform02"
    echo "sform03: $sform03"
    echo "Consider using fslorient -getsform and -setsform to fix."
fi

# IF MISMATCHED, do fslorient -getsform and -getqform; then fslorient -setsform and -setqform; Match other runs to the first run
# e.g. fslorient -setsform 1.10215 0 0 -89.5634 0 1.10215 0 -51.5421 0 0 1.1 -81.9419 0 0 0 1 $STUDY_DIR/derivatives/$subj/func/${subj}_task-rest_run-02_bold_reorient.nii.gz
# e.g. fslorient -setqform 1.10215 0 0 -89.5634 0 1.10215 0 -51.5421 0 0 1.1 -81.9419 0 0 0 1 $STUDY_DIR/derivatives/$subj/func/${subj}_task-rest_run-02_bold_reorient.nii.gz