ADE60P35 ;IHS/OIT/GAB - ADE V 6.0 PATCH 35 [ 11/22/2020  2:35 PM ]
 ;;6.0;ADE*6.0*35;;March 25, 1999;Build 82
 ;;This patch contains calls to update routines and contains the
 ;;2021 ADA-CDT Code Updates /IHS/OIT/GAB 11/2020
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
 ; only post for patch 35 - /IHS/OIT/GAB *35* 11/2020
 ; Add new, modify and delete ADA Codes
 N ADED,ADECNT,ADEVALUE
 D BMES^XPDUTL("Adding new 2021 ADA-CDT Codes...")
 D ADDCDT35^ADE6P351
 D BMES^XPDUTL(" ...DONE")
 D BMES^XPDUTL("Updating 2021 ADA-CDT OPSITE Values ...")
 D MOD2CDT^ADE6P354
 D BMES^XPDUTL("...DONE")
 D BMES^XPDUTL("Updating 2021 ADA-CDT RVU Values ...")
 D MOD3CDT^ADE6P355
 D BMES^XPDUTL("...DONE")
 D BMES^XPDUTL("Inactivating 2021 ADA-CDT Dental Codes ...")
 D DELCDT35^ADE6P353
 D BMES^XPDUTL("...DONE")
 Q
 ; ********************************************************************
SORRY(X) ;
 K DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....Please fix it.",40)
 Q
