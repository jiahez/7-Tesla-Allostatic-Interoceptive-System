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

# BANDPASS FILTERING ## 
# setenv PATH $PATH\:/cluster/pubsw/2/pubsw/Linux2-2.3-x86_64/packages/AFNI/current/bin
set hpf=0.01
set lpf=0.08

3dFourier -prefix $STUDY_DIR/derivatives/$subj/rest/001/f_st_mc_regout_hp.nii.gz -highpass $hpf $STUDY_DIR/derivatives/$subj/rest/001/f_st_mc_regout.nii.gz
3dFourier -prefix $STUDY_DIR/derivatives/$subj/rest/001/f_st_mc_regout_bp.nii.gz  -lowpass $lpf $STUDY_DIR/derivatives/$subj/rest/001/f_st_mc_regout_hp.nii.gz

## NORMALIZATION DONE USING SOURCED SCRIPT: normalization.sh 
source $STUDY_DIR/scripts/1.preprocessing/normalization.sh

# DETREND
fslmaths $STUDY_DIR/derivatives/$subj/rest/001/f_st_mc_regout_bp_m_2MNI.nii.gz -Tmean $STUDY_DIR/derivatives/$subj/rest/001/f_st_mc_regout_bp_m_2MNI_Tmean.nii.gz
fslmaths $STUDY_DIR/derivatives/$subj/rest/001/f_st_mc_regout_bp_m_2MNI.nii.gz -sub $STUDY_DIR/derivatives/$subj/rest/001/f_st_mc_regout_bp_m_2MNI_Tmean.nii.gz $subj/rest/001/f_st_mc_regout_bp_m_2MNI_det.nii.gz

# SMOOTHING using 1.25mm kernel
fslmaths $STUDY_DIR/derivatives/$subj/rest/001/f_st_mc_regout_bp_m_2MNI_det.nii.gz -s 1.25 $STUDY_DIR/derivatives/$subj/rest/001/fmcpr.sm0.mni305.1mm.nii.gz

# CONVERSION TO FS ORIENTATION/DIMENSIONS 
fslswapdim $STUDY_DIR/derivatives/$subj/rest/001/f_st_mc_regout_bp_m_2MNI.nii.gz x -z y $STUDY_DIR/derivatives/$subj/rest/001/f_st_mc_regout_bp_m_2MNI_LIA.nii.gz
fslroi $STUDY_DIR/derivatives/$subj/rest/001/f_st_mc_regout_bp_m_2MNI_LIA.nii.gz $STUDY_DIR/derivatives/$subj/rest/001/f_st_mc_regout_bp_m_2MNI_LIA_crop.nii.gz 14.5 151 14.5 151 16 186
mri_convert $STUDY_DIR/derivatives/$subj/rest/001/f_st_mc_regout_bp_m_2MNI_LIA_crop.nii.gz -oc -1.5 -16 9.5 $STUDY_DIR/derivatives/$subj/rest/001/f_st_mc_regout_bp_m_2MNI_LIA_crop_oc.nii.gz

# project to lh and rh surface
foreach hemi (lh rh)
	mri_vol2surf --src $STUDY_DIR/derivatives/$subj/rest/001/fmcpr.sm0.mni305.1mm.nii.gz --srcreg identity --ref T1.mgz --regheader mni152.fnirt --hemi $hemi --o $subj/rest/001/fmcpr.sm0.mni152.fnirt.${hemi}.nii.gz
end

