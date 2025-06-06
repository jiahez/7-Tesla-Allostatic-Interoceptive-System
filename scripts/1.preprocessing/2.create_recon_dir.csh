#!/ bin/csh
cd $STUDY_DIR

foreach ind (`seq 1 1 $n`)

	set subj=`awk NR==$ind $DATA_DIR/rsfmri/subj.lst`
	set run_no = `awk NR==$ind $DATA_DIR/rsfmri/T1_scan_number.lst`

	#mkdir $subj
	#mkdir $subj/mri
	#mkdir $subj/mri/orig

	mri_convert $DATA_DIR/$subj/T1/$run_no/zreconT1EPI/miepi_MPRAGE_FOR_FS_r_bfc.nii.gz $subj/mri/orig/001.mgz

end
