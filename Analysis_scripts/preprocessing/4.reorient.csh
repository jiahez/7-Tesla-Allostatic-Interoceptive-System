set n=25 # change according to actual sample size

cd /cluster/iaslab/FSMAP/

#setenv SUBJECTS_DIR /cluster/iaslab/FSMAP/recon

###################################################################################################################################################################
# RUN REORIENTATION AND CHECK BEFORE PREPROCESSING
foreach ind (`seq 1 1 $n`)

	set subj=`awk NR==$ind /cluster/iaslab/FSMAP/rsfmri/subj_g2.lst` # change subj list
	set rest_dir='/cluster/iaslab/FSMAP/'$subj'/rest'
	echo $subj

	set first=`awk -v line=$ind -v col=1 'NR == '$ind' { print $1 }' < rsfmri/restingstate_scan_number_g2.lst` 
	set second=`awk -v line=$ind -v col=2 'NR == '$ind' { print $2 }' < rsfmri/restingstate_scan_number_g2.lst` 
	set third=`awk -v line=$ind -v col=3 'NR == '$ind' {print $3 }' < rsfmri/restingstate_scan_number_g2.lst` 

	# REORIENTATION
	foreach run ($first $second $third)
		echo $run
	
		set run_dir=$rest_dir'/'$run 
		set subj_subname=`echo $subj| cut -c1-9`

		if ( $run == $first ) then
			set run_num='1' 
		else if ( $run == $second ) then
			set run_num='2'
		else if ( $run == $third ) then
			set run_num='3'
		else 
			echo "check run number"
		endif
		echo $run_num

		gunzip ${run_dir}/${subj_subname}_rest${run_num}.nii
		cp ${run_dir}/${subj_subname}_rest${run_num}.nii ${run_dir}/f.nii

		fslreorient2std $run_dir/f.nii $run_dir/f_reorient

	end

	# CHECK OUTPUT REORIENTATION
	if ( `fslorient -getsform ${rest_dir}/${first}/f_reorient.nii.gz` == `fslorient -getsform ${rest_dir}/${second}/f_reorient.nii.gz`) then
		eco "second run checks out"
	else if ( `fslorient -getsform $rest_dir/$first/f_reorient.nii.gz` == `fslorient -getsform $rest_dir/$third/f_reorient.nii.gz` ) then
		eco "third run checks out"
	else
		echo "$subj has mismatched orientations"
	endif

end

# IF MISMATCHED, do fslorient -getsform and -getqform; then fslorient -setsform and -setqform; Match other runs to the first run
# e.g. fslorient -setsform 1.10215 0 0 -89.5634 0 1.10215 0 -51.5421 0 0 1.1 -81.9419 0 0 0 1 008/f_reorient.nii.gz
# e.g. fslorient -setqform 1.10215 0 0 -89.5634 0 1.10215 0 -51.5421 0 0 1.1 -81.9419 0 0 0 1 008/f_reorient.nii.gz

