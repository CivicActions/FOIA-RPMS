ADE60P38 ;IHS/OIT/GAB - ADE 6.0 PATCH 38
 ;;6.0;ADE;**38**;MAR 25, 1999;Build 158
 ;;IHS/OIT/GAB 11.20.22 FILE 200 UPDATE
ENV ;EP - ENVIRONMENT CHECK 
 ;
 N IORVOFF,IORVON
 K XPDQUIT
 D ^XBKVAR
 D HOME^%ZIS
 D DUZ
 I $D(XPDQUIT) D SORRY Q
 ;
 D REV
 D PROM
 D HELLO
 D VER
 D START
 Q:$G(XPDQUIT)=1  ;stop if there are issues with the files
 ;
 I '$$CHKPAT("XU*8.0*1018") S XPDQUIT=1
 I '$$CHKPAT("DI*22.0*1018") S XPDQUIT=1
 I '$$CHKPAT("ADE*6.0*37") S XPDQUIT=1
 I $G(XPDQUIT)=1 D SORRY Q
 ;
 I $$CHKPAT("ADE*6.0*38") D CKADE
 S DIR(0)="Y"
 S DIR("A")="Continue with the ADE v6.0 Patch 38 install? This will take several minutes (Yes or No)?:"
 S DIR("B")="No"
 H 1
 D ^DIR
 K DIR
 I Y(0)["N"!(Y(0)["n") S XPDQUIT=1 W !!,$$CJ^XLFSTR(" Stopping the installation...",IOM) Q  ; do not continue with this update
 D OK
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
 I $$VCHK("ADE","6.0",37)
 I $$VCHK("DI","22.0",2)
 I $$VCHK("XU","8.0",2)
 Q
START N X,Y,Z,%,DIRUT,DIROUT,DTOUT,DUOUT
 ;
 I '$O(^VA(200,0)) D
 .S XPDQUIT=1 ; FILE #200 NOT PRESENT, Set XPDQUIT
 .W !!,$$CJ^XLFSTR(" New Person file is not present...stopping the conversion",IOM)
 I '$D(^DIC(6,0))!'$D(^DIC(3,0))!'$D(^DIC(16,0)) S XPDQUIT=1 W !!,$$CJ^XLFSTR(" File 3,6 or 16 is missing...stopping the conversion ",IOM)
 Q
CHKPAT(X)          ;
 ; CHECK IF PATCH HAS BEEN INSTALLED
 ;   RETURNS 1 IF PATCH HAS BEEN INSTALLED, 0 IF NOT
 N XPDA,OK
 S OK=0
 S XPDA=0
 F  S XPDA=$O(^XPD(9.7,"B",X,XPDA)) Q:'XPDA  D
 . I $P($G(^XPD(9.7,XPDA,0)),U,9)=3 S OK=1
 I X="ADE*6.0*38" Q OK  ;quit if patch 38
 S ADEMSG=$S(OK'=1:"Missing <<<--- PLEASE FIX IT!",1:"Present.")
 W !,$$CJ^XLFSTR("Need patch "_X_"....."_ADEMSG,IOM)
 Q OK
 ;
OK ;----- OK TO INSTALL?
 ;
 I $D(XPDQUIT) D
 . W !!,$$CJ^XLFSTR(IORVON_"Please FIX it!!"_IORVOFF,IOM) D SORRY
 I '$D(XPDQUIT) D
 . W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 . I '$$DIR^XBDIR("E","","","","","",1) D FAIL(2)
 Q
 ;
CKADE  ;
 ;IF PATCH HAS ALREADY BEEN INSTALLED,MAY NEED ROUTINES/TEMPLATES UPDATED, SO CONTINUE IF REQUESTED
 W !!,$$CJ^XLFSTR("You already have ADE v6.0 patch 38 installed",IOM)
 W !!,$$CJ^XLFSTR("Re-installing this patch could cause problems with your Dental Data",IOM)
 W !!,$$CJ^XLFSTR("if your file conversion did not complete",IOM)
 W !!,$$CJ^XLFSTR("Contact OIT Support immediately if the conversion failed",IOM)
 Q
VCHK(ADEPRE,ADEVER,ADEQUIT) ;
 ;CHECK VERSIONS 
 N ADEV,ADEMSG,Y
 S Y=1
 S ADEV=$$VERSION^XPDUTL(ADEPRE)
 S ADEMSG=$S(ADEV<ADEVER:" <<<--- FIX IT!",1:"")
 W !,$$CJ^XLFSTR("Need at least "_ADEPRE_" v "_ADEVER_"....."_ADEPRE_" v "_ADEV_" Present"_ADEMSG,IOM)
 I ADEV<ADEVER D FAIL(XPDQUIT) S Y=0
 Q Y
 ;
PRE ;EP -- PRE-INSTALL FROM KIDS
 ;
 D ^XBKVAR
 D BMES^XPDUTL("Beginning pre-install routine (PRE^ADE60P38)...")
 D BMES^XPDUTL(" Updating Dental files, options, field pointers & supporting cross-references for the New Person update...")
 ;add pre-install routine here
 D BMES^XPDUTL(" Pre-install routine is complete...")
 Q
 ;
POST ;EP -- POST-INSTALL FROM KIDS
 D ^XBKVAR
 D BMES^XPDUTL("Beginning post-install routine (POST^ADE60P38)...")
 D CKCONV
 I $G(XPDQUIT)=1 Q
 D ^ADECONVF
 I $G(XPDQUIT)=1 D BMES^XPDUTL("There was an issue with the install, please contact RPMS Support for assistance...") Q
 D ADECOMP  ;compile ADE template
 D BMES^XPDUTL("Delivering ADE*6.0*38 install message to select users...")
 D MAIL
 D BMES^XPDUTL("Post-install routine is complete.")
 Q
 ;
CKCONV  ; check to see if the conversion has already ran (CK=1)
 N C,CK
 S CK=0
 S C=0 F  S C=$O(^ADEPARAM(C)) Q:C'=+C  D
 . I $G(XPDQUIT)=1 Q
 . S CK=$G(^ADEPARAM(C,99))
 . I $G(CK)=1 S XPDQUIT=1 D BMES^XPDUTL("The file 200 conversion has already been completed, stopping install...") Q
 I $G(XPDQUIT)=1 D BMES^XPDUTL("If there was an issue with the install, please contact RPMS support...")
 Q
 ;
ADECOMP  ; compile templates
 N X,Y,ADEN
 D BMES^XPDUTL("Compiling Templates ...")
 S X="ADEPDIN"
 S ADEN="ADEPDFIND"
 S Y=$O(^DIPT("B",ADEN,""))
 S DMAX=4000
 D EN^DIPZ
 D BMES^XPDUTL("Templates have been compiled...")
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
 . W *7,!,$$CJ^XLFSTR("Sorry....installation stopped, please contact RPMS support for assistance  ",IOM)
 . S Y=$$DIR^XBDIR("E","Press RETURN")
 Q
 ;
MAIL ;SEND OUT A MAILMAN MESSAGE 
 ;
 N DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 K ^TMP("ADEP38MS",$J)
 S ^TMP("ADEP38MS",$J,1)=" --- ADE v6.0, Patch 38 has been installed into this namespace ---"
 I $G(XPDA) D
 . S %=0
 . F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   D
 . . S ^TMP("ADEP38MS",$J,(%+1))=" "_^(%,0)
 ;
 S XMSUB=$P($P($T(+1),";",2)," ",3,99)
 S XMDUZ=$S($G(DUZ):DUZ,1:.5)
 S XMTEXT="^TMP(""ADEP38MS"",$J,"
 S XMY(1)=""
 S XMY(DUZ)=""
 ;
 F %="XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 K ^TMP("ADEP38MS",$J)
 Q
