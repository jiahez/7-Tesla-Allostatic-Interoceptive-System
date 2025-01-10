foreach seed (dpIns_Gianaros pgACC_Gianaros dACC_Wager dmIns_Kurth sgACC_Gianaros mvAIns_Harper lvAIns_Wager dAmy_Gianaros DR_2020 Hypothalamus LC_l_r LG_l_r MD_Thal_Wager MPB_LPB_l_r Accumbens PAG_fin SC_DCfunc SN_l_r VTA_PBP_l_r VSM_l_r hippo_H hippo_B hippo_T)

	fscalc ${seed}.combined.rh_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul ${seed}.combined.rh_1.25mm/n90/osgm/t.nii.gz -o ${seed}.combined.rh_1.25mm/n90/osgm/t_masked.nii.gz

end

fscalc -o scripts/revision_scripts/hippo_maps/5fold/hippo_t_masked.nii.gz hippo_H.combined.rh_1.25mm/n90/osgm/t.nii.gz add hippo_B.combined.rh_1.25mm/n90/osgm/t.nii.gz add hippo_T.combined.rh_1.25mm/n90/osgm/t.nii.gz div 3 mul scripts/revision_scripts/hippo_maps/5fold/hippo_rh_sig_bin1.3_avg_bin950.nii.gz 
