ADE60P41 ;IHS/OIT/GAB - ADE V 6.0 PATCH 41 [ 12/06/2024  2:35 PM ]
 ;;6.0;ADE IHS DENTAL;**41**;March 25, 1999;Build 57
 ;;IHS/OIT/GAB Main Install Routine for Patch 41 
 ;
ENV ;Environment check
 N IORVOFF,IORVON
 K ADEMSG,XPDQUIT
 D ^XBKVAR
 D HOME^%ZIS
 D DUZ
 I $G(XPDQUIT) D SORRY Q
 D RV
 D XPZ
 D HELLO
 ;
 ;D VER  Per SQA remove since checking patch level
 D DUP
 I $G(XPDQUIT) W !," **********INSTALL ABORTED!**********" Q
 I '$$CHKPAT("XU*8.0*1020") S XPDQUIT=1
 I '$$CHKPAT("DI*22.0*1020") S XPDQUIT=1
 I '$$CHKPAT("ADE*6.0*40") S XPDQUIT=1
 I $G(XPDQUIT) W !!," **********INSTALL ABORTED**********" Q
 D OK
 Q
 ;
DUZ ; CHECK FOR VALID DUZ VARIABLES
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D FAIL(2)
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D FAIL(2)
 I '($G(DUZ(0))["@") W !,"THE DD UPDATES REQUIRE AN '@' IN YOUR DUZ(0)" D FAIL(2)
 Q
 ;
RV ; SET REVERSE VIDEO ON/OFF VARIABLES
 D HOME^%ZIS
 N X
 S X="IORVON;IORVOFF"
 D ENDR^%ZISS
 Q
 ;
XPZ ; PREVENT 'DISABLE OPTIONS' AND 'MOVE ROUTINES' PROMPTS
 I $G(XPDENV)=1 D
 . S XPDDIQ("XPZ1")=0 ;SUPPRESS 'DISABLE OPTIONS' PROMPT
 . S XPDDIQ("XPZ2")=0 ;SUPPRESS 'MOVE ROUTINES' PROMPT
 Q
 ;
HELLO ; HELLO MESSAGE AND ENVIRONMENT CHECK
 N X
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_" Patch "_$P($T(+2),";",5)_":",IOM)
 W !!
 Q
 ;
DUP ;----- CHECK FOR DUPLICATE ADE ENTRIES IN PACKAGE FILE
 N D,DA,DIC,X,Y
 S X="ADE",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","ADE")) D
 . W !!,*7,*7,$$CJ^XLFSTR("You have more than one entry in the      ",IOM)
 . W !,$$CJ^XLFSTR("PACKAGE file with an 'ADE' prefix.     ",IOM)
 . W !,$$CJ^XLFSTR($G(IORVON)_"One entry needs to be deleted"_$G(IORVOFF),IOM)
 . W !,$$CJ^XLFSTR("Please fix it.      ",IOM),!!,*7,*7
 . D FAIL(2)
 Q
CHKPAT(X) ;  CHECK IF PATCH HAS BEEN INSTALLED
 ;      RETURNS 1 IF PATCH HAS BEEN INSTALLED, 0 IF NOT
 ;
 N XPDA,OK
 S OK=0
 S XPDA=0
 F  S XPDA=$O(^XPD(9.7,"B",X,XPDA)) Q:'XPDA  D
 . I $P($G(^XPD(9.7,XPDA,0)),U,9)=3 S OK=1
 S ADEMSG=$S(OK'=1:"Missing <<<--- FIX IT!",1:"Present")
 W !,$$CJ^XLFSTR("Need patch "_X_"....."_ADEMSG,IOM)
 Q OK
 ;
PRE ;EP -- PRE-INSTALL FROM KIDS.
 ;
 D ^XBKVAR
 D BMES^XPDUTL("Installing the 2025 annual dental code updates...")
 ;
 D MES^XPDUTL("Pre-install routine is complete.")
 ;
 Q
 ;
POST ;EP Post-Install
 ; patch 41 Post
 D ^XBKVAR
 D BMES^XPDUTL("Adding 10 new Dental Codes ...")
 D ADDCDT41^ADE6P411
 D BMES^XPDUTL(" ...DONE")
 D BMES^XPDUTL("Inactivating 2 Dental Codes ...")
 D DELCDT41^ADE6P412
 D BMES^XPDUTL("...DONE")
 D BMES^XPDUTL("Adding Mnemonics for 5 codes and modifying description and use fields for 9170...")
 D ADDNM41^ADE6P413
 D MODCDT41^ADE6P414
 D BMES^XPDUTL("...DONE")
 ;
 D MAIL
 Q
 ;
SINGLE(K) ;----- GET HOLDERS OF A SINGLE KEY K.
 N Y
 Q:'$D(^XUSEC(K))
 S Y=0
 F  S Y=$O(^XUSEC(K,Y)) Q:'Y  S XMY(Y)=""
 Q
 ;
 ; ******************************************************************** ;
OK ; OK TO INSTALL?
 I '$D(XPDQUIT) D
 . W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 . I '$$DIR^XBDIR("E","","","","","",1) D FAIL(2)
 Q
 ;
MAIL ;SEND OUT A MAILMAN MESSAGE 
 N DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 K ^TMP("ADEP41",$J)
 S ^TMP("ADEP41",$J,1)=" --- ADE v6.0, Patch 41 has been installed into this namespace ---"
 I $G(XPDA) D
 . S %=0
 . F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   D
 . . S ^TMP("ADEP41",$J,(%+1))=" "_^(%,0)
 ;
 S XMSUB=$P($P($T(+1),";",2)," ",3,99)
 S XMDUZ=$S($G(DUZ):DUZ,1:.5)
 S XMTEXT="^TMP(""ADEP41"",$J,"
 S XMY(1)=""
 S XMY(DUZ)=""
 ;
 F %="XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 K ^TMP("ADEP41",$J)
 Q
 ;
FAIL(X) ; SET XPDQUIT
 K DIFQ
 S XPDQUIT=X
 Q
 ;
SORRY  ;
 K DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....Please fix it.",40)
 Q
