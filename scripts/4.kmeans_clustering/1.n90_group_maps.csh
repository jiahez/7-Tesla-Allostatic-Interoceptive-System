source /usr/local/freesurfer/nmr-stable60-env #(THIS IS IMPORTANT FOR THE MNI305 ANALYSIS)
setenv TMPDIR /scratch
setenv SUBJECTS_DIR /cluster/iaslab/FSMAP/recon

cd /vast/iaslab/FSMAP
	
foreach seed (dpIns_Gianaros pgACC_Gianaros dACC_Wager dAmy_Gianaros dmIns_Kurth sgACC_Gianaros mvAIns_Harper lvAIns_Wager dAmy_Gianaros DR_2020 Hypothalamus LC_l_r LG_l_r MD_Thal_Wager MPB_LPB_l_r Accumbens PAG_fin SC_DCfunc SN_l_r VTA_PBP_l_r VSM_l_r)

	foreach hemi (lh rh mni305)

		isxconcat-sess -sf /autofs/vast/iaslab/FSMAP/scripts/subj_n90.lst -analysis ${seed}.combined.${hemi}_1.25mm -contrast ${seed} -o ${seed}.combined.${hemi}_1.25mm/n90

		mri_glmfit --y ${seed}.combined.${hemi}_1.25mm/n90/${seed}.combined.${hemi}_1.25mm/${seed}/ces.nii.gz --osgm --glmdir ${seed}.combined.${hemi}_1.25mm/n90 --nii.gz


	end
end

foreach seed (hippo_H hippo_B hippo_T)


	foreach hemi (lh rh mni305)

		isxconcat-sess -sf /autofs/vast/iaslab/FSMAP/scripts/subj_n90.lst -analysis ${seed}.combined.${hemi}_1.25mm -contrast ${seed} -o ${seed}.combined.${hemi}_1.25mm/n90

		mri_glmfit --y ${seed}.combined.${hemi}_1.25mm/n90/${seed}.combined.${hemi}_1.25mm/${seed}/ces.nii.gz --osgm --glmdir ${seed}.combined.${hemi}_1.25mm/n90 --nii.gz


	end
end

