ADE60P40 ;IHS/OIT/GAB - ADE V 6.0 PATCH 40 [ 11/06/2023  2:35 PM ]
 ;;6.0;ADE IHS DENTAL;**40**;March 25, 1999;Build 10
 ;;IHS/OIT/GAB 11/2023 Patch 40 ADA-CDT code updates for 2024
 ;
ENV ;Environment check
 N IORVOFF,IORVON
 K ADEMSG
 ;
 D ^XBKVAR
 D HOME^%ZIS
 D DUZ
 I $G(XPDQUIT) D SORRY Q
 ;
 D RV
 D XPZ
 D HELLO
 I '$$CHKPAT("XU*8.0*1020") S XPDQUIT=1
 I '$$CHKPAT("DI*22.0*1020") S XPDQUIT=1
 I '$$CHKPAT("ADE*6.0*39") S XPDQUIT=1
 D OK
 ;
 Q
 ;
DUZ ; CHECK FOR VALID DUZ VARIABLES
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D FAIL(2)
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D FAIL(2)
 I '($G(DUZ(0))["@") W !,"THE DD UPDATES REQUIRE AN '@' IN YOUR DUZ(0)" D FAIL(2)
 Q
 ;
RV ; SET REVERSE VIDEO ON/OFF VARIABLES
 ;
 D HOME^%ZIS
 N X
 S X="IORVON;IORVOFF"
 D ENDR^%ZISS
 Q
 ;
XPZ ; PREVENT 'DISABLE OPTIONS' AND 'MOVE ROUTINES' PROMPTS
 ;
 I $G(XPDENV)=1 D
 . S XPDDIQ("XPZ1")=0 ;SUPPRESS 'DISABLE OPTIONS' PROMPT
 . S XPDDIQ("XPZ2")=0 ;SUPPRESS 'MOVE ROUTINES' PROMPT
 Q
 ;
HELLO ; HELLO MESSAGE AND ENVIRONMENT CHECK
 ;
 N X
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_" Patch "_$P($T(+2),";",5)_".",IOM)
 Q
 ;
CHKPAT(X) ;
 ;      CHECK IF PATCH HAS BEEN INSTALLED
 ;      RETURNS 1 IF PATCH HAS BEEN INSTALLED, 0 IF NOT
 ;
 N XPDA,OK
 S OK=0
 S XPDA=0
 F  S XPDA=$O(^XPD(9.7,"B",X,XPDA)) Q:'XPDA  D
 . I $P($G(^XPD(9.7,XPDA,0)),U,9)=3 S OK=1
 S ADEMSG=$S(OK'=1:"Missing <<<--- FIX IT!",1:"Present.")
 W !,$$CJ^XLFSTR("Need patch "_X_"....."_ADEMSG,IOM)
 Q OK
 ;
PRE ;EP -- PRE-INSTALL FROM KIDS.
 ;
 D ^XBKVAR
 ;
 D BMES^XPDUTL("Beginning pre-install routine (PRE^ADE60P40)...")
 ;
 ;PRE-INSTALL SUBROUTINE CALLS GO HERE
 ;
 D MES^XPDUTL("Pre-install routine is complete.")
 ;
 Q
 ;
POST ;EP Post-Install
 ; only post for patch 40 - /IHS/OIT/GAB *40*
 N ADED,ADECNT,ADEVALUE
 D BMES^XPDUTL("Adding new Dental Codes for 2024...")
 D ADDCDT40^ADE6P401
 D BMES^XPDUTL(" ...DONE")
 D BMES^XPDUTL("Adding 2024 Description and Use modifications ...")
 D MODCDT40^ADE6P402
 D BMES^XPDUTL(" ...DONE")
 D BMES^XPDUTL("The 2024 ADA-CDT dental code update has been completed ...")
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
 ;
 I $D(XPDQUIT) D
 . W !!,$$CJ^XLFSTR(IORVON_"Please FIX it!!"_IORVOFF,IOM) D SORRY
 ;
 I '$D(XPDQUIT) D
 . W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 . I '$$DIR^XBDIR("E","","","","","",1) D FAIL(2)
 Q
 ;
MAIL ;SEND OUT A MAILMAN MESSAGE 
 ;
 N DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 K ^TMP("ADEP40",$J)
 S ^TMP("ADEP40",$J,1)=" --- ADE v6.0, Patch 40 has been installed into this namespace ---"
 I $G(XPDA) D
 . S %=0
 . F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   D
 . . S ^TMP("ADEP40",$J,(%+1))=" "_^(%,0)
 ;
 S XMSUB=$P($P($T(+1),";",2)," ",3,99)
 S XMDUZ=$S($G(DUZ):DUZ,1:.5)
 S XMTEXT="^TMP(""ADEP40"",$J,"
 S XMY(1)=""
 S XMY(DUZ)=""
 ;
 F %="XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 K ^TMP("ADEP40",$J)
 Q
 ;
FAIL(X) ; SET XPDQUIT
 ;
 K DIFQ
 S XPDQUIT=X
 Q
 ;
SORRY  ;
 K DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....Please fix it.",40)
 Q
