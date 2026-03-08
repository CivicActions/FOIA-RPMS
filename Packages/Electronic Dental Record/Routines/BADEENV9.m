BADEENV9 ;IHS/OIT/GAB - BADE ENVIRONMENT CHECK ROUTINE PATCH 8;10-APR-2024 16:21;GAB
 ;;1.0;DENTAL/EDR INTERFACE;**9**;FEB 22, 2010;Build 16
 ;PRE & POST INIT FOR PATCH 9
 ;
 ;
ENV ;EP - ENVIRONMENT CHECK 
 ;
 N IORVOFF,IORVON
 K XPDQUIT,BADEMSG
 D ^XBKVAR
 D HOME^%ZIS
 D DUZ
 I $G(XPDQUIT) D SORRY W !,"INSTALL ABORTED!" Q
 D REV
 D PROM
 D HELLO
 ;D VER  ;removed check for versions since it checks for version/patch level below
 I '$$CHKPAT("XU*8.0*1020") S XPDQUIT=1
 I '$$CHKPAT("DI*22.0*1020") S XPDQUIT=1
 I '$$CHKPAT("BADE*1.0*8") S XPDQUIT=1
 D DUP
 D OK
 I $G(XPDQUIT) W !,"INSTALL ABORTED!"
 Q
DUZ ; CHECK FOR VALID DUZ VARIABLES
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D FAIL(2)
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D FAIL(2)
 I '($G(DUZ(0))["@") W !,"THE DD UPDATES REQUIRE AN '@' IN YOUR DUZ(0)" D FAIL(2)
 Q
REV ; SET REVERSE VIDEO ON/OFF VARIABLES
 D HOME^%ZIS
 N X
 S X="IORVON;IORVOFF"
 D ENDR^%ZISS
 Q
PROM ;----- PREVENT 'DISABLE OPTIONS' AND 'MOVE ROUTINES' PROMPTS
 I $G(XPDENV)=1 D
 . S XPDDIQ("XPZ1")=0 ;SUPPRESS 'DISABLE OPTIONS' PROMPT
 . S XPDDIQ("XPZ2")=0 ;SUPPRESS 'MOVE ROUTINES' PROMPT
 Q
HELLO ; INITIAL MESSAGE AND ENV CHECK
 N X
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_" Patch "_$P($T(+2),";",5)_".",IOM)
 Q
VER ; CHECK FOR VERSIONS
 ;
 I $$VCHK("BADE","1.0",2)
 I $$VCHK("DI","22.0",2)
 I $$VCHK("XU","8.0",2)
 Q
CHKPAT(X)          ;
 ; CHECK IF PATCH HAS BEEN INSTALLED
 ;   RETURNS 1 IF PATCH HAS BEEN INSTALLED, 0 IF NOT
 N XPDA,OK
 S OK=0
 S XPDA=0
 F  S XPDA=$O(^XPD(9.7,"B",X,XPDA)) Q:'XPDA  D
 . I $P($G(^XPD(9.7,XPDA,0)),U,9)=3 S OK=1
 S BADEMSG=$S(OK'=1:"Missing <<<--- PLEASE FIX IT!",1:"Present.")
 W !,$$CJ^XLFSTR("Need patch "_X_"....."_BADEMSG,IOM)
 Q OK
 ;
DUP  ;----- CHECK FOR DUPLICATE BADE ENTRIES IN PACKAGE FILE
 ;
 N D,DA,DIC,X,Y
 S X="BADE",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","BADE")) D
 . W !!,*7,*7,$$CJ^XLFSTR("You have more than one entry in the      ",IOM)
 . W !,$$CJ^XLFSTR("PACKAGE file with an 'BADE' prefix.     ",IOM)
 . W !,$$CJ^XLFSTR(IORVON_"One entry needs to be deleted"_IORVOFF,IOM)
 . W !,$$CJ^XLFSTR("FIX IT! Before proceeding.      ",IOM),!!,*7,*7
 . D FAIL(2)
 Q
OK ;----- OK TO INSTALL?
 ;
 I $G(XPDQUIT) D
 . W !!,$$CJ^XLFSTR(IORVON_"Please FIX it!!"_IORVOFF,IOM) D SORRY
 I '$G(XPDQUIT) D
 . W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 . I '$$DIR^XBDIR("E","","","","","",1) D FAIL(2)
 Q
 ;
VCHK(BADEPRE,BADEVER,BADEQUIT) ;   (example: "BADE","1.0",2)
 ;CHECK VERSIONS
 N BADEV,BADEMSG,Y
 S Y=1
 S BADEV=$$VERSION^XPDUTL(BADEPRE)
 S BADEMSG=$S(BADEV<BADEVER:" <<<--- FIX IT!",1:"")
 W !,$$CJ^XLFSTR("Need at least "_BADEPRE_" v "_BADEVER_"....."_BADEPRE_" v "_BADEV_" Present"_BADEMSG,IOM)
 I BADEV<BADEVER D FAIL(BADEQUIT) S Y=0
 Q Y
 ;
PRE ;EP -- PRE-INSTALL FROM KIDS
 ;
 D ^XBKVAR
 D BMES^XPDUTL("Beginning pre-install routine...")
 D BMES^XPDUTL(" For Bade v1.0 Patch 9...")
 ;add preinstall routine here, also add below if needed
 ;I $D(BADEQUIT) D BMES^XPDUTL("There was an issue with the install...") S XPDABORT=1
 D BMES^XPDUTL(" Pre-install routine is complete...")
 Q
 ;
POST ;EP -- POST-INSTALL FROM KIDS
 ;
 D ^XBKVAR
 D BMES^XPDUTL("Beginning post-install routine ...")
 ;add any post install routines here
 D BMES^XPDUTL("Post-install routine is complete.")
 D MAIL
 Q
 ;
MAIL ;SEND OUT A MAILMAN MESSAGE 
 ;
 N DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 K ^TMP("BADEP9",$J)
 S ^TMP("BADEP9",$J,1)=" --- BADE v1.0, Patch 9 HAS BEEN INSTALLED into this namespace ---"
 I $G(XPDA) D
 . S %=0
 . F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   D
 . . S ^TMP("BADEP9",$J,(%+1))=" "_^(%,0)
 ;
 S XMSUB=$P($P($T(+1),";",2)," ",3,99)
 S XMDUZ=$S($G(DUZ):DUZ,1:.5)
 S XMTEXT="^TMP(""BADEP9"",$J,"
 S XMY(1)=""
 S XMY(DUZ)=""
 ;
 F %="XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 K ^TMP("BADEP9",$J)
 Q
 ;
SINGLE(K) ;----- GET HOLDERS OF A SINGLE KEY K.
 N Y
 Q:'$D(^XUSEC(K))
 S Y=0
 F  S Y=$O(^XUSEC(K,Y)) Q:'Y  S XMY(Y)=""
 Q
FAIL(X) ;----- SET XPDQUIT
 K DIFQ
 S XPDQUIT=X
 Q
SORRY ;----- ISSUE 'SORRY... PRESS RETURN' MESSAGES
 N Y
 I '$D(ZTQUEUED) D
 . W *7,!,$$CJ^XLFSTR("Sorry....installation stopped  ",IOM)
 . S Y=$$DIR^XBDIR("E","Press RETURN")
 Q
