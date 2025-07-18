Analysis codes and main connectivity map outputs to accompany manuscript 

**Cortical and subcortical mapping of the allostatic-interoceptive system in the human brain using 7 Tesla fMRI**

Jiahe Zhang1,2, Danlei Chen1, Philip Deming1, Tara Srirangarajan3, Jordan E. Theriault1,4,5, Philip A. Kragel6, Ludger Hartley1, Kent M. Lee1, Kieran McVeigh1, Tor D. Wager7, Lawrence L. Wald5, Ajay B. Satpute1,5, Karen S. Quigley1, Susan Whitfield-Gabrieli1,2, Lisa Feldman Barrett1,2,5* & Marta Bianciardi5,8*

1 Department of Psychology, Northeastern University, Boston, MA 02115
2 Department of Psychiatry, Massachusetts General Hospital, Boston, MA 02139
3 Department of Psychology, Stanford University, Stanford, CA 94305
4 Department of Biology, Northeastern University, Boston, MA 02115
5 Department of Radiology, Athinoula A. Martinos Center for Biomedical Imaging, Massachusetts General Hospital, Boston, MA 02139
6 Department of Psychology, Emory University, Atlanta, GA 30322 
7 Department of Psychological and Brain Sciences, Dartmouth College, Hanover, NH 03755
8 Division of Sleep Medicine, Harvard University, Boston, MA

*These authors jointly supervised this work.

Preprint is available: https://doi.org/10.1101/2023.07.20.548178

Raw and preprocessed data are available: https://openneuro.org/datasets/ds005747
- Raw data are in BIDS format
- Preprocessed data (in derivatives/preprocessed) are outputs of step 1.preprocessing

Brief description of outputs
1. connectivity maps
    a. bootstrapped maps
    b. t maps
2. overlap maps
Viewing instructions have details on how to visualize surface and volume maps. 


Brief description of scripts
1. preprocessing: 
2. first_level: 
3. second_level:
4. bootstrapping:
5. kmeans_clustering:

Scripts were tested and run on Linux system equipped with SLURM computing. Prerequisites for running analysis scripts include:
1. MATALB
2. SPM12
3. FSL
4. Freesurfer 6.0.0 or later, and Freesurfer dev
5. AFNI
6. ANTS
7. Brainstem Navigator: save folder to $STUDY_DIR/scripts

To replicate the results in the manuscript using the scripts, please 
1. Download raw BIDS data (sub-XXX) and participants.tsv into $STUDY_DIR/rawdata
2. Download scripts into $STUDY_DIR/scripts
3. Download mni152.fnirt folder into $SUBJECTS_DIR