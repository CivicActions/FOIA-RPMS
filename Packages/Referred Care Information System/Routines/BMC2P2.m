BMC2P2 ;IHS/ITSC/FCJ - BMC 2.0 PATCH 2 ; [ 01/09/2004  4:31 PM ]
 ;;2.0;REFERRED CARE INFO SYSTEM;**2**;JAN 20, 2004
 ;
 ;
 I '$G(IOM) D HOME^%ZIS
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 ;
 I '(DUZ(0)["@") W:'$D(ZTQUEUED) !,"DUZ(0) DOES NOT CONTAIN AN '@'." D SORRY(2) Q
 ;
 S X=$$GET1^DIQ(200,DUZ,.01)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_" Patch "_$P($T(+2),";",5)_".",IOM)
 ;
 NEW IORVON,IORVOFF
 S X="IORVON;IORVOFF"
 D ENDR^%ZISS
 ;
 I $$VCHK("BMC","2.0",2,"'=")
 ;
 NEW DA,DIC
 S X="BMC",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","BMC")) D
 . W !!,*7,*7,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM),!,$$CJ^XLFSTR("PACKAGE File with an ""BMC"" prefix.",IOM)
 . W !,$$CJ^XLFSTR(IORVON_"One entry needs to be deleted."_IORVOFF,IOM)
 . D SORRY(2)
 .Q
 ;
 I $G(XPDQUIT) W !,$$CJ^XLFSTR(IORVON_"FIX IT! Before Proceeding."_IORVOFF,IOM),!!,*7,*7,*7 Q
 ;
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 ;
 D HELP^XBHELP("INTROE","BMC2P2")
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2) Q
 ;
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0 D HELP^XBHELP("INTROI","BMC2P2") I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2)
 ;
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
 ;
VCHK(BMCPRE,BMCVER,BMCQUIT,BMCCOMP) ; Check versions needed.
 ;  
 NEW BMCV
 S BMCV=$$VERSION^XPDUTL(BMCPRE)
 W !,$$CJ^XLFSTR("Need "_$S(BMCCOMP="<":"at least ",1:"")_BMCPRE_" v "_BMCVER_"....."_BMCPRE_" v "_BMCV_" Present",IOM)
 I @(BMCV_BMCCOMP_BMCVER) D SORRY(BMCQUIT) Q 0
 Q 1
 ;
PRE ;EP - From KIDS.
 I $$NEWCP^XPDUTL("PRE1","AUDS^BMC2P2")
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 Q
 ;
POST ;EP - From KIDS.
 ;
 ; ---Patch 1 Checks for installs are done in Install Questions.
 S %="P1^BMC2P2"
 I $$NEWCP^XPDUTL("POS1-"_%,%)
 ;
 ; ---Patch 2 Checks for duplicate menu option
 S %="P2OPT^BMC2P2"
 I $$NEWCP^XPDUTL("POS4-"_%,%)
 ;
 ; --- Restore dd audit settings.
 S %="AUDR^BMC2P2"
 I $$NEWCP^XPDUTL("POS5-"_%,%)
 ;
 ; --- Send mail message of install.
 S %="MAIL^BMC2P2"
 I $$NEWCP^XPDUTL("POS6-"_%,%)
 ;
 Q
 ;
MAIL ;
 D BMES^XPDUTL("BEGIN Delivering MailMan message to select users.")
 NEW DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("BMC2P2",$J)
 D RSLT(" --- BMC v 2.0 Patch 2, has been installed into this uci ---")
 F %=1:1 D RSLT($P($T(GREET+%),";",3)) Q:$P($T(GREET+%+1),";",3)="###"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   D RSLT(^(%,0))
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""BMC2P2"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="BMCZMENU","XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 KILL ^TMP("BMC2P2",$J)
 D MES^XPDUTL("END Delivering MailMan message to select users.")
 Q
 ;
RSLT(%) S ^(0)=$G(^TMP("BMC2P2",$J,0))+1,^(^(0))=%
 Q
 ;
SINGLE(K) ; Get holders of a single key K.
 NEW Y
 S Y=0
 Q:'$D(^XUSEC(K))
 F  S Y=$O(^XUSEC(K,Y)) Q:'Y  S XMY(Y)=""
 Q
 ;
INTROE ; Intro text during KIDS Environment check.
 ;;In this distribution:
 ;;(1) General Retrieval Report:
 ;;    a. Fixed naked ref. in Secondary Provider option 86 and 89
 ;;    b. Fixed dates to print in XX/XX/XX or XX/XX/XXXX formats
 ;;    c. Modified Column names to match options
 ;;    d. Added option to select new date ranges from saved report
 ;;    e. Added option to save total/subtotal report
 ;;    f. Added option to save/change custom titles
 ;;(2) Secondary Provider Workload report
 ;;    a. Ability to select and sort by Referral Type
 ;;    b. Fixed printing of correct fields
 ;;    c. Print Referral type on report
 ;;    d. Fixed sort by creator option
 ;;(3) Transfer Log report-fixed page break problem
 ;;(4) New option to Modify Referrals-ability to select new
 ;;    referrals for same patient
 ;;(5) On Referral lookup, display secondary referral information
 ;;(6) Fixed page break problem with Display Secondary Providers
 ;;    for a Specific Patient option
 ;;(7) Added Notes to Scheduler and Schedule apt within __ days
 ;;    to the Modify Referral options 2 and 3
 ;;(8) Added the Additional Data sent with patient to the
 ;;    Modify Referral option 3
 ;;(9) Added printing of Provider Physical Location to letters
 ;;(10)Transfer Log report-added ability to sort alphabetically by
 ;;    patient for Facility referred to and Case Manager options
 ;;(11)BMCFDR2 modified to match DD and help screen
 ;;(12)Modified routines to fix the Add Provider DX and Procedure
 ;;    Narrative when automatic DX and CPT parameter was set.
 ;;(13)Miscellaneous routine modifications
 ;;###
 ;
INTROI ; Intro text during KIDS Install.
 ;;A standard message will be produced by this update.
 ;;  
 ;;If you run interactively, results will be displayed on your screen,
 ;;as well as in the mail message and the entry in the INSTALL file.
 ;;If you queue to TaskMan, please read the mail message for results of
 ;;this update, and remember not to Q to the HOME device.
 ;;###
 ;
GREET ;;To add to mail message.
 ;;  
 ;;Greetings.
 ;;  
 ;;Standard data dictionaries on your RPMS system have been updated.
 ;;  
 ;;You are receiving this message because of the particular RPMS
 ;;security keys that you hold.  This is for your information, only.
 ;;You need do nothing in response to this message.
 ;;  
 ;;Questions about this patch, which is a product of the RPMS DBA
 ;;(Fonda Jackson at 971.235.5714),
 ;;can be directed to the DIR/RPMS Support Center, at 505-248-4371,
 ;;or via e-mail to "rpmshelp@mail.ihs.gov".
 ;;Please refer to patch "bmc*2.0*2".
 ;;  
 ;;###;NOTE: This line indicates the end of text in this message.
 ;
 ; -----------------------------------------------------
 ; The global location for dictionary audit is:
 ;           ^DD(FILE,0,"DDA")
 ; If the valuey is "Y", dd audit is on.  Any other value, or the
 ; absence of the node, means dd audit is off.
 ; -----------------------------------------------------
AUDS ;EP - From KIDS.
 D BMES^XPDUTL("Saving current DD AUDIT settings for files in this patch")
 D MES^XPDUTL("and turning DD AUDIT to 'Y'.")
 S ^XTMP("BMC2P2",0)=$$FMADD^XLFDT(DT,10)_"^"_DT_"^"_$P($P($T(+1),";",2)," ",3,99)
 NEW BMC
 S BMC=0
 F  S BMC=$O(^XTMP("XPDI",XPDA,"FIA",BMC)) Q:'BMC  D
 . I '$D(^XTMP("BMC2P2",BMC,"DDA")) S ^XTMP("BMC2P2",BMC,"DDA")=$G(^DD(BMC,0,"DDA"))
 . D MES^XPDUTL(" File "_$$RJ^XLFSTR(BMC,12)_" - "_$$LJ^XLFSTR(^XTMP("XPDI",XPDA,"FIA",BMC),30)_"- DD audit was '"_$G(^XTMP("BMC2P2",BMC,"DDA"))_"'"),MES^XPDUTL($$RJ^XLFSTR("Set to 'Y'",69))
 . S ^DD(BMC,0,"DDA")="Y"
 .Q
 D MES^XPDUTL("DD AUDIT settings saved in ^XTMP(.")
 Q
 ; -----------------------------------------------------
AUDR ; Restore the file data audit values to their original values.
 D BMES^XPDUTL("Restoring DD AUDIT settings for files in this patch.")
 NEW BMC
 S BMC=0
 F  S BMC=$O(^XTMP("BMC2P2",BMC)) Q:'BMC  D
 . S ^DD(BMC,0,"DDA")=^XTMP("BMC2P2",BMC,"DDA")
 . D MES^XPDUTL(" File "_$$RJ^XLFSTR(BMC,12)_" - "_$$LJ^XLFSTR($$GET1^DID(BMC,"","","NAME"),30)_"- DD AUDIT Set to '"_^DD(BMC,0,"DDA")_"'")
 .Q
 KILL ^XTMP("BMC2P2")
 D MES^XPDUTL("DD AUDIT settings restored.")
 Q
 ; -----------------------------------------------------
 ;
INSTALLD(BMC) ; Determine if patch BMC was installed, where BMC is
 ; the name of the INSTALL.  E.g "AVA*93.2*12".
 ;
 NEW DIC,X,Y
 ;  lookup package.
 S X=$P(BMC,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 Q 0
 ;  lookup version.
 S DIC=DIC_+Y_",22,",X=$P(BMC,"*",2)
 D ^DIC
 I Y<1 Q 0
 ;  lookup patch.
 S DIC=DIC_+Y_",""PAH"",",X=$P(BMC,"*",3)
 D ^DIC
 Q $S(Y<1:0,1:1)
 ;
 ; -----------------------------------------------------
DORFOPT ;DELETE OUT REF OPTION
 D BMES^XPDUTL("BEGIN Removing Old Outside Referral option.")
 ;REMOVE FROM OPTION
 I $$DELETE^XPDMENU("BMC MENU-RPTS ADMINISTRATIVE","BMC OUTSIDE REFERRALS")  D MES^XPDUTL($J("",5)_"Old Outside Referral menu option removed")
 E  D MES^XPDUTL($J("",5)_"ERROR:   remove Outside Referral menu FAILED.")
 ;REMOVE OPTION
 S DA=$O(^DIC(19,"B","BMC OUTSIDE REFERRALS",0)) I DA S DIK="^DIC(19," D ^DIK
 D MES^XPDUTL("END Removing Outside Referral menu.")
 Q
AORFOPT ;ADD OUT REF OPTION
 D BMES^XPDUTL("BEGIN Attaching New Outside Referral menu option.")
 I $$ADD^XPDMENU("BMC MENU-RPTS ADMINISTRATIVE","BMC OUTSIDE REFERRALS","OUT")  D MES^XPDUTL($J("",5)_"Outside Referral Menu added to Administrative Reports menu."),MES^XPDUTL($J("",5)_"Note that the security lock was *NOT* allocated.") I 1
 E  D MES^XPDUTL($J("",5)_"ERROR:   Outside Referral menu attachment FAILED.")
 D MES^XPDUTL("END Attaching Outside Referral menu.")
 Q
ASWKOPT ;ADD SECONDARY WORKLOAD OPTION
 Q:'$G(XPDQUES("POS2"))
 D BMES^XPDUTL("BEGIN Attaching Secondary Workload menu option.")
 I $$ADD^XPDMENU("BMC MENU-RPTS ADMINISTRATIVE","BMC RPT-SECONDARY WORKLOAD","SWK") D MES^XPDUTL($J("",5)_"Secondary Workload Menu added to Administrative Reports menu."),MES^XPDUTL($J("",5)_"Note that the security lock was *NOT* allocated.") I 1
 E  D MES^XPDUTL($J("",5)_"ERROR:   Secondary Workload menu attachment FAILED.")
 D MES^XPDUTL("END Attaching Secondary Workload menu.")
 Q
SECKEY ;Security Key Change
 Q:'$G(XPDQUES("POS3"))
 ;Add Security Key BMCZEDIT to BMC MENU-DATA ENTRY Option
 S DA=$O(^DIC(19,"B","BMC MENU-DATA ENTRY",0)) I DA S DIE="^DIC(19,",DR="3////"_"BMCZEDIT"  D ^DIE K DIE,DR,DA
 ;Remove Security Key BMCZMGR from BMC MODIFY REFERRAL
 S DA=$O(^DIC(19,"B","BMC MODIFY REFERRAL",0)) I DA S DIE="^DIC(19,",DR="3///"_"@"  D ^DIE K DIE,DR,DA
 D MES^XPDUTL("END Adding BMCZEDIT security key to Data Entry Menu and removing key from Modify Referral.")
 Q
 ;
P2OPT ;PATCH 2 TEST FOR DUPLICATE MENU OPTION AND DELETE OPTION
 ;OPTION WILL ONLY EXIST IF ORIGINAL PATCH 1 WAS INSTALLED
 D BMES^XPDUTL("BEGIN test and removal of multiple OUT-Menu options.")
 NEW BMC,BMC1,BMC2
 S BMC="" S BMC=$O(^DIC(19,"B","BMC MENU-RPTS ADMINISTRATIVE",BMC))
 Q:BMC'?1N.N
 S BMC1="" F  S BMC1=$O(^DIC(19,BMC,10,"C","OUT",BMC1)) Q:BMC1'?1N.N  D
 .S BMC2=$P(^DIC(19,BMC,10,BMC1,0),U)
 .Q:$D(^DIC(19,BMC2))
 .I '$D(^DIC(19,BMC2)) S DA=BMC1,DA(1)=BMC,DIK="^DIC(19,BMC,10," D ^DIK
 D BMES^XPDUTL("END of test and removal of Menu option")
 Q
 ;
P1 ;EP - from KIDS.
 Q:'$G(XPDQUES("POS1"))
 ;
 ; ---DELETE BMC OUTSITE REFERRAL OPTION
 ;S %="DORFOPT^BMC2P2"
 ;I $$NEWCP^XPDUTL("POS1-"_%,%)
 ;
 ; ---ADD BMC OUTSITE REFERRAL OPTION
 ;S %="AORFOPT^BMC2P2"
 ;I $$NEWCP^XPDUTL("POS2-"_%,%)
 ;
 ; ---ADD SECONDARY WORKLOAD OPTION
 S %="ASWKOPT^BMC2P2"
 I $$NEWCP^XPDUTL("POS2-"_%,%)
 ;
 ; ---SECURITY KEY CHANGES
 S %="SECKEY^BMC2P2"
 I $$NEWCP^XPDUTL("POS3-"_%,%)
 ;
 Q
