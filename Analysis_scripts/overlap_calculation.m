% for Table S3 -----------------------------------------------------------------------------------------------------------------------------------
% Connectivity maps
%  perm are binarized connectivity maps (positive and negative?)
%  osgm are cluster-corrected significance maps (with the values)

connSeedname = {'dpIns_Gianaros', 'pgACC_Gianaros', 'dAmy_Gianaros', 'dACC_Wager', 'dmIns_Kurth', 'sgACC_Gianaros',...
    'mvAIns_Harper', 'lvAIns_Wager', 'DR_2020', 'LG_l_r', 'SN_l_r', 'VTA_PBP_l_r', 'LC_l_r', 'MPB_LPB_l_r',...
    'Accumbens', ' 'Hypothalamus', 'MD_Thal_Wager', 'SC_DCfunc', 'VSM_l_r', 'PAG_fin','hippo_avg'};
BNname = {'DR_2020', 'LG_l_r', 'SN_l_r', 'VTA_PBP_l_r', 'LC_l_r', 'MPB_LPB_l_r', 'LPB_l_r', 'MPB_l_r', 'Accumbens', ...
    'hippo_B', 'hippo_H', 'hippo_T', 'Hippocampus','Hypothalamus', 'MD_Thal_Wager', 'SC_DCfunc', 'VSM_l_r', 'DMPAG', ...
    'DLPAG', 'LPAG', 'VLPAG', 'PAG_fin','dAmy_Gianaros'};

for i = 1:(length(connSeedname)-1)
	fileconn_bin{i}=strcat('/autofs/vast/iaslab/FSMAP/',connSeedname{i},'.combined.mni305_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz');
	fileconn{i}=strcat('/autofs/vast/iaslab/FSMAP/',connSeedname{i},'.combined.mni305_1.25mm/perm_test/5fold/sum_sig_bin1.3.nii.gz');
	conmaps_bin{i} = load_nifti(fileconn_bin{i});
	conmap{i} = load_nifti(fileconn{i});
end

% add average hippo map
fileconn_bin{i+1}='/autofs/vast/iaslab/FSMAP/scripts/revision_scripts/hippo_maps/hippo_mni305_sig_bin1.3_avg_bin950.nii.gz';
fileconn{i+1}='/autofs/vast/iaslab/FSMAP/scripts/revision_scripts/hippo_maps/hippo_mni305_sig_bin1.3_avg_bin950.nii.gz';
conmaps_bin{i+1} = load_nifti(fileconn_bin{i+1});
conmap{i+1} = load_nifti(fileconn{i+1});

%%
for j = 1:length(BNname)
	BN{j} = strcat('/autofs/vast/iaslab/FSMAP/ROIs/',BNname{j},'_LIA_crop_oc.nii.gz');
	label{j} = load_nifti(BN{j});
end


% Computing the overlap in terms of number of voxels in common
for C = 1:length(connSeedname)
	for L=1:length(BNname)
	%clear conmap label conmap_bin label_bin sum_roi
	%conmap = load_nifti(fileconn{C});
	%label = load_nifti(BN{L});
	clear conmap_bin label_bin sum_roi
	% Binarizing (re-do it just in case I missed a binarization above)
	%conmap_bin=conmap{C}.vol.*0;
	%conmap_bin(find(conmap{C}.vol))=1;
	conmap_bin=conmaps_bin{C}.vol;
	label_bin=label{L}.vol.*0;
	label_bin(find(label{L}.vol))=1;
	
	sum_roi = label_bin + conmap_bin;
	if not(isempty(find(sum_roi== 2)))
		nvox(C,L) = length(find(sum_roi== 2));
		perc_vol_label(C,L) = nvox(C,L)./length(find(label_bin));
	else
		nvox(C,L) = 0;
		perc_vol_label(C,L) = 0;
	end	
	end
fprintf([ num2str(C) 'th connectivity map\n'])
end

% Computing the mean and max
for C = 1:length(connSeedname)
	for L=1:length(BNname)
	clear  conmap_ok label_bin 
        conmap_ok=conmap{C}.vol;
	% Binarizing (re-do it just in case I missed a binarization above)
	label_bin=label{L}.vol.*0;
	label_bin(find(label{L}.vol))=1;
	% Computing
	MEANlogp_label(C,L)=mean(conmap_ok(find(label_bin)));
	MAXlogp_label(C,L)=max(conmap_ok(find(label_bin)));
	end
fprintf([ num2str(C) 'th connectivity map\n'])
end

save overlap_211210.mat  nvox perc_vol_label MEANlogp_label MAXlogp_label fileconn BN BNname connSeedname
% %%
% save  $dirOUT/overlap_v3_20210413_g1  nvox perc_vol_label MEANlogp_label MAXlogp_label fileconn BN BNname connSeedname
% % OR
% save  $dirOUT/overlap_v3_20210413_g2  nvox perc_vol_label MEANlogp_label MAXlogp_label fileconn BN BNname connSeedname
% 
% 
% %---------------------------------------------------------------------------------------------------
% %---------------------------------------------------------------------------------------------------
% % VISUALIZE FIGURES --------------------------------------------------------------------------------
% %---------------------------------------------------------------------------------------------------
% %---------------------------------------------------------------------------------------------------
% load $dirOUT/overlap_v3_20210413_g1
% % or group 2 
% load $dirOUT/zresults_conn/overlap_v3_20210413_g2
% 
% 
% # 1. CORTICAL SEEDS WITH ALL TARGETS (larger subcortical regions and brainstem nuclei -merged left and right)
% #-----------------------------------------------
% seedInd=1:8;
% targetind=[1:15];  %
% xnames=[];
% for Q=targetind
% xnames = [ xnames; BNname{Q}];
% end
% 
% % NUM VOXELS
% figure,
% n=0;
% for C=seedInd
% n=n+1;
% subplot(4,2,n),b=bar(nvox(C,targetind))
% set(gca,'XTick',1:length(targetind))
% set(gca,'XTickLabel', xnames)
% set(gca,'XTickLabelRotation',90)
% axis([ 0.5 length(targetind)+0.5   0 max(max(nvox(:,targetind)))+10])
% title(connSeedname{C})
% end
% dim1=20; dim2=25; 
% set(gcf,'PaperUnits','centimeters');
% set(gcf,'PaperPosition',[0 0 dim1 dim2]); set(gcf,'PaperSize',[dim1 dim2])
% map=gray; map=map(32:end,:);
% colormap(map)
% eval(['print -dtiff -r300 Fig_corticalSeeds_withBrainstem_NumVox_v4_g1.tiff'])
% % the brainstem results are not clearly visible because of the larger subcortical structures...
% 
% % PERC. VOLUME
% figure,
% n=0;
% for C=seedInd
% n=n+1;
% subplot(4,2,n),b=bar(100*perc_vol_label(C,targetind))
% set(gca,'XTick',1:length(targetind))
% set(gca,'XTickLabel', xnames)
% set(gca,'XTickLabelRotation',90)
% axis([ 0.5 length(targetind)+0.5   0 100*(max(max(perc_vol_label(:,targetind)))+0.1)])
% title(connSeedname{C})
% end
% dim1=20; dim2=25; 
% set(gcf,'PaperUnits','centimeters');
% set(gcf,'PaperPosition',[0 0 dim1 dim2]); set(gcf,'PaperSize',[dim1 dim2])
% map=gray; map=map(32:end,:);
% colormap(map)
% eval(['print -dtiff -r300 Fig_corticalSeeds_withBrainstem_Percvol_v4_g1.tiff'])
% % This is ok!
% 
% 
% % MEAN logPvalue
% figure,
% n=0;
% for C=seedInd
% n=n+1;
% subplot(4,2,n),b=bar(MEANlogp_label(C,targetind))
% set(gca,'XTick',1:length(targetind))
% set(gca,'XTickLabel', xnames)
% set(gca,'XTickLabelRotation',90)
% axis([ 0.5 length(targetind)+0.5   0 max(max(MEANlogp_label(:,targetind)))+1])
% title(connSeedname{C})
% end
% dim1=20; dim2=25; 
% set(gcf,'PaperUnits','centimeters');
% set(gcf,'PaperPosition',[0 0 dim1 dim2]); set(gcf,'PaperSize',[dim1 dim2])
% map=gray; map=map(32:end,:);
% colormap(map)
% eval(['print -dtiff -r300 Fig_corticalSeeds_withBrainstem_MEANlogp_v4_g1.tiff'])
% 
% % MAX logPvalue
% figure,
% n=0;
% for C=seedInd
% n=n+1;
% subplot(4,2,n),b=bar(MAXlogp_label(C,targetind))
% set(gca,'XTick',1:length(targetind))
% set(gca,'XTickLabel', xnames)
% set(gca,'XTickLabelRotation',90)
% axis([ 0.5 length(targetind)+0.5   0 max(max(MAXlogp_label(:,targetind)))+1])
% title(connSeedname{C})
% end
% dim1=20; dim2=25; 
% set(gcf,'PaperUnits','centimeters');
% set(gcf,'PaperPosition',[0 0 dim1 dim2]); set(gcf,'PaperSize',[dim1 dim2])
% map=gray; map=map(32:end,:);
% colormap(map)
% eval(['print -dtiff -r300 Fig_corticalSeeds_withBrainstem_MAXlogp_v4_g1.tiff'])
% 
% 
% 
% 
% 
% # 2. PAG SEEDS WITH ALL TARGETS (larger subcortical regions and brainstem nuclei -merged left and right)
% #-----------------------------------------------
% seedInd=9:13;  % PAG and subregions
% targetind=[1:15];  
% xnames=[];
% for Q=targetind
% xnames = [ xnames; BNname{Q}];
% end
% 
% figure,
% n=0;
% for C=seedInd
% n=n+1;
% subplot(3,2,n),b=bar(nvox(C,targetind))
% set(gca,'XTick',1:length(targetind))
% set(gca,'XTickLabel', xnames)
% set(gca,'XTickLabelRotation',90)
% axis([ 0.5 length(targetind)+0.5   0 max(max(nvox(:,targetind)))+10])
% title(connSeedname{C})
% end
% dim1=20; dim2=25; 
% set(gcf,'PaperUnits','centimeters');
% set(gcf,'PaperPosition',[0 0 dim1 dim2]); set(gcf,'PaperSize',[dim1 dim2])
% map=gray; map=map(32:end,:);
% colormap(map)
% eval(['print -dtiff -r300 Fig_PAGSeeds_withBrainstem_NumVox_v4_g1.tiff'])
% 
% figure,
% n=0;
% for C=seedInd
% n=n+1;
% subplot(3,2,n),b=bar(100*perc_vol_label(C,targetind))
% set(gca,'XTick',1:length(targetind))
% set(gca,'XTickLabel', xnames)
% set(gca,'XTickLabelRotation',90)
% axis([ 0.5 length(targetind)+0.5   0 100*(max(max(perc_vol_label(:,targetind)))+0.1)])
% title(connSeedname{C})
% end
% dim1=20; dim2=25; 
% set(gcf,'PaperUnits','centimeters');
% set(gcf,'PaperPosition',[0 0 dim1 dim2]); set(gcf,'PaperSize',[dim1 dim2])
% map=gray; map=map(32:end,:);
% colormap(map)
% %eval(['print -dtiff -r300 /space/tikal/4/mindovermatter/9/users/martab/U01/zresults_conn/Fig_PAGSeeds_withBrainstem_Percvol_v1.tiff'])
% %eval(['print -dtiff -r300 /space/tikal/4/mindovermatter/9/users/martab/U01/zresults_conn/Fig_PAGSeeds_withBrainstem_Percvol_v2.tiff'])
% eval(['print -dtiff -r300 /space/tikal/4/mindovermatter/9/users/martab/U01/zresults_conn/Fig_PAGSeeds_withBrainstem_Percvol_v4_g1.tiff'])
% 
% 
% % MEAN logPvalue
% figure,
% n=0;
% for C=seedInd
% n=n+1;
% subplot(4,2,n),b=bar(MEANlogp_label(C,targetind))
% set(gca,'XTick',1:length(targetind))
% set(gca,'XTickLabel', xnames)
% set(gca,'XTickLabelRotation',90)
% axis([ 0.5 length(targetind)+0.5   0 max(max(MEANlogp_label(:,targetind)))+1])
% title(connSeedname{C})
% end
% dim1=20; dim2=25; 
% set(gcf,'PaperUnits','centimeters');
% set(gcf,'PaperPosition',[0 0 dim1 dim2]); set(gcf,'PaperSize',[dim1 dim2])
% map=gray; map=map(32:end,:);
% colormap(map)
% eval(['print -dtiff -r300  Fig_PAGSeeds_withBrainstem_MEANlogp_v4_g1.tiff'])
% 
% % MAX logPvalue
% figure,
% n=0;
% for C=seedInd
% n=n+1;
% subplot(4,2,n),b=bar(MAXlogp_label(C,targetind))
% set(gca,'XTick',1:length(targetind))
% set(gca,'XTickLabel', xnames)
% set(gca,'XTickLabelRotation',90)
% axis([ 0.5 length(targetind)+0.5   0 max(max(MAXlogp_label(:,targetind)))+1])
% title(connSeedname{C})
% end
% dim1=20; dim2=25; 
% set(gcf,'PaperUnits','centimeters');
% set(gcf,'PaperPosition',[0 0 dim1 dim2]); set(gcf,'PaperSize',[dim1 dim2])
% map=gray; map=map(32:end,:);
% colormap(map)
% eval(['print -dtiff -r300 Fig_PAGSeeds_withBrainstem_MAXlogp_v4_g1.tiff'])
% 
% 
