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

#cd /cluster/iaslab/FSMAP/
#source /usr/local/freesurfer/nmr-stable60-env
#setenv TMPDIR /cluster/iaslab/FSMAP/tmpdir
#setenv SUBJECTS_DIR /cluster/iaslab/FSMAP/recon
#setenv PATH /cluster/matlab/R2019b/bin:$PATH


for seed in sgACC pACC aMCC mvAIns lvAIns dmIns dpIns mdThal LGN Hypothalamus Hippocampus dAmy NAcc PAG DR SC SN VTA PBN LC VSM dmPAG dPAG lPAG vlPAG headHippo bodyHippo tailHippo superficialSC deepSC atHT aHT mtpHT sHT; do

    for hemi in lh rh mni305; do

        mkanalysis-sess \
            -analysis "$STUDY_DIR/analysis/${seed}.combined.lh" \
            -surface mni152.fnirt lh \
            -fwhm 0 \
            -notask \
            -taskreg "${seed}.dat" 1 \
            -fsd rest \
            -TR 1 \
            -per-run \
            -overwrite

        mkanalysis-sess \
            -analysis "$STUDY_DIR/analysis/${seed}.combined.rh" \
            -surface mni152.fnirt rh \
            -fwhm 0 \
            -notask \
            -taskreg "${seed}.dat" 1 \
            -fsd rest \
            -TR 1 \
            -per-run \
            -overwrite

        fslmeants \
            -i "$STUDY_DIR/derivatives/$subj/rest/001/fmcpr.sm0.mni305.1mm.nii.gz" \
            -m "$STUDY_DIR/scripts/ROIs/${seed}.final.nii.gz" \
            -o "$STUDY_DIR/derivatives/$subj/rest/001/${seed}.dat"

    done

    for hemi in lh rh mni305; do
        selxavg3-sess \
			-s "$subj" \
			-a "$STUDY_DIR/analysis/${seed}.combined.$hemi" \
			-no-preproc \
			-overwrite
    done

done