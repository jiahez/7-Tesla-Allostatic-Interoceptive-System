fslswapdim $subj/rest1_1.25mm/001/fmcpr.sm0.mni305.1mm.nii.gz x z -y $subj/rest1_1.25mm/001/fmcpr.sm0.mni305.1mm_LAS.nii.gz

fslroi $subj/rest1_1.25mm/001/fmcpr.sm0.mni305.1mm_LAS.nii.gz $subj/rest1_1.25mm/001/fmcpr.sm0.mni305.1mm_LAS_crop.nii.gz -15.5 182 -16 218 -15.5 182

mri_convert $subj/rest1_1.25mm/001/fmcpr.sm0.mni305.1mm_LAS_crop.nii.gz -oc -1 -17 19 $subj/rest1_1.25mm/001/fmcpr.sm0.mni305.1mm_LAS_crop_oc.nii.gz

rm $subj/rest1_1.25mm/001/fmcpr.sm0.mni305.1mm_LAS.nii.gz 
rm $subj/rest1_1.25mm/001/fmcpr.sm0.mni305.1mm_LAS_crop.nii.gz