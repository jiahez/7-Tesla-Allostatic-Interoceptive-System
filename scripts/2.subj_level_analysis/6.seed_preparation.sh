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

# Extract subject ID from participants.tsv
subj=$(sed -n -E "$((SLURM_ARRAY_TASK_ID + 1))s/sub-(\S*)\>.*/\1/p" "$STUDY_DIR/rawdata/participants.tsv")

echo "Processing subject: $subj"

#source /usr/local/freesurfer/nmr-dev-env
#setenv SUBJECTS_DIR /autofs/cluster/iaslab/FSMAP/recon/

# cortical seeds
for seed in sgACC pACC aMCC mvAIns lvAIns dmIns dpIns; do

    mri_binarize \
        --i "$STUDY_DIR/scripts/ROIs/${seed}.rh.sm04.mgh" \
        --min 1e-9 \
        --o "$STUDY_DIR/scripts/ROIs/${seed}.rh.sm04.bin.mgh"

    mri_surf2vol \
        --so "$SUBJECTS_DIR/mni152.fnirt/surf/rh.pial" \
        "$STUDY_DIR/scripts/ROIs/${seed}.rh.sm04.bin.mgh" \
        --subject mni152.fnirt \
        --o "$STUDY_DIR/scripts/ROIs/${seed}.rh.sm04.vol.nii.gz"

    fslroi \
        "$STUDY_DIR/scripts/ROIs/${seed}.rh.sm04.vol.nii.gz" \
        "$STUDY_DIR/scripts/ROIs/${seed}.rh.sm04.vol_crop.nii.gz" \
        51.5 151 51.5 151 34 186

    mri_convert \
        "$STUDY_DIR/scripts/ROIs/${seed}.rh.sm04.vol_crop.nii.gz" \
        -oc -1.5 -16 9.5 \
        "$STUDY_DIR/scripts/ROIs/${seed}.rh.sm04.vol_crop_oc.nii.gz"

	cp "$STUDY_DIR/scripts/ROIs/${seed}.rh.sm04.vol_crop_oc.nii.gz" "$STUDY_DIR/scripts/ROIs/${seed}.final.nii.gz"

done


# subcortical seeds
for seed in mdThal LGN Hypothalamus Hippocampus dAmy NAcc PAG DR SC SN VTA PBN LC VSM dmPAG dPAG lPAG vlPAG headHippo bodyHippo tailHippo superficialSC deepSC atHT aHT mtpHT sHT; do

    fslswapdim \
        "$STUDY_DIR/scripts/ROIs/ROIs/${seed}.nii.gz" \
        x -z y \
        "$STUDY_DIR/scripts/ROIs/ROIs/${seed}_LIA.nii.gz"

    fslroi \
        "$STUDY_DIR/scripts/ROIs/ROIs/${seed}_LIA.nii.gz" \
        "$STUDY_DIR/scripts/ROIs/ROIs/${seed}_LIA_crop.nii.gz" \
        15.5 151 33.5 151 -2 186

    mri_convert \
        "$STUDY_DIR/scripts/ROIs/ROIs/${seed}_LIA_crop.nii.gz" \
        -oc -1.5 -16 9.5 \
        "$STUDY_DIR/scripts/ROIs/ROIs/${seed}_LIA_crop_oc.nii.gz"

	cp "$STUDY_DIR/scripts/ROIs/${seed}_LIA_crop_oc.nii.gz" "$STUDY_DIR/scripts/ROIs/${seed}.final.nii.gz"

done