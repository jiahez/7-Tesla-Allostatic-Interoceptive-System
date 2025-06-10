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

foreach set (1 2)
	3dFourier -prefix $subj/rest$set/001/f_st_mc_regout_hp.nii.gz -highpass $hpf $subj/rest$set/001/f_st_mc_regout.nii.gz
	3dFourier -prefix $subj/rest$set/001/f_st_mc_regout_bp.nii.gz  -lowpass $lpf $subj/rest$set/001/f_st_mc_regout_hp.nii.gz
	rm $subj/rest$set/001/f_st_mc_regout_hp.nii.gz
end

## NORMALIZATION DONE EXTERNAL TO THIS SCRIPT: 5.preproc_normalization_g2.sh (requires computation of the transformation matrices by Marta first, which are deposited to $DATA_DIR/scriptsMB/trasformT1epi2MNI_2ndcohort/; run this with full memory capacity on launchpad!) ##

# CONVERSION TO FS ORIENTATION/DIMENSIONS (THIS SHOULD HAVE BEEN THE LAST SERIES OF STEPS!!)
fslswapdim $subj/rest$set/001/f_st_mc_regout_bp_m_2MNI.nii.gz x -z y $subj/rest$set/001/f_st_mc_regout_bp_m_2MNI_LIA.nii.gz
fslroi $subj/rest$set/001/f_st_mc_regout_bp_m_2MNI_LIA.nii.gz $subj/rest$set/001/f_st_mc_regout_bp_m_2MNI_LIA_crop.nii.gz 14.5 151 14.5 151 16 186
mri_convert $subj/rest$set/001/f_st_mc_regout_bp_m_2MNI_LIA_crop.nii.gz -oc -1.5 -16 9.5 $subj/rest$set/001/f_st_mc_regout_bp_m_2MNI_LIA_crop_oc.nii.gz

# DETREND
fslmaths $subj/rest$set/001/f_st_mc_regout_bp_m_2MNI_LIA_crop_oc.nii.gz -Tmean $subj/rest$set/001/f_st_mc_regout_bp_m_2MNI_LIA_crop_oc_Tmean.nii.gz
fslmaths $subj/rest$set/001/f_st_mc_regout_bp_m_2MNI_LIA_crop_oc.nii.gz -sub $subj/rest$set/001/f_st_mc_regout_bp_m_2MNI_LIA_crop_oc_Tmean.nii.gz $subj/rest$set/001/f_st_mc_regout_bp_m_2MNI_det.nii.gz

# SMOOTHING
fslmaths $subj/rest$set/001/f_st_mc_regout_bp_m_2MNI_det.nii.gz -s 1.25 $subj/rest$set/001/fmcpr.sm0.mni305.1mm.nii.gz

rm $subj/rest$set/001/f_st_mc_regout_bp_m_2MNI_LIA.nii.gz
rm $subj/rest$set/001/f_st_mc_regout_bp_m_2MNI_LIA_crop.nii.gz
rm $subj/rest$set/001/f_st_mc_regout_bp_m_2MNI_LIA_crop_oc.nii.gz
rm $subj/rest$set/001/f_st_mc_regout_bp_m_2MNI_LIA_crop_oc_Tmean.nii.gz
end

# COMBINE
fslmerge -t $subj/rest1_1.25mm/001/fmcpr.sm0.mni305.1mm.nii.gz $subj/rest1/001/fmcpr.sm0.mni305.1mm.nii.gz $subj/rest2/001/fmcpr.sm0.mni305.1mm.nii.gz 

# link necessary files
cat $subj/rest1/001/fmc.mcdat $subj/rest2/001/fmc.mcdat > $subj/rest1_1.25mm/001/fmc.mcdat
rm $subj/rest1_1.25mm/001/global.meanval.dat
set meanval1=`cat $subj/rest1/001/global.meanval.dat`
set meanval2=`cat $subj/rest2/001/global.meanval.dat`
echo "($meanval1 + $meanval2)/2" | bc > $subj/rest1_1.25mm/001/global.meanval.dat
cp $subj/rest1/001/masks $subj/rest1_1.25mm/001/masks -r

# fix masks
mv ${subj}/rest1_1.25mm/001/masks/brain.mni305.1mm.nii.gz ${subj}/rest1_1.25mm/001/masks/brain.mni305.1mm_orig.nii.gz
cp dpIns_Gianaros.combined.mni305_1.25mm/mask.nii.gz ${subj}/rest1_1.25mm/001/masks/brain.mni305.1mm.nii.gz

# project merged file to lh and rh surface
foreach hemi (lh rh)
	mri_vol2surf --src $subj/rest1_1.25mm/001/fmcpr.sm0.mni305.1mm.nii.gz --srcreg identity --ref T1.mgz --regheader mni152.fnirt --hemi $hemi --o $subj/rest1_1.25mm/001/fmcpr.sm0.mni152.fnirt.${hemi}.nii.gz
end