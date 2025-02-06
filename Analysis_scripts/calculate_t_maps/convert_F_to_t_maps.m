cd /autofs/vast/iaslab/FSMAP

seeds={'dpIns_Gianaros','pgACC_Gianaros','dACC_Wager','dmIns_Kurth','sgACC_Gianaros','mvAIns_Harper','lvAIns_Wager',...
'dAmy_Gianaros','DR_2020','Hypothalamus','LC_l_r','LG_l_r','MD_Thal_Wager','MPB_LPB_l_r','Accumbens','PAG_fin','SC_DCfunc',...
'SN_l_r','VTA_PBP_l_r','VSM_l_r','hippo_H','hippo_B','hippo_T'};

for i=1:length(seeds)

	seed=seeds{i};

	F_map=MRIread(strcat(char(seed),'.combined.rh_1.25mm/n90/osgm/F.nii.gz'));
	sig_map=MRIread(strcat(char(seed),'.combined.rh_1.25mm/n90/osgm/sig.nii.gz'));
	t_map = F_map;
	t_map.vol=sign(sig_map.vol).*sqrt(t_map.vol);
	MRIwrite(t_map, strcat(char(seed),'.combined.rh_1.25mm/n90/osgm/t.nii.gz'));

end

