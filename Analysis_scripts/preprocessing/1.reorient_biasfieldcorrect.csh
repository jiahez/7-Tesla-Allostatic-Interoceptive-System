#!/ bin/csh
set n=25 # change according to actual sample size

foreach ind (`seq 1 1 $n`)

	set subj=`awk NR==$ind /cluster/iaslab/FSMAP/rsfmri/subj_g2.lst`
	set run_no = `awk NR==$ind /cluster/iaslab/FSMAP/rsfmri/T1_scan_number_g2.lst`

	echo $subj
	echo $subj
	echo $subj

	#Reorient miepi_MPRAGE_FOR_FS.nii.gz to standard orientation.
	fslreorient2std /cluster/iaslab/FSMAP/$subj/T1/$run_no/zreconT1EPI/miepi_MPRAGE_FOR_FS.nii.gz /cluster/iaslab/FSMAP/$subj/T1/$run_no/zreconT1EPI/miepi_MPRAGE_FOR_FS_r.nii.gz
	

	#Run the bias field correction on the miepi_MPRAGE_FOR_FS_r.nii.gz
	#check with Jiahe about the line below again

	/cluster/iaslab/FSMAP/scriptsMB/run-vbm --i /cluster/iaslab/FSMAP/$subj/T1/$run_no/zreconT1EPI/miepi_MPRAGE_FOR_FS_r.nii.gz --o /cluster/iaslab/FSMAP/$subj/T1/$run_no/zreconT1EPI/ZbfieldcorVBMtemp
	gzip /cluster/iaslab/FSMAP/$subj/T1/$run_no/zreconT1EPI/ZbfieldcorVBMtemp/minput.nii
	cp /cluster/iaslab/FSMAP/$subj/T1/$run_no/zreconT1EPI/ZbfieldcorVBMtemp/minput.nii.gz /cluster/iaslab/FSMAP/$subj/T1/$run_no/zreconT1EPI/miepi_MPRAGE_FOR_FS_r_bfc.nii.gz
	rm -r /cluster/iaslab/FSMAP/$subj/T1/$run_no/zreconT1EPI/ZbfieldcorVBMtemp/

end
