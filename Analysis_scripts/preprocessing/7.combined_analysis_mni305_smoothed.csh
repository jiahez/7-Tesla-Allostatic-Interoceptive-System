#source /usr/local/freesurfer/nmr-stable60-env
#setenv TMPDIR /cluster/iaslab/FSMAP/tmpdir
#setenv SUBJECTS_DIR /cluster/iaslab/FSMAP/recon
#setenv PATH /cluster/matlab/R2019b/bin:$PATH

set n=25

cd /cluster/iaslab/FSMAP/

foreach seed (dpIns_Gianaros pgACC_Gianaros dACC_Wager dAmy_Gianaros dmIns_Kurth sgACC_Gianaros mvAIns_Harper lvAIns_Wager)

	mkanalysis-sess -analysis ${seed}.combined.mni305_1.25mm_g2 -mni305 1 -fwhm 0 -notask -taskreg ${seed}_1.25mm.rh.sm04.dat 1 -fsd rest1_1.25mm -TR 1 -per-run -overwrite

	foreach ind (`seq 1 1 $n`)

		set subj=`awk NR==$ind /cluster/iaslab/FSMAP/rsfmri/subj_g2.lst` 

		# calculate volume connectivity map
		selxavg3-sess -s $subj -a ${seed}.combined.mni305_1.25mm_g2 -no-preproc -overwrite

	end

end
