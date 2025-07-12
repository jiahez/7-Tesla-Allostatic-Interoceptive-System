function regressOUT_regressors(filenameEPIin, regressors, filenameEPIout, createmask)

% function regressOUT_regressors(filenameEPIin, regressors, filenameEPIout)
% filenameEPI = name of nifti input data set
% regressors is a variable already loaded in matlab containing the regressors to be removed from the data..
% filenameEPI = name of nifti output data set 
% createmask='y' or 'n'. If 'y' will create a mask from the mean time-course, otherwise it will just find in-brain voxels from the first time-point.

% Assumption: slice direction is 3, timepoints 4
% Computing mask from the average EPI across repetitions..recompute if needed
% MaBia Version Sept. 2014


% LOADING DATA REGRESSORS
epi_magn=load_nifti(filenameEPIin); % load_nifti for example in /usr/local/freesurfer/stable5_1_0/matlab/
epi_magn_res=reshape(epi_magn.vol,size(epi_magn.vol,1)*size(epi_magn.vol,2), size(epi_magn.vol,3),size(epi_magn.vol,4) );

if createmask=='y'
	% GENERATING A MASK
	temp=mean(epi_magn.vol,4);
	threshold = 0.1; % 0.3; % change threshold to 0.2 or 0.1 or 0.3 if needed (see mask)
	mask=temp.*0; mask(temp> threshold*mean(mean(mean(temp))))=1; % 0.3; % change threshold 0.2 if needed (see mask)
	for sl=1:size(epi_magn.vol,3) mask(:,:,sl)=medfilt2(mask(:,:,sl)); end  % new: masked smoothed
	%figure, subplot(2,1,1),imagesc([mask(:,:,3) ; mask(:,:,floor(size(mask,3)/2)); mask(:,:,end-3)   ]'  )
	%subplot(2,1,2), imagesc([temp(:,:,3) ; temp(:,:,floor(size(temp,3)/2)); temp(:,:,end-3)   ]'  )
else  % images already betted
	mask=squeeze(epi_magn.vol(:,:,:,1));
	mask(find(squeeze(epi_magn.vol(:,:,:,1))))=1;
'No brain mask used, regression out of covariates performed in every voxel'
end


% REGRESS OUT COVARIATES OF NO INTEREST 
epi_magn_res_corr=epi_magn_res*0; 
for sl=1:size(epi_magn.vol,3)
	epi_magn_res_sl=squeeze(   epi_magn_res(find(mask(:,:,sl)), sl, :)  );% vx in mask x 151
	if size(epi_magn_res_sl,2)==1 epi_magn_res_sl=epi_magn_res_sl'; end
	DMREGR = [regressors]; % if needed add more regressors etc.
       	epi_magn_res_sl_corrREGR  =  (epi_magn_res_sl'  - DMREGR*pinv(DMREGR)*  epi_magn_res_sl')' ; 
        epi_magn_res_corr(find(mask(:,:,sl)), sl, :) = epi_magn_res_sl_corrREGR; clear epi_magn_res_sl_corrREGR; %it is ord dependent since DM is order depenedent!
fprintf('.')
end %sl
epi_magn_corrREGR=epi_magn; epi_magn_corrREGR.vol=epi_magn.vol*0; 
epi_magn_corrREGR.vol= reshape(epi_magn_res_corr,size(epi_magn.vol,1),size(epi_magn.vol,2), size(epi_magn.vol,3),size(epi_magn.vol,4) );

% SAVING THE NIFTI FILE
err = save_nifti(epi_magn_corrREGR, filenameEPIout);

if createmask=='y'
	% SAVING THE MASK FILE
	epi_mask=epi_magn; epi_mask.vol=mask;epi_mask.dim(4)=1;
	maskfilename= [ filenameEPIout(1:end-7) '_mask.nii.gz'];
	err = save_nifti(epi_mask, maskfilename);
end
 
% keyboard
