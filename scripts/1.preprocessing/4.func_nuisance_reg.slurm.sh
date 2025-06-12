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

# set temp directory
export TMPDIR=$DATA_DIR/tmpdir

# Resolve script path
MATALB_FILE="$STUDY_DIR/scripts/1.preprocessing/nuisance_regression.m"
SCRIPTS_DIR=$(dirname "$MATLAB_SCRIPT")

# Launch MATLAB
matlab -nodisplay -nosplash -nojvm -r "\
    cd('$SCRIPTS_DIR'); \
    subj_name='$subj';\ 
    DERIVATIVES_DIR='$STUDY_DIR/derivatives/';\ 
    dirOUT=direIN;  
    mot=load([ direIN 'fmcpr.mcdat']);
    MOTION_PAR=mot(:,2:7); 
    LAT_VENTRICLE=load([ direIN 'vcsf_lat_ventricle.dat']); 
    INF_LAT_VENTRICLE=load([ direIN 'vcsf_inf_lat_ventricle.dat']);
    CHOROID_PLEXUS=load([ direIN 'vcsf_choroid_plexus.dat']);	
    THIRD_VENTRICLE=load([ direIN 'vcsf_3rd_ventricle.dat']);
    FOURTH_VENTRICLE=load([ direIN 'vcsf_4th_ventricle.dat']);
    AQUEDUCT=load([ direIN 'aqueduct.dat']);
    WM=load([ direIN 'wm_mean.dat']);     
    regressors=detrend([MOTION_PAR LAT_VENTRICLE INF_LAT_VENTRICLE CHOROID_PLEXUS THIRD_VENTRICLE FOURTH_VENTRICLE AQUEDUCT WM],'constant');  
    filenameEPIin=[direIN 'f_st_mc.nii.gz'];
    filenameEPIout=[direOUT 'f_st_mc_regout.nii.gz'];
    regressOUT_regressors(filenameEPIin, regressors, filenameEPIout,'n');  
    run('$MATLAB_FILE'); \
    exit;"