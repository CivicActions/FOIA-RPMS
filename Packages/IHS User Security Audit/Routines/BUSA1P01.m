BUSA1P01 ;GDIT/HS/BEE-BUSA*1.0*1 Environmental Checking and Post Install ; 06 Mar 2013  9:52 AM
 ;;1.0;IHS USER SECURITY AUDIT;**1**;Nov 05, 2013;Build 15
 ;
ENV ;EP - Environmental Checking Routine
 ;
 ;Check for BUSA 1.0
 I $$VERSION^XPDUTL("BUSA")'="1.0" D BMES^XPDUTL("Version 1.0 of BUSA is required!") S XPDQUIT=2 Q
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
