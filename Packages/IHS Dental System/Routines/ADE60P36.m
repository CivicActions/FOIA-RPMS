ADE60P36 ;IHS/OIT/GAB - ADE V 6.0 PATCH 36 [ 10/20/2021  2:35 PM ]
 ;;6.0;ADE IHS DENTAL;**36**;March 25, 1999;Build 86
 ;;2022 ADA-CDT Code Updates /IHS/OIT/GAB 10/2021
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
 ; only post for patch 36 - /IHS/OIT/GAB *36* 10/2021
 ; U
 N ADED,ADECNT,ADEVALUE
 D BMES^XPDUTL("Adding new & modified Dental Codes for 2022...")
 D ADDCDT36^ADE6P361
 D BMES^XPDUTL(" ...DONE")
 D BMES^XPDUTL("Inactivating Dental Codes for 2022 ...")
 D DELCDT36^ADE6P363
 D BMES^XPDUTL("...DONE")
 Q
 ; ********************************************************************
SORRY(X) ;
 K DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....Please fix it.",40)
 Q
