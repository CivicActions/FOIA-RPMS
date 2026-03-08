ADS1P02 ;GDIT/HS/BEE-ADS Version 1.0 Patch 2 Post Install ; 01 Apr 2020  10:00 AM
 ;;1.0;DISTRIBUTION MANAGEMENT;**2**;Apr 23, 2020;Build 6
 ;
ENV ;EP - Environmental Checking Routine
 ;
 N VERSION,EXEC,BMWDT,LIEN
 ;
 ;Check for ADS*1.0*1
 I '$$INSTALLD("ADS*1.0*1") D BMES^XPDUTL("Version 1.0 Patch 1 of ADS is required!") S XPDQUIT=2 Q
 ;
 ;Check for BSTS*2.0*1 - Needed for logging call
 I '$$INSTALLD("BSTS*2.0*1") D BMES^XPDUTL("Version 2.0 Patch 1 of BSTS is required!") S XPDQUIT=2 Q
 ;
 ;Check for XU*8.0*1020
 I '$$INSTALLD("XU*8.0*1020") D BMES^XPDUTL("Version 8.0 Patch 1020 of XU is required!") S XPDQUIT=2 Q
 ;
 ;Check for DI*2.2*1020
 I '$$INSTALLD("DI*22.0*1020") D BMES^XPDUTL("Version 22.0 Patch 1020 of DI is required!") S XPDQUIT=2 Q
 ;
 Q
 ;
POST ;EP - Post install entry point
 ;
 NEW ZTQUEUED
 ;
 ;Run the license log
 S ZTQUEUED=1 D EN^ADSRPT
 ;
 ;Send it now
 D PLOG^BSTSAPIL
 ;
 Q
 ;
INSTALLD(ADSSTAL) ;EP - Determine if patch ADSSTAL was installed, where
 ; ADSSTAL is the name of the INSTALL.  E.g "XU*8.0*1019"
 ;
 NEW ADSY,INST
 ;
 S ADSY=$O(^XPD(9.7,"B",ADSSTAL,""))
 S INST=$S(ADSY>0:1,1:0)
 D IMES(ADSSTAL,INST)
 Q INST
 ;
IMES(ADSSTAL,Y) ;Display message to screen
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_ADSSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed"_$S(Y<1:"",1:" - *PASS*"),IOM))
 Q
