ADS1P06 ;IHS/GDIT/AEF - ADS Version 1.0 Patch 6 Env/Pre/Post Install
 ;;1.0;DISTRIBUTION MANAGEMENT;**6**;Apr 23, 2020;Build 8
 ;
ENV ;EP - Environmental Checking Routine
 ;
 ;Check for ADS*1.0*5:
 I '$$INSTALLD("ADS*1.0*5") D BMES^XPDUTL("Version 1.0 Patch 5 of ADS is required!") S XPDQUIT=2 Q
 ;
 ;Check for BSTS*1.0*1 - Needed for logging call:
 I '$$INSTALLD("BSTS*2.0*1") D BMES^XPDUTL("Version 2.0 Pach 1 of BSTS is required!") S XPDQUIT=2 Q
 ;
 ;Check for XU*8.0*1020:
 I '$$INSTALLD("XU*8.0*1020") D BMES^XPDUTL("Version 8.0 Patch 1020 of XU is required!") S XPDQUIT=2 Q
 ;
 ;Check for DI*22*1020:
 I '$$INSTALLD("DI*22.0*1020") D BMES^XPDUTL("Version 22.0 Patch 1020 of DI is required!") S XPDQUIT=2 Q
 ;
 Q
INSTALLD(X) ;EP - Determine if patch X was installed where X
 ; is the name of the install, e.g. "XU*8.0*1020"
 ;
 N IEN,Y
 S Y=0
 ;
 ;Find install entry and check if completed:
 S IEN=0
 F  S IEN=$O(^XPD(9.7,"B",X,IEN)) Q:'IEN  D
 . S:$$GET1^DIQ(9.7,IEN_",",.02,"I")=3 Y=1
 ;
 ;Display message:
 D IMES(X,Y)
 ;
 Q Y
IMES(X,Y) ;Display message to screen
 ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_X_""" is"_$S(Y<1:" *NOT",1:"")_" installed!"_$S(Y<1:"",1:" - *PASS*"),IOM))
 Q
PRE ;EP - PRE INSTALL
 ;
 Q
POST ;EP - POST INSTALL
 ;
 Q
