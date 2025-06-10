# USAGE
# customize Line 15
# sh run_preproc.sh sbatch_file_for_preproc

# RUN THE FOLLOWING SEQUENTIALLY
# 1. preprocess anatomical (customize Line 13)
#       sh run_preproc.sh 1.preproc_anat.slurm
# 2. reorient functionals (customize Lines 14-15)
#       sh run_preproc.sh 2.reorient_func.slurm
# 3. 


#############################################
# Please set STUDY_DIR in this line
export STUDY_STUDY=/PATH/TO/STUDY/DIRECTORY
#############################################

which_sbatch=$1
sbatch --array=1-$(( $( wc -l $STUDY_STUDY/rawdata/participants.tsv | cut -f1 -d' ' ) - 1 )) ${which_sbatch} ${STUDY_DIR}

