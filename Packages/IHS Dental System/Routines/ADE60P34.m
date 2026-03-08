ADE60P34 ;IHS/OIT/GAB - ADE V 6.0 PATCH 33 [ 11/22/2019  2:35 PM ]
 ;;6.0;ADE*6.0*34;;March 25, 1999;Build 68
 ;;This patch contains calls to 4 ADE PATCH update routines and contains the
 ;;2020 ADA-CDT Code Updates /IHS/OIT/GAB 11/2019
ENV ;Environment check
 I '$G(IOM) D HOME^%ZIS
 ;
 I '$G(DUZ) W !,"YOUR DUZ VARIABLE IS UNDEFINED!! Please login with your Access & Verify." D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) W !,"Your DUZ(0) VARIABLE IS UNDEFINED OR NULL." D SORRY(2) Q
 ;
 I '(DUZ(0)["@") W:'$D(ZTQUEUED) !,"YOUR DUZ(0) VARIABLE DOES NOT CONTAIN AN '@'." D SORRY(2)
 Q
POST ;EP Post-Install
 ; only post for patch 34 - /IHS/OIT/GAB *34* 11/2019
 ; Add new, modify and delete ADA Codes
 N ADED,ADECNT,ADEVALUE
 D BMES^XPDUTL("Adding new 2020 ADA-CDT Codes...")
 D ADDCDT34^ADE6P341
 D BMES^XPDUTL(" ...DONE")
 D BMES^XPDUTL("Updating 2020 ADA-CDT Descriptions ...")
 D MODCDT34^ADE6P342
 D BMES^XPDUTL(" ...DONE")
 D BMES^XPDUTL("Updating 2020 ADA-CDT OPSITE Values ...")
 D MOD2CDT^ADE6P344
 D BMES^XPDUTL("...DONE")
 D BMES^XPDUTL("Updating 2020 ADA-CDT RVU Values ...")
 D MOD3CDT^ADE6P345
 D BMES^XPDUTL("...DONE")
 D BMES^XPDUTL("Inactivating 2020 ADA-CDT Dental Codes ...")
 D DELCDT34^ADE6P343
 D BMES^XPDUTL("...DONE")
 Q
 ; ********************************************************************
SORRY(X) ;
 K DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....Please fix it.",40)
 Q
