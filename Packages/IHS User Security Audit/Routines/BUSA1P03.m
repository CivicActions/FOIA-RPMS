BUSA1P03 ;GDIT/HS/BEE-BUSA*1.0*3 Environmental Checking and Post Install ; 06 Mar 2013  9:52 AM
 ;;1.0;IHS USER SECURITY AUDIT;**3**;Nov 05, 2013;Build 47
 ;
ENV ;EP - Environmental Checking Routine
 ;
 N VERSION,EXEC,HSV,BMWVSN
 ;
 ; Verify that BMW classes exist and we have the correct version.
 S BMWVSN=$G(^BMW("fm2class","Version"))
 I BMWVSN="" D BMES^XPDUTL($$CJ^XLFSTR("Cannot retrieve BMW version",IOM)) S XPDQUIT=2 I 1
 E  I BMWVSN<2.39 D BMES^XPDUTL($$CJ^XLFSTR("BMW version 2.39 or higher required - installation aborted",IOM)) S XPDQUIT=2
 E  D BMES^XPDUTL($$CJ^XLFSTR("BMW version "_BMWVSN_" installed - *PASS*",IOM))
 ;
 ;Require HealthShare 2017.2.2 or later
 S HSV=0,VERSION=$$VERSION^%ZOSV D
 . NEW V1,V2,V3
 . S V1=$P(VERSION,".")
 . I V1>2017 Q
 . I V1<2017 D FIX(1) S HSV=1 Q
 . S V2=$P(VERSION,".",2)
 . I V2>2 Q
 . I V2<2 D FIX(1) S HSV=1 Q
 . S V3=$P(VERSION,".",3)
 . I V3>1 Q
 . D FIX(1) S HSV=1
 ;
 I HSV=0 D BMES^XPDUTL($$CJ^XLFSTR("Health Share v2017.2.2 or greater has been installed - *PASS*",IOM)) I 1
 E  S XPDQUIT=2
 ;
 ;Check for XU*8.0*1020
 I '$$INSTALLD("XU*8.0*1020") D BMES^XPDUTL("Version 8.0 Patch 1020 of XU is required!") S XPDQUIT=2 Q
 ;
 ;Check for DI*2.2*1020
 I '$$INSTALLD("DI*22.0*1020") D BMES^XPDUTL("Version 22.0 Patch 1020 of DI is required!") S XPDQUIT=2 Q
 ;
 ;Check for XT*7.3*1019
 I '$$INSTALLD("XT*7.3*1019") D BMES^XPDUTL("Version 7.3 Patch 1019 of XT is required!") S XPDQUIT=2 Q
 ;
 ;Check for BUSA*1.0*2
 I '$$INSTALLD("BUSA*1.0*2") D FIX(2) S XPDQUIT=2
 ;
 Q
 ;
PRE ;EP - Preinstallation
 ;
 ;Reset some transport files data
 NEW II,DA,DIK
 ;
 S II=0 F  S II=$O(^BUSACLS(II)) Q:'II  S DA=II,DIK="^BUSACLS(" D ^DIK
 ;
 Q
 ;
POS ;EP - Post Installation Code
 ;
 ;Compile class process
 ;
 N TRIEN,EXEC,ERR,CURR,TYP
 ;
 ;For each build, set this to the 9002319.05 entry to load
 S TRIEN=1
 ;
 ; Import BUSA classes
 K ERR
 I $G(TRIEN)'="" D IMPORT^BUSACLAS(TRIEN,.ERR)
 I $G(ERR) Q
 ;
 ;Turn on the switches
 F TYP="M","B","C","W","F" D
 . ;
 . ;Quit if already on
 . I '+$$STATUS^BUSAOPT(TYP) D
 . S CURR=1
 . D NREC^BUSAOPT(TYP,1)
 . ;
 . ;Make sure the indexes are set
 . NEW DA
 . S DA=$O(^BUSA(9002319.04,"B",TYP,""),-1)
 . I DA D SSET^BUSAUTL1
 ;
 Q
 ;
EX2H(X) ;Converts external date/time to $H
 ;
 NEW %DT,Y
 ;
 I $G(X)="" Q -1
 S:X[" " X=$TR(X," ","@")
 ;
 ;First convert to FMan
 S %DT="ST",Y=""
 D ^%DT
 I Y="-1" Q -1
 ;
 ;Now convert to $H
 Q $$FMTH^XLFDT(Y)
 ;
INSTALLD(BUSASTAL) ;EP - Determine if patch BUSASTAL was installed, where
 ; BUSASTAL is the name of the INSTALL.  E.g "BUSA*1.0*2"
 ;
 NEW BUSAY,INST
 ;
 S BUSAY=$O(^XPD(9.7,"B",BUSASTAL,""))
 S INST=$S(BUSAY>0:1,1:0)
 D IMES(BUSASTAL,INST)
 Q INST
 ;
IMES(BUSASTAL,Y) ;Display message to screen
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_BUSASTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed"_$S(Y<1:"",1:" - *PASS*"),IOM))
 Q
 ;
FIX(X) ;
 NEW MSG
 KILL DIFQ
 ;
 S MSG="HealthShare 2017.2.2 or later is required - installation aborted"
 I X=2 S MSG="This patch must be installed prior to the installation of BUSA*1.0*3"
 W *7,!,$$CJ^XLFSTR(MSG,IOM)
 Q
