#!/ bin/csh
cd $STUDY_DIR
mkdir -p $STUDY_DIR/derivatives

foreach subj (`awk '{print $1}' participants.tsv`)

	#Reorient to standard orientation.
	fslreorient2std rawdata/$subj/anat/${subj}_T1w.nii.gz rawdata/$subj/anat/${subj}_T1w_r.nii.gz
	
	#Run custom bias field correction script (Author credit: Marta Bianciardi, Brainstem Navigator; https://www.nitrc.org/projects/brainstemnavig)
	scripts/1.preprocessing/run_bfc.sh --i rawdata/$subj/anat/${subj}_T1w_r.nii.gz --o derivatives/$subj/zreconT1EPI/ZbfieldcorVBMtemp
	gzip derivatives/$subj/zreconT1EPI/ZbfieldcorVBMtemp/minput.nii
	cp derivatives/$subj/zreconT1EPI/ZbfieldcorVBMtemp/minput.nii.gz derivatives/$subj/anat/${subj}_T1w_r_bfc.nii.gz
	rm -r derivatives/$subj/zreconT1EPI/ZbfieldcorVBMtemp/
	
end
