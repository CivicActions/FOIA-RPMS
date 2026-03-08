BRNP05 ; IHS/OIT/GAB - PRE & POST INIT CODE FOR PATCH 5
 ;;2.0;IHS RELEASE OF INFORMATION;**5**;APR 10, 2003;Build 20
 ;IHS/OIT/GAB 07/28/2023 - ENVIRONMENT CHECK ROUTINE for BRN v2 Patch 5
 ;
 ;
CKENV ;entry point
 I '$G(IOM) D HOME^%ZIS
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." S XPDQUIT=2 Q
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." S XPDQUIT=2 Q
 ;
 S X=$$GET1^DIQ(200,DUZ,.01)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment...",IOM)
 ;
 ;Prevents "Disable Options..." and "Move Routines..." questions
 S XPDDIQ("XPZ1")=0,XPPDIQ("XPZ2")=0
 S PKG="IHS RELEASE OF INFORMATION"
 ;
CKVER ;CHECK FOR REQUIRED VERSION AND PATCHES
 S (VERS,PAT)=""
 W !," Checking for current version ..."
 S VERS=$$VERSION^XPDUTL(PKG)
 I VERS<2 W !,"You must first install IHS RELEASE OF INFORMATION V2.0." S XPDQUIT=2 Q
 I VERS="2.0" W !," You have version 2.0 ... "
 ; **** CHECK FOR CURRENT PATCH ****
 S PAT=$$LAST^XPDUTL(PKG,VERS)
 I $G(PAT) S PAT=$P(PAT,"^",1)
 W !!,"Checking for patch information ...."
 I PAT<4 W !,"You must first install IHS RELEASE OF INFORMATION v 2.0 patch 4" S XPDQUIT=2 Q
 I PAT>3 W !,"Last patch installed: ",PAT,!
 Q
 ;
 ;
POST ;EP; post init code
 ;ADD NEW REPORT OPTIONS
 N RP
 D BMES^XPDUTL("BEGIN Adding New Report Options...")
 S RP=$$ADD^XPDMENU("BRN MENU RPT","BRN RPT REQ METHOD SUBTOTAL","MET")
 I RP D MES^XPDUTL($J("",5)_"MET Report added to ROI Report menu.")
 I 'RP D MES^XPDUTL($J("",5)_"ERROR: Adding MET option FAILED.")
 S RP=$$ADD^XPDMENU("BRN MENU RPT","BRN RPT RECORD DISSEMINATION","RDIS")
 I RP D MES^XPDUTL($J("",5)_"RDIS Report added to ROI Report menu.")
 I 'RP D MES^XPDUTL($J("",5)_"ERROR: Adding RDIS option FAILED.")
 D MES^XPDUTL("END Adding New Report options to the menu...")
 Q
