BADENV10 ;IHS/GDIT/GAB - BADE ENVIRONMENT CHECK ROUTINE PATCH 8;10-APR-2025 16:21;GAB
 ;;1.0;DENTAL/EDR INTERFACE;**10**;FEB 22, 2010;Build 61
 ;PRE & POST INIT FOR PATCH 10
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
 D PROMPT
 D HELLO
 ;
 I '$$CHKPAT("XU*8.0*1018") S XPDQUIT=1
 I '$$CHKPAT("DI*22.0*1018") S XPDQUIT=1
 I '$$CHKPAT("BADE*1.0*9") S XPDQUIT=1
 D DUP
 D OK
 I $G(XPDQUIT) W !,"INSTALL ABORTED!"
 Q
DUZ ; CHECK FOR VALID DUZ VARIABLES
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D FAIL(2)
 I '($G(DUZ(0))["@") W !,"THE DD UPDATES REQUIRE AN '@' IN YOUR DUZ(0)" D FAIL(2)
 Q
REV ; SET REVERSE VIDEO ON/OFF VARIABLES
 D HOME^%ZIS
 N X
 S X="IORVON;IORVOFF"
 D ENDR^%ZISS
 Q
PROMPT ;----- PREVENT 'DISABLE OPTIONS' AND 'MOVE ROUTINES' PROMPTS
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
CHKPAT(X)  ; CHECK IF PATCH HAS BEEN INSTALLED
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
PRE ;EP -- PRE-INSTALL FROM KIDS
 ;
 Q  ;no pre-install actions for BADE v1 patch 10
 D BMES^XPDUTL("Beginning pre-install routine for BADE v1.0 Patch 10...")
 ;add preinstall routine here, also add below if needed
 ;I $D(BADEQUIT) D BMES^XPDUTL("There was an issue with the install...") S XPDABORT=1
 D BMES^XPDUTL(" Pre-install routine is complete...")
 Q
 ;
POST ;EP -- POST-INSTALL FROM KIDS
 ;
 S X1=DT,X2=365 ; add a PURGE DATE for Zero Node
 D C^%DTC
 S PURGDT=X
 S ^XTMP("BADEMDM",0)=X_"^"_DT_"^"_"BADE Failed Dental Notes Queue"
 D BMES^XPDUTL("Beginning post-install routine ...")
 D BMES^XPDUTL("Inactivating Merge Options...")
 D MERGOPT
 D BMES^XPDUTL("Merge options inactivated")
 ;
 D BMES^XPDUTL("BEGIN Attaching Dental Note menu and options.")
 D ADDMENU
 D MES^XPDUTL("     END Attaching Dental Note menu and options.")
 ;
 D BMES^XPDUTL("Post-install routine is complete.")
 D MAIL
 Q
 ;
MERGOPT ;Inactivate Merge Options (out of order)
 D OUT^XPDMENU("BADE EDR PAUSE MRG LOAD","**ACCESS DISABLED**")
 D OUT^XPDMENU("BADE EDR RESTART MRG UPLOAD","**ACCESS DISABLED**")
 D OUT^XPDMENU("BADE EDR SEND A40","**ACCESS DISABLED**")
 D OUT^XPDMENU("BADE EDR UPLOAD ALL MERGED PTS","**ACCESS DISABLED**")
 Q
 ;
ADDMENU ;Add the new Dental Note menu and the options to the menu
 I $$ADD^XPDMENU("BADE EDR MANAGE INTERFACE MENU","BADE EDR DENTAL NOTES MENU","RPC") D MES^XPDUTL($J("",5)_"Dental Note Menu added to BADE EDR MANAGE INTERFACE MENU") I 1
 E  D MES^XPDUTL($J("",5)_"ERROR:   Dental Note menu attachment FAILED or was already added.") Q
 ;
 I $$ADD^XPDMENU("BADE EDR DENTAL NOTES MENU","BADE EDR REPROC NOTES","REPR") D MES^XPDUTL($J("",5)_"Dental Note option added to BADE EDR DENTAL NOTES MENU") I 1
 E  D MES^XPDUTL($J("",5)_"ERROR:   Dental Note option attachment FAILED or was already added.")
 ;
 I $$ADD^XPDMENU("BADE EDR DENTAL NOTES MENU","BADE EDR PRINT FAILED NOTES","PRT") D MES^XPDUTL($J("",5)_"Dental Note option added to BADE EDR DENTAL NOTE MENU") I 1
 E  D MES^XPDUTL($J("",5)_"ERROR:   Dental Note option attachment FAILED or was already added.")
 ;
 I $$ADD^XPDMENU("BADE EDR DENTAL NOTES MENU","BADE EDR DEFAULT DENTAL NOTE","NOTE") D MES^XPDUTL($J("",5)_"BADE EDR DEFAULT DENTAL NOTE option added to BADE EDR DENTAL NOTE MENU") I 1
 E  D MES^XPDUTL($J("",5)_"ERROR:   Dental Note option attachment FAILED or was already added.")
 ;
 I $$ADD^XPDMENU("BADE EDR DENTAL NOTES MENU","BADE EDR PURGE NOTE ALERTS","BYDT") D MES^XPDUTL($J("",5)_"BADE EDR PURGE NOTE ALERTS option added to BADE EDR DENTAL NOTE MENU") I 1
 E  D MES^XPDUTL($J("",5)_"ERROR:   Dental Note option attachment FAILED or was already added.")
 ;
 I $$ADD^XPDMENU("BADE EDR DENTAL NOTES MENU","BADE EDR PURGE ALL NOTE ALERTS","PALL") D MES^XPDUTL($J("",5)_"BADE EDR PURGE ALL NOTE ALERTS option added to BADE EDR DENTAL NOTE MENU") I 1
 E  D MES^XPDUTL($J("",5)_"ERROR:   Dental Note option attachment FAILED or was already added.")
 ;
 I $$DELETE^XPDMENU("BADE EDR MANAGE INTERFACE MENU","BADE EDR DEFAULT DENTAL NOTE") D MES^XPDUTL($J("",5)_"BADE EDR DEFAULT DENTAL NOTE option removed from EDR Management Menu") I 1
 E  D MES^XPDUTL($J("",5)_"ERROR:   Dental Note option removal FAILED or was already removed")
 ;
 Q
MAIL ;SEND OUT A MAILMAN MESSAGE 
 ;
 N DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 K ^TMP("BADEP10",$J)
 S ^TMP("BADEP10",$J,1)=" --- BADE v1.0, Patch 10 HAS BEEN INSTALLED into this namespace ---"
 I $G(XPDA) D
 . S %=0
 . F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   D
 . . S ^TMP("BADEP10",$J,(%+1))=" "_^(%,0)
 ;
 S XMSUB=$P($P($T(+1),";",2)," ",3,99)
 S XMDUZ=$S($G(DUZ):DUZ,1:.5)
 S XMTEXT="^TMP(""BADEP10"",$J,"
 S XMY(1)=""
 S XMY(DUZ)=""
 ;
 F %="XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 K ^TMP("BADEP10",$J)
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
