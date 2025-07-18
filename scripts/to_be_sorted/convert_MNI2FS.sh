

fslswapdim $STUDY_DIR/derivatives/$subj/rest/001/f_st_mc_regout_bp_m_2MNI.nii.gz x -z y $STUDY_DIR/derivatives/$subj/rest/001/f_st_mc_regout_bp_m_2MNI_LIA.nii.gz
fslroi $STUDY_DIR/derivatives/$subj/rest/001/f_st_mc_regout_bp_m_2MNI_LIA.nii.gz $STUDY_DIR/derivatives/$subj/rest/001/f_st_mc_regout_bp_m_2MNI_LIA_crop.nii.gz 14.5 151 14.5 151 16 186
mri_convert $STUDY_DIR/derivatives/$subj/rest/001/f_st_mc_regout_bp_m_2MNI_LIA_crop.nii.gz -oc -1.5 -16 9.5 $STUDY_DIR/derivatives/$subj/rest/001/f_st_mc_regout_bp_m_2MNI_LIA_crop_oc.nii.gz
