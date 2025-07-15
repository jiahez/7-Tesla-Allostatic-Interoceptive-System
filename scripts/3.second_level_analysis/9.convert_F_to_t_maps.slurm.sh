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

# set temp directory
export TMPDIR=$DATA_DIR/tmpdir

# Resolve script path
SCRIPTS_DIR=$(dirname "$MATLAB_FILE")

# Launch MATLAB
matlab -nodisplay -nosplash -nojvm -r "\
    cd('$STUDY_DIR'); \
    seeds={'sgACC','pACC','aMCC','mvAIns','vAIns','dmIns','dpIns',..\
	'mdThal','LGN','Hypothalamus','Hippocampus','dAmy','NAcc','PAG','DR','SC','SN','VTA','PBN','LC','VSM',..\
	'dmPAG','dPAG','lPAG','vlPAG','headHippo','bodyHippo','tailHippo','superficialSC','deepSC','atHT','aHT','mtpHT','sHT'};\

	hemis={'lh','rh','mni305'};\

	for i=1:length(seeds)\

		seed=seeds{i};\

		for j=1:length(hemi)\

			hemi=hemis{j};\

			F_map=MRIread(strcat(char(seed),'.${hemi}/osgm/F.nii.gz'));\
			sig_map=MRIread(strcat(char(seed),'.r${hemi}/osgm/sig.nii.gz'));\
			t_map = F_map;\
			t_map.vol=sign(sig_map.vol).*sqrt(t_map.vol);\
			MRIwrite(t_map, strcat(char(seed),'.${hemi}/osgm/t.nii.gz'));\

		end

	end
    exit;"