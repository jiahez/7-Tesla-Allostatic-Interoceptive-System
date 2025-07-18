#!/bin/bash
#SBATCH --job-name=j_firstlevel
#SBATCH --partition=short
#SBATCH --time=48:00:00
#SBATCH -n 1
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=4G
#SBATCH --output=logs/%x.%A-%a.out
#SBATCH --error=logs/%x.%A-%a.err

#############################################
freesurfer_version="X.X.X"
export FREESURFER_HOME=/PATH/TO/FREESURFER
source "$FREESURFER_HOME/SetUpFreeSurfer.sh"
TR=2.34
#############################################

# set Freesurfer subjects directory
export SUBJECTS_DIR="$STUDY_DIR/derivatives/Freesurfer_${freesurfer_version}"

for seed in sgACC pACC aMCC mvAIns lvAIns dmIns dpIns \
mdThal LGN Hypothalamus Hippocampus dAmy NAcc PAG DR SC SN VTA PBN LC VSM \
dmPAG dPAG lPAG vlPAG headHippo bodyHippo tailHippo superficialSC deepSC atHT aHT mtpHT sHT; do
	for hemi in lh rh mni305; do
		fscalc \
			${STUDY_DIR}/${seed}.${hemi}/bootstrapping/sum_sig_bin1.3_bin950.nii.gz \
			mul ${STUDY_DIR}/${seed}.${hemi}/osgm/t.nii.gz \
			-o ${STUDY_DIR}/${seed}.${hemi}/osgm/t_masked.nii.gz
	done
done

for hemi in lh rh mni305; do
	fscalc \
		-o ${STUDY_DIR}/scripts/revision_scripts/hippo_maps/5fold/hippo_t_masked.nii.gz \
		${STUDY_DIR}/hippo_H.combined.rh_1.25mm/n90/osgm/t.nii.gz \
		add ${STUDY_DIR}/hippo_B.combined.rh_1.25mm/n90/osgm/t.nii.gz \
		add ${STUDY_DIR}/hippo_T.combined.rh_1.25mm/n90/osgm/t.nii.gz \
		div 3 \
		mul ${STUDY_DIR}/scripts/revision_scripts/hippo_maps/5fold/hippo_rh_sig_bin1.3_avg_bin950.nii.gz 
done