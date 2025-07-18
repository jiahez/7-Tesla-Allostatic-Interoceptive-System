# fix symbolic links before running analysis; this was due to cluster to vast storage change
foreach subj (FSMAP_060_190210 FSMAP_061_190211 FSMAP_064_190304 FSMAP_065_190304 FSMAP_069_190324 FSMAP_070_190331 FSMAP_072_190331 FSMAP_074_190401 FSMAP_081_190429 FSMAP_084_190516 FSMAP_094_190617 FSMAP_095_190626 FSMAP_096_190630 FSMAP_097_190630 FSMAP_098_190703 FSMAP_099_190708 FSMAP_114_191023 FSMAP_116_191104 FSMAP_117_191104 FSMAP_118_191106 FSMAP_119_191113)

	cd $subj/rest1_1.25mm

	rm *_test
	foreach seed ( VLPAG sgACC_Gianaros pgACC_Gianaros PAG_fin mvAIns_Harper LPAG dpIns_Gianaros DMPAG dmIns_Kurth DLPAG dAmy_Gianaros )
		foreach hemi ( lh rh mni305 )
			rm ${seed}.combined.${hemi}_1.25mm
			mv ${seed}.combined.${hemi}_1.25mm_g2 ${seed}.combined.${hemi}_1.25mm
		end
	end

	cd ../../
end



source /usr/local/freesurfer/nmr-stable60-env #(THIS IS IMPORTANT FOR THE MNI305 ANALYSIS)
setenv TMPDIR /cluster/iaslab/FSMAP/tmpdir
setenv SUBJECTS_DIR /cluster/iaslab/FSMAP/recon

cd /vast/iaslab/FSMAP/

foreach seed (dpIns_Gianaros pgACC_Gianaros dACC_Wager dAmy_Gianaros dmIns_Kurth sgACC_Gianaros mvAIns_Harper lvAIns_Wager)
	foreach hemi (lh rh mni305)
	
		foreach group (n91)

			isxconcat-sess -sf rsfmri/subj_${group}.lst -analysis ${seed}.combined.${hemi}_1.25mm -contrast ${seed}_1.25mm.rh.sm04 -o ${seed}.combined.${hemi}_1.25mm/${group}

			mri_glmfit --y ${seed}.combined.${hemi}_1.25mm/${group}/${seed}.combined.${hemi}_1.25mm/${seed}_1.25mm.rh.sm04/ces.nii.gz --osgm --glmdir ${seed}.combined.${hemi}_1.25mm/${group} --nii.gz

			mri_binarize --i ${seed}.combined.${hemi}_1.25mm/${group}/osgm/sig.nii.gz --min 1.3 --o ${seed}.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz

		end
	end

end

foreach seed (DR_2020 LG_l_r SN_l_r VTA_PBP_l_r LC_l_r MPB_LPB_l_r LPB_l_r MPB_l_r Accumbens hippo_B hippo_H hippo_T Hypothalamus MD_Thal_Wager SC_DCfunc VSM_l_r) 

	foreach hemi (lh rh mni305)

		foreach group (n91)

			isxconcat-sess -sf rsfmri/subj_${group}.lst -analysis ${seed}.combined.${hemi}_1.25mm -contrast ${seed}_1.25mm -o ${seed}.combined.${hemi}_1.25mm/${group}

			mri_glmfit --y ${seed}.combined.${hemi}_1.25mm/${group}/${seed}.combined.${hemi}_1.25mm/${seed}_1.25mm/ces.nii.gz --osgm --glmdir ${seed}.combined.${hemi}_1.25mm/${group} --nii.gz

			mri_binarize --i ${seed}.combined.${hemi}_1.25mm/${group}/osgm/sig.nii.gz --min 1.3 --o ${seed}.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz
		end

	end

end

foreach seed (DMPAG DLPAG LPAG VLPAG PAG_fin)

	foreach hemi (lh rh mni305)
		foreach group (n91)

			isxconcat-sess -sf rsfmri/subj_${group}.lst -analysis ${seed}.combined.${hemi}_1.25mm -contrast ${seed} -o ${seed}.combined.${hemi}_1.25mm/${group}

			mri_glmfit --y ${seed}.combined.${hemi}_1.25mm/${group}/${seed}.combined.${hemi}_1.25mm/${seed}/ces.nii.gz --osgm --glmdir ${seed}.combined.${hemi}_1.25mm/${group} --nii.gz

			mri_binarize --i ${seed}.combined.${hemi}_1.25mm/${group}/osgm/sig.nii.gz --min 1.3 --o ${seed}.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz
		end

	end

end



foreach seed (SC_superficial SC_deep)

	foreach hemi (lh rh mni305)
		foreach group (n91)

			isxconcat-sess -sf rsfmri/subj_${group}.lst -analysis ${seed}.combined.${hemi}_1.25mm -contrast ${seed} -o ${seed}.combined.${hemi}_1.25mm/${group}

			mri_glmfit --y ${seed}.combined.${hemi}_1.25mm/${group}/${seed}.combined.${hemi}_1.25mm/${seed}/ces.nii.gz --osgm --glmdir ${seed}.combined.${hemi}_1.25mm/${group} --nii.gz

			mri_binarize --i ${seed}.combined.${hemi}_1.25mm/${group}/osgm/sig.nii.gz --min 1.3 --o ${seed}.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz
		end

	end

end

foreach seed (hippo_B hippo_T) 

	foreach hemi (mni305)

		foreach group (n90)

			isxconcat-sess -sf scripts/subj_${group}.lst -analysis ${seed}.combined.${hemi}_1.25mm -contrast ${seed}_1.25mm -o ${seed}.combined.${hemi}_1.25mm/${group}

			mri_glmfit --y ${seed}.combined.${hemi}_1.25mm/${group}/${seed}.combined.${hemi}_1.25mm/${seed}_1.25mm/ces.nii.gz --osgm --glmdir ${seed}.combined.${hemi}_1.25mm/${group} --nii.gz

			mri_binarize --i ${seed}.combined.${hemi}_1.25mm/${group}/osgm/sig.nii.gz --min 1.3 --o ${seed}.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz
		end

	end

end

