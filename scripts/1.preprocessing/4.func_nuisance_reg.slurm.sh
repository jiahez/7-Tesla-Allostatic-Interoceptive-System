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

# CONFIGURATION SETUP (MANUALLY MODIFY AFTERWARDS)
fcseed-config -vcsf -fcname vcsf.dat -fsd rest$set -pca -cfg rsfmri/vcsf1_1.25mm.config
fcseed-config -vcsf -fcname vcsf.dat -fsd rest2 -pca -cfg rsfmri/vcsf2.config # THEN GO INTO FILE AND ADD 14 and 15 TO segidlists
fcseed-config -wm -fcname wm.dat -fsd rest1 -pca -cfg rsfmri/wm1.config
fcseed-config -wm -fcname wm.dat -fsd rest2 -pca -cfg rsfmri/wm2.config
fcseed-config -vcsf -fcname vcsf_mean.dat -fsd rest1 -mean -cfg rsfmri/vcsf1_mean.config
fcseed-config -wm -fcname wm_mean.dat -fsd rest1 -mean -cfg rsfmri/wm1_mean.config

# Extract subject ID from participants.tsv
subj=$(sed -n -E "$((SLURM_ARRAY_TASK_ID + 1))s/sub-(\S*)\>.*/\1/p" "$STUDY_DIR/rawdata/participants.tsv")

# create symbolic links to set up for next step 
ln -s $STUDY_DIR/derivatives/$subj/rest/001/fmc.nii.gz $STUDY_DIR/derivatives/$subj/rest/001/fmcpr.nii.gz
ln -s $STUDY_DIR/derivatives/$subj/rest/001/fmc.mcdat $STUDY_DIR/derivatives/$subj/rest/001/fmcpr.mcdat
ln -s $STUDY_DIR/derivatives/$subj/rest/001/fmc.nii.gz.mclog $STUDY_DIR/derivatives/$subj/rest/001/fmcpr.nii.gz.mclog
ln -s $STUDY_DIR/derivatives/$subj/rest/001/fmc.mat.aff12.1D $STUDY_DIR/derivatives/$subj/rest/001/fmcpr.mat.aff12.1D

# THIS IS DONE TO CREATE A PREPROC-SESS LOG TO TRICK FREESURFER INTO THINKING PREPROC IS DONE UP TO NORMALIZATION
preproc-sess -s $subj -fsd rest -fwhm 0 -per-run -update -surface mni152.fnirt lhrh -mni305-1mm
ln -s $STUDY_DIR/derivatives/$subj/rest/001/fmc.nii.gz $STUDY_DIR/derivatives/$subj/func/f_st_mc.nii.gz
mv $STUDY_DIR/derivatives/$subj/rest/001/fmcpr.sm0.mni152.fnirt.lh.nii.gz $STUDY_DIR/derivatives/$subj/rest/001/fmcpr.sm0.mni152.fnirt.lh_orig.nii.gz
mv $STUDY_DIR/derivatives/$subj/rest/001/fmcpr.sm0.mni152.fnirt.rh.nii.gz $STUDY_DIR/derivatives/$subj/rest/001/fmcpr.sm0.mni152.fnirt.rh_orig.nii.gz
mv $STUDY_DIR/derivatives/$subj/rest/001/fmcpr.sm0.mni305.1mm.nii.gz $STUDY_DIR/derivatives/$subj/rest/001/fmcpr.sm0.mni305.1mm_orig.nii.gz

# extract nuisance regressors
fcseed-sess -s $subj -cfg $STUDY_DIR/scripts/config_files/vcsf_lat_ventricle.config -overwrite 
fcseed-sess -s $subj -cfg $STUDY_DIR/scripts/config_files/vcsf_inf_lat_ventricle.config -overwrite
fcseed-sess -s $subj -cfg $STUDY_DIR/scripts/config_files/vcsf_choroid_plexus.config -overwrite
fcseed-sess -s $subj -cfg $STUDY_DIR/scripts/config_files/vcsf_3rd_ventricle.config -overwrite
fcseed-sess -s $subj -cfg $STUDY_DIR/scripts/config_files/vcsf_4th_ventricle.config -overwrite
fcseed-sess -s $subj -cfg $STUDY_DIR/scripts/config_files/wm_mean.config -overwrite
fslmeants -i $subj/rest/001/fmcpr.nii.gz -o $subj/rest/001/aqueduct.dat -m $subj/aqueduct_mask_5vx.nii.gz


# source /usr/local/freesurfer/nmr-stable60-env
# setenv TMPDIR $DATA_DIR/tmpdir
# setenv SUBJECTS_DIR $DATA_DIR/recon
# matlab.new -nodisplay -nodesktop -nojvm
## CHECK IF THE RIGHT FS VERSION WAS LOADED:
# which load_nifti
## IF WRONG VERSION, ADD PATH FOR RIGHT VERSION:
# addpath /autofs/cluster/freesurfer/centos6_x86_64/stable6/matlab/
# cd /cluster/iaslab/FSMAP
# run scripts/nuisance_regression_g2.m
