# Fig S2: CORTICAL MAPS OF CORTICAL SEEDS
# SN: dmIns, dpIns, lvAIns; DMN: dACC, mvAIns, pgACC, sgACC
foreach hemi (lh rh mni305)
	# SN
	fscalc dmIns_Kurth.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul dpIns_Gianaros.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul lvAIns_Wager.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz -o scripts/revision_scripts/overlap_maps/cortSeed_SN_cluster_${hemi}.nii.gz 

	# DMN
	fscalc dACC_Wager.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul sgACC_Gianaros.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul pgACC_Gianaros.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul mvAIns_Harper.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz -o scripts/revision_scripts/overlap_maps/cortSeed_DMN_cluster_${hemi}.nii.gz 
end

# Fig S7: CORTICAL MAPS OF SUBCORTICAL SEEDS
# k=2 (not optimal)
#1: dAmy, LG, MD_Thal, Accumbens, SC_DCfunc SN_l_r VTA hippo
#2: DR, Hypothal, LC, MPB_LPB, PAG_fin, VSM_l_r

foreach hemi (lh rh)

	# Cluster 1: less robust
	fscalc DR_2020.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul Hypothalamus.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul LC_l_r.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul MPB_LPB_l_r.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul PAG_fin.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul VSM_l_r.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz  -o scripts/revision_scripts/overlap_maps/subcort_Cluster1_${hemi}_k2.nii.gz 

	# Cluster 2: more robust
	fscalc LG_l_r.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul MD_Thal_Wager.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul Accumbens.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul SC_DCfunc.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul SN_l_r.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul VTA_PBP_l_r.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul rsfmri/hippo_maps/5fold/hippo_${hemi}_sig_bin1.3_avg_bin950.nii.gz mul dAmy_Gianaros.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz -o scripts/revision_scripts/overlap_maps/subcort_Cluster2_${hemi}_k2.nii.gz 

end

# k=3 (presented)
#1: dAmy, LG, MD_Thal, Accumbens, SC_DCfunc SN_l_r VTA hippo
#2: DR, Hypothal, PAG_fin
#3: LC, MPB_LPB, VSM_l_r
foreach hemi (lh rh)

	# Cluster 1: lowest brainstem; LC, MPB_LPB, VSM
	fscalc LC_l_r.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul MPB_LPB_l_r.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul VSM_l_r.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz  -o scripts/revision_scripts/overlap_maps/subcortSeed_Cluster1_${hemi}_k3.nii.gz 

	# Cluster 2: DR, Hypothal, PAG
	fscalc DR_2020.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul Hypothalamus.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul PAG_fin.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz -o scripts/revision_scripts/overlap_maps/subcortSeed_Cluster2_${hemi}_k3.nii.gz 

	# Cluster 3: most robust
	fscalc LG_l_r.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul MD_Thal_Wager.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul Accumbens.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul SC_DCfunc.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul SN_l_r.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul VTA_PBP_l_r.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul rsfmri/hippo_maps/5fold/hippo_${hemi}_sig_bin1.3_avg_bin950.nii.gz mul dAmy_Gianaros.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz -o scripts/revision_scripts/overlap_maps/subcortSeed_Cluster3_${hemi}_k3.nii.gz 

end

# SUBCORTICAL MAPS OF SUBCORTICAL SEEDS
foreach hemi (mni305)

	# Cluster 1: lowest brainstem; LC, MPB_LPB, VSM
	fscalc LC_l_r.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul MPB_LPB_l_r.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul VSM_l_r.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz  -o scripts/revision_scripts/overlap_maps/subcortSeed_Cluster1_${hemi}_k3.nii.gz 

	# Cluster 2: DR, Hypothal, PAG
	fscalc DR_2020.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul Hypothalamus.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul PAG_fin.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz -o scripts/revision_scripts/overlap_maps/subcortSeed_Cluster2_${hemi}_k3.nii.gz 

	# Cluster 3: most robust
	fscalc LG_l_r.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul MD_Thal_Wager.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul Accumbens.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul SC_DCfunc.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul SN_l_r.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul VTA_PBP_l_r.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz mul rsfmri/hippo_maps/5fold/hippo_${hemi}_sig_bin1.3_avg_bin950.nii.gz mul dAmy_Gianaros.combined.${hemi}_1.25mm/perm_test/5fold/sum_sig_bin1.3_bin950.nii.gz -o scripts/revision_scripts/overlap_maps/subcortSeed_Cluster3_${hemi}_k3.nii.gz 

end

############## OLD CODES ############

cluster -i rsfmri/mni305_overlap_all_${group}.nii.gz -t 0.5 >> rsfmri/mni305_overlap_all_${group}_clusters.txt

# CORTICAL MAPS OF SUBCORTICAL SEEDS: based on subcortico-subcortical clustering
foreach group (g1_n46 g2_n45)
	foreach hemi (lh rh)
		# Cluster 1: less robust
		mris_calc -o rsfmri/subcort_Cluster1a_${hemi}_${group}.nii.gz PAG_fin.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz mul VSM_l_r.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz
		mris_calc -o rsfmri/subcort_Cluster1a_${hemi}_${group}.nii.gz rsfmri/subcort_Cluster1a_${hemi}_${group}.nii.gz mul DR_2020.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz
		mris_calc -o rsfmri/subcort_Cluster1a_${hemi}_${group}.nii.gz rsfmri/subcort_Cluster1a_${hemi}_${group}.nii.gz mul MPB_LPB_l_r.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz 			
		mris_calc -o rsfmri/subcort_Cluster1a_${hemi}_${group}.nii.gz rsfmri/subcort_Cluster1a_${hemi}_${group}.nii.gz mul LC_l_r.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz


		# Cluster 2: more robust
		mris_calc -o rsfmri/subcort_Cluster2a_${hemi}_${group}.nii.gz MD_Thal_Wager.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz mul LG_l_r.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz
		mris_calc -o rsfmri/subcort_Cluster2a_${hemi}_${group}.nii.gz rsfmri/subcort_Cluster2a_${hemi}_${group}.nii.gz mul rsfmri/hippo_maps/hippo_${group}_${hemi}_sig_avg_bin1.3.nii.gz
		mris_calc -o rsfmri/subcort_Cluster2a_${hemi}_${group}.nii.gz rsfmri/subcort_Cluster2a_${hemi}_${group}.nii.gz mul dAmy_Gianaros.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz
		mris_calc -o rsfmri/subcort_Cluster2a_${hemi}_${group}.nii.gz rsfmri/subcort_Cluster2a_${hemi}_${group}.nii.gz mul Accumbens.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz
		mris_calc -o rsfmri/subcort_Cluster2a_${hemi}_${group}.nii.gz rsfmri/subcort_Cluster2a_${hemi}_${group}.nii.gz mul SC_DCfunc.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz 
		mris_calc -o rsfmri/subcort_Cluster2a_${hemi}_${group}.nii.gz rsfmri/subcort_Cluster2a_${hemi}_${group}.nii.gz mul SN_l_r.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz 
		mris_calc -o rsfmri/subcort_Cluster2a_${hemi}_${group}.nii.gz rsfmri/subcort_Cluster2a_${hemi}_${group}.nii.gz mul VTA_PBP_l_r.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz 
		mris_calc -o rsfmri/subcort_Cluster2a_${hemi}_${group}.nii.gz rsfmri/subcort_Cluster2a_${hemi}_${group}.nii.gz mul Hypothalamus.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz


	end
end


# MERGE ALL 21 CORTICAL AND SUBCORTICAL OVERLAP MAPS FOR VISUALIZATION

foreach group (g1_n46 g2_n45)

	# CREATE CONTINUOUS CONJUNCTION MAPS
	fslmaths MD_Thal_Wager.combined.mni305_1.25mm/${group}/osgm/sig_bin1.3.nii.gz -add LG_l_r.combined.mni305_1.25mm/${group}/osgm/sig_bin1.3.nii.gz -add Hypothalamus.combined.mni305_1.25mm/${group}/osgm/sig_bin1.3.nii.gz -add rsfmri/hippo_maps/hippo_${group}_mni305_sig_avg_bin1.3.nii.gz -add dAmy_Gianaros.combined.mni305_1.25mm/${group}/osgm/sig_bin1.3.nii.gz -add Accumbens.combined.mni305_1.25mm/${group}/osgm/sig_bin1.3.nii.gz -add PAG_fin.combined.mni305_1.25mm/${group}/osgm/sig_bin1.3.nii.gz -add DR_2020.combined.mni305_1.25mm/${group}/osgm/sig_bin1.3.nii.gz -add SC_DCfunc.combined.mni305_1.25mm/${group}/osgm/sig_bin1.3.nii.gz -add SN_l_r.combined.mni305_1.25mm/${group}/osgm/sig_bin1.3.nii.gz -add VTA_PBP_l_r.combined.mni305_1.25mm/${group}/osgm/sig_bin1.3.nii.gz -add MPB_LPB_l_r.combined.mni305_1.25mm/${group}/osgm/sig_bin1.3.nii.gz -add LC_l_r.combined.mni305_1.25mm/${group}/osgm/sig_bin1.3.nii.gz -add VSM_l_r.combined.mni305_1.25mm/${group}/osgm/sig_bin1.3.nii.gz -add dACC_Wager.combined.mni305_1.25mm/${group}/osgm/sig_bin1.3.nii.gz -add dmIns_Kurth.combined.mni305_1.25mm/${group}/osgm/sig_bin1.3.nii.gz -add dpIns_Gianaros.combined.mni305_1.25mm/${group}/osgm/sig_bin1.3.nii.gz -add lvAIns_Wager.combined.mni305_1.25mm/${group}/osgm/sig_bin1.3.nii.gz -add mvAIns_Harper.combined.mni305_1.25mm/${group}/osgm/sig_bin1.3.nii.gz -add pgACC_Gianaros.combined.mni305_1.25mm/${group}/osgm/sig_bin1.3.nii.gz -add sgACC_Gianaros.combined.mni305_1.25mm/${group}/osgm/sig_bin1.3.nii.gz rsfmri/mni305_overlap_all_added_${group}.nii.gz 

	foreach hemi (lh rh)
		mris_calc -o rsfmri/${hemi}_overlap_all_added_${group}.nii.gz Hypothalamus.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz add VSM_l_r.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz
		mris_calc -o rsfmri/${hemi}_overlap_all_added_${group}.nii.gz rsfmri/${hemi}_overlap_all_added_${group}.nii.gz add PAG_fin.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz
		mris_calc -o rsfmri/${hemi}_overlap_all_added_${group}.nii.gz rsfmri/${hemi}_overlap_all_added_${group}.nii.gz add DR_2020.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz
		mris_calc -o rsfmri/${hemi}_overlap_all_added_${group}.nii.gz rsfmri/${hemi}_overlap_all_added_${group}.nii.gz add MPB_LPB_l_r.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz 			
		mris_calc -o rsfmri/${hemi}_overlap_all_added_${group}.nii.gz rsfmri/${hemi}_overlap_all_added_${group}.nii.gz add LC_l_r.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz
		mris_calc -o rsfmri/${hemi}_overlap_all_added_${group}.nii.gz rsfmri/${hemi}_overlap_all_added_${group}.nii.gz add MD_Thal_Wager.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz
		mris_calc -o  rsfmri/${hemi}_overlap_all_added_${group}.nii.gz rsfmri/${hemi}_overlap_all_added_${group}.nii.gz add LG_l_r.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz
		mris_calc -o  rsfmri/${hemi}_overlap_all_added_${group}.nii.gz rsfmri/${hemi}_overlap_all_added_${group}.nii.gz add rsfmri/hippo_maps/hippo_${group}_${hemi}_sig_avg_bin1.3.nii.gz
		mris_calc -o  rsfmri/${hemi}_overlap_all_added_${group}.nii.gz rsfmri/${hemi}_overlap_all_added_${group}.nii.gz add dAmy_Gianaros.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz
		mris_calc -o  rsfmri/${hemi}_overlap_all_added_${group}.nii.gz rsfmri/${hemi}_overlap_all_added_${group}.nii.gz add Accumbens.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz
		mris_calc -o  rsfmri/${hemi}_overlap_all_added_${group}.nii.gz rsfmri/${hemi}_overlap_all_added_${group}.nii.gz add SC_DCfunc.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz 
		mris_calc -o  rsfmri/${hemi}_overlap_all_added_${group}.nii.gz rsfmri/${hemi}_overlap_all_added_${group}.nii.gz add SN_l_r.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz 
		mris_calc -o  rsfmri/${hemi}_overlap_all_added_${group}.nii.gz rsfmri/${hemi}_overlap_all_added_${group}.nii.gz add VTA_PBP_l_r.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz 
		mris_calc -o  rsfmri/${hemi}_overlap_all_added_${group}.nii.gz rsfmri/${hemi}_overlap_all_added_${group}.nii.gz add dACC_Wager.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz
		mris_calc -o  rsfmri/${hemi}_overlap_all_added_${group}.nii.gz rsfmri/${hemi}_overlap_all_added_${group}.nii.gz add dmIns_Kurth.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz
		mris_calc -o  rsfmri/${hemi}_overlap_all_added_${group}.nii.gz rsfmri/${hemi}_overlap_all_added_${group}.nii.gz add dpIns_Gianaros.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz
		mris_calc -o  rsfmri/${hemi}_overlap_all_added_${group}.nii.gz rsfmri/${hemi}_overlap_all_added_${group}.nii.gz add lvAIns_Wager.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz
		mris_calc -o  rsfmri/${hemi}_overlap_all_added_${group}.nii.gz rsfmri/${hemi}_overlap_all_added_${group}.nii.gz add mvAIns_Harper.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz
		mris_calc -o  rsfmri/${hemi}_overlap_all_added_${group}.nii.gz rsfmri/${hemi}_overlap_all_added_${group}.nii.gz add pgACC_Gianaros.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz
		mris_calc -o  rsfmri/${hemi}_overlap_all_added_${group}.nii.gz rsfmri/${hemi}_overlap_all_added_${group}.nii.gz add sgACC_Gianaros.combined.${hemi}_1.25mm/${group}/osgm/sig_bin1.3.nii.gz

	end

end

foreach group (g1_n46 g2_n45)

	# INFLATE CORTICAL MAPS
	foreach hemi (lh rh)

		mri_surf2vol --identity mni152.fnirt --template $SUBJECTS_DIR/mni152.fnirt/mri/orig.mgz --hemi ${hemi} --surfval rsfmri/${hemi}_overlap_all_added_${group}.nii.gz --o rsfmri/${hemi}_overlap_all_added_${group}.vol.nii.gz --fillribbon

	end

	# MERGE doesn't work due to different dimensions; simply load lh, rh and mni305 into freeview
	#fslmaths rsfmri/lh_overlap_all_added_${group}.vol.nii.gz -add rsfmri/rh_overlap_all_added_${group}.vol.nii.gz -add rsfmri/mni305_overlap_all_added_${group}.nii.gz rsfmri/merged_all_added.nii.gz

end

