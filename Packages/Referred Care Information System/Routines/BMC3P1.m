BMC3P1 ;IHS/ITSC/FCJ - BMC 3.0 PATCH 1 INSTALL;    [ 12/21/2004  2:59 PM ]
 ;;3.0;REFERRED CARE INFO SYSTEM;**1**;DEC 20, 2004
 ;
 I '$G(IOM) D HOME^%ZIS
 NEW IORVON,IORVOFF
 S X="IORVON;IORVOFF"
 D ENDR^%ZISS
 I '$G(DUZ) W !,$$CJ^XLFSTR("DUZ UNDEFINED OR 0.",IOM) D SORRY(2) Q
 I '$L($G(DUZ(0))) W !,$$CJ^XLFSTR("DUZ(0) UNDEFINED OR NULL.",IOM) D SORRY(2) Q
 I '(DUZ(0)["@") W:'$D(ZTQUEUED) !,$$CJ^XLFSTR("DUZ(0) DOES NOT CONTAIN AN '@'.",IOM) D SORRY(2) Q
 ;
ENV S X=$$GET1^DIQ(200,DUZ,.01)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_".",IOM)
 ;
 S BMCNEW=""
 D NEW I 'BMCNEW I $$VCHK("BMC","3.0",2,"<")
 I $$VCHK("XU","8.0",2,"<")
 I $$VCHK("DI","21.0",2,"<")
 I $$VCHK("ATX","5.1",2,"<")
 I $$VCHK("AUPN","99.1",2,"<")
 G:BMCNEW ENV1
 ;
 NEW DA,DIC
 S X="BMC",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","BMC")) D
 . W !!,*7,*7,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM),!,$$CJ^XLFSTR("PACKAGE File with an ""BMC"" prefix.",IOM)
 . W !,$$CJ^XLFSTR(IORVON_"One entry needs to be deleted."_IORVOFF,IOM)
 . D SORRY(2)
 ;
ENV1 ;
 I $G(XPDQUIT) W !,$$CJ^XLFSTR(IORVON_"You must Fix it Before Proceeding."_IORVOFF,IOM),!!,*7,*7,*7 Q
 ;
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2) Q
 D HELP^XBHELP("INTROE","BMC3P1")
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2) Q
 ;
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0 D HELP^XBHELP("INTROI","BMC3P1") I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2)
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR(IORVON_"Sorry....You must fix it before you can install."_IORVOFF,IOM)
 Q
 ;
VCHK(BMCPRE,BMCVER,BMCQUIT,BMCCOMP) ; Check versions needed.
 ;  
 NEW BMCV
 S BMCV=$$VERSION^XPDUTL(BMCPRE)
 W !,$$CJ^XLFSTR("Need "_$S(BMCCOMP="<":"at least ",1:"")_BMCPRE_" v "_BMCVER_"....."_BMCPRE_" v "_BMCV_" Present",IOM)
 S BMCV=+(BMCV)
 I @(BMCV_BMCCOMP_BMCVER) D SORRY(BMCQUIT) Q 0
 Q 1
 ;
NEW ;TEST FOR NEW PACKAGE
 S X="BMC",Y="BMB"
 I '$D(^DIC(9.4,"C","BMC")),'$D(^DIC(19,"C",X)),'($E($O(^DIC(19,"B",Y)),1,4)=X),'($E($O(^DIC(19.1,"B",Y)),1,4)=X) W !!,$$CJ^XLFSTR("NEW INSTALL",IOM),! S BMCNEW=1 Q
 Q
 ;
INTROE ; Intro text during KIDS Environment check.
 ;;In this distribution:
 ;;(1) General Retrieval Report: 
 ;;    a. Added Case Review Comments to Selection
 ;;    b. Added Discharge Comments to Selection
 ;;    c. Fixed Business Office Comments
 ;;(2) Referral Review Report
 ;;    a. Print both ICD-9 and DX categories on Report
 ;;(3) Display referral print option available on display screen
 ;;(4) Changed prompt for RCIS Diagnosis to ICD-9
 ;;(5) Added an In-house referral letter
 ;;(6) Added separate menu otion for Discharge summary/consult
 ;;    letter
 ;;(7) Added multiple denial reasons and providers to referral.
 ;;    Fields will populate automatically if CHS link is on.
 ;;(8) Slave printing of Standard Referral letter
 ;;(9) Added referral number to In-house referral report.
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
PRE ;EP - From KIDS.
 I BMCNEW W !,"YOU MUST HAVE VERSION 3.0 INSTALLED" Q
 I $$NEWCP^XPDUTL("PRE1","AUDS^BMC3P1")
 Q
 ;
POST ;EP - From KIDS.
 ;
 ; ---ADD Menu option
 S %="DSOPT^BMC3P1"
 I $$NEWCP^XPDUTL("POS1-"_%,%)
 ;
 ; --- Restore dd audit settings.
 S %="AUDR^BMC3P1"
 I $$NEWCP^XPDUTL("POS2-"_%,%)
 ;
SNDM ; --- Send mail message of install.
 S %="MAIL^BMC3P1"
 I $$NEWCP^XPDUTL("POS3-"_%,%)
 Q
 ;
MAIL ;
 D BMES^XPDUTL("BEGIN Delivering MailMan message to select users.")
 NEW DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("BMC3P1",$J)
 D RSLT(" --- BMC v 3.0, has been installed into this uci ---")
 F %=1:1 D RSLT($P($T(GREET+%),";",3)) Q:$P($T(GREET+%+1),";",3)="###"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   D RSLT(^(%,0))
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""BMC3P1"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="BMCZMENU","XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 KILL ^TMP("BMC3P1",$J)
 D MES^XPDUTL("END Delivering MailMan message to select users.")
 Q
 ;
RSLT(%) S ^(0)=$G(^TMP("BMC3P1",$J,0))+1,^(^(0))=%
 Q
 ;
SINGLE(K) ; Get holders of a single key K.
 NEW Y
 S Y=0
 Q:'$D(^XUSEC(K))
 F  S Y=$O(^XUSEC(K,Y)) Q:'Y  S XMY(Y)=""
 Q
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
 ;;Questions about this version, which is a product of the RPMS DBA
 ;;(Fonda Jackson at 971.235.5714),
 ;;can be directed to the DIR/RPMS Support Center, at 505-248-4371,
 ;;or via e-mail to "rpmshelp@mail.ihs.gov".
 ;;Please refer to "bmc 3.0.
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
 S ^XTMP("BMC3P1",0)=$$FMADD^XLFDT(DT,10)_"^"_DT_"^"_$P($P($T(+1),";",2)," ",3,99)
 NEW BMC
 S BMC=0
 F  S BMC=$O(^XTMP("XPDI",XPDA,"FIA",BMC)) Q:'BMC  D
 . I '$D(^XTMP("BMC3P1",BMC,"DDA")) S ^XTMP("BMC3P1",BMC,"DDA")=$G(^DD(BMC,0,"DDA"))
 . D MES^XPDUTL(" File "_$$RJ^XLFSTR(BMC,12)_" - "_$$LJ^XLFSTR(^XTMP("XPDI",XPDA,"FIA",BMC),30)_"- DD audit was '"_$G(^XTMP("BMC3P1",BMC,"DDA"))_"'"),MES^XPDUTL($$RJ^XLFSTR("Set to 'Y'",69))
 . S ^DD(BMC,0,"DDA")="Y"
 .Q
 D MES^XPDUTL("DD AUDIT settings saved in ^XTMP(.")
 Q
 ; -----------------------------------------------------
AUDR ; Restore the file data audit values to their original values.
 D BMES^XPDUTL("Restoring DD AUDIT settings for files in this patch.")
 NEW BMC
 S BMC=0
 F  S BMC=$O(^XTMP("BMC3P1",BMC)) Q:'BMC  D
 . S ^DD(BMC,0,"DDA")=^XTMP("BMC3P1",BMC,"DDA")
 . D MES^XPDUTL(" File "_$$RJ^XLFSTR(BMC,12)_" - "_$$LJ^XLFSTR($$GET1^DID(BMC,"","","NAME"),30)_"- DD AUDIT Set to '"_^DD(BMC,0,"DDA")_"'")
 .Q
 KILL ^XTMP("BMC3P1")
 D MES^XPDUTL("DD AUDIT settings restored.")
 Q
 ; -----------------------------------------------------
 ;
DSOPT ;ADD DISHCHARGE COMMENTS AND LETTER REC OPTION
 NEW BMC
 S BMC=0
 I $$ADD^XPDMENU("BMC MENU EDIT REFERRAL","BMC DSCH COMMENTS/LTR REC","DDS") D MES^XPDUTL($J("",5)_"Discharge comments/ltr recieved menu option.")
 Q
