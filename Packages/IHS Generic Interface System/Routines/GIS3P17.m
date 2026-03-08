GIS3P17 ;ihs/cmi/maw - GIS Patch 17 Post Init ; 03 Nov 2021  3:13 PM
 ;;3.01;IHS Generic Interface System;**17**;FEB 20, 2002;Build 3
 ;
ENV ;-- environment check
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I '$$INSTALLD("XU*8.0*1018") D SORRY(2) Q
 I '$$INSTALLD("DI*22.0*1018") D SORRY(2) Q
 I '$$INSTALLD("GIS*3.01*16") D SORRY(2) Q
 Q
 ;
INSTALLD(BPDMSTAL) ;EP - Determine if patch BPDMSTAL was installed, where
 ; BPDMSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW BPDMY,DIC,X,Y
 S X=$P(BPDMSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(BPDMSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(BPDMSTAL,"*",3)
 D ^DIC
 S BPDMY=Y
 D IMES
 Q $S(BPDMY<1:0,1:1)
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_BPDMSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
 ;
BLANK ; EP - Blank Line
 D MES^XPDUTL(" ")
 Q
 ;
