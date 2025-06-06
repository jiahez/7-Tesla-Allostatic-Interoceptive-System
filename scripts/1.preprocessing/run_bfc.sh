#!/bin/tcsh -f
# run-vbm

set VERSION = '$Id$';

set outdir = ();
set input = ();
set subject = ();
set LeftRightReverse = 0; 
set UseSymTemplate = 0;
set UseDartel = 1;

set MLF = ();
set monly = 0;
set tmpdir = ();
set cleanup = 1;
set LF = ();

set inputargs = ($argv);
set PrintHelp = 0;

if($#argv == 0) goto usage_exit;
set n = `echo $argv | grep -e -help | wc -l` 
if($n != 0) then
  set PrintHelp = 1;
  goto usage_exit;
endif
set n = `echo $argv | grep -e -version | wc -l` 
if($n != 0) then
  echo $VERSION
  exit 0;
endif

goto parse_args;
parse_args_return:

goto check_params;
check_params_return:

mkdir -p $outdir
if($status) exit 1;

# Get full path to output dir
pushd $outdir > /dev/null
set outdir = `pwd`;
popd > /dev/null

if($#tmpdir == 0) set tmpdir = $outdir/tmpdir.run-vbm
mkdir -p $tmpdir

if($#MLF == 0) set MLF = $outdir/run_vbm.m
rm -f $MLF

if($#LF == 0) set LF = $outdir/run-vbm.log
if($LF != /dev/null) rm -f $LF

echo "Log file for run-vbm" >> $LF
date  | tee -a $LF
echo "" | tee -a $LF
#echo "setenv SUBJECTS_DIR $SUBJECTS_DIR" | tee -a $LF
echo "cd `pwd`"  | tee -a $LF
echo $0 $inputargs | tee -a $LF
echo "" | tee -a $LF
#cat $FREESURFER_HOME/build-stamp.txt | tee -a $LF
uname -a  | tee -a $LF
echo "matlabcmd $matlabcmd" | tee -a $LF

set StartTime = `date`;
set tSecStart = `date '+%s'`;

# Convert input to nifti, make sure it is a float
#set cmd = (mri_convert $input -odt float $outdir/input.nii)
#if($LeftRightReverse) set cmd = ($cmd --left-right-reverse-pix)
#echo $cmd | tee -a $LF
#$cmd | tee -a $LF
#if($status) exit 1;
if (${input:e} == gz) then
 echo "unzipping"
 cp $input $outdir/input.nii.gz
 gunzip $outdir/input.nii.gz
else
 echo "unzipping not needed"
 cp $input $outdir/input.nii
endif

set input = $outdir/input.nii

set vbmbatch = $outdir/vbmbatch.m
rm -f $vbmbatch

#-------------------------------------------------------------
tee $vbmbatch >& /dev/null <<EOF
matlabbatch{1}.spm.tools.vbm8.estwrite.data = {'$input,1'};
matlabbatch{1}.spm.tools.vbm8.estwrite.opts.tpm = {'$TPM'};
matlabbatch{1}.spm.tools.vbm8.estwrite.opts.biasreg = 0.0001;
matlabbatch{1}.spm.tools.vbm8.estwrite.opts.biasfwhm = 60;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.bias.native = 1;
EOF

tee -a $MLF >& /dev/null <<EOF
% Matlab Version
spm8path = '$spm8path';
if(~isempty(spm8path)) addpath(spm8path); end
fprintf('%s\n',version);
fprintf('%s\n',which('spm'));
input = '$input';
monly = [$monly];
spm_defaults
global defaults
EOF

cat $vbmbatch >> $MLF

tee -a $MLF >& /dev/null <<EOF
try
  spm_jobman('initcfg');
catch
  fprintf('ERROR: running spm_jobman(initcfg)\n');
  if(~monly) quit; end
  return;
end
try
  spm_jobman('run_nogui',matlabbatch)
catch
  fprintf('ERROR: running spm_jobman(run_nogui)\n');
  if(~monly) quit; end
  return;
end
EOF

if(! $monly ) echo "quit;" >> $MLF

echo "------------------------------------------" >> $LF
cat $MLF >> $LF
echo "------------------------------------------" >> $LF


if(! $monly) then
  date | tee -a $LF
  cat $MLF | $matlabcmd -nodisplay -nojvm -nosplash | tee -a $LF
  echo "" | tee -a $LF
  date | tee -a $LF
endif

if($cleanup) rm -rf $tmpdir

set tSecEnd = `date '+%s'`;
@ tSecRun = $tSecEnd - $tSecStart;

set EndTime = `date`;
echo "Started at $StartTime" | tee -a $LF
echo "Ended   at $EndTime" | tee -a $LF
echo "VBM-Run-Time-Sec $tSecRun" | tee -a $LF

echo "run-vbm done" | tee -a $LF
echo ""

echo "moving the BFC-volume to the desired output."
mv $outdir/minput.nii $outdir.nii
echo "deleting other files..."
rm -r $outdir
echo "done"
exit 0

###############################################

############--------------##################
parse_args:
set cmdline = ($argv);
while( $#argv != 0 )

  set flag = $argv[1]; shift;
  
  switch($flag)

    #case "--s":
      #if($#argv < 1) goto arg1err;
      #set subject = $argv[1]; shift;
      #set input = $SUBJECTS_DIR/$subject/mri/rawavg.mgz
      #set outdir = $SUBJECTS_DIR/$subject/mri/vbm
      #breaksw

    #case "--s+orig":
      #if($#argv < 1) goto arg1err;
      #set subject = $argv[1]; shift;
      #set input = $SUBJECTS_DIR/$subject/mri/orig.mgz
      #set outdir = $SUBJECTS_DIR/$subject/mri/vbm
      #breaksw

    case "--i":
      if($#argv < 1) goto arg1err;
      set input = $argv[1]; shift;
      breaksw

    case "--o":
      if($#argv < 1) goto arg1err;
      set outdir = $argv[1]; shift;
      breaksw

    case "--xhemi":
    case "--lrrev":
    case "--left-right-reverse":
      set LeftRightReverse = 1;
      set UseSymTemplate = 1;
      breaksw

    case "--monly":
      if($#argv < 1) goto arg1err;
      set monly = 1;
      set MLF = $argv[1]; shift;
      set cleanup = 0;
      breaksw

    case "--matlab":
      if($#argv < 1) goto arg1err;
      set matlabcmd = $argv[1]; shift;
      breaksw

    case "--spm8":
      if($#argv < 1) goto arg1err;
      set spm8path = $argv[1]; shift;
      breaksw

    case "--sym":
      set UseSymTemplate = 1;
      set UseDartel = 0;
      breaksw

    case "--no-sym":
      set UseSymTemplate = 0;
      breaksw

    case "--log":
      if($#argv < 1) goto arg1err;
      set LF = $argv[1]; shift;
      breaksw

    case "--nolog":
    case "--no-log":
      set LF = /dev/null
      breaksw

    case "--tmpdir":
      if($#argv < 1) goto arg1err;
      set tmpdir = $argv[1]; shift;
      set cleanup = 0;
      breaksw

    case "--nocleanup":
      set cleanup = 0;
      breaksw

    case "--cleanup":
      set cleanup = 1;
      breaksw

    case "--debug":
      set verbose = 1;
      set echo = 1;
      breaksw

    default:
      echo ERROR: Flag $flag unrecognized. 
      echo $cmdline
      exit 1
      breaksw
  endsw

end

goto parse_args_return;
############--------------##################

############--------------##################
check_params:

if($#input == 0) then
  echo "ERROR: must spec input"
  exit 1;
endif
if(! -e $input) then
  echo "ERROR: cannot find $input"
  exit 1;
endif
if($#outdir == 0) then
  echo "ERROR: must spec outdir"
  exit 1;
endif
if($LeftRightReverse) set outdir = $outdir-xhemi
if($UseSymTemplate) set outdir = $outdir-sym
if(! -e $matlabcmd) then
  echo "ERROR: cannot find matlab command $matlabcmd"
  echo "Set with --matlab option"
  exit 1;
endif
if(! -e $spm8path) then
  echo "ERROR: cannot find spm8 path $spm8path"
  echo "Set with --spm8 option"
  exit 1;
endif
if($#matlabcmd == 0) then
  set matlabcmd = `which matlab`;
endif
if(! $UseSymTemplate) then
  set TPM = $spm8path/toolbox/Seg/TPM.nii
else
  set TPM = /space/crash/1/users/greve/vbm-templates/TPM.sym.nii
  #set TPM = /space/crash/1/users/greve/vbm-templates/TPM_symmetric.nii
endif
if(! -e $TPM) then
  echo "ERROR: cannot find $TPM"
  exit 1;
endif

goto check_params_return;
############--------------##################

############--------------##################
arg1err:
  echo "ERROR: flag $flag requires one argument"
  exit 1
############--------------##################
arg2err:
  echo "ERROR: flag $flag requires two arguments"
  exit 1
############--------------##################

############--------------##################
usage_exit:
  echo ""
  echo "run-vbm"
  echo "  --i input"
  echo "  --o outputdir"
  echo "  --s subject : uses rawavg as input, mri/vbm as output"
  echo "  --s+orig subject : uses orig as input, mri/vbm as output"
  echo "  --sym : use symmetric template"
  echo "  --xhemi : left-right reverse (implies --sym)"
  echo ""

  if(! $PrintHelp) exit 1;
  echo $VERSION
  cat $0 | awk 'BEGIN{prt=0}{if(prt) print $0; if($1 == "BEGINHELP") prt = 1 }'
exit 1;

#---- Everything below here is printed out as part of help -----#
BEGINHELP

View on subject 'dartel'

Native Space:
input.nii   Source data
p0input.nii PVE
p1input.nii GM
p2input.nii WM
p3input.nii CSF
minput.nii  Bias corrected

Dartel Warped Space (121 x 145 x 121, 1.5mm)
wmrinput.nii  Anatomy
wrp0input.nii PVE
wrp1input.nii GM
wrp2input.nii WM
wrp3input.nii CSF
m0wrp1input.nii GM,  Modulated Non-linear only
m0wrp2input.nii WM,  Modulated Non-linear only
m0wrp3input.nii CSF, Modulated Non-linear only
jac_wrp1input.nii jacobian warp field
rp[0123]input.nii -- diff with wrp[0123]input.nii ????

pinput_seg8.txt - text file with segmentation volumes

SPM-VBM (version 5 and after) performs segmentation and registration
simultaneously resulting in only one warp field.

Dont know:
y_rinput.nii
iy_rinput.nii

# To get a segmentation
mri_concat p[1-3]*.nii --o seg.nii --max-index
mri_mask seg.nii p0input.nii seg.nii

# By Doug Greve
