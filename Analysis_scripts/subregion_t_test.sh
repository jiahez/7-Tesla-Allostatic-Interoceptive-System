mkdir /vast/iaslab/FSMAP/scripts/revision_scripts/subregion_t_test
cd /vast/iaslab/FSMAP/scripts/revision_scripts/subregion_t_test

## PAG ##

for seed in DMPAG DLPAG LPAG VLPAG; do

	mkdir -p /vast/iaslab/FSMAP/scripts/revision_scripts/subregion_t_test/$seed

	for hemi in lh rh mni305; do

		for subj in `cat /vast/iaslab/FSMAP/scripts/subj_n90.lst`; do

			ln /vast/iaslab/FSMAP/$subj/rest1_1.25mm/$seed.combined.${hemi}_1.25mm/$seed/ces.nii.gz /vast/iaslab/FSMAP/scripts/revision_scripts/subregion_t_test/$seed/$subj.$hemi.nii.gz

		done

	done

done


for contrast in DM_DL DM_L DM_VL DL_L DL_VL L_VL; do


	rm $contrast -r
	mkdir -p $contrast

	A="$(cut -d'_' -f1 <<< $contrast)"
	B="$(cut -d'_' -f2 <<< $contrast)"

	for hemi in lh rh mni305; do

		# create paired-difference map per subject
		for subj in `cat /vast/iaslab/FSMAP/scripts/subj_n90.lst`; do

			mris_calc -o $contrast/$subj.$hemi.nii.gz ${A}PAG/$subj.$hemi.nii.gz sub ${B}PAG/$subj.$hemi.nii.gz
		done

		# combined all paired-difference maps into one 4D volumes
		mri_concat --o $contrast/$contrast.$hemi.merged.nii.gz --i $contrast/*.$hemi.nii.gz

		# run one sample t-test
		mri_glmfit --glmdir $contrast/$hemi.osgm --y $contrast/$contrast.$hemi.merged.nii.gz --fsgd FSGD --C contrast.mtx
	done

done



## hippocampus ##

for seed in hippo_H hippo_B hippo_T; do

	mkdir -p /vast/iaslab/FSMAP/scripts/revision_scripts/subregion_t_test/$seed

	for hemi in lh rh mni305; do

		for subj in `cat /vast/iaslab/FSMAP/scripts/subj_n90.lst`; do

			ln /vast/iaslab/FSMAP/$subj/rest1_1.25mm/$seed.combined.${hemi}_1.25mm/$seed/ces.nii.gz /vast/iaslab/FSMAP/scripts/revision_scripts/subregion_t_test/$seed/$subj.$hemi.nii.gz

		done

	done

done



for contrast in H_B H_T B_T; do


	rm $contrast -r
	mkdir -p $contrast

	A="$(cut -d'_' -f1 <<< $contrast)"
	B="$(cut -d'_' -f2 <<< $contrast)"

	for hemi in lh rh mni305; do

		# create paired-difference map per subject
		for subj in `cat /vast/iaslab/FSMAP/scripts/subj_n90.lst`; do

			mris_calc -o $contrast/$subj.$hemi.nii.gz hippo_${A}/$subj.$hemi.nii.gz sub hippo_${B}/$subj.$hemi.nii.gz
		done

		# combined all paired-difference maps into one 4D volumes
		mri_concat --o $contrast/$contrast.$hemi.merged.nii.gz --i $contrast/*.$hemi.nii.gz

		# run one sample t-test
		mri_glmfit --glmdir $contrast/$hemi.osgm --y $contrast/$contrast.$hemi.merged.nii.gz --fsgd FSGD --C contrast.mtx
	done

done

## superior colliculus ##

for seed in sc_superficial sc_deep; do

	mkdir -p /vast/iaslab/FSMAP/scripts/revision_scripts/subregion_t_test/$seed

	for hemi in lh rh mni305; do

		for subj in `cat /vast/iaslab/FSMAP/scripts/subj_n90.lst`; do

			ln /vast/iaslab/FSMAP/$subj/rest1_1.25mm/$seed.combined.${hemi}_1.25mm/$seed/ces.nii.gz /vast/iaslab/FSMAP/scripts/revision_scripts/subregion_t_test/$seed/$subj.$hemi.nii.gz

		done

	done

done



for contrast in superficial_deep; do


	rm $contrast -r
	mkdir -p $contrast

	A="superficial"
	B="deep"

	for hemi in lh rh mni305; do

		# create paired-difference map per subject
		for subj in `cat /vast/iaslab/FSMAP/scripts/subj_n90.lst`; do

			mris_calc -o $contrast/$subj.$hemi.nii.gz sc_${A}/$subj.$hemi.nii.gz sub sc_${B}/$subj.$hemi.nii.gz
		done

		# combined all paired-difference maps into one 4D volumes
		mri_concat --o $contrast/$contrast.$hemi.merged.nii.gz --i $contrast/*.$hemi.nii.gz

		# run one sample t-test
		mri_glmfit --glmdir $contrast/$hemi.osgm --y $contrast/$contrast.$hemi.merged.nii.gz --fsgd FSGD --C contrast.mtx
	done

done

