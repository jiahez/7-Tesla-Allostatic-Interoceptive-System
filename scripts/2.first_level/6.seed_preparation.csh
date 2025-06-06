#source /usr/local/freesurfer/nmr-dev-env
#setenv SUBJECTS_DIR /autofs/cluster/iaslab/FSMAP/recon/

# cortical seeds
foreach seed (pgACC_Gianaros dpIns_Gianaros dACC_Wager dAmy_Gianaros dmIns_Kurth sgACC_Gianaros mvAIns_Harper lvAIns_Wager)

	# COPY ROIS FROM ORIGINAL DIRECTORY
	#cp /cluster/iaslab/buckner_fsfast_fc/rsfmri/ROIs/${seed}.label ROIs/
	#cp /cluster/iaslab/buckner_fsfast_fc/rsfmri/ROIs/${seed}.nii.gz ROIs/
	#cp /cluster/iaslab/buckner_fsfast_fc/rsfmri/ROIs/${seed}.rh.sm00.mgh ROIs/
	#cp /cluster/iaslab/buckner_fsfast_fc/rsfmri/ROIs/${seed}.rh.sm04.mgh ROIs/

	mri_binarize --i ROIs/${seed}.rh.sm04.mgh --min 10e-10 --o ROIs/${seed}.rh.sm04.bin.mgh

	mri_surf2vol --so $SUBJECTS_DIR/mni152.fnirt/surf/rh.pial ROIs/${seed}.rh.sm04.bin.mgh --subject mni152.fnirt --o ROIs/${seed}.rh.sm04.vol.nii.gz

	fslroi ROIs/${seed}.rh.sm04.vol.nii.gz ROIs/${seed}.rh.sm04.vol_crop.nii.gz 51.5 151 51.5 151 34 186
	mri_convert ROIs/${seed}.rh.sm04.vol_crop.nii.gz -oc -1.5 -16 9.5 ROIs/${seed}.rh.sm04.vol_crop_oc.nii.gz

end


# subcortical seeds
foreach seed (DR_2020 LG_l_r SN_l_r VTA_PBP_l_r LC_l_r MPB_LPB_l_r LPB_l_r MPB_l_r Accumbens hippo_B hippo_H hippo_T Hypothalamus MD_Thal_Wager SC_DCfunc VSM_l_r DMPAG DLPAG LPAG VLPAG PAG_fin)

	fslswapdim ROIs/${seed}.nii.gz x -z y ROIs/${seed}_LIA.nii.gz

	fslroi ROIs/${seed}_LIA.nii.gz ROIs/${seed}_LIA_crop.nii.gz 15.5 151 33.5 151 -2 186

	mri_convert ROIs/${seed}_LIA_crop.nii.gz -oc -1.5 -16 9.5 ROIs/${seed}_LIA_crop_oc.nii.gz

end

# SC seeds
foreach seed (sc_superficial sc_deep)
	mri_convert --in_orientation RAS --out_orientation LIA -ot nii ROIs/${seed}.nii.gz ROIs/${seed}_LIA.nii.gz

	fslroi ROIs/${seed}_LIA.nii.gz ROIs/${seed}_LIA_crop.nii.gz 15.5 151 33.5 151 -2 186

	mri_convert ROIs/${seed}_LIA_crop.nii.gz -oc -1.5 -16 9.5 ROIs/${seed}_LIA_crop_oc.nii.gz

end


