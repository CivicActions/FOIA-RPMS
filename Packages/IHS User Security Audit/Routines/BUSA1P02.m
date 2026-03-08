BUSA1P02 ;GDIT/HS/BEE-BUSA*1.0*2 Environmental Checking and Post Install ; 06 Mar 2013  9:52 AM
 ;;1.0;IHS USER SECURITY AUDIT;**2**;Nov 05, 2013;Build 11
 ;
ENV ;EP - Environmental Checking Routine
 ;
 ;Require HealthShare 2017.2.2 or later
 S VERSION=$$VERSION^%ZOSV D
 . NEW V1,V2,V3
 . S V1=$P(VERSION,".")
 . I V1>2017 Q
 . I V1<2017 D FIX(1) S XPDQUIT=2 Q
 . S V2=$P(VERSION,".",2)
 . I V2>2 Q
 . I V2<2 D FIX(1) S XPDQUIT=2 Q
 . S V3=$P(VERSION,".",3)
 . I V3>1 Q
 . D FIX(1) S XPDQUIT=2
 ;
 I $G(XPDQUIT)'=2 D MES^XPDUTL($$CJ^XLFSTR("Health Share v2017.2.2 or greater has been installed",IOM))
 ;
 ;Check for BUSA*1.0*1
 I '$$INSTALLD("BUSA*1.0*1") D FIX(2) S XPDQUIT=2
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
 N TRIEN,EXEC,ERR
 ;
 ;For each build, set this to the 9002319.05 entry to load
 S TRIEN=1
 ;
 ; Import BUSA classes
 K ERR
 I $G(TRIEN)'="" D IMPORT^BUSACLAS(TRIEN,.ERR)
 I $G(ERR) Q
 ;
 Q
 ;
INSTALLD(BUSASTAL) ;EP - Determine if patch BUSASTAL was installed, where
 ; BUSASTAL is the name of the INSTALL.  E.g "BUSA*1.0*1"
 ;
 NEW BUSAY,INST
 ;
 S BUSAY=$O(^XPD(9.7,"B",BUSASTAL,""))
 S INST=$S(BUSAY>0:1,1:0)
 D IMES(BUSASTAL,INST)
 Q INST
 ;
IMES(BUSASTAL,Y) ;Display message to screen
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_BUSASTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
 ;
FIX(X) ;
 NEW MSG
 KILL DIFQ
 ;
 S MSG="HealthShare 2017.2.2 or later is required prior to the installation of BUSA*1.0*2"
 I X=2 S MSG="This patch must be installed prior to the installation of BUSA*1.0*2"
 W *7,!,$$CJ^XLFSTR(MSG,IOM)
 Q
