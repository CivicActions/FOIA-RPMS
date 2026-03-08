BUSA1P05 ;GDIT/HS/BEE-BUSA*1.0*5 Environmental Checking and Post Install ; 06 Mar 2013  9:52 AM
 ;;1.0;IHS USER SECURITY AUDIT;**5**;Nov 05, 2013;Build 42
 ;
ENV ;EP - Environmental Checking Routine
 ;
 N VERSION,EXEC,HSV,BMWVSN
 ;
 ;Check for XU*8.0*1020
 I '$$INSTALLD("XU*8.0*1020") D BMES^XPDUTL("Version 8.0 Patch 1020 of XU is required!") S XPDQUIT=2 Q
 ;
 ;Check for DI*2.2*1020
 I '$$INSTALLD("DI*22.0*1020") D BMES^XPDUTL("Version 22.0 Patch 1020 of DI is required!") S XPDQUIT=2 Q
 ;
 ;Check for BUSA*1.0*3
 I '$$INSTALLD("BUSA*1.0*4") D FIX(2) S XPDQUIT=2
 ;
 Q
 ;
PRE ;EP - Preinstallation
 ;
 ;Reset some transport files data
 NEW II,DA,DIK
 ;
 ;Clear BUSA CACHE CLASS TRANSPORT
 S II=0 F  S II=$O(^BUSACLS(II)) Q:'II  S DA=II,DIK="^BUSACLS(" D ^DIK
 ;
 ;Clear BUSA FILEMAN AUDIT INCLUSIONS FILE
 S II=0 F  S II=$O(^BUSAFMAN(II)) Q:'II  S DA=II,DIK="^BUSAFMAN(" D ^DIK
 ;
 Q
 ;
PST ;EP - Post Installation Code
 ;
 ;Compile class process
 ;
 NEW TRIEN,EXEC,ERR,CURR,TYP,ZTDTH,ZTDESC,ZTRTN,ZTIO,ZTSAVE,ZTSK,X1,X2,X,%,Y,DIR,DTOUT,DUOUT,DIRUT,DIROUT
 NEW USR,IKEY
 ;
 ;For each build, set this to the 9002319.05 entry to load
 S TRIEN=1
 ;
 ; Import BUSA classes
 K ERR
 I $G(TRIEN)'="" D IMPORT^BUSACLAS(TRIEN,.ERR)
 I $G(ERR) Q
 ;
 ;Make a copy of BUSA FILEMAN LOCAL AUDIT DEF
 D MES^XPDUTL("Making a backup copy of BUSA FILEMAN LOCAL AUDIT DEF definition")
 D PST^BUSAFMAN
 ;
 ;Assign any users with BUSAZMGR key, the BUSAZMENU key as well
 W !!,"Assigning the BUSAZMENU key to holders of the BUSAZMGR key",!
 S IKEY=$O(^DIC(19.1,"B","BUSAZMENU","")) I 'IKEY Q
 S USR=0 F  S USR=$O(^XUSEC("BUSAZMGR",USR)) Q:'USR  D
 . NEW KEYS,OUT,DA,DIC,X,Y,DINUM
 . ;
 . ;Check if they already have the key
 . S KEYS(1)="BUSAZMENU"
 . D OWNSKEY^XUSRB(.OUT,.KEYS,USR)
 . I $G(OUT(1)) Q
 . ;
 . ;Assign BUSAZMENU
 . S DIC(0)="NMQ",DIC("P")="200.051PA"
 . S DIC="^VA(200,"_USR_",51,"
 . S DA(1)=USR,X=IKEY,DINUM=IKEY
 . K DO,DD D FILE^DICN Q
 ;
 Q
 ;
INSTALLD(BUSASTAL,PATCH) ;EP - Determine if patch BUSASTAL was installed, where
 ; BUSASTAL is the name of the INSTALL.  E.g "BUSA*1.0*4"
 ;
 NEW BUSAY,INST
 ;
 S BUSAY=$O(^XPD(9.7,"B",BUSASTAL,""))
 S INST=$S(BUSAY>0:1,1:0)
 D IMES(BUSASTAL,INST)
 Q INST
 ;
IMES(BUSASTAL,Y) ;Display message to screen
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_$S($G(PATCH)]"":PATCH,1:BUSASTAL)_""" is"_$S(Y<1:" *NOT*",1:"")_" installed"_$S(Y<1:"",1:" - *PASS*"),IOM))
 Q
 ;
FIX(X) ;
 NEW MSG
 KILL DIFQ
 ;
 S MSG="Missing required patch - installation aborted"
 I X=2 S MSG="This patch must be installed prior to the installation of BUSA*1.0*5"
 W *7,!,$$CJ^XLFSTR(MSG,IOM)
 Q
