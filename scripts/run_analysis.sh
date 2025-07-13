# USAGE
# customize Line 15
# sh run_analysis.sh sbatch_file_for_preproc

# RUN THE FOLLOWING SEQUENTIALLY
# 1. preprocess anatomical (customize Line 13)
#       sh run_analysis.sh 1.anat_preproc.slurm.sh
# 2. reorient functionals (customize Lines 14-15)
#       sh run_analysis.sh 2.func_reorient.slurm.sh
# 3. run slice timing correction, coregistration, and motion correction (customize Lines 12)
#       sh run_analysis.sh 3.func_stc_coreg_mc.slurm.sh
# 4. run nuisance regression (customize Lines 12)
#       sh run_analysis.sh 4.func_nuisance_reg.slurm.sh
# 5. run banpass filtering, normalization and smoothing (customize Lines 12)
#       sh run_analysis.sh 5.func_bpfiltering_normalization_smoothing.slurm.sh
# 6. prepare seeds (customize Lines 12)
#       sh run_analysis.sh 6.seed_preparation.slurm.sh
# 5. run banpass filtering, normalization and smoothing (customize Lines 12)
#       sh run_analysis.sh 5.func_bpfiltering_normalization_smoothing.slurm.sh




#############################################
# Please set STUDY_DIR in this line
export STUDY_STUDY=/PATH/TO/STUDY/DIRECTORY
#############################################

which_sbatch=$1
sbatch --array=1-$(( $( wc -l $STUDY_STUDY/rawdata/participants.tsv | cut -f1 -d' ' ) - 1 )) ${which_sbatch} ${STUDY_DIR}

