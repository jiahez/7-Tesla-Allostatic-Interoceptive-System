#cd /cluster/iaslab/FSMAP/
#source /usr/local/freesurfer/nmr-stable60-env
#setenv TMPDIR /cluster/iaslab/FSMAP/tmpdir
#setenv SUBJECTS_DIR /cluster/iaslab/FSMAP/recon
#setenv PATH /cluster/matlab/R2019b/bin:$PATH

set n=25

cd /cluster/iaslab/FSMAP/


foreach seed (lvAIns_Wager)
# (dpIns_Gianaros pgACC_Gianaros dACC_Wager dAmy_Gianaros dmIns_Kurth sgACC_Gianaros mvAIns_Harper lvAIns_Wager)

	mkanalysis-sess -analysis ${seed}.combined.lh_1.25mm_g2 -surface mni152.fnirt lh -fwhm 0 -notask -taskreg ${seed}_1.25mm.rh.sm04.dat 1 -fsd rest1_1.25mm -TR 1 -per-run -overwrite
	mkanalysis-sess -analysis ${seed}.combined.rh_1.25mm_g2 -surface mni152.fnirt rh -fwhm 0 -notask -taskreg ${seed}_1.25mm.rh.sm04.dat 1 -fsd rest1_1.25mm -TR 1 -per-run -overwrite

	foreach ind (`seq 6 1 25`)

		set subj=`awk NR==$ind /cluster/iaslab/FSMAP/rsfmri/subj_g2.lst` 

		fslmeants -i $subj/rest1_1.25mm/001/fmcpr.sm0.mni305.1mm.nii.gz -m ROIs/${seed}.rh.sm04.vol_crop_oc.nii.gz -o $subj/rest1_1.25mm/001/${seed}_1.25mm.rh.sm04.dat

		# calculate volume connectivity map
		selxavg3-sess -s $subj -a ${seed}.combined.lh_1.25mm_g2 -no-preproc -overwrite
		selxavg3-sess -s $subj -a ${seed}.combined.rh_1.25mm_g2 -no-preproc -overwrite

	end

end


