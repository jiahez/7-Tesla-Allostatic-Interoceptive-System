prefsu[1]=FSMAP_053_190114; dirT1[1]=007;
prefsu[2]=FSMAP_054_190123; dirT1[2]=007;
prefsu[3]=FSMAP_055_190127; dirT1[3]=007;
prefsu[4]=FSMAP_058_190206; dirT1[4]=007;
prefsu[5]=FSMAP_060_190210; dirT1[5]=007;
prefsu[6]=FSMAP_061_190211; dirT1[6]=007;
prefsu[7]=FSMAP_064_190304; dirT1[7]=007;
prefsu[8]=FSMAP_065_190304; dirT1[8]=007;
prefsu[9]=FSMAP_069_190324; dirT1[9]=007;
prefsu[10]=FSMAP_070_190331; dirT1[10]=007;
prefsu[11]=FSMAP_072_190331; dirT1[11]=007;
prefsu[12]=FSMAP_074_190401; dirT1[12]=007;
prefsu[13]=FSMAP_081_190429; dirT1[13]=007;
prefsu[14]=FSMAP_084_190516; dirT1[14]=007;
prefsu[15]=FSMAP_094_190617; dirT1[15]=007;
prefsu[16]=FSMAP_095_190626; dirT1[16]=007;
prefsu[17]=FSMAP_096_190630; dirT1[17]=007;
prefsu[18]=FSMAP_097_190630; dirT1[18]=007;    
prefsu[19]=FSMAP_098_190703; dirT1[19]=007;
prefsu[20]=FSMAP_099_190708; dirT1[20]=007;		
prefsu[21]=FSMAP_114_191023; dirT1[21]=007;
prefsu[22]=FSMAP_116_191104; dirT1[22]=007;
prefsu[23]=FSMAP_117_191104; dirT1[23]=007;
prefsu[24]=FSMAP_118_191106; dirT1[24]=007;
prefsu[25]=FSMAP_119_191113; dirT1[25]=007;

dirn_sub=001
pref1=rest1    #check if the same names for all the subjects
pref2=rest2
fixed=/usr/pubsw/packages/fsl/current/data/standard/MNI152_T1_1mm_brain.nii.gz # Target file without brain

for su in 23 24 25

do
	dirT1_sub[${su}]=/cluster/iaslab/FSMAP/${prefsu[${su}]}/T1/${dirT1[${su}]}/zreconT1EPI/

	# Creating a mask from the T1_mprage (alternative way to get a mask and probably better for normaliz. purposes)
	#---------------------------------------------------------
	fslmaths ${dirT1_sub[${su}]}/miepi_MPRAGE_FOR_FS_r_bfc.nii.gz -bin ${dirT1_sub[${su}]}/miepi_MPRAGE_FOR_FS_r_bfc_mask.nii.gz
	# Filling some very small holes ("fh"=fill hole) within the mask with afni, then converting brik to nii
	3dmask_tool -input ${dirT1_sub[${su}]}/miepi_MPRAGE_FOR_FS_r_bfc_mask.nii.gz -prefix  ${dirT1_sub[${su}]}/temp  -fill_holes
	3dAFNItoNIFTI  -prefix ${dirT1_sub[${su}]}/miepi_MPRAGE_FOR_FS_r_bfc_mask_fh.nii.gz  ${dirT1_sub[${su}]}/temp+tlrc.BRIK
	rm ${dirT1_sub[${su}]}/temp+tlrc*
	# *** Check *** if mask looks ok with:
	# fslview ${dirT1_sub[${su}]}/miepi_MPRAGE_FOR_FS_r_bfc.nii.gz ${dirT1_sub[${su}]}/miepi_MPRAGE_FOR_FS_r_bfc_mask_fh.nii.gz

	# Applying a mask and the nornalization transformations
	#---------------------------------------------------------
	for ses in 1 2  # then add here a loop for ses 1 and 2
	do
		# Setting file names (loop for ses1 and 2)
		#---------------------------------------------------------
		eval prefi='$'pref$ses
		dirfMRI=/cluster/iaslab/FSMAP/${prefsu[${su}]}/${prefi}/${dirn_sub}/
		filefMRI=$dirfMRI/f_st_mc_regout_bp 
		dirTransformT12MNI=/cluster/iaslab/FSMAP/scriptsMB/trasformT1epi2MNI_2ndcohort/${prefsu[${su}]:0:9}
		
		# Masking the fmri processed data with the mask miepi_MPRAGE_FOR_FS_r_bfc_mask_fh.nii.gz
		# This takes several minutes 
		#---------------------------------------------------------
		fslmaths $filefMRI -mul ${dirT1_sub[${su}]}/miepi_MPRAGE_FOR_FS_r_bfc_mask_fh.nii.gz ${filefMRI}_m
		
		# Applying the normalization transformations of fmri data from T1epispace to MNI152 space....
		# Split the 4D file in a series of 384 3D files, then run the normalization for each of them, finally create a 4D file again
		# This is because antsApplyTransforms -d 4 (4D) option gets killed or does not work
		moving=${filefMRI}_m
		mkdir ${dirfMRI}/temp_norm
		for index in {1..768}   # it will create inside temp_norm files from 000 to 383
		do
			indexOK="$(($index-1))"
			printf -v indexOK_3zeropad "%03d" $indexOK    #  this is to zeropad up to ###
			fslroi ${moving}.nii.gz  ${dirfMRI}/temp_norm/temp${indexOK_3zeropad} $indexOK 1 
			moving3D=${dirfMRI}/temp_norm/temp${indexOK_3zeropad}
			/cluster/pubsw/arch/CentOS5-x86-64/packages/ANTS/dev/bin/antsApplyTransforms -d 3 -e 0 -i ${moving3D}.nii.gz -r ${fixed} -o ${moving3D}_2_MNI152_T1_1mm_brain.nii.gz -t $dirTransformT12MNI/miepi_MPRAGE_FOR_FS_r_bfc_2_MNI152_T1_1mm_brain1Warp.nii.gz $dirTransformT12MNI/miepi_MPRAGE_FOR_FS_r_bfc_2_MNI152_T1_1mm_brain0GenericAffine.mat -v 1
		done

		# Then Merge the normalized files in a single 4D file --------------
		# (to check if all the timepoints have been normalized: ls *MNI152* | wc -w   ; this should give 384) 
		#---------------------------------------------------------
		fslmerge -t ${moving}_2_MNI152_T1_1mm_brain.nii.gz  ${dirfMRI}/temp_norm/*MNI152_T1_1mm_brain*
		# Remove the temp folder
		rm ${dirfMRI}/temp_norm -r
		mv ${moving}_2_MNI152_T1_1mm_brain.nii.gz ${moving}_2MNI.nii.gz 
	done # loop ses (run1 then run2)
done # subjects






