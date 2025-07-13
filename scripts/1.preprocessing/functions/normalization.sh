
dirT1=$STUDY_DIR/derivatives/$subj/anat

# Creating a mask from the T1_mprage (alternative way to get a mask and probably better for normaliz. purposes)
#---------------------------------------------------------
fslmaths ${dirT1}/${subj}_T1w_r_bfc.nii.gz -bin ${dirT1}/${subj}_T1w_r_bfc_mask.nii.gz
# Filling some very small holes ("fh"=fill hole) within the mask with afni, then converting brik to nii
3dmask_tool -input ${dirT1}/${subj}_T1w_r_bfc_mask.nii.gz -prefix ${dirT1}/temp  -fill_holes
3dAFNItoNIFTI  -prefix ${dirT1}/${subj}_T1w_r_bfc_mask_fh.nii.gz  ${dirT1}/temp+tlrc.BRIK
rm ${dirT1[${su}]}/temp+tlrc*
# *** Check *** if mask looks ok with:
# fslview ${dirT1}/${subj}_T1w_r_bfc_mask.nii.gz ${dirT1}/${subj}_T1w_r_bfc_mask_fh.nii.gz

# Run coregistration
$STUDY_DIR/scripts/BrainstemNavigator1.0/Tutorial/antsreg_CC_deform_T1wstructural2MNI.sh ${dirT1}/${subj}_T1w_r_bfc.nii.gz $FSLDIR/data/standard/MNI152_T1_1mm.nii.gz $dirT1

# Setting file names 
#---------------------------------------------------------
dirfMRI=$STUDY_DIR/derivatives/$subj/rest/001
filefMRI=$dirfMRI/f_st_mc_regout_bp 

# Masking the fmri processed data with the mask miepi_MPRAGE_FOR_FS_r_bfc_mask_fh.nii.gz
# This takes several minutes 
#---------------------------------------------------------
fslmaths $filefMRI -mul ${dirT1}/${subj}_T1w_r_bfc_mask_fh.nii.gz ${filefMRI}_m

# Applying the normalization transformations of fmri data from T1epispace to MNI152 space....
moving=${filefMRI}_m
mkdir ${dirfMRI}/temp_norm
for index in {1..768} 
do
	indexOK="$(($index-1))"
	printf -v indexOK_3zeropad "%03d" $indexOK    #  this is to zeropad up to ###
	fslroi ${moving}.nii.gz  ${dirfMRI}/temp_norm/temp${indexOK_3zeropad} $indexOK 1 
	moving3D=${dirfMRI}/temp_norm/temp${indexOK_3zeropad}
	/cluster/pubsw/arch/CentOS5-x86-64/packages/ANTS/dev/bin/antsApplyTransforms -d 3 -e 0 -i ${moving3D}.nii.gz -r ${fixed} -o ${moving3D}_2_MNI152_T1_1mm_brain.nii.gz -t $dirTransformT12MNI/miepi_MPRAGE_FOR_FS_r_bfc_2_MNI152_T1_1mm_brain1Warp.nii.gz $dirTransformT12MNI/miepi_MPRAGE_FOR_FS_r_bfc_2_MNI152_T1_1mm_brain0GenericAffine.mat -v 1
done

# (to check if all the timepoints have been normalized: ls *MNI152* | wc -w   ; this should give 768) 
#---------------------------------------------------------
fslmerge -t ${moving}_2_MNI152_T1_1mm_brain.nii.gz  ${dirfMRI}/temp_norm/*MNI152_T1_1mm_brain*
# Remove the temp folder
rm ${dirfMRI}/temp_norm -r
mv ${moving}_2_MNI152_T1_1mm_brain.nii.gz ${moving}_2MNI.nii.gz 