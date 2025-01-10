#--------------------------------------------
#@# MotionCor Mon Jun 22 12:41:46 EDT 2009

 cp /autofs/space/greve_001/users/greve/subjects/mni152.fnirt/mri/orig/001.mgz /autofs/space/greve_001/users/greve/subjects/mni152.fnirt/mri/rawavg.mgz 


 mri_convert /autofs/space/greve_001/users/greve/subjects/mni152.fnirt/mri/rawavg.mgz /autofs/space/greve_001/users/greve/subjects/mni152.fnirt/mri/orig.mgz --conform 


 mri_add_xform_to_header -c /autofs/space/greve_001/users/greve/subjects/mni152.fnirt/mri/transforms/talairach.xfm /autofs/space/greve_001/users/greve/subjects/mni152.fnirt/mri/orig.mgz /autofs/space/greve_001/users/greve/subjects/mni152.fnirt/mri/orig.mgz 

#--------------------------------------------
#@# Nu Intensity Correction Mon Jun 22 12:42:05 EDT 2009

 mri_nu_correct.mni --i orig.mgz --o nu.mgz --n 2 

#--------------------------------------------
#@# Talairach Mon Jun 22 12:43:24 EDT 2009

 talairach_avi --i nu.mgz --xfm transforms/talairach.auto.xfm 


 cp transforms/talairach.auto.xfm transforms/talairach.xfm 

#--------------------------------------------
#@# Talairach Failure Detection Mon Jun 22 12:45:09 EDT 2009

 talairach_afd -T 0.005 -xfm transforms/talairach.xfm 


 awk -f /usr/local/freesurfer/dev/bin/extract_talairach_avi_QA.awk /autofs/space/greve_001/users/greve/subjects/mni152.fnirt/mri/transforms/talairach_avi.log 

#--------------------------------------------
#@# Intensity Normalization Mon Jun 22 12:45:10 EDT 2009

 mri_normalize -g 1 nu.mgz T1.mgz 

#--------------------------------------------
#@# Skull Stripping Mon Jun 22 12:50:46 EDT 2009

 mri_em_register -skull nu.mgz /usr/local/freesurfer/dev/average/RB_all_withskull_2008-03-26.gca transforms/talairach_with_skull.lta 


 mri_watershed -T1 -brain_atlas /usr/local/freesurfer/dev/average/RB_all_withskull_2008-03-26.gca transforms/talairach_with_skull.lta T1.mgz brainmask.auto.mgz 


 cp brainmask.auto.mgz brainmask.mgz 

#-------------------------------------
#@# EM Registration Mon Jun 22 13:37:59 EDT 2009

 mri_em_register -mask brainmask.mgz nu.mgz /usr/local/freesurfer/dev/average/RB_all_2008-03-26.gca transforms/talairach.lta 

#--------------------------------------
#@# CA Normalize Mon Jun 22 14:28:36 EDT 2009

 mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /usr/local/freesurfer/dev/average/RB_all_2008-03-26.gca transforms/talairach.lta norm.mgz 

#--------------------------------------
#@# CA Reg Mon Jun 22 14:32:26 EDT 2009

 mri_ca_register -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /usr/local/freesurfer/dev/average/RB_all_2008-03-26.gca transforms/talairach.m3z 

#--------------------------------------
#@# CA Reg Inv Tue Jun 23 00:49:30 EDT 2009

 mri_ca_register -invert-and-save transforms/talairach.m3z 

#--------------------------------------
#@# Remove Neck Tue Jun 23 00:51:30 EDT 2009

 mri_remove_neck -radius 25 nu.mgz transforms/talairach.m3z /usr/local/freesurfer/dev/average/RB_all_2008-03-26.gca nu_noneck.mgz 

#--------------------------------------
#@# SkullLTA Tue Jun 23 00:54:05 EDT 2009

 mri_em_register -skull -t transforms/talairach.lta nu_noneck.mgz /usr/local/freesurfer/dev/average/RB_all_withskull_2008-03-26.gca transforms/talairach_with_skull.lta 

#--------------------------------------
#@# SubCort Seg Tue Jun 23 01:50:30 EDT 2009

 mri_ca_label -align -nobigventricles norm.mgz transforms/talairach.m3z /usr/local/freesurfer/dev/average/RB_all_2008-03-26.gca aseg.auto_noCCseg.mgz 


 mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz mni152.fnirt 

#--------------------------------------
#@# Merge ASeg Tue Jun 23 02:42:23 EDT 2009

 cp aseg.auto.mgz aseg.mgz 

#--------------------------------------------
#@# Intensity Normalization2 Tue Jun 23 02:42:23 EDT 2009

 mri_normalize -aseg aseg.mgz -mask brainmask.mgz norm.mgz brain.mgz 

#--------------------------------------------
#@# Mask BFS Tue Jun 23 02:50:48 EDT 2009

 mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz 

#--------------------------------------------
#@# WM Segmentation Tue Jun 23 02:50:55 EDT 2009

 mri_segment brain.mgz wm.seg.mgz 


 mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.mgz wm.asegedit.mgz 


 mri_pretess wm.asegedit.mgz wm norm.mgz wm.mgz 

#--------------------------------------------
#@# Fill Tue Jun 23 02:57:20 EDT 2009

 mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.auto_noCCseg.mgz wm.mgz filled.mgz 

#--------------------------------------------
#@# Tessellate lh Tue Jun 23 02:59:18 EDT 2009

 mri_pretess ../mri/filled.mgz 255 ../mri/norm.mgz ../mri/filled-pretess255.mgz 


 mri_tessellate ../mri/filled-pretess255.mgz 255 ../surf/lh.orig.nofix 


 rm -f ../mri/filled-pretess255.mgz 


 mris_extract_main_component ../surf/lh.orig.nofix ../surf/lh.orig.nofix 

#--------------------------------------------
#@# Smooth1 lh Tue Jun 23 02:59:42 EDT 2009

 mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix 

#--------------------------------------------
#@# Inflation1 lh Tue Jun 23 02:59:51 EDT 2009

 mris_inflate -no-save-sulc ../surf/lh.smoothwm.nofix ../surf/lh.inflated.nofix 

#--------------------------------------------
#@# QSphere lh Tue Jun 23 03:01:29 EDT 2009

 mris_sphere -q -seed 1234 ../surf/lh.inflated.nofix ../surf/lh.qsphere.nofix 

#--------------------------------------------
#@# Fix Topology lh Tue Jun 23 03:14:13 EDT 2009

 cp ../surf/lh.orig.nofix ../surf/lh.orig 


 cp ../surf/lh.inflated.nofix ../surf/lh.inflated 


 mris_fix_topology -mgz -sphere qsphere.nofix -ga -seed 1234 mni152.fnirt lh 


 mris_euler_number ../surf/lh.orig 


 mris_remove_intersection ../surf/lh.orig ../surf/lh.orig 


 rm ../surf/lh.inflated 

#--------------------------------------------
#@# Make Final Surf lh Tue Jun 23 03:59:20 EDT 2009

 mris_make_surfaces -noaparc -mgz -T1 brain.finalsurfs mni152.fnirt lh 

#--------------------------------------------
#@# Surf Volume lh Tue Jun 23 05:17:18 EDT 2009

 mris_calc -o lh.area.mid lh.area add lh.area.pial 


 mris_calc -o lh.area.mid lh.area.mid div 2 


 mris_calc -o lh.volume lh.area.mid mul lh.thickness 

#--------------------------------------------
#@# Smooth2 lh Tue Jun 23 05:17:19 EDT 2009

 mris_smooth -n 3 -nw -seed 1234 ../surf/lh.white ../surf/lh.smoothwm 

#--------------------------------------------
#@# Inflation2 lh Tue Jun 23 05:17:27 EDT 2009

 mris_inflate ../surf/lh.smoothwm ../surf/lh.inflated 


 mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 ../surf/lh.inflated 


#-----------------------------------------
#@# Curvature Stats lh Tue Jun 23 05:21:48 EDT 2009

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm mni152.fnirt lh curv sulc 

#--------------------------------------------
#@# Sphere lh Tue Jun 23 05:22:01 EDT 2009

 mris_sphere -seed 1234 ../surf/lh.inflated ../surf/lh.sphere 

#--------------------------------------------
#@# Surf Reg lh Tue Jun 23 08:43:40 EDT 2009

 mris_register -curv ../surf/lh.sphere /usr/local/freesurfer/dev/average/lh.average.curvature.filled.buckner40.tif ../surf/lh.sphere.reg 

#--------------------------------------------
#@# Jacobian white lh Tue Jun 23 10:35:31 EDT 2009

 mris_jacobian ../surf/lh.white ../surf/lh.sphere.reg ../surf/lh.jacobian_white 

#--------------------------------------------
#@# AvgCurv lh Tue Jun 23 10:35:36 EDT 2009

 mrisp_paint -a 5 /usr/local/freesurfer/dev/average/lh.average.curvature.filled.buckner40.tif#6 ../surf/lh.sphere.reg ../surf/lh.avg_curv 

#-----------------------------------------
#@# Cortical Parc lh Tue Jun 23 10:35:40 EDT 2009

 mris_ca_label -aseg ../mri/aseg.mgz -seed 1234 mni152.fnirt lh ../surf/lh.sphere.reg /usr/local/freesurfer/dev/average/lh.curvature.buckner40.filled.desikan_killiany.2009-03-04.gcs ../label/lh.aparc.annot 

#-----------------------------------------
#@# Parcellation Stats lh Tue Jun 23 10:36:29 EDT 2009

 mris_anatomical_stats -mgz -f ../stats/lh.aparc.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab mni152.fnirt lh 

#-----------------------------------------
#@# Cortical Parc 2 lh Tue Jun 23 10:36:43 EDT 2009

 mris_ca_label -aseg ../mri/aseg.mgz -seed 1234 mni152.fnirt lh ../surf/lh.sphere.reg /usr/local/freesurfer/dev/average/lh.atlas2005_simple.gcs ../label/lh.aparc.a2005s.annot 

#-----------------------------------------
#@# Parcellation Stats 2 lh Tue Jun 23 10:37:46 EDT 2009

 mris_anatomical_stats -mgz -f ../stats/lh.aparc.a2005s.stats -b -a ../label/lh.aparc.a2005s.annot -c ../label/aparc.annot.a2005s.ctab mni152.fnirt lh 

#--------------------------------------------
#@# Tessellate rh Tue Jun 23 10:38:02 EDT 2009

 mri_pretess ../mri/filled.mgz 127 ../mri/norm.mgz ../mri/filled-pretess127.mgz 


 mri_tessellate ../mri/filled-pretess127.mgz 127 ../surf/rh.orig.nofix 


 rm -f ../mri/filled-pretess127.mgz 


 mris_extract_main_component ../surf/rh.orig.nofix ../surf/rh.orig.nofix 

#--------------------------------------------
#@# Smooth1 rh Tue Jun 23 10:38:27 EDT 2009

 mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix 

#--------------------------------------------
#@# Inflation1 rh Tue Jun 23 10:38:36 EDT 2009

 mris_inflate -no-save-sulc ../surf/rh.smoothwm.nofix ../surf/rh.inflated.nofix 

#--------------------------------------------
#@# QSphere rh Tue Jun 23 10:40:31 EDT 2009

 mris_sphere -q -seed 1234 ../surf/rh.inflated.nofix ../surf/rh.qsphere.nofix 

#--------------------------------------------
#@# Fix Topology rh Tue Jun 23 10:51:48 EDT 2009

 cp ../surf/rh.orig.nofix ../surf/rh.orig 


 cp ../surf/rh.inflated.nofix ../surf/rh.inflated 


 mris_fix_topology -mgz -sphere qsphere.nofix -ga -seed 1234 mni152.fnirt rh 


 mris_euler_number ../surf/rh.orig 


 mris_remove_intersection ../surf/rh.orig ../surf/rh.orig 


 rm ../surf/rh.inflated 

#--------------------------------------------
#@# Make Final Surf rh Tue Jun 23 11:52:01 EDT 2009

 mris_make_surfaces -noaparc -mgz -T1 brain.finalsurfs mni152.fnirt rh 

#--------------------------------------------
#@# Surf Volume rh Tue Jun 23 13:10:38 EDT 2009

 mris_calc -o rh.area.mid rh.area add rh.area.pial 


 mris_calc -o rh.area.mid rh.area.mid div 2 


 mris_calc -o rh.volume rh.area.mid mul rh.thickness 

#--------------------------------------------
#@# Smooth2 rh Tue Jun 23 13:10:39 EDT 2009

 mris_smooth -n 3 -nw -seed 1234 ../surf/rh.white ../surf/rh.smoothwm 

#--------------------------------------------
#@# Inflation2 rh Tue Jun 23 13:10:47 EDT 2009

 mris_inflate ../surf/rh.smoothwm ../surf/rh.inflated 


 mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 ../surf/rh.inflated 


#-----------------------------------------
#@# Curvature Stats rh Tue Jun 23 13:15:19 EDT 2009

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm mni152.fnirt rh curv sulc 

#--------------------------------------------
#@# Sphere rh Tue Jun 23 13:15:32 EDT 2009

 mris_sphere -seed 1234 ../surf/rh.inflated ../surf/rh.sphere 

#--------------------------------------------
#@# Surf Reg rh Tue Jun 23 16:07:12 EDT 2009

 mris_register -curv ../surf/rh.sphere /usr/local/freesurfer/dev/average/rh.average.curvature.filled.buckner40.tif ../surf/rh.sphere.reg 

#--------------------------------------------
#@# Jacobian white rh Tue Jun 23 17:57:15 EDT 2009

 mris_jacobian ../surf/rh.white ../surf/rh.sphere.reg ../surf/rh.jacobian_white 

#--------------------------------------------
#@# AvgCurv rh Tue Jun 23 17:57:19 EDT 2009

 mrisp_paint -a 5 /usr/local/freesurfer/dev/average/rh.average.curvature.filled.buckner40.tif#6 ../surf/rh.sphere.reg ../surf/rh.avg_curv 

#-----------------------------------------
#@# Cortical Parc rh Tue Jun 23 17:57:23 EDT 2009

 mris_ca_label -aseg ../mri/aseg.mgz -seed 1234 mni152.fnirt rh ../surf/rh.sphere.reg /usr/local/freesurfer/dev/average/rh.curvature.buckner40.filled.desikan_killiany.2009-03-04.gcs ../label/rh.aparc.annot 

#-----------------------------------------
#@# Parcellation Stats rh Tue Jun 23 17:58:15 EDT 2009

 mris_anatomical_stats -mgz -f ../stats/rh.aparc.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab mni152.fnirt rh 

#-----------------------------------------
#@# Cortical Parc 2 rh Tue Jun 23 17:58:29 EDT 2009

 mris_ca_label -aseg ../mri/aseg.mgz -seed 1234 mni152.fnirt rh ../surf/rh.sphere.reg /usr/local/freesurfer/dev/average/rh.atlas2005_simple.gcs ../label/rh.aparc.a2005s.annot 

#-----------------------------------------
#@# Parcellation Stats 2 rh Tue Jun 23 17:59:34 EDT 2009

 mris_anatomical_stats -mgz -f ../stats/rh.aparc.a2005s.stats -b -a ../label/rh.aparc.a2005s.annot -c ../label/aparc.annot.a2005s.ctab mni152.fnirt rh 

#--------------------------------------------
#@# ASeg Stats Tue Jun 23 17:59:50 EDT 2009

 mri_segstats --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --excludeid 0 --brain-vol-from-seg --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --subject mni152.fnirt --surf-wm-vol --ctab /usr/local/freesurfer/dev/ASegStatsLUT.txt 

#--------------------------------------------
#@# Cortical ribbon mask Tue Jun 23 18:25:06 EDT 2009

 mris_volmask --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon --save_distance mni152.fnirt 

#-----------------------------------------
#@# AParc-to-ASeg Tue Jun 23 18:43:22 EDT 2009

 mri_aparc2aseg --s mni152.fnirt --volmask 


 mri_aparc2aseg --s mni152.fnirt --volmask --a2005s 

#-----------------------------------------
#@# WMParc Tue Jun 23 18:51:33 EDT 2009

 mri_aparc2aseg --s mni152.fnirt --labelwm --hypo-as-wm --rip-unknown --volmask --o mri/wmparc.mgz --ctxseg aparc+aseg.mgz 


 mri_segstats --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brain-vol-from-seg --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --subject mni152.fnirt --surf-wm-vol --ctab /usr/local/freesurfer/dev/FreeSurferColorLUT.txt 

