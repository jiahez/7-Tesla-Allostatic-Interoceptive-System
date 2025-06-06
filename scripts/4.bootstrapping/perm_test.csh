#!/bin/tcsh

source /usr/local/freesurfer/nmr-stable60-env #(THIS IS IMPORTANT FOR THE MNI305 ANALYSIS)
setenv TMPDIR /scratch
setenv SUBJECTS_DIR /cluster/iaslab/FSMAP/recon

cd /vast/iaslab/FSMAP/

#set seed and hemi
set seed = $argv[1]
set hemi = $argv[2]

mkdir -p ${seed}.combined.${hemi}_1.25mm/perm_test/5fold

foreach i (`seq 1 1 1000`)

	#concatenate all subjects' data into one file
	isxconcat-sess -sf scripts/revision_scripts/bootstrapping_test/5fold/subj_lists/subj_iter${i}a.lst -analysis ${seed}.combined.${hemi}_1.25mm -contrast ${seed} -o ${seed}.combined.${hemi}_1.25mm/iter${i}a

	#compute FC with seed
	mri_glmfit --y ${seed}.combined.${hemi}_1.25mm/iter${i}a/${seed}.combined.${hemi}_1.25mm/${seed}/ces.nii.gz --osgm --glmdir ${seed}.combined.${hemi}_1.25mm/iter${i}a --nii.gz

	#binarize FC map
	mri_binarize --i ${seed}.combined.${hemi}_1.25mm/iter${i}a/osgm/sig.nii.gz --min 1.3 --o ${seed}.combined.${hemi}_1.25mm/perm_test/5fold/iter${i}_sig_bin1.3.nii.gz

	#remove intermediate directory
	rm -r ${seed}.combined.${hemi}_1.25mm/iter${i}a

end

#sum all binarized maps
mri_concat ${seed}.combined.${hemi}_1.25mm/perm_test/5fold/iter*sig_bin1.3.nii.gz --o ${seed}.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3.nii.gz --sum
