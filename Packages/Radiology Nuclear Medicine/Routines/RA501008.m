RA501008 ;ihs/cmi/maw - Radiology 5.0 Patch 1008 Environment Check
 ;;5.0;Radiology/Nuclear Medicine;**1008**;Mar 13, 2020;Build 14
 Q
 ;
ENV ;-- check to make sure 1007 is installed
 N MODULE,VERSION,PATCH
 S MODULE="RA"
 S VERSION="5.0"
 S PATCH=1007
 S SYSPATCH=$$PATCH^XPDUTL(MODULE_"*"_VERSION_"*"_PATCH)
 I 'SYSPATCH W !,"Patch "_PATCH_" is required before this can be installed."
 S XPDABORT=1
 Q
 ;
POST ;-- post init
 D ADD^XPDMENU("RA PNL","RA INTERPRETING SITE")
 Q
 ;
