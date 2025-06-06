# DO NOT RUN eta2 SCRIPT IN FS DEV VERSION!! WILL RUN INTO TEMPNAME ERROR
# run this with freesurfer 5.3.0 (6.0.0 has a different load_nifti function that will break)

source /usr/local/freesurfer/nmr-stable53-env
cd /vast/iaslab/FSMAP/

# SECTION A: CORTICAL MAPS OF CORTICAL SEEDS
rm scripts/revision_scripts/kmeans_clustering/lh_corticalSeed.lst
rm scripts/revision_scripts/kmeans_clustering/rh_corticalSeed.lst

foreach seed (dpIns_Gianaros pgACC_Gianaros dACC_Wager dmIns_Kurth sgACC_Gianaros mvAIns_Harper lvAIns_Wager)

	# These group maps give highly similar eta2 estimates
	#echo $seed.combined.lh_1.25mm/n90/osgm/sig.nii.gz >> scripts/revision_scripts/kmeans_clustering/lh_corticalSeed.lst
	#echo $seed.combined.rh_1.25mm/n90/osgm/sig.nii.gz >> scripts/revision_scripts/kmeans_clustering/rh_corticalSeed.lst

	echo $seed.combined.lh_1.25mm/perm_test/5fold/sum_sig_bin1.3.nii.gz >> scripts/revision_scripts/kmeans_clustering/lh_corticalSeed.lst
	echo $seed.combined.rh_1.25mm/perm_test/5fold/sum_sig_bin1.3.nii.gz >> scripts/revision_scripts/kmeans_clustering/rh_corticalSeed.lst

end

~/mhollen/eta2 -L scripts/revision_scripts/kmeans_clustering/lh_corticalSeed.lst -R scripts/revision_scripts/kmeans_clustering/rh_corticalSeed.lst -o scripts/revision_scripts/kmeans_clustering/eta2_lhrh_corticalSeed -m -M

# SECTION B: CORTICAL MAPS OF SUBCORTICAL SEEDS
rm scripts/revision_scripts/kmeans_clustering/lh_subcorticalSeed.lst
rm scripts/revision_scripts/kmeans_clustering/rh_subcorticalSeed.lst

foreach seed (dAmy_Gianaros DR_2020 Hypothalamus LC_l_r LG_l_r MD_Thal_Wager MPB_LPB_l_r Accumbens PAG_fin SC_DCfunc SN_l_r VTA_PBP_l_r VSM_l_r)

	echo $seed.combined.lh_1.25mm/perm_test/5fold/sum_sig_bin1.3.nii.gz >> scripts/revision_scripts/kmeans_clustering/lh_subcorticalSeed.lst
	echo $seed.combined.rh_1.25mm/perm_test/5fold/sum_sig_bin1.3.nii.gz >> scripts/revision_scripts/kmeans_clustering/rh_subcorticalSeed.lst
	
end

echo rsfmri/hippo_maps/5fold/hippo_lh_sig_bin1.3_avg.nii.gz >> scripts/revision_scripts/kmeans_clustering/lh_subcorticalSeed.lst
echo rsfmri/hippo_maps/5fold/hippo_rh_sig_bin1.3_avg.nii.gz >> scripts/revision_scripts/kmeans_clustering/rh_subcorticalSeed.lst

~/mhollen/eta2 -L scripts/revision_scripts/kmeans_clustering/lh_subcorticalSeed.lst -R scripts/revision_scripts/kmeans_clustering/rh_subcorticalSeed.lst -o scripts/revision_scripts/kmeans_clustering/eta2_lhrh_subcorticalSeed -m -M

# SECTION C: SUBCORTICAL MAPS OF SUBCORTICAL SEEDS (run on icepuff if not enough memory)
rm scripts/revision_scripts/kmeans_clustering/mni305_subcorticalSeed.lst

foreach seed (dAmy_Gianaros DR_2020 Hypothalamus LC_l_r LG_l_r MD_Thal_Wager MPB_LPB_l_r Accumbens PAG_fin SC_DCfunc SN_l_r VTA_PBP_l_r VSM_l_r)


	echo $seed.combined.mni305_1.25mm/perm_test/5fold/sum_sig_bin1.3.nii.gz >> scripts/revision_scripts/kmeans_clustering/mni305_subcorticalSeed.lst

end

echo rsfmri/hippo_maps/5fold/hippo_mni305_sig_bin1.3_avg.nii.gz >> scripts/revision_scripts/kmeans_clustering/mni305_subcorticalSeed.lst

~/mhollen/eta2 -I scripts/revision_scripts/kmeans_clustering/mni305_subcorticalSeed.lst -o scripts/revision_scripts/kmeans_clustering/eta2_mni305_subcorticalSeed -m -M 
# didn't save .mat file; manually created .mat using .csv data

